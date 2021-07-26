package com.controllers.consulta;

import java.io.Serializable;

import java.util.List;

import javax.ejb.EJB;
import javax.enterprise.context.RequestScoped;
import javax.inject.Named;

import com.daos.consulta.ConsultaDao;
import com.entities.consulta.Consulta;

@Named("ciudad")
@RequestScoped
public class PersonaCiudadBean implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@EJB
	private ConsultaDao personaDao;
	
	public List<Consulta> getPersonas() {
		return personaDao.buscarPorCiudad();
	}
}
