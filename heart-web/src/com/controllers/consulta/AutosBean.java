package com.controllers.consulta;

import java.io.Serializable;




import java.util.List;

import javax.annotation.PostConstruct;
import javax.ejb.EJB;
import javax.enterprise.context.SessionScoped;
import javax.inject.Named;

import com.daos.consulta.AutoDao;
import com.daos.consulta.ConsultaDao;
import com.entities.consulta.Auto;
import com.entities.consulta.Consulta;




@Named("autos")
@SessionScoped
public class AutosBean implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private List<Consulta> dueños;
	
	private int año;
	private String placa;
	private Consulta dueño;
	
	
	@EJB
	private AutoDao autoDao;
	
	public List<Auto> getAutos() {
		return autoDao.listar();
	}
	
	@EJB
	private ConsultaDao personaDao;
	
	public int getAño() {
		return año;
	}

	public void setAño(int anio) {
		this.año = anio;
	}

	public String getPlaca() {
		return placa;
	}

	public void setPlaca(String placa) {
		this.placa = placa;
	}

	public Consulta getDueño() {
		return dueño;
	}

	public void setDueño(Consulta duenio) {
		this.dueño = duenio;
	}
	
	
	
	public void setDueños(List<Consulta> duenios) {
		this.dueños = duenios;
	}

	public List<Consulta> getDueños(){
		return dueños;
	}
	
	@PostConstruct
	public void inicializar() {
		dueños = personaDao.listar();
	}
	
	
	public String registrar() {
		Auto nuevo = new Auto();		
		nuevo.setDueño(dueño);
		nuevo.setAnio(año);
		nuevo.setPlaca(placa);
		autoDao.crear(nuevo);
		return "registrado";
	}
	
	
	
}
