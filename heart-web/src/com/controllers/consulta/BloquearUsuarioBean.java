package com.controllers.consulta;

import java.io.Serializable;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.ejb.EJB;
import javax.enterprise.context.SessionScoped;
import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.inject.Named;

import org.primefaces.context.PrimeFacesContext;

import com.daos.consulta.UsuarioDao;
import com.entities.consulta.Consulta;
import com.entities.consulta.Usuario;

@Named("bloquear")
@SessionScoped
public class BloquearUsuarioBean implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private Usuario usuario;
	private List<Usuario> usu;
	
	@EJB
	private UsuarioDao usuariodao;
	
	
	@PostConstruct
	public void init() {
		usuario = new Usuario();
		usu = usuariodao.listar();
	}
	
	
	
	
	
	public List<Usuario> getUsu() {
		return usu;
	}





	public void setUsu(List<Usuario> usu) {
		this.usu = usu;
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
			
			if (us != null ) {
				System.out.println("IF");
				PrimeFacesContext.getCurrentInstance().getExternalContext().getSessionMap().put("usuario", us);
				Usuario nuevoUsuario=new Usuario();
				nuevoUsuario.setCodigo(usuariodao.codigoup(usuario));
				nuevoUsuario.setCorreo(usuariodao.correoup(usuario));
				nuevoUsuario.setClave(usuariodao.claveup(usuario));
				nuevoUsuario.setEstado(false);
				nuevoUsuario.setDueño(usuariodao.duenoup(usuario));
				nuevoUsuario.setRol(usuariodao.rolup(usuario));
				usuariodao.actualizar(nuevoUsuario);
				 
				System.out.println("IFb");
				
			} else {
				FacesContext.getCurrentInstance().addMessage(null,
						new FacesMessage(FacesMessage.SEVERITY_WARN, "Aviso", "Credenciales Incorrectas"));
			System.out.println("ELSE BLOCK");
			}
			
		} catch (Exception e) {
			FacesContext.getCurrentInstance().addMessage(null,
					new FacesMessage(FacesMessage.SEVERITY_WARN, "Aviso", "Error"));
		System.out.println("CATCH block");
		}
		return redireccion;
	}
	
}