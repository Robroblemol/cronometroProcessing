void datoVelocidad(float v,int tt){

      nPoints = 10;
      plot.setPoints(new GPointsArray());
      GPointsArray points = new GPointsArray(nPoints);
        GPointsArray pointsV = new GPointsArray(nPoints);

        float t = float(tt)/1000;
        println("TFG: "+t);
        points.add(0,0,"t: 0, v: 0");
        points.add(t,v,"t: "+t+", v: "+v);//agregamos como tipo float
        pointsV.add(0,v,"t: 0, v:"+v);
        pointsV.add(t,v,"t: "+t+" v: "+v);

      plot.setPoints(points);
      plot1.setPoints(pointsV);
}
