/*
 * To the extent possible under law, Russell Gordon has waived all copyright and related
 * or neighboring rights to Rule Based Sketch. This work is published from: Canada.
 * http://creativecommons.org/publicdomain/zero/1.0/
 *
 * Thursday, June 26, 2014
 * 
 * Rule-based art sketch, homework for week 3 of Creative Coding course.
 * https://www.futurelearn.com/courses/creative-coding
 *
 * Element 0
 *
 * Form 1       Circle
 * Behaviour 1  move in a straight line
 * Behaviour 2  constrain to a surface
 *
 * Process 0
 *
 * A rectangular surface filled with copies of Element 0.
 * If two Elements intersect then draw a line connecting their
 * centres, colouring the line based on the circle being odd or even.
 */

float x[], y[];      // position
float dx[], dy[];    // change in position

boolean captureOutput = false; // whether to save GIF files for output

void setup() {

  // create canvas
  size(400, 400);

  // number of elements
  int num = 1;

  // initialize arrays
  x = new float[num];
  y = new float[num];
  dx = new float[num];
  dy = new float[num];

  // initalize elements
  for (int i = 0; i < x.length; i++) {
    // initial position
    x[i] = width/2;
    y[i] = height/2;

    // initial direction
    dx[i] = random(-1, 1);
    dy[i] = random(-1, 1);
  }

  // background
  background(255);

  // smoother lines
  smooth(2);
}

void draw() {

  // update elements on screen
  for (int i = 0; i < x.length; i++) {

    // Change position of element
    x[i] += dx[i];
    y[i] += dy[i];
    
    // Check for boundary
    constrainToSurface(x, y, dx, dy, i);

    // Further from centre, more faint
    float transparency = dist(x[i], y[i], width/2, height/2);
    transparency = 100 - map(transparency, 0, dist(0, height/2, width/2, height/2), 0, 100);
    println(transparency);
    noStroke();
    fill(0, transparency);

    // Draw element on screen
    ellipse(x[i], y[i], 2, 2);
  }

  // Save frames every so often
  if (frameCount % 10 == 0 && captureOutput == true) {
    saveFrame("output-#######.gif");
  }
}

// constrainToSurface
// 
// Purpose: Ensure that an element does not go off the screen
//
// Parameters:      x[]      A reference to an array containing x values for all elements
//                  y[]      A reference to an array containing y values for all elements
//                  dx[]     A reference to an array containing horizontal change values for all elements
//                  dy[]     A reference to an array containing vertical change values for all elements
//                  i        What element to check the position of
void constrainToSurface(float[] x, float[] y, float[] dx, float[] dy, int i) {
  
  // constrain horizontally
  if (x[i] + dx[i] > width) {    // right boundary
    dx[i] = random(-1, -0.01);
  } else if (x[i] + dx[i] < 0) { // left boundary
    dx[i] = random(0.01, 1);
  }

  // constrain vertically
  if (y[i] + dy[i] > height) {    // bottom boundary
    dy[i] = random(-1, -0.01);
  } else if (y[i] + dy[i] < 0) { // top boundary
    dy[i] = random(0.01, 1);
  }
}
