import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import grafica.*; 
import processing.serial.*; 
import static javax.swing.JOptionPane.*; 
import g4p_controls.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Cronometro extends PApplet {

//libreria grafica
//libreria serial
//mensajes emergentes
//importamos libreria

 GPlot plot; // declaro objeto grafica
 GPlot plot1; // declaro objeto grafica
 Serial myPort;// declaro pbjeto puerto serie
int nPoints = 6; // numero de puntos tipo entero
//variables String para almacenar los datos enviados por el arduino
String Cad,anCad=" ",TF="1",AF="10",TT= "00:00:000",TP="",V= "0.000",A = "0.000";
// indicadores para tipo de medicion Velovidad o Aceleracion
boolean flagdatV =false,flagdatA = false;
final boolean debug = true;
char lastC,startC;// variables para almacenar el ultimo caracter y el primero
public PShape star;
GPointsArray points = new GPointsArray(nPoints);// declaramos el array de puntos
GPointsArray points1 = new GPointsArray(nPoints);
// agregamos boton para salvar los datos en .CSV
GButton bSalvar = new GButton(this,340,45,100,35,"Salvar");
//bSalvar.fireAllEvents(true);
Table tabla;// declaro objeto tipo tabla
TableRow newRow;

public void setup(){
  String COMx,COMlist = "";
  // tama\u00f1o en pantalla de la aplicacion

  try{
  if(debug) printArray(Serial.list());
  int i = Serial.list().length;
    if (i != 0) {
      if (i >= 2) {
        //si tenemos mas de un puerto
        for (int j = 0; j < i;) {// guardamos en el String el nombre de cada COM
          COMlist += PApplet.parseChar(j+'a') + " = " + Serial.list()[j];
          if (++j < i) COMlist += ",  ";
        }
        //solicitamos al usuario elegir el puerto a usar
        COMx = showInputDialog("\u00bfA que puerto se desea conectar? (a,b,..):\n"+COMlist);
        if (COMx == null) exit();//si no escribo nada cierra aplicacion
        if (COMx.isEmpty()) exit();
        //Convertimos a entero
        //lo que se hace es quitarle el
        //valor de letra en string
        i = PApplet.parseInt(COMx.toLowerCase().charAt(0) - 'a') + 1;
      }
      String portName = Serial.list()[i-1];// asignamos el nombre de puerto
      if(debug) println(portName);
      myPort = new Serial(this, portName, 9600); // asignamos velocidad de tranferencia
      myPort.bufferUntil('\n'); //Borramos el buffer de recepcion
    }
    else {
      showMessageDialog(frame,"El dispocitivo no esta conectado al PC");
      exit();
    }
  }
  catch (Exception e){
    showMessageDialog(frame,"Puerto COM no disponible");
    println("Error:", e);
    exit();
  }

  plot = new GPlot(this);// creamos la grafica
  plot.setPos(50, 300);//ajustamos la posicion
  plot.setDim(350, 225);//dimencion de la ventana
  plot.getTitle().setText("x(t) vs t");//titulo de grafico
  plot.getXAxis().getAxisLabel().setText("t(s)");//titulo eje X
  plot.getYAxis().getAxisLabel().setText("x(m)");//titulo eje Y
 //plot.getXAxis().setNTicks(10);
  //plot.activatePanning();
  plot.activatePointLabels();
  //plot.activateZooming(1.5);

   plot1 = new GPlot(this);// creamos la grafica
  plot1.setPos(550, 300);//ajustamos la posicion
  plot1.setDim(350, 225);//dimencion de la ventana
  plot1.getTitle().setText("v(t) vs t");//titulo de grafico
  plot1.getXAxis().getAxisLabel().setText("t (s)");//titulo eje X
  plot1.getYAxis().getAxisLabel().setText("v (m/s)");//titulo eje Y
  //plot1.activatePanning();
  plot1.activatePointLabels();
  //plot1.activateZooming(1.5); // activamos zoom con el mouse
}

public void draw(){
  background(162,160,160);// ajustamos color de fondo
  if(myPort.available()>1){// si el puerto serie esta habilido
    Cad=myPort.readString();//tomamos el nuevo valor en el puerto serie
    anCad+=Cad;// lo concatenamos a lo recivido anteriormente
    //println (""+anCad);
    lastC=anCad.charAt(anCad.length()-1);//comparamos el final de la trama
    if(lastC=='%'){// si es igual a %
      flagdatV = true;// los datos recividos son de velocidad
    }else if (lastC=='!'){// si es igual a !
      flagdatA = true;// los datos son de aceleracion
    }
  }
   // println (""+Cad);
  if(flagdatV == true){// si los datos son de velocidad
    println (anCad); // imprimimos datos por consola
    println (anCad.charAt(1));
    flagdatV = false;// flagdatv vuelve a falso
    startC=anCad.charAt(1);//sacamos el primer caracter del string
    datoVelocidad(startC);// lo enviamos a la funcion velocidad
  }
  if(flagdatA == true){//si los datos son de aceleracion
    println (anCad); //imprimimos datos por consola
   // println (anCad.charAt(1));
    flagdatA = false;//flagdatv vuelve a falso
    startC=anCad.charAt(1);//sacamos el primer caracter del string
    datoAceleracion(startC);//lo enviamos a la funcion velocidad
  }
    //println("startC: "+startC);
    int c = color (0);// variable de color para el texto
    fill (c);// lo que escibamos a partir de aqui tendr\u00e1 colo negro
    textSize(47);//asignamos tama\u00f1o del texto para el titulo
    text("Resultados y Gr\u00e1ficos de los Datos Medidos ",32,100);// titulo con su posicion
    textSize(20);// asignamos tama\u00f1o para el resto del texto
    text("Total de Fanjas Oscuras: "+TF,220,179);
    text("Ancho de Fanjas: "+AF+" mm",220,214);
    text("Tiempo Total: "+TT,533,179);
    text("Velocidad: "+V+" m/s",533,214);
    text("Aceleraci\u00f3n: "+A+"m/s",220,247);
    textSize(10);
    text("2",441,238);

     //plot.defaultDraw();
    plot.beginDraw();// iniciamos dibujo de grafica
    plot.drawBackground();// pintamos el fondo por defecto (blanco)
    plot.drawBox();//dibujamos la caja que nontiene la grafica
    plot.drawXAxis();// eje X
    plot.drawYAxis();// eje y
    plot.drawTitle();// titulo de grafico
    plot.drawGridLines(GPlot.BOTH);// grilla
    plot.drawLines();// uso de lineas
    plot.drawPoints();// uso de puntos
    plot.drawLabels();// pintamos la etiquetas
    plot.endDraw();// finaliza el dibujo de la grafica

    plot1.beginDraw();
    plot1.drawBackground();
    plot1.drawBox();
    plot1.drawXAxis();
    plot1.drawYAxis();
    plot1.drawTitle();
    plot1.drawGridLines(GPlot.BOTH);
    plot1.drawLines();
    plot1.drawPoints();
    plot1.drawLabels();
    plot1.endDraw();


}
public void handleButtonEvents(GButton Botton,GEvent event){
  String save = "new";
 if(Botton == bSalvar && event == GEvent.PRESSED){
   save = showInputDialog("Digite nombre para guardar datoss");
   saveTable(tabla,"data/"+save+".csv");
 }
}
public void datoAceleracion(char startC){
if(startC=='@'){
  
      //nPoints = 10;
       //plot.getYAxis().getAxisLabel().setText("m/s");//titulo eje Y
       //plot.defaultDraw();
       V="0.00";
       
          plot.setPoints(new GPointsArray());
          //(2,5)
          //(5,6)
      if(anCad.substring(2,4).equals("TF")==true){
        //TF=anCad.substring(4,5);
        TF=anCad.substring(4,6);
        if(PApplet.parseInt(TF)<10)
          TF=""+PApplet.parseInt(TF);//eliminamos el cero anterior
        //println("TF: "+TF);
      }
      
      nPoints = PApplet.parseInt (TF);
      nPoints=(nPoints*2)-1;
      GPointsArray pointsA = new GPointsArray(nPoints);
 

      if(anCad.substring(6,8).equals("AF")==true){
      //if(anCad.substring(5,7).equals("AF")==true){
        AF=anCad.substring(8,11);
        //AF=anCad.substring(7,9);
        if(PApplet.parseInt(AF)<100)
          AF=""+PApplet.parseInt(AF);//eliminamos el cero anterior
        //println("AF: "+AF);
      }
      if(anCad.substring(11,13).equals("TT")==true){
      //if(anCad.substring(9,11).equals("TT")==true){
        TT=anCad.substring(13,22);
        //TT=anCad.substring(11,20);
        //println("TT: "+TT);
      }
      //(23,25)
      //int = 22 
      int r=24;
      String axuCad;
      if(anCad.substring(22,24).equals("TP")==true){
      //if(anCad.substring(20,22).equals("TP")==true){
       //  prin  tln("Entre a TP");
        // println("length: "+anCad.length());
        for(int i = 0; i <= nPoints; i++){
   
              if(anCad.substring(r,(r+1)).equals("f")){
              TP="";
              r++;
              axuCad=anCad.substring(r,(r+1));
              while((axuCad.equals("f")!=true) && (axuCad.equals("A")!=true)){
                if(r<(anCad.length())-1){
                  TP=TP+anCad.substring(r,(r+1));
                }               
                r++;
                axuCad=anCad.substring(r,(r+1));
              }
              }
              //r++;
              //println("r: "+r); 
              //println("TP: "+TP);
              //r=r+9;
              
              pointsA.add(i,PApplet.parseFloat(TP));//agregamos como tipo float
              //points1.add()
      }
      }
      
  //    println(anCad.substring(r,(r+1)));
      if(anCad.substring(r,(r+1)).equals("A")){
        A="";
       println("Entre a A:");
       axuCad=anCad.substring(r,(r+1));
       r++;
       while((axuCad.equals("!")!=true)){
             A=A+anCad.substring(r,(r+1));
            axuCad=anCad.substring(r,(r+1));
            r++;
       }
       A=A.substring(0,(A.length()-1));
       println("A:"+A);
      }
      GPointsArray pointsX = new GPointsArray(nPoints);
      GPointsArray pointsV = new GPointsArray(nPoints);
      
      float t,x,v0,vi,vt,a = PApplet.parseFloat (A),h=(PApplet.parseFloat(AF)/1000);
      
      v0=((PApplet.parseFloat(AF)/1000)/((pointsA.getY(1)/1000)-(pointsA.getY(0)/1000)));
      //v0=(h/((pointsA.getY(1)/1000)/2));
      //v0=((float(AF))/(pointsA.getY(1)-pointsA.getY(0)));
      vi=((2*h)/(pointsA.getY(1)/1000));
      for (int i = 0; i <=nPoints; i++){
        t = pointsA.getY(i);
        t = t/1000;
        x=(((a*(t*t))/2)+v0*t);
        //vt=((a*t)+vi);
        vt=((a*t)+v0);
        //x=((float(AF)/1000)*i);
        x=redondear(x);
        vt=redondear(vt);
        pointsX.add(t,x,"t: "+t+", x: "+x);
        pointsV.add(t,vt,"t: "+t+", vt: "+vt);
        println("x: "+x+" t: "+t);
        //println(""+t);
      }
 /*     x=(float(AF)/1000);
     //calculo de velocidad
       for (int i = 1; i <nPoints; i++){
         //vt=(pointsX.getY(i-1)-pointsX.getY(i))/(pointsX.getX(i-1)-pointsX.getX(i));
         //vt=x/(pointsX.getX(i)-pointsX.getX(i-1));
         //vt=x/(((pointsX.getX(i)-pointsX.getX(i-1)))/2);
        
         vt=redondear(vt);
         pointsV.add(pointsX.getX(i-1),vt,"t: "+pointsX.getX(i-1)+", vt: "+vt);
          println("vt: "+vt+" t: "+pointsX.getX(i-1));    
     }*/
          
      plot1.setPoints(pointsV);
      plot.setPoints(pointsX);
      //points.removeRange(0,nPoints);   
      anCad=" ";
      startC=' ';
    }
}
public float redondear (float x){
 return round(x*1000.0f)/1000.0f;
}
public void datoVelocidad(char startC){
if(startC=='@'){
      nPoints = 10;
       //plot.getYAxis().getAxisLabel().setText("m/s");//titulo eje Y
       //plot.defaultDraw();
          plot.setPoints(new GPointsArray());
          GPointsArray points = new GPointsArray(nPoints);
          A="0.000";
          
      if(anCad.substring(2,4).equals("TF")==true){
        //(4,6)
        TF=anCad.substring(4,6);
        //TF=anCad.substring(4,5);
        //println("TF: "+TF);
      }
      
      //(6,9)
      if(anCad.substring(6,8).equals("AF")==true){
      //if(anCad.substring(5,7).equals("AF")==true){
        //(9,11)
        AF=anCad.substring(8,11);
        //AF=anCad.substring(7,9);
        //println("TF: "+TF);
      }
      //(10,12)
      if(anCad.substring(11,13).equals("TT")==true){
      //if(anCad.substring(9,11).equals("TT")==true){
        //(12,21)
        TT=anCad.substring(13,22);
        //TT=anCad.substring(11,20);
        //println("TF: "+TF);
      }
      //(21,22)
      if(anCad.substring(22,23).equals("V")==true){
       //if(anCad.substring(20,21).equals("V")==true){
         //(22,26)
         V=anCad.substring(23,28);
        //V=anCad.substring(21,26);
        //println("TF: "+TF);
      }
        GPointsArray pointsV = new GPointsArray(nPoints);
        String TFG=TT;
        TFG=(TFG.substring(6,(TFG.length())));
        float TF = PApplet.parseFloat(TFG)/1000;
        println("TFG: "+TF);
        points.add(0,0,"t: 0, v: 0");
        points.add(TF,PApplet.parseFloat(V),"t: "+TF+", v: "+V);//agregamos como tipo float
        pointsV.add(0,PApplet.parseFloat(V),"t: 0, v: "+V);
        pointsV.add(TF,PApplet.parseFloat(V),"t: "+TF+" v: "+V);
        
        
      plot.setPoints(points);
      plot1.setPoints(pointsV);
      //points.removeRange(0,1);
      anCad=" ";
      startC=' ';
    }
}
  public void settings() {  size(1050,650); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Cronometro" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
