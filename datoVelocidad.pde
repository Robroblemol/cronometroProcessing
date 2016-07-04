void datoVelocidad(char startC){
if(startC=='@'){
      nPoints = 10;
       //plot.getYAxis().getAxisLabel().setText("m/s");//titulo eje Y
       //plot.defaultDraw();
          plot.setPoints(new GPointsArray());
          
      if(anCad.substring(2,4).equals("TF")==true){
        TF=anCad.substring(4,5);
        //println("TF: "+TF);
      }
      if(anCad.substring(5,7).equals("AF")==true){
        AF=anCad.substring(7,9);
        //println("TF: "+TF);
      }
      if(anCad.substring(9,11).equals("TT")==true){
        TT=anCad.substring(11,20);
        //println("TF: "+TF);
      }
       if(anCad.substring(20,21).equals("V")==true){
        V=anCad.substring(21,26);
        //println("TF: "+TF);
      }
        GPointsArray pointsV = new GPointsArray(nPoints);
        String TFG=TF;
        //TFG=TFG.substring(4,(TFG.length()));
        points.add(0,0);
        points.add(float(TFG),float(V));//agregamos como tipo float
        pointsV.add(0,float(V));
        pointsV.add(float(TFG),float(V));
        
      plot.setPoints(points);
      plot1.setPoints(pointsV);
     // points.removeRange(0,nPoints);
      anCad=" ";
      startC=' ';
    }
}