package com.controllers.consulta;

import java.io.Serializable;


import javax.ejb.EJB;
import javax.enterprise.context.RequestScoped;
import javax.inject.Named;

import com.daos.consulta.UsuarioDao;
import com.entities.consulta.Usuario;

@Named("registrou")
@RequestScoped

public class RegistroUsuarioBean implements Serializable {

	
	private static final long serialVersionUID=1L;
	private int id;
	private String correo;
	private String clave;
	private boolean estado;
	private int perfil;
	private int rol;
	
	@EJB
	private UsuarioDao usuarioDao;
		
	

	public int getId() {
		return id;
	}



	public void setId(int id) {
		this.id = id;
	}





	public String getCorreo() {
		return correo;
	}



	public void setCorreo(String correo) {
		this.correo = correo;
	}



	public String getClave() {
		return clave;
	}



	public void setClave(String clave) {
		this.clave = clave;
	}



	public boolean isEstado() {
		return estado;
	}



	public void setEstado(boolean estado) {
		this.estado = estado;
	}



	public int getPerfil() {
		return perfil;
	}



	public void setPerfil(int perfil) {
		this.perfil = perfil;
	}



	public int getRol() {
		return rol;
	}



	public void setRol(int rol) {
		this.rol = rol;
	}







	public UsuarioDao getUsuarioDao() {
		return usuarioDao;
	}



	public void setUsuarioDao(UsuarioDao usuarioDao) {
		this.usuarioDao = usuarioDao;
	}



	public String registrar() {
		Usuario nuevoUsuario=new Usuario();
		nuevoUsuario.setCorreo(correo);
		nuevoUsuario.setClave(clave); 
		nuevoUsuario.setEstado(estado);
		usuarioDao.crear(nuevoUsuario);
		return "registradousu"; 
	} 
}
