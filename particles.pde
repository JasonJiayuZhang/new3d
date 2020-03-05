class Particle extends Objects {

  Particle(float _x, float _y, float _z, float _vx, float _vz, float _vy) {
    x = _x;
    y = _y;
    z = _z;
    vx = _vx;
    vz = _vz;
    vy = _vy;
    location = new PVector(x, y, z);
    position = new PVector(x, y, z);
    velocity = new PVector (random(4), random(4), random(4));
    velocity.rotate( random(TWO_PI) );
    c = color(random(255), random(255), random(255));
  }

  void show() {

    fill(c);
    pushMatrix();
    translate(x, y, z);
    translate(location.x, location.y, location.z);
    box(30);
    popMatrix();
  }

  void act() {
    //position.add(velocity);
    x = x + vx;
    z = z + vz;
    y = y + vy;
    vy = vy + gravity;
    if (y > height-10) {
      location.add(velocity);
      timer--;
      x = x - vx;
      z = z - vz;
      y = y - vy;
      gravity = 0;
      if (timer == 0) {
        lives = 0;
        timer = 60;
        timer--;
      }
    }
  }
}
