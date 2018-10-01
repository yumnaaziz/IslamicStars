// open-CV
//import gab.opencv.*;
//import processing.video.*;
//import java.awt.*;

//Capture video;
//OpenCV opencv;

// do some stuff
 
// Convert pattern to stars, using something like the Hankin method.
// To do: add line separation...


ArrayList<Poly>  polys;
 
//boolean isInteractive = false; // turn off when you've found a good ratio for this tiling...
 
float minx=10000, maxx=-10000, miny=10000, maxy=-10000;
float dxs = 1;
float dys = 1;
float lm = 10;
float tm = 10;
float ratio = 1;
float angStar = (2*PI)/18;  // 30 degrees
float edgeDist = .1;
float starEdge = 1000;


// sine and cos
float a = 0.0;
float inc = TWO_PI/100.0;
float prev_x = 0, prev_y = 50, x, y;
int i = 0;
boolean upperlimitreached = false;
boolean lowerlimitreached = true;

float inc2 = TWO_PI/100.0;
float prev_x2 = 0, prev_y2 = 50, x2, y2;
int i2 = 360;
boolean upperlimitreached2 = true;
boolean lowerlimitreached2 = false;
float frequency = 0.5;



void setup()
{
  size(2160,2160);
  colorMode(RGB, 1);
  smooth();
  strokeWeight(2);
  //   noLoop();
  
  polys = new ArrayList<Poly>();
  ReadFile("altair1.txt");
 frameRate(120);
}
 
void draw()
{
 
  calcWaveOne();  
  calcWaveTwo();
  angStar = .001 + (float) (x*155)/width*PI;
  edgeDist = (float) (y2*140)/height;
  
  println("x: " + x + "y: " + y);
  println("x2: " + x2 + "y2: " + y2);
 

  //println("angstar = " + angStar  + " edgeDist = " + edgeDist);

  // println("angstar = " + angStar  + " lm = " + lm);
   // println("ratio = " + ratio);
//  }
  background(0);
  for (int i = 0; i < polys.size(); ++i) {
    Poly poly = polys.get(i);
    poly.doDraw();
  }
  
  saveFrame("recorded/ren_####.png");
}



void calcWaveOne()
{
  x = radians(i);
  y = sin(x);
  println("x: " + x + "y: " + y);
  prev_x = x;
  prev_y = y;
  a = a + inc;  
  if(upperlimitreached == false && lowerlimitreached == true)
  {
    i+=5;
    if(i == 360)
    {
      upperlimitreached = true;
      lowerlimitreached = false;
    }
  }
  if(lowerlimitreached == false && upperlimitreached == true)
  {
    i-=5;
    if(i == 0)
    {
      lowerlimitreached = true;
      upperlimitreached = false;
    }
  }
  
 
}

void calcWaveTwo()
{
  x2 = radians(i2);
  y2 = (sin(x2) +1)*2;
  println("x2: " + x2 + "y2: " + y2);
  prev_x2 = x2;
  prev_y2 = y2;
  a = a + inc;  
  if(upperlimitreached2 == false && lowerlimitreached2 == true)
  {
    i2+=1;
    if(i2 ==360)
    {
      upperlimitreached2 = true;
      lowerlimitreached2 = false;
    }
  }
  if(lowerlimitreached2 == false && upperlimitreached2 == true)
  {
    i2-=1;
    if(i2 == 0)
    {
      lowerlimitreached2 = true;
      upperlimitreached2 = false;
    }
  }
  
 
}

//void calcWaveOne()
//{
//  if(i == 100)
//  {
//    i = 0;
//  }
//  x = i;
//  y = 50 + sin(a) * 40.0;
//  line(prev_x, prev_y, x, y);
//  prev_x = x;
//  prev_y = y;
//  a = a + inc;
//  i+=4;
//}


class MyFloat {
  float v;
  MyFloat(float v) {
    this.v = v;
  }
  float floatValue() {
    return v;
  }
}
 
