void datoVelocidad(float v,int tt){

float t = 0;
float x = 0;
float vm =0;
nPoints = 10;
plot.setPoints(new GPointsArray());
GPointsArray points = new GPointsArray(nPoints);
GPointsArray pointsV = new GPointsArray(nPoints);

points.add(0,0,"t: 0, v: 0");
pointsV.add(0,v,"t: 0, v:"+v);

for (int i=10;i>0;i--){
  t = (float(tt)/1000)/i;
  x=v*t;
  points.add(t,x,"t: "+t+", x: "+x);//agregamos como tipo float
  vm=x/t;
  pointsV.add(t,v,"t: "+t+" v: "+v);

}
      plot.setPoints(points);
      plot1.setPoints(pointsV);
}
