import grafica.*;//libreria grafica
import processing.serial.*;//libreria serial
import static javax.swing.JOptionPane.*;//mensajes emergentes
import g4p_controls.*;//importamos libreria

 GPlot plot; // declaro objeto grafica
 GPlot plot1; // declaro objeto grafica
 Serial myPort;// declaro pbjeto puerto serie
 GButton bSalvar;
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
Table tabla;// declaro objeto tipo tabla
TableRow newRow;

void setup(){
  String COMx,COMlist = "";
  size(1050,650);// tamaño en pantalla de la aplicacion

  try{
  if(debug) printArray(Serial.list());
  int i = Serial.list().length;
    if (i != 0) {
      if (i >= 2) {
        //si tenemos mas de un puerto
        for (int j = 0; j < i;) {// guardamos en el String el nombre de cada COM
          COMlist += char(j+'a') + " = " + Serial.list()[j];
          if (++j < i) COMlist += ",  ";
        }
        //solicitamos al usuario elegir el puerto a usar
        COMx = showInputDialog("¿A que puerto se desea conectar? (a,b,..):\n"+COMlist);
        if (COMx == null) exit();//si no escribo nada cierra aplicacion
        if (COMx.isEmpty()) exit();
        //Convertimos a entero
        //lo que se hace es quitarle el
        //valor de letra en string
        i = int(COMx.toLowerCase().charAt(0) - 'a') + 1;
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
  // agregamos boton para salvar los datos en .CSV
  bSalvar = new GButton(this,540,225,100,35,"Salvar");
  bSalvar.fireAllEvents(true);

  tabla = new Table();// constructor of tabla Object
  tabla.addColumn("t(s)");
  tabla.addColumn("x(m)");//Add columns
  newRow = tabla.addRow();// add Row

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

void draw(){
  background(162,160,160);// ajustamos color de fondo
  // if(myPort.available()>1){// si el puerto serie esta habilido
    // Cad=myPort.readString();//tomamos el nuevo valor en el puerto serie
    // anCad+=Cad;// lo concatenamos a lo recivido anteriormente
    // println(anCad);
    // lastC=anCad.charAt(anCad.length()-1);//comparamos el final de la trama
  //   if(lastC=='2'){// si es igual a %
  //     flagdatV = true;// los datos recividos son de velocidad
  //     println("dato aceleracion detectado");
  //   }
  //   else if (lastC=='!'){// si es igual a !
  //     flagdatA = true;// los datos son de aceleracion
  //   }
  // }
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
    color c = color (0);// variable de color para el texto
    fill (c);// lo que escibamos a partir de aqui tendrá colo negro
    textSize(47);//asignamos tamaño del texto para el titulo
    text("Resultados y Gráficos de los Datos Medidos ",32,100);// titulo con su posicion
    textSize(20);// asignamos tamaño para el resto del texto
    text("Total de Fanjas Oscuras: "+TF,220,179);
    text("Ancho de Fanjas: "+AF+" mm",220,214);
    text("Tiempo Total: "+TT,533,179);
    text("Velocidad: "+V+" m/s",533,214);
    text("Aceleración: "+A+"m/s",220,247);
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
void handleButtonEvents(GButton Botton,GEvent event){
  String save = "new";
 if(Botton == bSalvar && event == GEvent.PRESSED){
   save = showInputDialog("Digite nombre para guardar datoss");
   saveTable(tabla,"data/"+save+".csv");
 }
}
String comCadTF= "Total",numS = "",comCadAF="Ancho",comCadTT="Tiemp",comCadA = "Acele";
int tf = 100,af = 0,tt =0;
float a =0;
void serialEvent(Serial p) {
  try {
    Cad=myPort.readString();//tomamos el nuevo valor en el puerto serie

    if(Cad.length()>=5){
      //println(Cad.substring(0,5));
      //println(Cad);
      if(Cad.substring(0,5).equals(comCadTF)==true){
        numS=Cad.substring(Cad.length()-3,Cad.length()-2);//menos dos al final para saltar el \n
        println("String:"+numS+"-");
        tf = int(numS);
        println("dato tiempo total detectado TF = "+tf);
      }
      if(Cad.substring(0,5).equals(comCadAF)==true){
          numS=Cad.substring(Cad.length()-7,Cad.length()-5);//menos dos al final para saltar el \n
          println("String:"+numS+"-");
          af=int(numS);
          println("dato ancho franja detectado AF = "+af);
      }
      if(Cad.substring(0,5).equals(comCadTT)==true){
        numS=Cad.substring(Cad.length()-5,Cad.length()-2);//menos dos al final para saltar el \n
        println("String:"+numS+"-");
        tt=int(numS);
        println("dato tiempo total detectado  = "+tt);
      }
      if(Cad.substring(0,5).equals(comCadA)==true){
        numS=Cad.substring(Cad.length()-14,Cad.length()-8);//menos dos al final para saltar el \n
        println("String:"+numS+"-");
        a=float(numS);
        println("dato aceleracion detectado  = "+a);
      }
    }

  }
  catch(RuntimeException e) {
   println("error de "+e);
  }
 }
