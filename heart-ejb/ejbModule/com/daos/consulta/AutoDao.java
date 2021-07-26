package com.daos.consulta;

import java.util.List;


import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import com.entities.consulta.Auto;
import com.entities.consulta.ReporteAuto;



@Stateless
public class AutoDao {

	@PersistenceContext
	private EntityManager em;
	
	
	
	public void crear(Auto auto)
	{
		em.persist(auto);
		em.refresh(auto);
		
	}
	public Auto actualizar(Auto auto) {
		return em.merge(auto);
		}
	
	public void borrar(Integer codigo) {
		Auto auto = em.find(Auto.class, codigo);
		em.remove(auto);
		}
	
	public Auto buscar(Integer codigo) {
		return em.find(Auto.class, codigo);
		}
	 
    public List<Auto> listar() {
		return em.createQuery("SELECT a FROM Auto a ").getResultList();
	}
    
	/*public List<Auto> obtenerNumAutoPropietario() {
		TypedQuery<Auto> consulta = em.createNamedQuery("Auto.listarNumAutoPropietario", Auto.class);
		return consulta.getResultList();
	}*/
	
	/*public List<Auto> obtenerAutos() {
		TypedQuery<Auto> consulta = em.createNamedQuery("Auto.listarTodos", Auto.class);
		return consulta.getResultList();
	}*/
	
	public List<Object[]> obtenerAutos() {
		
		Query q = em.createNativeQuery("SELECT nombre_per, count(*) as numero_de_autos \r\n"
				+ "from tb_Auto ,tb_usuario \r\n"
				+ "where tb_usuario.id_per= tb_auto.id_per\r\n"
				+ "group by nombre_per");
		List<Object[]> usuarioRes = q.getResultList();
		
    	return usuarioRes;

	}
	
   
	
}


