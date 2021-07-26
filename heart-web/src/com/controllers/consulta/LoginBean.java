package com.controllers.consulta;

import java.io.Serializable;

import javax.annotation.PostConstruct;
import javax.ejb.EJB;
import javax.enterprise.context.SessionScoped;
import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.inject.Named;

import org.primefaces.context.PrimeFacesContext;

import com.daos.consulta.UsuarioDao;
import com.entities.consulta.Usuario;

@Named("login")
@SessionScoped
public class LoginBean implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private Usuario usuario;
	
	@EJB
	private UsuarioDao usuariodao;
	
	
	@PostConstruct
	public void init() {
		usuario = new Usuario();
	}
	
	
	
	
	
	public Usuario getUsuario() {
		return usuario;
	}





	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}





	public UsuarioDao getUsuariodao() {
		return usuariodao;
	}





	public void setUsuariodao(UsuarioDao usuariodao) {
		this.usuariodao = usuariodao;
	}





	public static long getSerialversionuid() {
		return serialVersionUID;
	}



	public String iniciarSesion() {
		Usuario us;
		boolean estado;
		String redireccion = null;
		try {
			
			us = usuariodao.iniciarSesion(usuario);
			estado= usuariodao.estado(usuario);
			int rol = us.getRol().getRols();
			if (us != null  && estado==false) {
				redireccion = "templates/bloqueado?faces-redirect=true";
				System.out.println("if");
			}else if (us != null && rol==1) {
				PrimeFacesContext.getCurrentInstance().getExternalContext().getSessionMap().put("usuario", us);
				redireccion = "menuAdministrador?faces-redirect=true";
				System.out.println("else if");
			}else if (us != null && rol==2) {
				PrimeFacesContext.getCurrentInstance().getExternalContext().getSessionMap().put("usuario", us);
				redireccion = "menuRegistrado?faces-redirect=true";
				System.out.println("else if");
			} 
				else {
				FacesContext.getCurrentInstance().addMessage(null,
						new FacesMessage(FacesMessage.SEVERITY_WARN, "Aviso", "Credenciales Incorrectas"));
			System.out.println("else");
			}
			
		} catch (Exception e) {
			FacesContext.getCurrentInstance().addMessage(null,
					new FacesMessage(FacesMessage.SEVERITY_WARN, "Aviso", "Error"));
		System.out.println("catch");
		}
		return redireccion;
	}
}
