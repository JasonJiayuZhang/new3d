class Bullet extends Objects {

  Bullet(float _x, float _y, float _z, float _vx, float _vz, float _vy) {
    x = _x;
    y = _y;
    z = _z;
    vx = _vx;
    vz = _vz;
    vy = _vy;
  }

  void show() {

    pushMatrix();
    translate(x, y, z);
    fill(black);
    sphere(10);
    popMatrix();
  }

  void act() {
    x = x + vx;
    z = z + vz;
    y = y + vy;
    vy = vy + gravity;

    if (y > height-400) {
      timer--;
      x = x - vx;
      z = z - vz;
      y = y - vy;
      gravity = 0;
      if (timer == 0) {
        lives = 0;
        timer = 60;
      }
    }
  }
}
