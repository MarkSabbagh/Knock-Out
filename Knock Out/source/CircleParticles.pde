class CircleParticles {

  PVector location = new PVector(0, 0);
  PVector velocity = new PVector(0, 0);

  float size = width/100;
  float lifeSpan = 255;
  float rotation;
  color c;
  boolean sqaure = true;

  CircleParticles(float x, float y, float vx, float vy, float r, color c, int shape) {
    location.x = x;
    location.y = y;
    velocity.x = vx;
    velocity.y = vy;
    rotation = r;
    this.c = c;
    if (shape == 1)
      sqaure = false;
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

    if (sqaure) {
      rect(0, 0, size/3, size/3);
    } else {
      noStroke();
      ellipse(0, 0, size/3, size/3);

    }

    popMatrix();
  }

  void fade() {
    location.add(velocity);
    lifeSpan-=6;
  }
}