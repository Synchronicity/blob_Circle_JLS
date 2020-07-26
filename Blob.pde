// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/o1Ob28sF0N8

class Blob {
  float minx;
  float miny;
  float maxx;
  float maxy;

  int id = 0;

  int lifespan = maxLife;

  boolean taken = false;

  Blob(float bx, float by) {
    minx = bx;
    miny = by;
    maxx = bx;
    maxy = by;
  }

  boolean checkLife() {
    lifespan--; 
    if (lifespan < 0) {
      return true;
    } else {
      return false;
    }
  }


  void show() {
    stroke(0);
    fill(255, lifespan);
    strokeWeight(10);
    rectMode(CORNERS);
    rect(minx, miny, maxx, maxy);

    textAlign(CENTER);
    textSize(32);
    fill(0);
    text(id, minx + (maxx-minx)*0.5, miny + (maxy-miny)*0.5+10);
    textSize(16);
    text(lifespan, minx + (maxx-minx)*0.5, miny - 10);  
  }


  void add(float bx, float by) {
    minx = min(minx, bx);
    miny = min(miny, by);
    maxx = max(maxx, bx);
    maxy = max(maxy, by);
  }

  void become(Blob other) {
    minx = other.minx;
    maxx = other.maxx;
    miny = other.miny;
    maxy = other.maxy;
    lifespan = maxLife;
  }

  float size() {
    return (maxx-minx)*(maxy-miny);
  }

  PVector getCenter() {
    float x = (maxx - minx)* 0.5 + minx;
    float y = (maxy - miny)* 0.5 + miny;    
    return new PVector(x, y);
  }

  boolean isNear(float bx, float by) {
    float cx = max(min(bx, maxx), minx);
    float cy = max(min(by, maxy), miny);
    float d = distSq(cx, cy, bx, by);

    if (d < distThreshold*distThreshold) {
      return true;
    } else {
      return false;
    }
  }
  
  // Récupération ID instance
  int getId(){
    return this.id;  
  }
}
