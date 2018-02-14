class CircleParticles {

  PVector location = new PVector(0, 0);
  PVector velocity = new PVector(0, 0);

  float size = width/100;
  float lifeSpan = 255;
  float rotation;
  color c;

  CircleParticles(float x, float y, float vx, float vy, float r, color c) {
    location.x = x;
    location.y = y;
    velocity.x = vx;
    velocity.y = vy;
    rotation = r;
    this.c = c;
  }

  void show() {
    //noFill();
    stroke(c, lifeSpan);
    fill(c, lifeSpan);
    strokeWeight(width/200);
    pushMatrix();
    //ellipse(location.x, location.y, size/4, size/4);
    translate(location.x, location.y);
    rotate(rotation);
    rect(0, 0, size/3, size/3);
    popMatrix();
  }

  void fade() {
    location.add(velocity);
    lifeSpan-=6;
  }
}