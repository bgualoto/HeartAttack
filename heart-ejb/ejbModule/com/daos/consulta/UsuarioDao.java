package com.daos.consulta;

import java.util.List;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import com.entities.consulta.Consulta;
import com.entities.consulta.Rol;
import com.entities.consulta.Usuario;

@Stateless
public class UsuarioDao {

	@PersistenceContext
	private EntityManager em;
	
	
	
	public int codigous(Usuario us){
		
		int codigo1=0;
		Usuario usuario = null;
		String consulta;
		try {
			consulta = "SELECT u FROM Usuario u WHERE u.correo= ?1 AND u.clave= ?2";
			Query query = em.createQuery(consulta);
			query.setParameter(1, us.getCorreo());
			query.setParameter(2, us.getClave());
			List<Usuario> lista = query.getResultList();
			
			if (!lista.isEmpty()) {
				usuario = lista.get(0);
				codigo1=usuario.getCodigo();
				
			}
		} catch (Exception e) {
			throw e;
		}
		
		return codigo1;
	}
	
	public boolean estado(Usuario us){
		boolean estado1=false;
		Usuario usuario = null;
		String consulta;
		try {
			consulta = "SELECT u FROM Usuario u WHERE u.correo= ?1 AND u.clave= ?2";
			Query query = em.createQuery(consulta);
			query.setParameter(1, us.getCorreo());
			query.setParameter(2, us.getClave());
			List<Usuario> lista = query.getResultList();
			
			if (!lista.isEmpty()) {
				usuario = lista.get(0);
				if(usuario.isEstado()==true) {
					estado1=true;
				}
				
			}
		} catch (Exception e) {
			throw e;
		}
		
		return estado1;
	}
	
	public Usuario iniciarSesion(Usuario us) {
		Usuario usuario = null;
		String consulta;
		try {
			consulta = "SELECT u FROM Usuario u WHERE u.correo= ?1 AND u.clave= ?2";
			Query query = em.createQuery(consulta);
			query.setParameter(1, us.getCorreo());
			query.setParameter(2, us.getClave());
			List<Usuario> lista = query.getResultList();
			if (!lista.isEmpty()) {
				usuario = lista.get(0);
			}
		} catch (Exception e) {
			throw e;
		}
		return usuario; 
	}
	public Usuario iniciarSesion1(Usuario us) {
		Usuario usuario = null;
		String consulta;
		try {
			consulta = "SELECT u FROM Usuario u WHERE u.correo= ?1";
			Query query = em.createQuery(consulta);
			query.setParameter(1, us.getCorreo());
			List<Usuario> lista = query.getResultList();
			if (!lista.isEmpty()) {
				usuario = lista.get(0);
			}
		} catch (Exception e) {
			throw e;
		}
		return usuario;
	}
	

	public Usuario cambiarClave(Usuario us) {
		Usuario usuario = null;
		String consulta;
		try {
			consulta = "UPDATE Usuario u SET u.clave= ?1 WHERE u.correo= ?2 AND u.clave= ?3";
//			Query query = em.createQuery(consulta);
			
//			query.setParameter(1, us.getCorreo());
//			query.setParameter(2, us.getClave());
//			List<Usuario> lista = query.getResultList();
//			if (!lista.isEmpty()) {
//				usuario = lista.get(0);
//			}
		} catch (Exception e) {
			throw e;
		}
		return usuario;
	}
	
	

	public void crear(Usuario persona) {
		em.persist(persona);
		em.refresh(persona);
	}

	public Usuario actualizar(Usuario persona) {
		return em.merge(persona);
	}

	public void borrar(Integer codigo) {
		Usuario persona = em.find(Usuario.class, codigo);
		em.remove(persona);
	}

	public Usuario buscar(Integer codigo) {
		return em.find(Usuario.class, codigo);
	}
	
	
	//
	
	
	
	
	//CODIGO USUARIO
	public int codigoup(Usuario us){
		int codigoup1=0;
		Usuario usuario = null;
		String consulta;
		try {
			consulta = "SELECT u FROM Usuario u WHERE u.correo= ?1 AND u.clave= ?2";
			Query query = em.createQuery(consulta);
			query.setParameter(1, us.getCorreo());
			query.setParameter(2, us.getClave());
			List<Usuario> lista = query.getResultList();
			
			if (!lista.isEmpty()) {
				usuario = lista.get(0);
				codigoup1=usuario.getCodigo();
				
			}
		} catch (Exception e) {
			throw e;
		}
		
		return codigoup1;
	}
	//CORREO USUARIO
	public String correoup(Usuario us){
		String correoup1= null;
		Usuario usuario = null;
		String consulta;
		try {
			consulta = "SELECT u FROM Usuario u WHERE u.correo= ?1 AND u.clave= ?2";
			Query query = em.createQuery(consulta);
			query.setParameter(1, us.getCorreo());
			query.setParameter(2, us.getClave());
			List<Usuario> lista = query.getResultList();
			
			if (!lista.isEmpty()) {
				usuario = lista.get(0);
				correoup1=usuario.getCorreo();
				
			}
		} catch (Exception e) {
			throw e;
		}
		
		return correoup1;
	}
	//clave usuario
	public String claveup(Usuario us){
		String claveup1=null;
		Usuario usuario = null;
		String consulta;
		try {
			consulta = "SELECT u FROM Usuario u WHERE u.correo= ?1 AND u.clave= ?2";
			Query query = em.createQuery(consulta);
			query.setParameter(1, us.getCorreo());
			query.setParameter(2, us.getClave());
			List<Usuario> lista = query.getResultList();
			
			if (!lista.isEmpty()) {
				usuario = lista.get(0);
				claveup1=usuario.getClave();
				
			}
		} catch (Exception e) {
			throw e;
		}
		
		return claveup1;
	}
	//DUEÑO USUARIO
	public int duenoup(Usuario us){
		int duenoup1=0;
		Usuario usuario = null;
		String consulta;
		try {
			consulta = "SELECT u FROM Usuario u WHERE u.correo= ?1 AND u.clave= ?2";
			Query query = em.createQuery(consulta);
			query.setParameter(1, us.getCorreo());
			query.setParameter(2, us.getClave());
			List<Usuario> lista = query.getResultList();
			
			if (!lista.isEmpty()) {
				usuario = lista.get(0);
				duenoup1=usuario.getDueño();
				
			}
		} catch (Exception e) {
			throw e;
		}
		
		return duenoup1;
	}
	//ROL USUARIO
	public Rol rolup(Usuario us){
		Rol rolup1= null;
		Usuario usuario = null;
		String consulta;
		try {
			consulta = "SELECT u FROM Usuario u WHERE u.correo= ?1 AND u.clave= ?2";
			Query query = em.createQuery(consulta);
			query.setParameter(1, us.getCorreo());
			query.setParameter(2, us.getClave());
			List<Usuario> lista = query.getResultList();
			
			if (!lista.isEmpty()) {
				usuario = lista.get(0);
				rolup1=usuario.getRol();
				
			}
		} catch (Exception e) {
			throw e;
		}
		
		return rolup1;
	}
	public List<Usuario> listar() {
		return em.createQuery("SELECT u FROM Usuario u order by id_us").getResultList();
	}
}
