float x;
float y;
float easing = 0.05;

PImage[] wave = new PImage[3];

int[] pos = {0,0,0};

void setup() {
  size(960, 640, P2D); 
  noStroke();

  wave[0] = loadImage("wave_3.png");
  wave[1] = loadImage("wave_2.png");
  wave[2] = loadImage("wave_1.png");

}

void draw() { 
  background(51);
  
  float targetY = mouseY;
  float dy = targetY - y;
  y += dy * easing;

  for (int i = 0; i < 3; i++) {
    drawWave((i+1)*2, color(i*50, i*80, i*100), i);
  }
}

void drawWave(int _spd, color _color, int _i) {
  fill(_color);
  image(wave[_i], pos[_i], y+(_i*120));
  image(wave[_i], pos[_i]-1100, y+(_i*120));
  if (pos[_i] < width) {
    pos[_i] += _spd;
  } else {
    pos[_i] = 0;
  }
}