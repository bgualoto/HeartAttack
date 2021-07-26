package com.controllers.consulta;
import java.io.Serializable;
import java.util.List;
import javax.ejb.EJB;
import javax.enterprise.context.SessionScoped;
import javax.inject.Named;

import com.daos.consulta.AuditoriaDao;
import com.daos.consulta.ConsultaDao;
import com.entities.consulta.Auditoria;
import com.entities.consulta.Consulta;

@Named("auditoria")
@SessionScoped


public class AuditoriaBean implements Serializable {

	/**
	*
	*/
	private static final long serialVersionUID = 1L;

	@EJB
	private AuditoriaDao consultaDao;

	public List<Auditoria> getConsultas() {
		return consultaDao.listarT();
	}
}