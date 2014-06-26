/*
 * Creative Coding
 * Week 3, 04 - spinning top: curved motion with sin() and cos()
 * by Indae Hwang and Jon McCormack
 * Copyright (c) 2014 Monash University
 *
 * This sketch is the first cut at translating the motion of a spinning top
 * to trace a drawing path. This sketch traces a path using sin() and cos()
 *
 */

float[] x, y;      // current drawing position
float[] dx, dy;    // change in position at each frame
float rad;       // radius for the moving hand

void setup() {
  size(800, 800);

  // Initialize arrays
  int num = 2;
  x = new float[num];
  y = new float[num];
  dx = new float[num];
  dy = new float[num];

  for (int i = 0; i < x.length; i++) {
    // initial position in the centre of the screen
    x[i] = width/2;
    y[i] = height/2;

    // dx and dy are the small change in position each frame
    dx[i] = random(-1, 1);
    dy[i] = random(-1, 1);
  }
  background(0);
}


void draw() {
  // blend the old frames into the background
  blendMode(BLEND);
  fill(0, 0);
  noStroke();
  rect(0, 0, width, height);
  rad = radians(frameCount);

  for (int i = 0; i < x.length; i++) {

    // calculate new position
    x[i] += dx[i];
    y[i] += dy[i];

    //  fill(0, 0, 255);
    //  ellipse(x, y, 1, 1);

    float max = 1;
    float min = 0.5;

    //When the shape hits the edge of the window, it reverses its direction and changes velocity
    if (x[i] > width-100*(i*3) || x[i] < 100*(i*3)) {
      dx[i] = dx[i] > 0 ? -random(min, max) : random(min, max);
    }

    if (y[i] > height-100*(i*3) || y[i] < 100*(i*3)) {
      dy[i] = dy[i] > 0 ? -random(min, max) : random(min, max);
    }

    float bx = x[i] + 100 * sin(rad);
    float by = y[i] + 100 * cos(rad);

    //fill(255, 0, 0);
    //ellipse(bx, by, 2, 2);

    fill(180);

    float radius = 100 * sin(rad*0.1);
    float handX = bx + radius * sin(rad*3);
    float handY = by + radius * cos(rad*3);

    // As "top" approaches edge of canvas, lines are more opaque
    // In centre of canvas, lines are less opaque
    float transparency = dist(handX, handY, width/2, height/2);
    if (i == 0) {
      transparency = map(transparency, 0, dist(0, 0, width/2, height/2), 0, 10);
    } else {
      transparency = 20 - map(transparency, 0, dist(300, 300, width/2, height/2), 0, 20);
    }
    if (i == 0) {
      stroke(255, transparency);
    } else {
      stroke(61, 91, 144, transparency); // blue
    }

    line(bx, by, handX, handY);
    //ellipse(handX, handY, 2, 2);
    
  }
  
  // Every 1000 frames, save the result
  if (frameCount % 1000 == 0) {
     saveFrame("output-########.png"); 
  }
}
