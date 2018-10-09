import codeanticode.syphon.*;

//// face tracking
import gab.opencv.*;
import processing.video.*;
import java.awt.*;


Capture video;
OpenCV opencv;

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
float prev_x = 0, prev_y = 50, x, y;
int i = 0;
boolean upperlimitreached = false;
boolean lowerlimitreached = true;

float prev_x2 = 0, prev_y2 = 50, x2, y2;
int i2 = 360;
boolean upperlimitreached2 = true;
boolean lowerlimitreached2 = false;

float frequency = 0; // from 0 to 2.5
float increment = 0.1;
float speed = 10.0; //higher the speed, the slower the animation

int time = 0;
int timetillSpeedIncrease = 8;
float prevFace_x, prevFace_y;

float idletime;
long timeToWait = 120;// in miliseconds
long lastTime;

//Particles
float alpha = 255;
Particle particle;

// Trail/Delay
ArrayList<Line> history1 = new ArrayList<Line>(); 
ArrayList<Line> history2 = new ArrayList<Line>();  

// FadeAnimation
float mColor = 0.1;
boolean changeDirection = false;

SyphonServer server;

void setup()
{
  size(600,600, P3D);
  server = new SyphonServer(this, "Processing Syphon");
  colorMode(RGB, 1);
  smooth();
  strokeWeight(2);
  //   noLoop();
  
  polys = new ArrayList<Poly>();
  ReadFile("altair1.txt");
  
  // Video stuff
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  video.start();
  
  // time stuff
  lastTime = millis();
 
  particle = new Particle(new PVector(width/2, height/2), 5);
  frameRate(60);
}
 
void draw()
{
  if ( millis() - lastTime > timeToWait) 
  {
   FaceTracking();
  // Calculate the sine wave
  calcWaveOne();  
  calcWaveTwo();
  
  angStar = (.001 + (float) (x*55)/width*PI)*frequency;
  edgeDist = (float) (y2*40)/height * frequency;
  background(0);
  
  FadeAnimation();
  
  DrawAnimation(); //<>//
  
    //LineTrail();
    //UpdateAlpha();
  //<>//
   //  for (int i = 0; i < polys.size(); ++i) 
   //{
   //   Poly poly = polys.get(i);
   //   poly.saved = false;
   //}
  //<>//
  UpdateTime();
  server.sendScreen(); 
  println("FrameRate: " + frameRate);
  }
}

void DrawAnimation()
{
   for (int i = 0; i < polys.size(); ++i) 
  {
    //FadeAnimation();
    Poly poly = polys.get(i);
    poly.doDraw(i);
  }
}
void FadeAnimation()
{
  if(millis()-lastTime > timeToWait)
    {
      if(changeDirection == false)
      {
        mColor+=0.1;
        if(mColor > 1)
        {
          changeDirection = true;
        }
      }
      if(changeDirection)
      {
        mColor-=0.1;
        if(mColor < 0.2)
        {
          changeDirection = false;
        }
      }
      
      println("mColor: " + mColor);
    }

}


void UpdateAlpha()
{
  if(alpha < 0)
  {
    alpha = 255;
  }
  else
  {
    alpha--;
  }
  println("Alpha: " + alpha);
}

void LineTrail()
{
  if(frequency != 0)
  {
    if(lastTime > 100)
    {
    for(int j = 0; j <history1.size(); j++)
      {
        //println("size of his1: " + poly.history1.size());
        Line line = history1.get(j);
        stroke(0.5, j*2);
        line(line.getX1(), line.getY1(), line.getX2(),line.getY2());
      }
      
       for(int j = 0; j <history2.size(); j++)
      {
        //println("size of his2: " + poly.history1.size());
        Line line = history2.get(j);
        stroke(0.5, j*2);
        line(line.getX1(), line.getY1(), line.getX2(),line.getY2());
      }
    }
      
  }
}
void UpdateTime()
{
  time +=1;
  lastTime = millis();
  println("Time: " + time);
}

void FaceTracking()
{
  // Face tracking
  opencv.loadImage(video);

  //image(video, 0, 0 );
  Rectangle[] faces = opencv.detect();
  println(" Faces: " + faces.length);
  
 if(faces.length > 0)
 {
    println("how much the head has moved: " + (prevFace_x - faces[0].x) + 
    " " + ( prevFace_y - faces[0].y));
    
    // staying still
    if(abs(prevFace_x - faces[0].x) <= 3 && abs(prevFace_y - faces[0].y) <= 3)
    {
      // check time 
      if(time > timetillSpeedIncrease)
      {
        if(frequency < 2.3)
        {
          frequency += increment;
        }
        
        time = 0;
      }
    } else 
    {
      frequency = 0;
    }
    
    prevFace_x = faces[0].x;
    prevFace_y = faces[0].y;
 }
  println("Frequency: " + frequency);
}

void captureEvent(Capture c) {
  c.read();
}

void calcWaveOne()
{
  x = radians(i);
  y = sin(x);
  //println("x: " + x + "y: " + y);
  prev_x = x;
  prev_y = y;
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
  y2 = (sin(x2)+1)*2;
  //println("x2: " + x2 + "y2: " + y2);
  prev_x2 = x2;
  prev_y2 = y2;
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
}  //<>// //<>// //<>// //<>//
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
