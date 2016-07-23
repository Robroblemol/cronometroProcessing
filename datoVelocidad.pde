void datoVelocidad(char startC){
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
        float TF = float(TFG)/1000;
        println("TFG: "+TF);
        points.add(0,0,"t: 0, v: 0");
        points.add(TF,float(V),"t: "+TF+", v: "+V);//agregamos como tipo float
        pointsV.add(0,float(V),"t: 0, v: "+V);
        pointsV.add(TF,float(V),"t: "+TF+" v: "+V);
        
        
      plot.setPoints(points);
      plot1.setPoints(pointsV);
      //points.removeRange(0,1);
      anCad=" ";
      startC=' ';
    }
}