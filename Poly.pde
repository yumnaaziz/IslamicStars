class Poly
{
  ArrayList<Point>  pts;
  int nbrSides;

  
  Line l1 = new Line();
  Line l2 = new Line();
  public boolean saved = false;
  
  Poly(int nbrSides)
  {
    this.nbrSides = nbrSides;
    this.pts = new ArrayList<Point>();
  }
   
  void AddDot(float x, float y)
  {
    pts.add( new Point(x,y) );
  }
   
  void doDraw(int k)
  {
    if (outsideBorder())
    {
      fill(.5);
      return;
    }
    else
      fill(1, 1, 1, 0);
     
    float r = sin(nbrSides*PI*2/8.0);
    float g = sin(nbrSides*PI*2/8.0+2);
    float b = sin(nbrSides*PI*2/8.0+4);
    //fill  (.9+r*.1, .9+g*.1, .9+b*.1);
     noStroke();
 
    String outStr = nbrSides +",";
    beginShape();
     
    for (int i = 0; i <= nbrSides; ++i) {
      Point pt = (Point) pts.get(i % nbrSides); 
      vertex( tx(pt.x), ty(pt.y) );
      if (i < nbrSides)
        outStr += pt.x + "," + pt.y + ",";
    }
    endShape();
    // println(outStr);
     
   
    stroke(mColor); //<>//

    float cx = 0;
    float cy = 0;
    for (int i = 0; i < nbrSides; ++i) {
      Point pt = (Point) pts.get(i % nbrSides);
      cx += tx(pt.x);
      cy += ty(pt.y);
    }
    cx /= nbrSides;
    cy /= nbrSides;
    

    
    for (int i = 0; i < nbrSides; ++i) 
    {

       Point p1 = (Point) pts.get(i % nbrSides);
       Point p2 = (Point) pts.get((i+1) % nbrSides);
       Point p3 = (Point) pts.get((i+2) % nbrSides);
       // Draw segment that starts at midpoint of p2,p1 and goes at angle p2,p1 + (PI-angStar)/2
       // to the point where it intersects segment that starts at midpoint of p2,p3 and goes at angle p2,p3-(PI-angStar)/2
       float mx1 = (p1.x + p2.x)/2;
       float my1 = (p1.y + p2.y)/2;
       mx1 += (p1.x - p2.x)*edgeDist;
       my1 += (p1.y - p2.y)*edgeDist;
       float mx2 = (p3.x + p2.x)/2;
       float my2 = (p3.y + p2.y)/2;
       mx2 += (p3.x - p2.x)*edgeDist;
       my2 += (p3.y - p2.y)*edgeDist;
       float ang1 = atan2(p2.y-p1.y,p2.x-p1.x) + (PI-angStar)/2;
       float ang2 = atan2(p2.y-p3.y,p2.x-p3.x) - (PI-angStar)/2;
       float ex1 = mx1+cos(ang1)*starEdge;
       float ey1 = my1+sin(ang1)*starEdge;
       float ex2 = mx2+cos(ang2)*starEdge;
       float ey2 = my2+sin(ang2)*starEdge;
       Point ip = intersection(mx1,my1,ex1,ey1,mx2,my2,ex2,ey2);
       if (ip == null)
         continue;
       
       

     line(tx(mx1),ty(my1), tx(ip.x), ty(ip.y));
     line(tx(mx2),ty(my2), tx(ip.x), ty(ip.y)); //current
     
     //if(saved == false){
       
     //if(frequency > 0) 
     //{
     //l1.setLine(tx(mx1), ty(my1), tx(ip.x), ty(ip.y), nbrSides, k);
     //l2.setLine(tx(mx2), ty(my2), tx(ip.x), ty(ip.y), nbrSides, k);
     //history1.add(l1);
     //history2.add(l2);
       
     //  if(history1.size() > nbrSides*polys.size())
     //  {
     //    history1.remove(0);
     //  }
        
     //     if(history2.size() > nbrSides*polys.size())
     //  {
     //    history2.remove(0);
     //  }
     //}
       
       //saved = true;
     //} 
     
     
 
        //by aquib
    
    
     
     
         
         //end by aquib
 
    //  particle = new Particle(new PVector(random(tx(mx1), tx(ip.x)), random(ty(my1),ty(ip.y))), 2);
    
    //if(time > timetillSpeedIncrease){
    //  particle.UpdatePosition(new PVector(random(tx(mx1), tx(ip.x)), random(ty(my1),ty(ip.y))));
    //  //pa//rticle.setOcuurance(1n  
    //}
    
    //particle.run();
   
       // Find point where these lines intersect, and draw line from mx1,my1 ix,iy   and mx2,my2,ix,iy
    }
   
    //println("end of for loop in do draw");
}
 
  boolean outsideBorder()
  {
    float cx = 0;
    float cy = 0;
    for (int i = 0; i < nbrSides; ++i) {
      Point pt = (Point) pts.get(i % nbrSides);
      cx += tx(pt.x);
      cy += ty(pt.y);
    }
    cx /= nbrSides;
    cy /= nbrSides;
    float dx = cx - width/2;
    float dy = cy - height/2;
    return sqrt(dx*dx + dy*dy) > ratio*width/2 ;
  }
}
