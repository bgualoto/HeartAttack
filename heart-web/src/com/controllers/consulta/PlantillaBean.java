package com.controllers.consulta;

import java.io.Serializable;

import javax.annotation.PostConstruct;
import javax.ejb.EJB;
import javax.enterprise.context.SessionScoped;
import javax.faces.context.FacesContext;
import javax.faces.view.ViewScoped;
import javax.inject.Named;

import com.daos.consulta.UsuarioDao;
import com.entities.consulta.Usuario;

@Named("plantilla")
//@SessionScoped
@ViewScoped
public class PlantillaBean implements Serializable {
	
private Usuario usuario;
	
	@EJB
	private UsuarioDao usuariodao;
	
	
	@PostConstruct
	public void init() {
		usuario = new Usuario();
	}
	
	
	
	public void verificarSesion() {
		Usuario us1;
		boolean estado;
		String redireccion = null;
		try {
			
			us1 = usuariodao.iniciarSesion(usuario);
			estado= usuariodao.estado(usuario);
			int rol = us1.getRol().getRols();
			if (us1 != null  && rol==1) { 
			us1 = (Usuario) FacesContext.getCurrentInstance().getExternalContext().getSessionMap()
					.get("usuario");
			redireccion = "menuAdministrador?faces-redirect=true";
			}
			if (us1 != null  && rol==2) { 
				us1 = (Usuario) FacesContext.getCurrentInstance().getExternalContext().getSessionMap()
						.get("usuario");
				redireccion = "menuRegistrado?faces-redirect=true";
				
				}
			if (us1 == null) {
				FacesContext.getCurrentInstance().getExternalContext().redirect("permisos.xhtml");
			}
		} catch (Exception e) {
		}
	}
	
	
	
	}
