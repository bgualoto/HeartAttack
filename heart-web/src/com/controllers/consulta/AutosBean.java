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
	
	private List<Consulta> due�os;
	
	private int a�o;
	private String placa;
	private Consulta due�o;
	
	
	@EJB
	private AutoDao autoDao;
	
	public List<Auto> getAutos() {
		return autoDao.listar();
	}
	
	@EJB
	private ConsultaDao personaDao;
	
	public int getA�o() {
		return a�o;
	}

	public void setA�o(int anio) {
		this.a�o = anio;
	}

	public String getPlaca() {
		return placa;
	}

	public void setPlaca(String placa) {
		this.placa = placa;
	}

	public Consulta getDue�o() {
		return due�o;
	}

	public void setDue�o(Consulta duenio) {
		this.due�o = duenio;
	}
	
	
	
	public void setDue�os(List<Consulta> duenios) {
		this.due�os = duenios;
	}

	public List<Consulta> getDue�os(){
		return due�os;
	}
	
	@PostConstruct
	public void inicializar() {
		due�os = personaDao.listar();
	}
	
	
	public String registrar() {
		Auto nuevo = new Auto();		
		nuevo.setDue�o(due�o);
		nuevo.setAnio(a�o);
		nuevo.setPlaca(placa);
		autoDao.crear(nuevo);
		return "registrado";
	}
	
	
	
}
