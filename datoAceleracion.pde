void datoAceleracion(char startC){
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
        if(int(TF)<10)
          TF=""+int(TF);//eliminamos el cero anterior
        //println("TF: "+TF);
      }
      
      nPoints = int (TF);
      nPoints=(nPoints*2)-1;
      GPointsArray pointsA = new GPointsArray(nPoints);
 

      if(anCad.substring(6,8).equals("AF")==true){
      //if(anCad.substring(5,7).equals("AF")==true){
        AF=anCad.substring(8,11);
        //AF=anCad.substring(7,9);
        if(int(AF)<100)
          AF=""+int(AF);//eliminamos el cero anterior
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
              
              pointsA.add(i,float(TP));//agregamos como tipo float
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
      
      float t,x,v0,vt,a = float (A);
      v0=((float(AF)/1000)/(pointsA.getY(1)/1000)-(pointsA.getY(0)/1000));
      //v0=((float(AF))/(pointsA.getY(1)-pointsA.getY(0)));
      //v0=v0/1000;
      for (int i = 1; i <=nPoints; i++){
        t = pointsA.getY(i);
        t = t/1000;
        //x=((a*(t*t))/2+v0*t);
        x=((float(AF)/1000)*i);
        //vt=((a*t)+v0);
        vt=((float(AF)/1000)*i)/t; 
        pointsX.add(t,x,"t: "+t+", x: "+x);
        pointsV.add(t,vt,"t: "+t+", vt: "+vt);
        //println("x: "+x+" t: "+t+" vt: "+vt);
        println("x: "+x+" t: "+t);
      }
        println("a: "+a);
          
      //plot.setPoints(pointsA);
      plot1.setPoints(pointsV);
      plot.setPoints(pointsX);
      //points.removeRange(0,nPoints);   
      anCad=" ";
      startC=' ';
    }
}