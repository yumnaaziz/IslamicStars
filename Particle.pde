class Particle
{
  PVector position; 
  float radius;
  float lifeSpan;
  int occurance;
  Particle(PVector p, float r)
  {
    position = p;
    radius = r;
    lifeSpan = 255;
    occurance = 0;
  }
  
  void setOcuurance(int occur){
    
    occurance = occur;
  }
  
  int getOccurance(){
    
    return occurance;
  }
  
  boolean isDead()
  {
    if(lifeSpan < 0.0)
    {
      return true;
    }
    else
      return false;
  }
  
  void run()
  {
    update();
    display();
  }
  
  void UpdatePosition(PVector p)
  {
    position = p;
  }
 
 void display()
 {
   stroke(150, lifeSpan);
   fill(204, 102, 0, lifeSpan);
   ellipse(position.x, position.y, radius, radius);
 }
  
  void update()
  { 
    //lifeSpan = lifeSpan - 2.0;
    //println("lifeSpan: " + lifeSpan);
    
    // if(lifeSpan < 0.0)
    // {
    //   lifeSpan = 225;
    // }
  }
  
}
