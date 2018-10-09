class Line {
 
  float x1;
  float y1;
  float x2;
  float y2;
  float alpha;
  int nbrSides;
  int iteration;
  void setLine(float xOne, float yOne, float xTwo, float yTwo, int nbrS, int i){
   
    x1 = xOne;
    y1 = yOne;
    x2 = xTwo;
    y2 = yTwo;
    iteration = i;
    nbrSides = nbrS;
  }
  
  float getX1()
  {
    return x1;
  }
  
   float getX2()
  {
    return x2;
  }
  
   float getY1()
  {
    return y1;
  }
  
  
   float getY2()
  {
    return y2;
  }
  
  float getAlpha()
  {
    return alpha;
  }
  
}
