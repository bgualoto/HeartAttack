package com.entities.consulta;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

@Entity
@Table(name="tb_rol",catalog="bd_consulta",schema="public")



public class Rol implements Serializable{
	
	public Rol() {
		super();
	}   
	
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)

	@Column(name="id_rol")
	private int rols;
	
	@Column(name="descripcion_rol")
	private String descripcion;
	
	private static final long serialVersionUID = 1L;

	public int getRols() {
		return rols;
	}

	public void setRols(int rols) {
		this.rols = rols;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}


	

}
