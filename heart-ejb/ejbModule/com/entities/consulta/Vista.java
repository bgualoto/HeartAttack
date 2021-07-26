package com.entities.consulta;

import java.io.Serializable;
import java.sql.Date;
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
@Table(name="dim_report",catalog="bd_consulta",schema="public")


public class Vista implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)

	@Column(name="pk_report")
	private int pkreport;
	
	@Column(name="dolor_pecho")
	private int dolorpecho;
	
	@Column(name="presion_art")
	private int presion;	
	
	@Column(name="colesterol")
	private int colesterol;	
	
	@Column(name="azucar_sangre")
	private int asangre;	
	
	@Column(name="result_elect")
	private int result;
	
	@Column(name="frec_cardiaca")
	private int fcardiaca;
	
	@Column(name="angina_inducida")
	private int angina;
	
	@Column(name="pico_anterior")
	private int pico;
	
	@Column(name="tasa_tal")
	private int tasa;
	
	@Column(name="variable_objetivo")
	private int variable;
	
	@Column(name="fecha_diagnostico")
	private Date fechadiag;	
	
	@Column(name="edad")
	private int edad;	
	
	@Column(name="genero")
	private int genero;	
	
	@Column(name="saturacion")
	private int saturacion;
	
	@Column(name="buques")
	private int buques;
	
	@Column(name="pendiente")
	private int pendiente;
	
	@Column(name="anio")
	private double anio;	
	
	@Column(name="trimestre")
	private double trimestre;
	
	@Column(name="mes")
	private double mes;
	
	@Column(name="dia")
	private double dia;
	
	@Column(name="fecha")
	private Date fecha;
	
	@Column(name="semestre")
	private double semestre;
	
	@Column(name="nombre_semestre")
	private String nsemestre;	
	
	@Column(name="nombre_trimestre")
	private String ntrimestre;
	
	@Column(name="nombre_mes")
	private String nmes;

	public Vista() {
		super();
		// TODO Auto-generated constructor stub
	}

	public int getPkreport() {
		return pkreport;
	}

	public void setPkreport(int pkreport) {
		this.pkreport = pkreport;
	}

	public int getDolorpecho() {
		return dolorpecho;
	}

	public void setDolorpecho(int dolorpecho) {
		this.dolorpecho = dolorpecho;
	}

	public int getPresion() {
		return presion;
	}

	public void setPresion(int presion) {
		this.presion = presion;
	}

	public int getColesterol() {
		return colesterol;
	}

	public void setColesterol(int colesterol) {
		this.colesterol = colesterol;
	}

	public int getAsangre() {
		return asangre;
	}

	public void setAsangre(int asangre) {
		this.asangre = asangre;
	}

	public int getResult() {
		return result;
	}

	public void setResult(int result) {
		this.result = result;
	}

	public int getFcardiaca() {
		return fcardiaca;
	}

	public void setFcardiaca(int fcardiaca) {
		this.fcardiaca = fcardiaca;
	}

	public int getAngina() {
		return angina;
	}

	public void setAngina(int angina) {
		this.angina = angina;
	}

	public int getPico() {
		return pico;
	}

	public void setPico(int pico) {
		this.pico = pico;
	}

	public int getTasa() {
		return tasa;
	}

	public void setTasa(int tasa) {
		this.tasa = tasa;
	}

	public int getVariable() {
		return variable;
	}

	public void setVariable(int variable) {
		this.variable = variable;
	}

	public Date getFechadiag() {
		return fechadiag;
	}

	public void setFechadiag(Date fechadiag) {
		this.fechadiag = fechadiag;
	}

	public int getEdad() {
		return edad;
	}

	public void setEdad(int edad) {
		this.edad = edad;
	}

	public int getGenero() {
		return genero;
	}

	public void setGenero(int genero) {
		this.genero = genero;
	}

	public int getSaturacion() {
		return saturacion;
	}

	public void setSaturacion(int saturacion) {
		this.saturacion = saturacion;
	}

	public int getBuques() {
		return buques;
	}

	public void setBuques(int buques) {
		this.buques = buques;
	}

	public int getPendiente() {
		return pendiente;
	}

	public void setPendiente(int pendiente) {
		this.pendiente = pendiente;
	}

	public double getAnio() {
		return anio;
	}

	public void setAnio(double anio) {
		this.anio = anio;
	}

	public double getTrimestre() {
		return trimestre;
	}

	public void setTrimestre(double trimestre) {
		this.trimestre = trimestre;
	}

	public double getMes() {
		return mes;
	}

	public void setMes(double mes) {
		this.mes = mes;
	}

	public double getDia() {
		return dia;
	}

	public void setDia(double dia) {
		this.dia = dia;
	}

	public Date getFecha() {
		return fecha;
	}

	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}

	public double getSemestre() {
		return semestre;
	}

	public void setSemestre(double semestre) {
		this.semestre = semestre;
	}

	public String getNsemestre() {
		return nsemestre;
	}

	public void setNsemestre(String nsemestre) {
		this.nsemestre = nsemestre;
	}

	public String getNtrimestre() {
		return ntrimestre;
	}

	public void setNtrimestre(String ntrimestre) {
		this.ntrimestre = ntrimestre;
	}

	public String getNmes() {
		return nmes;
	}

	public void setNmes(String nmes) {
		this.nmes = nmes;
	}
	
	
}
	