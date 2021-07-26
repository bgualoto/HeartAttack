package com.daos.consulta;

import java.util.List;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import com.entities.consulta.Menu;

@Stateless
public class MenuDao {
	
	@PersistenceContext
	private EntityManager em;

	
	public List<Menu> listar() {
		return em.createQuery("SELECT m FROM Menu m").getResultList();
		}
	
	
}
