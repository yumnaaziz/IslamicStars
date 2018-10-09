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
