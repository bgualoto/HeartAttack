package com.entities.consulta;
import java.io.Serializable;
import java.sql.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQuery;
import javax.persistence.Table;


@Entity
@Table(name="tb_auditoria",catalog="bd_consulta",schema="auditoria")
@NamedQuery(name = "Auditoria.listarT", query = "SELECT a FROM Auditoria a")

public class Auditoria implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)

	@Column(name="id_aud")
	private int auditoria;
	
	@Column(name="tabla_aud")
	private String tabla;
	
	@Column(name="operacion_aud")
	private String accion;	
	
	@Column(name="valoranterior_aud")
	private String valoranterior;
	
	@Column(name="valornuevo_aud")
	private String valornuevo;
	
	@Column(name="fecha_aud")
	private Date fechaaud;
	
	@Column(name="usuario_aud")
	private String usuario;
	


	public Auditoria() {
		super();
		// TODO Auto-generated constructor stub
	}

	public int getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(int auditoria) {
		this.auditoria = auditoria;
	}

	public String getTabla() {
		return tabla;
	}

	public void setTabla(String tabla) {
		this.tabla = tabla;
	}

	public String getAccion() {
		return accion;
	}

	public void setAccion(String accion) {
		this.accion = accion;
	}

	public String getValoranterior() {
		return valoranterior;
	}

	public void setValoranterior(String valoranterior) {
		this.valoranterior = valoranterior;
	}

	public String getValornuevo() {
		return valornuevo;
	}

	public void setValornuevo(String valornuevo) {
		this.valornuevo = valornuevo;
	}

	public Date getFechaaud() {
		return fechaaud;
	}

	public void setFechaaud(Date fechaaud) {
		this.fechaaud = fechaaud;
	}

	public String getUsuario() {
		return usuario;
	}

	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}

	
	
}
