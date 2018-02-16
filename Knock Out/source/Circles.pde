class Squares {

  PVector location = new PVector(0, 0);
  float size = 0;
  float speed = width/200;

  Squares(float x, float y, float s) {
    location.x = x;
    location.y = y;
    speed = s;
  }

  void show() {
    noFill();
    stroke(60, 255-map(size, 0, width*1.5, 0, 255));
    strokeWeight(width/300);
    //ellipse(location.x, location.y, size, size);
    rectMode(CENTER);
    rect(location.x, location.y, size, size);
  }

  void grow() {
    size += speed;
  }
}