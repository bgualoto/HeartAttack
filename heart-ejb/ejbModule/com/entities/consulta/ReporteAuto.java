package com.entities.consulta;

import java.io.Serializable;
import java.lang.String;
import java.util.Date;
import javax.persistence.*;



public class ReporteAuto implements Serializable {


	private String nombre;
	
	private long numeroAutos;

	
	private static final long serialVersionUID = 1L;

	public ReporteAuto() {
		super();
	}   

	
	public long getNumeroAutos() {
		return numeroAutos;
	}
	public void setNumeroAutos(long numeroAutos) {
		this.numeroAutos = numeroAutos;
	}
	
	
	public String getNombre() {
		return nombre;
	}
	
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	
	
	
	
   
	
}
