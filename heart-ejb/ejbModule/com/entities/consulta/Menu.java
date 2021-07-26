package com.entities.consulta;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name="tb_menu",catalog="bd_consulta",schema="public")

public class Menu implements Serializable {
	
	private static final long serialVersionUID = 1L;
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name="id_men")
	private int codigo;
	@Column(name="nombre_men")
	private String menu;
	@Column(name="tipo_men")
	private String tipo;
	@ManyToOne
	@JoinColumn(name="submenu_men")
	private Menu submenu;
	@ManyToOne
	@JoinColumn(name="id_rol")
	private Rol rol;
	public int getCodigo() {
		return codigo;
	}
	public void setCodigo(int codigo) {
		this.codigo = codigo;
	}
	public String getMenu() {
		return menu;
	}
	public void setMenu(String menu) {
		this.menu = menu;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public Menu getSubmenu() {
		return submenu;
	}
	public void setSubmenu(Menu submenu) {
		this.submenu = submenu;
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
