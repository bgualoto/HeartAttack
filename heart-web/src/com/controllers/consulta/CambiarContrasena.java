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

@Named("cambiar")
@SessionScoped
public class CambiarContrasena implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String clavenueva;
	public String getClavenueva() {
		return clavenueva;
	}





	public void setClavenueva(String clavenueva) {
		this.clavenueva = clavenueva;
	}


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
			
			if (us != null ) {
				System.out.println("IF");
				PrimeFacesContext.getCurrentInstance().getExternalContext().getSessionMap().put("usuario", us);
				Usuario nuevoUsuario=new Usuario();
				nuevoUsuario.setCodigo(usuariodao.codigoup(usuario));
				nuevoUsuario.setCorreo(usuariodao.correoup(usuario));
				nuevoUsuario.setClave(clavenueva);
				nuevoUsuario.setEstado(usuariodao.estado(usuario));
				nuevoUsuario.setDueño(usuariodao.duenoup(usuario));
				nuevoUsuario.setRol(usuariodao.rolup(usuario));
				usuariodao.actualizar(nuevoUsuario);
				
				System.out.println("IF");
				
			} else {
				FacesContext.getCurrentInstance().addMessage(null,
						new FacesMessage(FacesMessage.SEVERITY_WARN, "Aviso", "Credenciales Incorrectas"));
			System.out.println("ELSE");
			}
			
		} catch (Exception e) {
			FacesContext.getCurrentInstance().addMessage(null,
					new FacesMessage(FacesMessage.SEVERITY_WARN, "Aviso", "Error"));
		System.out.println("CATCH");
		}
		return redireccion;
	}
	
	
	public String cambiar() {
		Usuario nuevoUsuario=new Usuario();
		
		 
		
		nuevoUsuario.setCodigo(usuario.getCodigo());
		nuevoUsuario.setCorreo(usuario.getCorreo());
		
		nuevoUsuario.setEstado(usuario.isEstado());
		nuevoUsuario.setDueño(usuario.getDueño());
		nuevoUsuario.setRol(usuario.getRol());
		nuevoUsuario.setClave(clavenueva); 
		usuariodao.actualizar(nuevoUsuario);
		
		return "actualizado"; 
	}







}