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

void setup() {

  // create canvas
  size(400, 400);

  // number of elements
  int num = 50;

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

    // Further from centre, more faint
    float transparency = dist(x[i], y[i], width/2, height/2);
    transparency = 100 - map(transparency, 0, dist(0, 0, width/2, height/2), 0, 100);
    println(transparency);
    noStroke();
    fill(0, transparency);

    // Draw element on screen
    ellipse(x[i], y[i], 2, 2);
  }

  // Save frames every so often
  if (frameCount % 10 == 0) {
    saveFrame("output-#######.png");
  }
}
