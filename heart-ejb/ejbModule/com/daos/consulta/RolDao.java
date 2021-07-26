package com.daos.consulta;



import java.util.List;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import com.entities.consulta.Consulta;
import com.entities.consulta.Rol;


@Stateless
public class RolDao {
	
	@PersistenceContext
	private EntityManager em;


	public void crear(Rol persona) {
		em.persist(persona);
		em.refresh(persona);
	}

	public Rol actualizar(Rol persona) {
		return em.merge(persona);
	}

	public void borrar(Integer codigo) {
		Rol persona = em.find(Rol.class, codigo);
		em.remove(persona);
	}

	public Rol buscar(Integer codigo) {
		return em.find(Rol.class, codigo);
	}
	public List<Rol> listar() {
		return em.createQuery("SELECT r FROM Rol r order by id_rol").getResultList();
	}

}
