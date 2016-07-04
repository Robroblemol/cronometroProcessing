import grafica.*;//libreria serial
import processing.serial.*;//

 GPlot plot; // declaro objeto grafica
 GPlot plot1; // declaro objeto grafica
 Serial myPort;// declaro pbjeto puerto serie 
int nPoints = 6; // numero de puntos tipo entero
//variables String para almacenar los datos enviados por el arduino
String Cad,anCad=" ",TF="1",AF="10",TT= "00:00:000",TP="",V= "0.000",A = "0.000";
// indicadores para tipo de medicion Velovidad o Aceleracion
boolean flagdatV =false,flagdatA = false;
char lastC,startC;// variables para almacenar el ultimo caracter y el primero
public PShape star;
GPointsArray points = new GPointsArray(nPoints);// declaramos el array de puntos
GPointsArray points1 = new GPointsArray(nPoints);
void setup(){
  
  size(1050,650);// tamaño en pantalla de la aplicacion
  
  String portName = Serial.list()[0]; 
  printArray(Serial.list());
  myPort = new Serial(this, portName, 9600);  
  
  plot = new GPlot(this);// creamos la grafica
  plot.setPos(50, 300);//ajustamos la posicion
  plot.setDim(350, 225);//dimencion de la ventana
  plot.getTitle().setText("x s t");//titulo de grafico
  plot.getXAxis().getAxisLabel().setText("t(s)");//titulo eje X
  plot.getYAxis().getAxisLabel().setText("x(m)");//titulo eje Y

  plot.activatePointLabels();
  
   plot1 = new GPlot(this);// creamos la grafica
  plot1.setPos(550, 300);//ajustamos la posicion
  plot1.setDim(350, 225);//dimencion de la ventana
  plot1.getTitle().setText("v s t");//titulo de grafico
  plot1.getXAxis().getAxisLabel().setText("t (s)");//titulo eje X
  plot1.getYAxis().getAxisLabel().setText("v (m/s)");//titulo eje Y

  plot1.activatePointLabels();
   // plot.activateZooming(1.5); // activamos zoom con el mouse
}

void draw(){
  background(162,160,160);
  if(myPort.available()>1){
    Cad=myPort.readString();
    anCad+=Cad;
    //println (""+anCad);
    lastC=anCad.charAt(anCad.length()-1);//comparamos el final de la trama
    if(lastC=='%'){
      flagdatV = true;
    }else if (lastC=='!'){
      flagdatA = true;
    }
  }
   // println (""+Cad);
  if(flagdatV == true){
    println (anCad); 
    println (anCad.charAt(1));
    flagdatV = false;
    startC=anCad.charAt(1);
    datoVelocidad(startC);
  }
  if(flagdatA == true){
    println (anCad); 
   // println (anCad.charAt(1));
    flagdatA = false;
    startC=anCad.charAt(1);
    datoAceleracion(startC);
  }
    //println("startC: "+startC);
    color c = color (0);
    fill (c);
    textSize(55);
    text("Cronometro de Laboratorio",148,100);
    textSize(20);
    text("Total de Fanjas: "+TF,220,179);
    text("Ancho de Fanjas: "+AF+" mm",220,214);
    text("Tiempo Total: "+TT,533,179);
    text("Velocidad: "+V+" m/s",533,214);
    text("Aceleracion: "+A+"m/s",220,247);
    
     //plot.defaultDraw();
    plot.beginDraw();
    plot.drawBackground();
    plot.drawBox();
    plot.drawXAxis();
    plot.drawYAxis();
    plot.drawTitle();
    plot.drawGridLines(GPlot.BOTH);
    plot.drawLines();
    plot.drawPoints();
    plot.endDraw();
    
        plot1.beginDraw();
    plot1.drawBackground();
    plot1.drawBox();
    plot1.drawXAxis();
    plot1.drawYAxis();
    plot1.drawTitle();
    plot1.drawGridLines(GPlot.BOTH);
    plot1.drawLines();
    plot1.drawPoints();
    plot1.endDraw();
    //println (""+Cad);
    
}