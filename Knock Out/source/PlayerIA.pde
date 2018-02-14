class PlayerAI {
  PVector location = new PVector(width*.25, height/2);
  PVector velocity = new PVector(0, 0);
  PVector additionalVelocity = new PVector(0, 0);

  int dashTimer = 30;
  int bounceTimer;
  int wallTimer = 10;
  float directionX = 1;
  float directionY = 1;
  int size = width/25;
  int moveSpeed = width/800;
  int orbDist = height/10;
  int collisionTimer = 10;
  float angle;
  int hp = 30;
  
  // From .3 - .65 (.3 being hardest)
  float difficulty = .65;

  int moveFromWall = 10;

  PVector o1 = new PVector(width/2, height/2 + orbDist);

  float time = 0;

  void show() {
    fill(#f44542);
    stroke(#f44542);
    ellipse(location.x, location.y, size, size);

    textAlign(CENTER, CENTER);
    textSize(width/25);
    text(hp, width*.9, height*.1);

    if (size <= 0) {
      translate(0, 0);
      textSize(width/15);
      text("You Win", width*.5, height*.5);
      if(keyPressed){
        nexus.restart();
      }
    }
  }

  void move() {
    if (size > 0) {
      // moving
      if (additionalVelocity.x + additionalVelocity.y == 0)
        location = location.add(velocity);
      else
        location = location.add(additionalVelocity);

      if (additionalVelocity.x > 0) {
        additionalVelocity.x -= width/600;
        additionalVelocity.y -= width/600;
      } else {
        additionalVelocity.set(0, 0);
      }


      // Moving away from the walls.
      if (location.x - size/2 < width*.1 && location.x + size/2 > width*.9 && location.y - size/2 < height*.1 && location.y + size/2 > height*.9 && bounceTimer < 0) {
        time += random(10, 20);
        bounceTimer = 30;
      }

      // bounce off walls
      if (location.x - size/2 < 0) {
        location.x = size/2;
        directionX *= -1;
        makeCircle();
      } else if (location.x + size/2 > width) {
        location.x = width - size/2;
        directionX *= -1;
        makeCircle();
      }

      if (location.y - size/2 < 0) {
        location.y = size/2;
        directionY *= -1;
        makeCircle();
      } else if (location.y + size/2 > height) {
        location.y = height - size/2;
        directionY *= -1;
        makeCircle();
      }
    }

    // Make particle trail
    if (frameCount % 5 == 0 && abs(velocity.x) + abs(velocity.y) >= .01){
      nexus.effects.createCircle(location.x, location.y, 3);
    }

    if (hp < 1) {
      nexus.effects.createCircle(location.x, location.y, 3);
      size--;
      hp = 0;
      if (size > 0)
        nexus.effects.shakeTimer = 10;
    }

    if (size <= 0) {
      size = 0;
    }

    // While dashing make even more particles
    if (abs(velocity.x) > moveSpeed*10 || abs(velocity.y) > moveSpeed*10) {
      for (int i = 0; i < 3; i++)
        nexus.effects.createCircle(location.x, location.y, 3);
    }

    dashTimer--;
    wallTimer--;
    collisionTimer--;
  }

  void makeCircle() {
    if (wallTimer < 0) {
      nexus.effects.createCircle(location.x, location.y, 1);
      wallTimer = 10;
    }
  }

  void collisions() {
    if (dist(o1.x, o1.y, nexus.p1.location.x, nexus.p1.location.y) < size && collisionTimer < 0) {
      nexus.effects.shakeTimer = 15;
      nexus.p1.velocity = nexus.p1.velocity.set((nexus.p1.location.x - location.x) * .2, (nexus.p1.location.y - location.y) * .2);
      collisionTimer = 30;
      nexus.p1.hp--;
      text(hp, width*.9, height*.1);
    }
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
      stroke(#f44542);
      strokeWeight(width/400);
      //ellipse(location.x, location.y, orbDist*2, orbDist*2);
      fill(#f44542);
      ellipse(o1.x, o1.y, size/3, size/3);
      line(location.x, location.y, o1.x, o1.y);
    }
  }

  void control() {

    // Movementas

    if (noise(time + 300) < difficulty) {
      // Moving semi randomly
      velocity.y = directionY * (map(noise(time), 0, 1, -moveSpeed*10, moveSpeed*10));
      velocity.x = directionX * (map(noise(time + 20), 0, 1, -moveSpeed*10, moveSpeed*10));
    } else {
      // Attacking
      velocity.x = (nexus.p1.location.x - location.x) * .05;
      velocity.y = (nexus.p1.location.y - location.y) * .05;
    }


    bounceTimer--;

    // Rotation
    if (noise(time+100) < .3 || dist(location.x, location.y, nexus.p1.location.x, nexus.p1.location.y) < width/3)
      angle += PI/20 * directionX * directionY;

    // Orb distance control
    if (orbDist < dist(location.x, location.y, nexus.p1.location.x, nexus.p1.location.y)) {
      if (orbDist <= height/3.5)
        orbDist += 6;
    } else {
      if (orbDist >= height/15)
        orbDist -= 6;
    }


    time += .01;
  }
}