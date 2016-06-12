import grafica.*;//libreria serial
import processing.serial.*;//

 GPlot plot; // declaro objeto grafica
 Serial myPort;// declaro pbjeto puerto serie 
int nPoints = 6; // numero de puntos tipo entero
//variables String para almacenar los datos enviados por el arduino
String Cad,anCad=" ",TF="1",AF="10",TT= "00:00:000",TP="",V= "0.000",A = "0.000";
// indicadores para tipo de medicion Velovidad o Aceleracion
boolean flagdatV =false,flagdatA = false;
char lastC,startC;// variables para almacenar el ultimo caracter y el primero
public PShape star;
GPointsArray points = new GPointsArray(nPoints);// declaramos el array de puntos

void setup(){
  
  size(850,650);// tamaño en pantalla de la aplicacion
  
  String portName = Serial.list()[0]; 
 // printArray(Serial.list());
  myPort = new Serial(this, portName, 9600);  
  
  plot = new GPlot(this);// creamos la grafica
  plot.setPos(360, 100);//ajustamos la posicion
  plot.setDim(350, 225);//dimencion de la ventana
  plot.getTitle().setText("m s t");//titulo de grafico
  plot.getXAxis().getAxisLabel().setText("t");//titulo eje X
  plot.getYAxis().getAxisLabel().setText("m/s");//titulo eje Y

    plot.activateZooming(1.5); // activamos zoom con el mouse
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
    textSize(20);
    text("Total de Fanjas: "+TF,50,150);
    text("Ancho de Fanjas: "+AF+" mm",50,180);
    text("Tiempo Total: "+TT,50,210);
    text("Velocidad: "+V+" m/s",50,240);
    text("Aceleracion: "+A+"m/s",50,270);
    
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
    //println (""+Cad);
    
}