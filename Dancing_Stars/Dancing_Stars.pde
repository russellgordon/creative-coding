/*
 * Creative Coding
 * Week 2, 05 - Moving Patterns 1
 * by Indae Hwang and Jon McCormack
 * Copyright (c) 2014 Monash University
 *
 * This sketch builds on the previous sketches, drawing shapes based on the
 * current framerate. The movement of individual shapes combine to create a
 * gestalt field of motion. Use the arrow keys on your keyboard to change the
 * frame rate. 
 * 
 */

// variable used to store the current frame rate value
int frame_rate_value;
float hue = 0.0;

void setup() {
  size(500, 500);

  frame_rate_value = 6;
  frameRate(frame_rate_value);
  rectMode(CENTER);
  background(hue, 80, 90, 50);
  colorMode(HSB, 360, 100, 100, 100);
}


void draw() {
  
  // Background rotates through from red to green to blue repeatedly.
  // See: https://twitter.com/rgordon/status/406373396939673602/photo/1
  hue += 0.5;
  if (hue > 360) {
    hue = 0;
  }
  background(hue, 80, 90, 50);

  int num = 10;
  int margin = 0;
  float gutter = 0; //distance between each cell
  float cellsize = ( width - (2 * margin) - gutter * (num - 1) ) / (num - 1);

  int circleNumber = 0; // counter
  for (int i=0; i<num; i++) {
    for (int j=0; j<num; j++) {
      circleNumber = (i * num) + j; // different way to calculate the circle number from w2_04

      float tx = margin + cellsize * i + gutter * i;
      float ty = margin + cellsize * j + gutter * j;

      movingCircle(tx, ty, cellsize, circleNumber);
    }
  }
} //end of draw 


void movingCircle(float x, float y, float size, int circleNum) {

  float finalAngle;
  finalAngle = frameCount + circleNum;

  //the rotating angle for each tempX and tempY postion is affected by frameRate and angle;  
  float tempX = x + (size / 2) * sin(PI / frame_rate_value * finalAngle);
  float tempY = y + (size / 2) * cos(PI / frame_rate_value * finalAngle);

  noStroke();
  drawStarOfDavid(tempX, tempY, size/5);
}


/*
 * keyReleased function
 *
 * called automatically by Processing when a keyboard key is released
 */
void keyReleased() {

  // right arrow -- increase frame_rate_value
  if (keyCode == RIGHT && frame_rate_value < 60) {
    frame_rate_value++;
  }

  // left arrow -- decrease frame_rate_value
  if ( keyCode == LEFT && frame_rate_value > 1) {
    frame_rate_value--;
  }

  // set the frameRate and print current value on the screen
  frameRate(frame_rate_value);
  println("Current frame Rate is: " + frame_rate_value);
}

// drawStar
//
// Purpose: Draw a star at the specified point
void drawStarOfDavid(float x, float y, float base) {

  // get length of longer interior side
  float i = (base * sin(radians(30))) / sin(radians(120));

  // get height of interior triangle
  float ih = tan(radians(30)) * (base/2);

  // set visual characteristics
  fill(61, 94, 99);

  // draw first triangle (middle vertex facing up)
  triangle(x - base/2, y + ih, x, y - i, x + base/2, y + ih); 

  // draw second triangle (middle vertex facing down)
  triangle(x - base/2, y - ih, x, y + i, x + base/2, y - ih);

}
