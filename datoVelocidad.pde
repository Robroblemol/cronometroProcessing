void datoVelocidad(float v,int tt){

float t = 0;
float x = 0;
float vm =0;
nPoints = 10;
plot.setPoints(new GPointsArray());
GPointsArray points = new GPointsArray(nPoints);
GPointsArray pointsV = new GPointsArray(nPoints);

points.add(0,0,"t: 0, x: 0");
pointsV.add(0,v,"t: 0, v:"+v);

for (int i=9;i>0;i--){
  t = (float(tt)/1000)/i;
  t=redondear(t);
  v=redondear(v);
  x=v*t;
  //x=redondear(x);
  points.add(t,x,"t: "+t+", x: "+x);//agregamos como tipo float
  vm=x/t;
  vm=redondear(v);
  pointsV.add(t,vm,"t: "+t+" v: "+vm);

}
      plot.setPoints(points);
      plot1.setPoints(pointsV);
}
