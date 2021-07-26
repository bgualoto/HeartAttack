package com.daos.consulta;

import java.util.List;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

import com.entities.consulta.Consulta;

@Stateless
public class ConsultaDao {

	@PersistenceContext
	private EntityManager em;

	public void crear(Consulta persona) {
		em.persist(persona);
		em.refresh(persona);
	}

	public Consulta actualizar(Consulta persona) {
		return em.merge(persona);
	}

	public void borrar(Integer codigo) {
		Consulta persona = em.find(Consulta.class, codigo);
		em.remove(persona);
	}

	public Consulta buscar(Integer codigo) {
		return em.find(Consulta.class, codigo);
	}

	public List<Consulta> listar() {
		return em.createQuery("SELECT p FROM Consulta p order by id_per").getResultList();
	}

	public List<Consulta> buscarPorCiudad() {
		TypedQuery<Consulta> consulta = em.createNamedQuery("Consulta.buscarPorCiudad", Consulta.class);
		return consulta.getResultList();
	}

	public List<Consulta> buscarPorEdad() {
		TypedQuery<Consulta> consulta = em.createNamedQuery("Consulta.buscarPorEdad", Consulta.class);
		return consulta.getResultList();
	}

	public List<Consulta> obtenerTodas() {
		TypedQuery<Consulta> consulta = em.createNamedQuery("Consulta.listarTodos", Consulta.class);
		return consulta.getResultList();
	}

}
