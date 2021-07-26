package com.daos.consulta;

import java.util.List;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

import com.entities.consulta.Auditoria;
import com.entities.consulta.Consulta;

@Stateless
public class AuditoriaDao {
	@PersistenceContext
	private EntityManager em;
	

	public List<Auditoria> listarT() {
		TypedQuery<Auditoria> consulta = em.createNamedQuery("Auditoria.listarT", Auditoria.class);
		return consulta.getResultList();
	}
}

