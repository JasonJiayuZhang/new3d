import fisica.*;
color black = #000000;
color white = #FFFFFF;
boolean up, down, left, right, wkey, akey, skey, dkey, ekey;
boolean spacekey = false;
int bs = 100;
ArrayList<Bullet> bullets;
float howmuchparticle = 1000;
ArrayList<Particle> particles;
ArrayList<Objects> objects;
float lx = 2500, ly = height/2 - bs/2, lz = 2500;
PVector xzDirection = new PVector(0, -20); //which way we are facing
PVector xyDirection = new PVector(20, 0);  //for looking up and down
PVector strafeDir = new PVector(10, 0);
float leftRightHeadAngle = 0;
float upDownHeadAngle    = 0;
float headangle = 0;
PImage map;
PImage qblock, dT, dS, dB;
Snow[] snow = new Snow[1];
Snow s;
int shotTimer;
int threshold;
int timer = 60;
int lives = 1;
int live = 1;
float gravity = -9.8;  
float num = -5;
float rotx = PI/4, roty = rotx = PI/4;

void setup() {
  fullScreen(P3D);
  frameRate(150);
  smooth();
  shotTimer = 0;
  threshold = 120;
  qblock      = loadImage("qblock.png");
  dT    = loadImage("dirt_top.png");
  dS   = loadImage("dirt_side.jpg");
  dB = loadImage("dirt_bottom.jpg");
  textureMode(NORMAL);
  //bullet
  bullets = new ArrayList<Bullet>();
  //snow
  s = new Snow();
  for (int i = 0; i < snow.length; i++) {
    snow[i] = new Snow();
    map = loadImage("map.png");
  }
  //explosion
  particles = new ArrayList<Particle>();
}




void draw() {
  background(255);

  //directions
  float dx = lx+xzDirection.x;
  float dy = ly+ xyDirection.y;
  float dz = xzDirection.y+lz;

  //Heads up display

  fill(0);
  textSize(10);
  text(int(frameRate), 20, height-10);

  textSize(20);
  noStroke();
  textMode(SHAPE);

  //middle
  text(""+ int(num), width/2-15, height-850);


  num=map(mouseX, 0, width, 0, 360);


  stroke(0, 191, 255);
  noFill();
  strokeWeight(5);
  arc(width/2, height/2, 75, 75, -0.5, radians(30));
  arc(width/2, height/2, 75, 75, -2.3, radians(-50));
  arc(width/2, height/2, 75, 75, -3.7, radians(-150));
  arc(width/2, height/2, 75, 75, -5.5, radians(-225));

  line(width/2+37, height/2, width/2+50, height/2);
  line(width/2-38, height/2, width/2-50, height/2);
  line(width/2, height/2+37, width/2, height/2+50);
  line(width/2, height/2-38, width/2, height/2-50);

  noFill();
  strokeWeight(5);
  line(700, 20, width-690, 20);
  line(700, 60, width-690, 60);

  line(700, 60, 700, 20);
  line(width-690, 60, width-690, 20);


  strafeDir = xzDirection.copy();
  strafeDir.rotate(PI/2);

  //looking
  pushMatrix();
  camera(lx, ly, lz, dx, dy, dz, 0, 1, 0); 
  xzDirection.rotate(leftRightHeadAngle);
  xyDirection.rotate(upDownHeadAngle/2);
  leftRightHeadAngle = -(pmouseX - mouseX) * 0.01;
  upDownHeadAngle    = (pmouseY - mouseY) * 0.01;

  //actions
  for (int i = 0; i < snow.length; i++) {
    snow[i].show();
    snow[i].act();
  }





  if (wkey) {
    lx = lx + xzDirection.x;
    lz = lz + xzDirection.y;
  }

  if (skey) {
    lx = lx - xzDirection.x;
    lz = lz - xzDirection.y;
  }

  if (akey) {
    lx = lx - strafeDir.x;
    lz = lz - strafeDir.y;
  }
  if (dkey) {
    lx = lx + strafeDir.x;
    lz = lz + strafeDir.y;
  }

  shotTimer++;
  if (ekey && shotTimer >= threshold) { 
    bullets.add(new Bullet(lx, ly, lz, xzDirection.x, xzDirection.y, xyDirection.y));

    shotTimer = 0;
  }




  drawMap();
  drawFloor();  
  drawBullets();
  popMatrix();
}

