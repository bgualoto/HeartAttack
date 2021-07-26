package com.entities.consulta;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;


@Entity
@Table(name="tb_usuario",catalog="bd_consulta",schema="public")
@NamedQueries({
@NamedQuery(name = "Consulta.buscarPorCiudad", query = "SELECT p FROM Consulta p WHERE p.ciudad='Quito'"),
@NamedQuery(name = "Consulta.buscarPorEdad", query = "SELECT p FROM Consulta p WHERE p.edad>=25"),
@NamedQuery(name = "Consulta.listarTodos", query = "SELECT p FROM Consulta p WHERE p.edad>=25")

}) 

public class Consulta implements Serializable {

	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)

	@Column(name="id_per")
	private int identificacion;
	
	@Column(name="nombre_per")
	private String nombre;
	
	@Column(name="ciudad_per")
	private String ciudad;	
	
	@Column(name="edad_per")
	private int edad;
	
	@Column(name="correo_per")
	private String correo;
	
	@Column(name="clave_per")
	private String clave;
	
	@Column(name="estadocivil_per")
	private String estadoCivil;
	
	//BARRA
	@OneToMany(fetch = FetchType.EAGER, mappedBy ="dueño")
	private List<Auto> autos;

	
	public Consulta() {
		super();
	}   
	
	
	private static final long serialVersionUID = 1L;
	

	public int getIdentificacion() {
		return this.identificacion;
	}

	public void setIdentificacion(int identificacion) {
		this.identificacion = identificacion;
	}   
	public String getNombre() {
		return this.nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}   
	
	public int getEdad() {
		return this.edad;
	}

	public void setEdad(int edad) {
		this.edad = edad;
	}
	
	public String getCorreo() {
		return correo;
	}
	public void setCorreo(String correo) {
		this.correo = correo;
	}
	public String getCiudad() {
		return ciudad;
	}
	public void setCiudad(String ciudad) {
		this.ciudad = ciudad;
	}
	public String getClave() {
		return clave;
	}
	public void setClave(String clave) {
		this.clave = clave;
	}
	
	public String getEstadoCivil() {
		return estadoCivil;
	}
	public void setEstadoCivil(String estadoCivil) {
		this.estadoCivil = estadoCivil;
	}

	
	
}
