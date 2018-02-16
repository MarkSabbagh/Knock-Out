// // // Controls
// wasd - movement
// Space - dash
// left key and right key - orb rotation
// up key and right key - distance of orbs

Nexus nexus;

void setup() {
  fullScreen(P2D);
  frameRate(60);
  nexus = new Nexus();
}

void draw() {
  nexus.run();
}

void keyPressed() {

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

void keyReleased() {

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