void drawBullets() {
  int i = 0;
  //shotTimer--;
  if (spacekey) {
    //&& shotTimer >= threshold
    ly = ly -14;
    shotTimer = 0;
  } else {
    ly = ly - gravity;
    if (ly > height/2 - 700) {
      gravity = 0;
    }
    if (ly < height/2 - 400) {
      gravity = -9.8;
    }
  }
  while (i < bullets.size()) {
    Bullet b = bullets.get(i);
    b.act();
    b.show();
    i++;
    if (lives == 0) {
      bullets.remove(b); 
      for (int j = 0; j < howmuchparticle; j++) {
        particles.add(new Particle(lx, ly-200, lz, xzDirection.x, xzDirection.y, xyDirection.y));
      }
    }
  }
  int n = 0;
  while (n < particles.size()) {
    Particle p = particles.get(n);
    p.show();
    p.act();
    n++;
    if (lives <= 0) {
      particles.remove(p);
      lives = 1;
    }
  }
  if (timer ==0 &&lives  == 3 && ekey) {
    bullets.add(new Bullet(lx, ly, lz, xzDirection.x, xzDirection.y, xyDirection.y));
  }
}
void drawFloor() {
  int x = 0;
  int y = height/2 + bs/2;
  stroke(100);
  strokeWeight(1);
  while (x < map.width*bs) {
    line(x, y, 0, x, y, map.height*bs);
    x = x + bs;
  }

  int z = 0;
  while (z < map.height*bs) {
    line(0, y, z, map.width*bs, y, z);
    z = z +bs;
  }

  noStroke();
}



void drawMap() {
  int mapX = 0, mapY = 0;
  int worldX = 0, worldZ = 0;

  while ( mapY < map.height ) {
    //read in a pixel
    color pixel = map.get(mapX, mapY);

    worldX = mapX * bs;
    worldZ = mapY * bs;

    if (pixel == black) {
      texturedBox(dT, dS, dB, worldX, height/2, worldZ, bs/2);
    }

    mapX++;
    if (mapX > map.width) {
      mapX = 0; //go back to the start of the row
      mapY++;   //go down to the next row
    }

    if (dist(pixel, lx, ly, lz) < 1000) {
      ly = height/2 - 600;
      //gravity = 0;
    }
  }
}

void texturedBox(PImage top, PImage side, PImage bottom, float x, float y, float z, float size) {
  pushMatrix();
  translate(x, y, z);
  scale(size);

  beginShape(QUADS);
  noStroke();
  texture(side);

  // +Z Front Face
  vertex(-1, -1, 1, 0, 0);
  vertex( 1, -1, 1, 1, 0);
  vertex( 1, 1, 1, 1, 1);
  vertex(-1, 1, 1, 0, 1);

  // -Z Back Face
  vertex(-1, -1, -1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1, 1, -1, 1, 1);
  vertex(-1, 1, -1, 0, 1);

  // +X Side Face
  vertex(1, -1, 1, 0, 0);
  vertex(1, -1, -1, 1, 0);
  vertex(1, 1, -1, 1, 1);
  vertex(1, 1, 1, 0, 1);

  // -X Side Face
  vertex(-1, -1, 1, 0, 0);
  vertex(-1, -1, -1, 1, 0);
  vertex(-1, 1, -1, 1, 1);
  vertex(-1, 1, 1, 0, 1);

  endShape();

  beginShape();
  texture(bottom);

  // +Y Bottom Face
  vertex(-1, 1, -1, 0, 0);
  vertex( 1, 1, -1, 1, 0);
  vertex( 1, 1, 1, 1, 1);
  vertex(-1, 1, 1, 0, 1);

  endShape();

  beginShape();
  texture(top);

  // -Y Top Face
  vertex(-1, -1, -1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1, -1, 1, 1, 1);
  vertex(-1, -1, 1, 0, 1);

  endShape();

  popMatrix();
}

void keyPressed() { 
  if (keyCode == UP) up = true;
  if (keyCode == DOWN) down = true;
  if (keyCode == LEFT) left = true;
  if (keyCode == RIGHT) right = true;
  if (key == 'w')  wkey = true;
  if (key == 's') skey = true;
  if (key == 'a') akey = true;
  if (key == 'd') dkey = true;
  if (key == 'e') ekey = true;
  if (key == ' ')       spacekey = true;
}

void keyReleased() {
  if (keyCode == UP) up = false;
  if (keyCode == DOWN) down = false;
  if (keyCode == LEFT) left = false;
  if (keyCode == RIGHT) right = false;
  if (key == 'w')  wkey = false;
  if (key == 's') skey = false;
  if (key == 'a') akey = false;
  if (key == 'd') dkey = false;
  if (key == 'e') ekey = false;
  if (key == ' ')       spacekey = false;
}
