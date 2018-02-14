class Effects {

  ArrayList<Circles> backCircles = new ArrayList<Circles>();
  ArrayList<CircleParticles> circleParticles = new ArrayList<CircleParticles>();

  int shakeTimer = 0;

  void particleCircles() {
    for (int i = circleParticles.size()-1; i >= 0; i--) {
      CircleParticles c = circleParticles.get(i);
      c.fade();
      c.show();
      if (c.lifeSpan <= 0) {
        circleParticles.remove(i);
      }
    }
  }

  void ui() {
    fill(255);
    stroke(0);
    rectMode(LEFT);
    strokeWeight(width/300);
    rect(width*.3, height*.1, width*.7, height*.9, width*.01);

    textAlign(CENTER, CENTER);
    textSize(width/20);
    fill(#f44542);
    text("Knock Out", width/2, height*.2);

    textSize(width/50);
    fill(0);
    text("WASD - movement", width/2, height*.37);
    text("Arrow Keys - orb control", width/2, height*.41);
    text("Space - speed boost", width/2, height*.45);

    rectMode(CENTER);
    fill(#f44542);
    rect(width/2, height*.6, width/4, height/12);
    rect(width/2, height*.7, width/4, height/12);
    rect(width/2, height*.8, width/4, height/12);

    fill(0);
    textSize(width/30);
    text("Easy", width/2, height * .59);
    text("Medium", width/2, height * .69);
    text("Hard", width/2, height * .79);

    if (mousePressed && mouseX > width*.4 && mouseX < width*.6 && mouseY > height*.55 && mouseY < height*.65) {
      nexus.play = true;
      nexus.ai.difficulty = .65;
    } else if (mousePressed && mouseX > width*.4 && mouseX < width*.6 && mouseY > height*.65 && mouseY < height*.75) {
      nexus.play = true;
      nexus.ai.difficulty = .5;
    } else if (mousePressed && mouseX > width*.4 && mouseX < width*.6 && mouseY > height*.75 && mouseY < height*.85) {
      nexus.play = true;
      nexus.ai.difficulty = .3;
    }
  }

  void backgroundCircles() {
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

  void shakeScreen() {
    if (shakeTimer > 0) {
      translate(random(-width/70, width/70), random(-height/70, height/70));
    } else {
      translate(0, 0);
    }
    shakeTimer--;
  }

  void createCircle(float x, float y, int type) {
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
      circleParticles.add(new CircleParticles(x, y, random(-5, 5), random(-5, 5), random(0, 1), #f44542));
      break;
    }
  }
}