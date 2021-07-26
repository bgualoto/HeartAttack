package com.controllers.consulta;

import java.io.Serializable;
import java.util.List;
import javax.ejb.EJB;
import javax.enterprise.context.SessionScoped;
import javax.inject.Named;
import com.daos.consulta.ConsultaDao;
import com.entities.consulta.Consulta;

@Named("consultas")
@SessionScoped


public class ConsultaBean implements Serializable {

	/**
	*
	*/
	private static final long serialVersionUID = 1L;

	@EJB
	private ConsultaDao consultaDao;

	public List<Consulta> getConsultas() {
		return consultaDao.listar();
	}
}
