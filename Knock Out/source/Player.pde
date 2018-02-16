class Player {
  PVector location = new PVector(width*.75, height/2);
  PVector velocity = new PVector(0, 0);

  int dashTimer = 10;
  int collisionTimer = 10;
  int wallTimer = 10;
  int size = width/25;
  int moveSpeed = width/900;
  int orbDist = height/10;
  int hp = 30;
  float angle;
  float rotationSpeed = PI/20;
  int boostCounter = 0;

  PVector o1 = new PVector(width/2, height/2 + orbDist);


  int wKey;
  int dKey;
  int sKey;
  int aKey;
  int tabKey;
  int up;
  int down;
  int right;
  int left;

  void show() {
    fill(0);
    stroke(0);
    ellipse(location.x, location.y, size, size);

    textSize(width/25);
    text(hp, width*.1, height*.1);

    if (size <= 0) {
      translate(0, 0);
      textSize(width/15);
      text("You Lose", width*.5, height*.5);
      if (keyPressed) {
        nexus.restart();
      }
    }
  }

  void move() {
    // drifting
    location = location.add(velocity);
    velocity.mult(.85);

    // bounce off walls
    if (location.x - size/2 < 0) {
      location.x = size/2;
      velocity.x *= -.7;
      makeCircle();
    } else if (location.x + size/2 > width) {
      location.x = width - size/2;
      velocity.x *= -.7;
      makeCircle();
    }

    if (location.y - size/2 < 0) {
      location.y = size/2;
      velocity.y *= -.7;
      makeCircle();
    } else if (location.y + size/2 > height) {
      location.y = height - size/2;
      velocity.y *= -.7;
      makeCircle();
    }

    if (frameCount % 5 == 0 && abs(velocity.x) + abs(velocity.y) >= .01) {
      nexus.effects.createCircle(location.x, location.y, 2);
    }

    if (hp < 1) {
      nexus.effects.createCircle(location.x, location.y, 2);
      size--;
      hp = 0;
      if (size > 0)
        nexus.effects.shakeTimer = 10;
    }

    if (size <= 0) {
      size = 0;
    }

    if (abs(velocity.x) > moveSpeed*10 || abs(velocity.y) > moveSpeed*10) {
      for (int i = 0; i < 3; i++)
        nexus.effects.createCircle(location.x, location.y, 2);
    }

    dashTimer--;
    wallTimer--;
    collisionTimer--;
  }

  void powerUp() {
    if (dist(location.x, location.y, nexus.effects.powerup.x, nexus.effects.powerup.y) < size) {
      nexus.effects.powerup.set(-width, -height);
      rotationSpeed = PI/10;
      boostCounter = 300;
      size = width/18;
    }

    if (boostCounter <= 0 && hp > 0) {
      rotationSpeed = PI/20;
      size = width/25;
    }
    boostCounter--;
  }

  void makeCircle() {
    if (wallTimer < 0) {
      nexus.effects.createCircle(location.x, location.y, 1);
      wallTimer = 10;
    }
    //nexus.effects.shakeTimer = 10;
  }


  void rotateOrbital() {
    o1.x -= location.x;
    o1.y -= location.y;



    o1.x = cos(angle)*orbDist;
    o1.y = sin(angle)*orbDist;



    o1.x += location.x;
    o1.y += location.y;
  }

  void showOrbitals() {
    if (hp > 0) {
      //noFill();
      stroke(0);
      strokeWeight(width/400);
      //ellipse(location.x, location.y, orbDist*2, orbDist*2);
      fill(0);
      ellipse(o1.x, o1.y, size/3, size/3);
      line(location.x, location.y, o1.x, o1.y);
    }
  }

  void collisions() {
    if (dist(o1.x, o1.y, nexus.ai.location.x, nexus.ai.location.y) < size && collisionTimer < 0 && hp > 0) {
      nexus.effects.shakeTimer = 15;
      nexus.ai.additionalVelocity = nexus.ai.additionalVelocity.set((nexus.ai.location.x - o1.x) * 2, (nexus.ai.location.y - o1.y) * 2);
      nexus.ai.time += 30;
      collisionTimer = 30;
      nexus.ai.hp--;
    }
  }

  void control() {
    if (size > 0) {
      if (aKey == 1) {
        velocity.x -= moveSpeed;
      }
      if (dKey == 1) {
        velocity.x += moveSpeed;
      }
      if (sKey == 1) {
        velocity.y += moveSpeed;
      }
      if (wKey == 1) {
        velocity.y -= moveSpeed;
      }
      if (up == 1 && orbDist <= height/3.5) {
        orbDist += width/100;
      }
      if (down == 1 && orbDist >= height/15) {
        orbDist -= width/100;
      }
      if (right == 1) {
        angle += rotationSpeed;
      }
      if (left == 1 || boostCounter > 0) {
        angle -= rotationSpeed;
      }
    }

    // dash
    if (tabKey == 1 && nexus.p1.dashTimer < 0) {
      velocity.mult(4);
      tabKey = 0;
      dashTimer = 20;
    }
  }
}