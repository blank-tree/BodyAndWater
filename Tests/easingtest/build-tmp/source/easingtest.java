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

public class easingtest extends PApplet {

float x;
float y;
float easing = 0.05f;

PImage[] wave = new PImage[3];

int[] pos = {0,0,0};

public void setup() {
   
  noStroke();

  wave[0] = loadImage("wave_3.png");
  wave[1] = loadImage("wave_2.png");
  wave[2] = loadImage("wave_1.png");

}

public void draw() { 
  background(51);
  
  float targetY = mouseY;
  float dy = targetY - y;
  y += dy * easing;

  for (int i = 0; i < 3; i++) {
    drawWave((i+1)*2, color(i*50, i*80, i*100), i);
  }
}

public void drawWave(int _spd, int _color, int _i) {
  fill(_color);
  image(wave[_i], pos[_i], y+(_i*120));
  image(wave[_i], pos[_i]-1100, y+(_i*120));
  if (pos[_i] < width) {
    pos[_i] += _spd;
  } else {
    pos[_i] = 0;
  }
}
  public void settings() {  size(960, 640, P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "easingtest" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
