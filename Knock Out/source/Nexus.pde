class Nexus {
  Player p1 = new Player();
  PlayerAI ai = new PlayerAI();
  Effects effects = new Effects();
  boolean play = false;

  void run() {
    background(255);
    effects.shakeScreen();
    effects.backgroundCircles();
    effects.powerUp();
    effects.particleCircles();
    if (play == false)
      effects.ui();
    if (play == true) {
      player();
      ai();
    }
  }

  void player() {
    p1.control();
    p1.move();
    p1.rotateOrbital();
    p1.collisions();
    p1.powerUp();
    p1.showOrbitals();
    p1.show();
  }

  void ai() {
    ai.control();
    ai.move();
    ai.rotateOrbital();
    ai.collisions();
    ai.powerUp();
    ai.showOrbitals();
    ai.show();
  }
  
  void restart(){
    ai.hp = 30;
    ai.location.set(width*.25, height/2);
    ai.size = width/25;
    ai.boostCounter = 0;
    
    
    p1.hp = 30;
    p1.location.set(width*.75, height/2);
    p1.size = width/25;
    p1.boostCounter = 0;
    
    play = false;
  }
}