package com.controllers.consulta;

import java.io.Serializable;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import javax.ejb.EJB;
import javax.enterprise.context.RequestScoped;
import javax.inject.Named;

import org.primefaces.model.chart.Axis;
import org.primefaces.model.chart.AxisType;
import org.primefaces.model.chart.BarChartModel;
import org.primefaces.model.chart.ChartSeries;

import com.daos.consulta.AutoDao;
import com.daos.consulta.ConsultaDao;
import com.entities.consulta.Auto;
import com.entities.consulta.Consulta;
import com.entities.consulta.ReporteAuto;

@Named("panel")
@RequestScoped
public class PanelBean implements Serializable {
	/**
	* 
	*/
	private static final long serialVersionUID = 1L;
	@EJB
	private ConsultaDao personaDao;
	private List<Consulta> reporte = null;

	private ChartSeries reporte2;
	private BarChartModel barModel, barModelAuto;

	public BarChartModel getBarModel() {
		return barModel;
	}

	
	public List<Consulta> getPersonas() {
		reporte = personaDao.obtenerTodas();
		crearBarModel();
		return reporte;
	}

	private BarChartModel initBarModel() {
		BarChartModel model = new BarChartModel();
		reporte2 = new ChartSeries();
		reporte2.setLabel("Personas");
		for (Consulta cData : reporte) {
			reporte2.set(cData.getNombre(), cData.getEdad());
		}
		model.addSeries(reporte2);
		return model;
	}

	private void crearBarModel() {
		barModel = initBarModel();
		barModel.setTitle("Personas y Edad"); // corresponde al título
		barModel.setLegendPosition("ne"); // ubicación de los títulos
		Axis xAxis = barModel.getAxis(AxisType.X); // definir los datos del eje x
		xAxis.setLabel("Personas");
		Axis yAxis = barModel.getAxis(AxisType.Y); // definer los datos del eje y
		yAxis.setLabel("Edad");
		yAxis.setMin(0); // establecer los valores mínimo y máximo
		yAxis.setMax(50);
	}


	// METODO AUTO
	
	private  List<Object[]> reporteAuto = null;
	@EJB
	private AutoDao autosDao;

	public BarChartModel getBarModelAuto() {
		return barModelAuto;
	}
	
	
	public  List<Auto> getAutos() {
		reporteAuto = autosDao.obtenerAutos();
		List<Auto> listAuto = new ArrayList<Auto>();
		for (Object[] row : reporteAuto) {
			Auto resp = new Auto();
			resp.setDueño(new Consulta());
			resp.getDueño().setNombre((String) row[0]);
			resp.setNumeroAutos( (BigInteger) row[1]);
			listAuto.add(resp);
			}
		crearBarModelAuto();
		return listAuto;
	}

	private BarChartModel initBarModelAuto() {
		BarChartModel model = new BarChartModel();
		
		reporte2 = new ChartSeries();
		reporte2.setLabel("Personas");
		for (Object[] row : reporteAuto) {
		reporte2.set((String) row[0], (BigInteger) row[1]);
		}
		model.addSeries(reporte2);
		return model;
	}
	
	private void crearBarModelAuto() {
		barModelAuto = initBarModelAuto();
		barModelAuto.setTitle("Personas y Autos"); // corresponde al título
		barModelAuto.setLegendPosition("ne"); // ubicación de los títulos
		Axis xAxis = barModelAuto.getAxis(AxisType.X); // definir los datos del eje x
		xAxis.setLabel("Personas");
		Axis yAxis = barModelAuto.getAxis(AxisType.Y); // definer los datos del eje y
		yAxis.setLabel("Autos");
		yAxis.setMin(0); // establecer los valores mínimo y máximo
		yAxis.setMax(10);
	}
	
	

	
	

}