void datoAceleracion(float a, int tt, int t1, int tf,int af){
float vi = (float(af)/1000)/(float(t1)/1000);//calculamos velocidad inicial
float t = 0;
float x = 0;
float v = 0;
GPointsArray pointsX = new GPointsArray(nPoints);
GPointsArray pointsV = new GPointsArray(nPoints);

 plot.setPoints(new GPointsArray());

for(int i =((tf*2)-1);i>0;i--){
  t=(float(tt)/1000)/i;
  t=redondear(t);
  x=vi*t+(a*(t*t))/2;
  x=redondear(x);
  v=vi+a*t;
  v=redondear(v);
  pointsX.add(t,x,"t: "+t+", x: "+x);
  pointsV.add(t,v,"t: "+t+", vt: "+v);
  println("x: "+x+" t: "+t);
  TableRow newRow = tabla.addRow();
  newRow.setFloat("x(m)",x);
  newRow.setFloat("t(s)",t);
}
plot1.setPoints(pointsV);
plot.setPoints(pointsX);
}
float redondear (float x){
 return round(x*1000.0f)/1000.0f;
}
