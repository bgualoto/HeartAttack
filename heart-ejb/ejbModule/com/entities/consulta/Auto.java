package com.entities.consulta;

import java.io.Serializable;

import java.lang.String;
import java.math.BigInteger;
import java.util.Date;
import javax.persistence.*;

/**
 * Entity implementation class for Entity: Auto
 *
 */
@Entity
@Table(name="tb_auto",catalog="bd_consulta",schema="public")


@NamedQueries({
@NamedQuery(name = "listarAutos", query = "SELECT a FROM Auto a "),

//@NamedQuery(name = "Auto.listarNumAutoPropietario", query = "SELECT p.nombre, count(*) as numero_de_autos from Auto a,Consulta p where a.dueño= p.identificacion group by  p.nombre ")                                                                               
//@NamedQuery(name = "Auto.listarNumAutoPropietario", query = "SELECT p FROM Auto p WHERE p.placa_auto='POKL-2732' "),

@NamedQuery(name = "Auto.listarTodos", query = "SELECT p FROM Auto p WHERE p.placa='PUI-3621'")


}) 


public class Auto implements Serializable {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	
	@Column(name="id_auto")
	private int codigoAuto;
	
	@Column(name="anio_auto")
	private int anio;
	
	@Column(name="placa_auto")
	private String placa;
	
	@ManyToOne
	@JoinColumn(name="id_per")
	private Consulta dueño;
	
	@Transient
	private BigInteger numeroAutos;
	
	@Transient
	private String nombre;
	
	
	//barra
	@ManyToOne
	@JoinColumn(name="id_persona")

	//private Persona dueño;	
	
	private static final long serialVersionUID = 1L;

	public Auto() {
		super();
	}   
	public int getCodigoAuto() {
		return this.codigoAuto;
	}

	public void setCodigoAuto(int codigoAuto) {
		this.codigoAuto = codigoAuto;
	}   
	
	
	
	
	

	public int getAnio() {
		return anio;
	}




	public void setAnio(int anio) {
		this.anio = anio;
	}


	public String getPlaca() {
		return this.placa;
	}

	public void setPlaca(String placa) {
		this.placa = placa;
	}   
	
	public Consulta getDueño() {
		return this.dueño;
	}

	public void setDueño(Consulta dueño) {
		this.dueño = dueño;
	}
	
	
	public BigInteger getNumeroAutos() {
		return numeroAutos;
	}
	public void setNumeroAutos(BigInteger numeroAutos) {
		this.numeroAutos = numeroAutos;
	}
	
	
	public String getNombre() {
		return nombre;
	}
	
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	
	
	
	
   
	
}
