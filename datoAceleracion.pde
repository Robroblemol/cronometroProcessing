void datoAceleracion(char startC){
if(startC=='@'){
  
      //nPoints = 10;
       plot.getYAxis().getAxisLabel().setText("m/s");//titulo eje Y
       //plot.defaultDraw();
          plot.setPoints(new GPointsArray());
      if(anCad.substring(2,4).equals("TF")==true){
        TF=anCad.substring(4,5);
        //println("TF: "+TF);
      }
      
      nPoints = int (TF);
      nPoints=(nPoints*2)-1;
      GPointsArray pointsA = new GPointsArray(nPoints);
      
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
      int r=22;
      String axuCad;
      if(anCad.substring(20,22).equals("TP")==true){
         //println("Entre a TP");
         //println("length: "+anCad.length());
        for(int i = 0; i < nPoints; i++){
   
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
            
      }
      }
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
      plot.setPoints(pointsA);
      //points.removeRange(0,nPoints);   
      anCad=" ";
      startC=' ';
    }
}