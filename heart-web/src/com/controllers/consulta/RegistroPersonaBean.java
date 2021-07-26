package com.controllers.consulta;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.ejb.EJB;
import javax.enterprise.context.RequestScoped;
import javax.enterprise.context.SessionScoped;
import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.inject.Named;

import org.primefaces.context.PrimeFacesContext;

import com.daos.consulta.ConsultaDao;
import com.daos.consulta.RolDao;
import com.entities.consulta.Consulta;
import com.entities.consulta.Persona;
import com.entities.consulta.Rol;
import com.daos.consulta.UsuarioDao;
import com.entities.consulta.Usuario;

@Named("registro")
@SessionScoped

public class RegistroPersonaBean implements Serializable {

	
	private static final long serialVersionUID=1L;
	private String nombre;
	public Usuario getUsuario() {
		return usuario;
	}






	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}



	private String ciudad;
	private int edad;
	private String estadoCivil;
	private String correo;
	private String clave;
	private boolean estado;
	private int dueño;
	private Rol rol;
	private Usuario usuario;
	public Rol getRol() {
		return rol;
	}






	public void setRol(Rol rol) {
		this.rol = rol;
	}






	public RolDao getRolDao() {
		return rolDao;
	}






	public void setRolDao(RolDao rolDao) {
		this.rolDao = rolDao;
	}






	public int getDueño() {
		return dueño;
	}






	public void setDueño(int dueño) {
		this.dueño = dueño;
	}













	public List<Consulta> getDueños() {
		return dueños;
	}
	
	






	public void setDueños(List<Consulta> dueños) {
		this.dueños = dueños;
	}


	public List<Rol> getRoles() {
		return roles;
	}


	public void setRoles(List<Rol> roles) {
		this.roles = roles;
	}



	private List<Consulta> dueños;
	
	private List<Rol> roles;
	
	public int duenon() {
		int d1= dueños.size()+1;
		return d1;
	}
	
	public Consulta dueno() {
		Consulta d=dueños.get(dueños.size()-1);
		return d;
		
	}
	@EJB
	private ConsultaDao personaDao;
	@EJB
	private RolDao rolDao;
	
	@EJB
	private UsuarioDao usuarioDao;	
	public String getNombre() {
		return nombre;
	}
	
	




	public boolean isEstado() {
		return estado;
	}




	public void setEstado(boolean estado) {
		this.estado = estado;
	}

	




	public void setNombre(String nombre) {
		this.nombre = nombre;
	}



	public String getCiudad() {
		return ciudad;
	}


	public void setCiudad(String ciudad) {
		this.ciudad = ciudad;
	}


	public int getEdad() {
		return edad;
	}


	public void setEdad(int edad) {
		this.edad = edad;
	} 
	public String getEstadoCivil() {
		return estadoCivil;
	}

	public void setEstadoCivil(String estadoCivil) {
		this.estadoCivil = estadoCivil;
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


	public ConsultaDao getPersonaDao() {
		return personaDao;
	}

	public void setPersonaDao(ConsultaDao personaDao) {
		this.personaDao = personaDao;
	}
	
	public UsuarioDao getUsuarioDao() {
		return usuarioDao;
	}



	public void setUsuarioDao(UsuarioDao usuarioDao) {
		this.usuarioDao = usuarioDao;
	}
	@PostConstruct
	public void inicializar() {
		dueños = personaDao.listar();
		roles = rolDao.listar();
		usuario = new Usuario();
	}

	
	
	public String registrar() {
		String redireccion = null;
		Consulta nuevaPersona=new Consulta();
		nuevaPersona.setNombre(nombre);
		nuevaPersona.setCiudad(ciudad);
		nuevaPersona.setEdad(edad);
		nuevaPersona.setEstadoCivil(estadoCivil); 
		nuevaPersona.setCorreo(correo);
		nuevaPersona.setClave(clave); 
		personaDao.crear(nuevaPersona);
		Usuario nuevoUsuario=new Usuario();
		nuevoUsuario.setDueño(duenon());
		nuevoUsuario.setCorreo(correo);
		nuevoUsuario.setClave(clave); 
		nuevoUsuario.setEstado(true);
		nuevoUsuario.setRol(rol);
		usuarioDao.crear(nuevoUsuario);
		if(nuevoUsuario!=null){
			redireccion = "consultarUsuarios1?faces-redirect=true";
		}
		
		return redireccion; 
	}
	
//	public String registrado() {
//		Usuario us;
//		int r=1;
//		boolean estado;
//		String redireccion = null;
//		try {
//			
//			
//			if (registrar()=1) {
//				redireccion = "templates/bloqueado?faces-redirect=true";
//				System.out.println("if");
//			} 
//				else {
//				FacesContext.getCurrentInstance().addMessage(null,
//						new FacesMessage(FacesMessage.SEVERITY_WARN, "Aviso", "Credenciales Incorrectas"));
//			System.out.println("else");
//			}
//			
//		} catch (Exception e) {
//			FacesContext.getCurrentInstance().addMessage(null,
//					new FacesMessage(FacesMessage.SEVERITY_WARN, "Aviso", "Error"));
//		System.out.println("catch");
//		}
//		return redireccion;
//	}







}
