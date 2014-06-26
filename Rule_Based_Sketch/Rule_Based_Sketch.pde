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

float x, y;      // position
float dx, dy;    // change in position

void setup() {
  
  // create canvas
  size(800, 800);
  
  // initial position
  x = width/2;
  y = height/2;
  
  // initial direction
  dx = random(-1, 1);
  dy = random(-1, 1);
  
  // background
  background(255);
  
  // black, no border for element
  noStroke();
  fill(0);
  
}

void draw() {
  
  // Change position of element
  x += dx;
  y += dy;
  
  // Draw element on screen
  ellipse(x, y, 2, 2);
  
}
