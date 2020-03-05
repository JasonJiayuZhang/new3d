class Snow {

  float x = random(0, 5000);
  float y = random(-2500, -400);
  float z = random(200, 5000);
  float vy = random(-5, 5);
  float vx = random(-5, 5);
  float vz = random(-5, 5) ;
  int timer = 60;

  void show() {

    pushMatrix();
    translate(x, y, z);
    fill(black);
    box(10);
    popMatrix();
  }

  void act() {
    y = y - vy;
    vy = vy -0.05;
    x = x - vx;
    z = z - vz;
    if (y > height-400) {
      timer--;
      vy = vy +0.05;
      y = y + vy;
      x = x + vx;
      z = z + vz;
      if (timer == 0) {
        y = random(-2500, -400);
        timer = 60;
        vy = random(-5, -9);
        vx = random(-5, 5);
      }
    }
  }
}
