package com.entities.consulta;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Transient;

@Entity
@Table(name="tb_usuariolog",catalog="bd_consulta",schema="public")

/*@NamedQueries({
@NamedQuery(name = "Consulta.buscarPorCiudad", query = "SELECT p FROM Consulta p WHERE p.ciudad='Quito'")
}) */


public class Usuario implements Serializable {

	private static final long serialVersionUID = 1L;
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	
	@Column(name="id_us")
	private int codigo;
	@Column(name="correo_us")
	private String correo;
	@Column(name="clave_us")
	private String clave;
	@Column(name="estado_us")
	private boolean estado;
	
	
	
	@Column(name="id_per")
	private int dueño;
	
	

	public int getDueño() {
		return dueño;
	}

	public void setDueño(int dueño) {
		this.dueño = dueño;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	@Transient
	private String nombre;
	
	@ManyToOne
	@JoinColumn(name="id_rol")
	private Rol rol;

	public int getCodigo() {
		return codigo;
	}

	public void setCodigo(int codigo) {
		this.codigo = codigo;
	}

	public String getCorreo() {
		return correo;
	}

	public void setCorreo(String correo) {
		this.correo = correo;
	}

	public String getClave() {
		return clave;
	}

	public void setClave(String clave) {
		this.clave = clave;
	}

	public boolean isEstado() {
		return estado;
	}

	public void setEstado(boolean estado) {
		this.estado = estado;
	}

	



	public Rol getRol() {
		return rol;
	}

	public void setRol(Rol rol) {
		this.rol = rol;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
	
	
}
