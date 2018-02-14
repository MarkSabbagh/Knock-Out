import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class KnockOut extends PApplet {

// // // Controls
// wasd - movement
// Space - dash
// left key and right key - orb rotation
// up key and right key - distance of orbs

Nexus nexus;

public void setup() {
  
  nexus = new Nexus();
}

public void draw() {
  nexus.run();
}

public void keyPressed() {

  // Player 1
  if (key == 'a' || key == 'A') {
    nexus.p1.aKey = 1;
  }
  if (key == 'd' || key == 'D') {
    nexus.p1.dKey = 1;
  }
  if (key == 'w' || key == 'W') {
    nexus.p1.wKey = 1;
  }
  if (key == 's' || key == 'S') {
    nexus.p1.sKey = 1;
  }
  if (keyCode == UP) {
    nexus.p1.up = 1;
  }
  if (keyCode == DOWN) {
    nexus.p1.down = 1;
  }
  if (keyCode == RIGHT) {
    nexus.p1.right = 1;
  }
  if (keyCode == LEFT) {
    nexus.p1.left = 1;
  }
  if ((key == ' ' || key == ' ') && nexus.p1.dashTimer < 0) {
    nexus.p1.tabKey = 1;
  }
}

public void keyReleased() {

  // PLayer 1
  if (key == 'a' || key == 'A') {
    nexus.p1.aKey = 0;
  }
  if (key == 'd' || key == 'D') {
    nexus.p1.dKey = 0;
  }
  if (key == 'w' || key == 'W') {
    nexus.p1.wKey = 0;
  }
  if (key == 's' || key == 'S') {
    nexus.p1.sKey = 0;
  }
  if (keyCode == UP) {
    nexus.p1.up = 0;
  }
  if (keyCode == DOWN) {
    nexus.p1.down = 0;
  }
  if (keyCode == RIGHT) {
    nexus.p1.right = 0;
  }
  if (keyCode == LEFT) {
    nexus.p1.left = 0;
  }
  if ((key == ' ' || key == ' ') && nexus.p1.dashTimer < 0) {
    nexus.p1.tabKey = 0;
  }
}
class CircleParticles {

  PVector location = new PVector(0, 0);
  PVector velocity = new PVector(0, 0);

  float size = width/100;
  float lifeSpan = 255;
  float rotation;
  int c;

  CircleParticles(float x, float y, float vx, float vy, float r, int c) {
    location.x = x;
    location.y = y;
    velocity.x = vx;
    velocity.y = vy;
    rotation = r;
    this.c = c;
  }

  public void show() {
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

  public void fade() {
    location.add(velocity);
    lifeSpan-=6;
  }
}
class Circles {

  PVector location = new PVector(0, 0);
  float size = 0;
  float speed = width/200;

  Circles(float x, float y, float s) {
    location.x = x;
    location.y = y;
    speed = s;
  }

  public void show() {
    noFill();
    stroke(60, 255-map(size, 0, width*1.5f, 0, 255));
    strokeWeight(width/300);
    //ellipse(location.x, location.y, size, size);
    rectMode(CENTER);
    rect(location.x, location.y, size, size);
  }

  public void grow() {
    size += speed;
  }
}
class Effects {

  ArrayList<Circles> backCircles = new ArrayList<Circles>();
  ArrayList<CircleParticles> circleParticles = new ArrayList<CircleParticles>();

  int shakeTimer = 0;

  public void particleCircles() {
    for (int i = circleParticles.size()-1; i >= 0; i--) {
      CircleParticles c = circleParticles.get(i);
      c.fade();
      c.show();
      if (c.lifeSpan <= 0) {
        circleParticles.remove(i);
      }
    }
  }

  public void ui() {
    fill(255);
    stroke(0);
    rectMode(LEFT);
    strokeWeight(width/300);
    rect(width*.3f, height*.1f, width*.7f, height*.9f, width*.01f);

    textAlign(CENTER, CENTER);
    textSize(width/20);
    fill(0xfff44542);
    text("Knock Out", width/2, height*.2f);

    textSize(width/50);
    fill(0);
    text("WASD - movement", width/2, height*.37f);
    text("Arrow Keys - orb control", width/2, height*.41f);
    text("Space - speed boost", width/2, height*.45f);

    rectMode(CENTER);
    fill(0xfff44542);
    rect(width/2, height*.6f, width/4, height/12);
    rect(width/2, height*.7f, width/4, height/12);
    rect(width/2, height*.8f, width/4, height/12);

    fill(0);
    textSize(width/30);
    text("Easy", width/2, height * .59f);
    text("Medium", width/2, height * .69f);
    text("Hard", width/2, height * .79f);

    if (mousePressed && mouseX > width*.4f && mouseX < width*.6f && mouseY > height*.55f && mouseY < height*.65f) {
      nexus.play = true;
      nexus.ai.difficulty = .65f;
    } else if (mousePressed && mouseX > width*.4f && mouseX < width*.6f && mouseY > height*.65f && mouseY < height*.75f) {
      nexus.play = true;
      nexus.ai.difficulty = .5f;
    } else if (mousePressed && mouseX > width*.4f && mouseX < width*.6f && mouseY > height*.75f && mouseY < height*.85f) {
      nexus.play = true;
      nexus.ai.difficulty = .3f;
    }
  }

  public void backgroundCircles() {
    if (frameCount % 60 == 0) {
      backCircles.add(new Circles(random(width), random(height), width/200));
    }

    for (int i = backCircles.size()-1; i >= 0; i--) {
      Circles c = backCircles.get(i);
      c.grow();
      c.show();
      if (c.size> width*2) {
        backCircles.remove(i);
      }
    }
  }

  public void shakeScreen() {
    if (shakeTimer > 0) {
      translate(random(-width/70, width/70), random(-height/70, height/70));
    } else {
      translate(0, 0);
    }
    shakeTimer--;
  }

  public void createCircle(float x, float y, int type) {
    switch(type) {

      // Bcakground cricles
    case 1:
      backCircles.add(new Circles(x, y, width/50));
      break;

      // Ball trail circles
    case 2:
      circleParticles.add(new CircleParticles(x, y, random(-5, 5), random(-5, 5), random(0, 1), 0));
      break;

      // Ball trail circles for AI
    case 3:
      circleParticles.add(new CircleParticles(x, y, random(-5, 5), random(-5, 5), random(0, 1), 0xfff44542));
      break;
    }
  }
}

class Nexus {
  Player p1 = new Player();
  PlayerAI ai = new PlayerAI();
  Effects effects = new Effects();
  boolean play = false;

  public void run() {
    background(255);
    effects.shakeScreen();
    effects.backgroundCircles();
    effects.particleCircles();
    if (play == false)
      effects.ui();
    if (play == true) {
      player();
      ai();
    }
  }

  public void player() {
    p1.control();
    p1.move();
    p1.rotateOrbital();
    p1.collisions();
    p1.showOrbitals();
    p1.show();
  }

  public void ai() {
    ai.control();
    ai.move();
    ai.rotateOrbital();
    ai.collisions();
    ai.showOrbitals();
    ai.show();
  }
  
  public void restart(){
    ai.hp = 30;
    ai.location.set(width*.25f, height/2);
    ai.size = width/25;
    p1.hp = 30;
    p1.location.set(width*.75f, height/2);
    p1.size = width/25;
    
    play = false;
  }
}

class Player {
  PVector location = new PVector(width*.75f, height/2);
  PVector velocity = new PVector(0, 0);

  int dashTimer = 10;
  int collisionTimer = 10;
  int wallTimer = 10;
  int size = width/25;
  int moveSpeed = width/800;
  int orbDist = height/10;
  int hp = 30;
  float angle;

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

  public void show() {
    fill(0);
    stroke(0);
    ellipse(location.x, location.y, size, size);

    textSize(width/25);
    text(hp, width*.1f, height*.1f);

    if (size <= 0) {
      translate(0, 0);
      textSize(width/15);
      text("You Lose", width*.5f, height*.5f);
      if(keyPressed){
        nexus.restart();
      }
    }
  }

  public void move() {
    // drifting
    location = location.add(velocity);
    velocity.mult(.85f);

    // bounce off walls
    if (location.x - size/2 < 0) {
      location.x = size/2;
      velocity.x *= -.7f;
      makeCircle();
    } else if (location.x + size/2 > width) {
      location.x = width - size/2;
      velocity.x *= -.7f;
      makeCircle();
    }

    if (location.y - size/2 < 0) {
      location.y = size/2;
      velocity.y *= -.7f;
      makeCircle();
    } else if (location.y + size/2 > height) {
      location.y = height - size/2;
      velocity.y *= -.7f;
      makeCircle();
    }

    if (frameCount % 5 == 0 && abs(velocity.x) + abs(velocity.y) >= .01f){
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

  public void makeCircle() {
    if (wallTimer < 0) {
      nexus.effects.createCircle(location.x, location.y, 1);
      wallTimer = 10;
    }
    //nexus.effects.shakeTimer = 10;
  }


  public void rotateOrbital() {
    o1.x -= location.x;
    o1.y -= location.y;



    o1.x = cos(angle)*orbDist;
    o1.y = sin(angle)*orbDist;



    o1.x += location.x;
    o1.y += location.y;
  }

  public void showOrbitals() {
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

  public void collisions() {
    if (dist(o1.x, o1.y, nexus.ai.location.x, nexus.ai.location.y) < size && collisionTimer < 0 && nexus.ai.collisionTimer <= 0) {
      nexus.effects.shakeTimer = 15;
      nexus.ai.additionalVelocity = nexus.ai.additionalVelocity.set((nexus.ai.location.x - location.x) * .1f, (nexus.ai.location.y - location.y) * .1f);
      nexus.ai.time += 30;
      collisionTimer = 30;
      nexus.ai.hp--;
    }
  }

  public void control() {
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
      if (up == 1 && orbDist <= height/3.5f) {
        orbDist += 6;
      }
      if (down == 1 && orbDist >= height/15) {
        orbDist -= 6;
      }
      if (right == 1) {
        angle += PI/20;
      }
      if (left == 1) {
        angle -= PI/20;
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
class PlayerAI {
  PVector location = new PVector(width*.25f, height/2);
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
  float difficulty = .65f;

  int moveFromWall = 10;

  PVector o1 = new PVector(width/2, height/2 + orbDist);

  float time = 0;

  public void show() {
    fill(0xfff44542);
    stroke(0xfff44542);
    ellipse(location.x, location.y, size, size);

    textAlign(CENTER, CENTER);
    textSize(width/25);
    text(hp, width*.9f, height*.1f);

    if (size <= 0) {
      translate(0, 0);
      textSize(width/15);
      text("You Win", width*.5f, height*.5f);
      if(keyPressed){
        nexus.restart();
      }
    }
  }

  public void move() {
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
      if (location.x - size/2 < width*.1f && location.x + size/2 > width*.9f && location.y - size/2 < height*.1f && location.y + size/2 > height*.9f && bounceTimer < 0) {
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
    if (frameCount % 5 == 0 && abs(velocity.x) + abs(velocity.y) >= .01f){
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

  public void makeCircle() {
    if (wallTimer < 0) {
      nexus.effects.createCircle(location.x, location.y, 1);
      wallTimer = 10;
    }
  }

  public void collisions() {
    if (dist(o1.x, o1.y, nexus.p1.location.x, nexus.p1.location.y) < size && collisionTimer < 0) {
      nexus.effects.shakeTimer = 15;
      nexus.p1.velocity = nexus.p1.velocity.set((nexus.p1.location.x - location.x) * .2f, (nexus.p1.location.y - location.y) * .2f);
      collisionTimer = 30;
      nexus.p1.hp--;
      text(hp, width*.9f, height*.1f);
    }
  }


  public void rotateOrbital() {
    o1.x -= location.x;
    o1.y -= location.y;


    o1.x = cos(angle)*orbDist;
    o1.y = sin(angle)*orbDist;


    o1.x += location.x;
    o1.y += location.y;
  }

  public void showOrbitals() {
    if (hp > 0) {
      //noFill();
      stroke(0xfff44542);
      strokeWeight(width/400);
      //ellipse(location.x, location.y, orbDist*2, orbDist*2);
      fill(0xfff44542);
      ellipse(o1.x, o1.y, size/3, size/3);
      line(location.x, location.y, o1.x, o1.y);
    }
  }

  public void control() {

    // Movementas

    if (noise(time + 300) < difficulty) {
      // Moving semi randomly
      velocity.y = directionY * (map(noise(time), 0, 1, -moveSpeed*10, moveSpeed*10));
      velocity.x = directionX * (map(noise(time + 20), 0, 1, -moveSpeed*10, moveSpeed*10));
    } else {
      // Attacking
      velocity.x = (nexus.p1.location.x - location.x) * .05f;
      velocity.y = (nexus.p1.location.y - location.y) * .05f;
    }


    bounceTimer--;

    // Rotation
    if (noise(time+100) < .3f || dist(location.x, location.y, nexus.p1.location.x, nexus.p1.location.y) < width/3)
      angle += PI/20 * directionX * directionY;

    // Orb distance control
    if (orbDist < dist(location.x, location.y, nexus.p1.location.x, nexus.p1.location.y)) {
      if (orbDist <= height/3.5f)
        orbDist += 6;
    } else {
      if (orbDist >= height/15)
        orbDist -= 6;
    }


    time += .01f;
  }
}
  public void settings() {  fullScreen(P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "KnockOut" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