void ReadFile(String vFileName)
{
  ArrayList<MyFloat> vipts = new ArrayList<MyFloat>();
  String lines[] = loadStrings(vFileName);
  for (int i = 0; i < lines.length; ++i) {
      if (lines[i].length() < 3)
        continue;
      String nums[] = lines[i].split(",");
      for (int j = 0; j < nums.length; ++j) {
        if (nums[j].substring(0,1).equals(" "))
          nums[j] = nums[j].substring(1);
        if (nums[j].length() > 0)
          vipts.add(new MyFloat(float(nums[j])));
      }
    }
    polys = new ArrayList<Poly>();
    float[] ipts;
    ipts = new float[vipts.size()];
    println("loaded " + vipts.size() + " points");
    for (int i = 0; i < vipts.size(); ++i) {
      ipts[i] = vipts.get(i).floatValue();
    }
 
    for (int i = 0; i < vipts.size(); )
    {
      int nbrSides = (int) ipts[i++];
      Poly poly = new Poly(nbrSides);
      for (int j = 0; j < nbrSides; ++j) {
        poly.AddDot(ipts[i+j*2],ipts[i+j*2+1]);
      }
      i += nbrSides*2;
      polys.add(poly);
    }
    println("loaded " + polys.size() + " polys");
    dxs = (width-lm*2)/(float)(maxx-minx);
    dys = (height-tm*2)/(float)(maxy-miny);   
 
}
 
 
class Point
{
  float x,y;
  Point(float x, float y)
  {
    this.x = x;
    this.y = y;
    if (x < minx)  minx = x;
    if (x > maxx)  maxx = x;
    if (y < miny)  miny = y;
    if (y > maxy)  maxy = y;
  } 
}
 
// this crashes in certain situations...
Point intersection(float x1,float y1,float x2,float y2,
   float x3, float y3, float x4,float y4 )
   {
    float d = (x1-x2)*(y3-y4) - (y1-y2)*(x3-x4);
    try {
//      float xi = ((x3-x4)*(x1*y2-y1*x2)-(x1-x2)*(x3*y4-y3*x4))/d;
//      float yi = ((y3-y4)*(x1*y2-y1*x2)-(y1-y2)*(x3*y4-y3*x4))/d;
      float denom = (y4-y3)*(x2-x1) - (x4-x3)*(y2-y1);
      float numea = (x4-x3)*(y1-y3) - (y4-y3)*(x1-x3);
      float numeb = (x2-x1)*(y1-y3) - (y2-y1)*(x1-x3);
      if (abs(denom) < 0.01) {
        if (numea == 0.0 && numeb == 0.0)
        {
            // coincident
            println("c");
            return new Point ( x1, y1 );
        }
        else {
            // parallel
            println("p");
            return null;
        }
      }
      float ua = numea / denom;
      float ub = numeb / denom;
      if (ua >= 0.0f && ua <= 1.0f && ub >= 0.0f && ub <= 1.0f)
      {
        float xi = x1 + ua*(x2-x1);
        float yi = y1 + ua*(y2-y1);
        if (xi > 0 && xi < width && yi > 0 && yi < width)
          return new Point(xi,yi);
        else
          return null;
      }
      else {
        // not intersecting - this works well...
        return new Point (x1, y1 );
      }
    }
    catch (Exception e)
    {
      println("e");
      return null;
    } 
}
 
class Poly
{
  ArrayList<Point>  pts;
  int nbrSides;
   
  Poly(int nbrSides)
  {
    this.nbrSides = nbrSides;
    this.pts = new ArrayList<Point>();
  }
   
  void AddDot(float x, float y)
  {
    pts.add( new Point(x,y) );
  }
   
  void doDraw()
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
    // fill  (.9+r*.1, .9+g*.1, .9+b*.1);
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
 
    stroke(1);
 
    float cx = 0;
    float cy = 0;
    for (int i = 0; i < nbrSides; ++i) {
      Point pt = (Point) pts.get(i % nbrSides);
      cx += tx(pt.x);
      cy += ty(pt.y);
    }
    cx /= nbrSides;
    cy /= nbrSides;
    for (int i = 0; i < nbrSides; ++i) {
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
       line(tx(mx2),ty(my2), tx(ip.x), ty(ip.y));
       // Find point where these lines intersect, and draw line from mx1,my1 ix,iy   and mx2,my2,ix,iy
    }
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
 
float tx(float x)
{
  return (x - minx)*dxs + lm;
}
 
float ty(float y)
{
  return (y - miny)*dys + tm;
}
 
void myLine(float x1, float y1, float x2, float y2)
{
  line(tx(x1),ty(y1),tx(x2),ty(y2));
}
