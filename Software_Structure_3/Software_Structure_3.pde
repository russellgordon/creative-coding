/*
 * Software Structure #003
 * 
 * A surface filled with one hundred medium to small sized circles. Each
 * circle has a different size and direction, but moves at the same slow
 * rate. 
 * 
 * Display: 
 * 
 * A. The instantaneous intersections of the circles
 * B. The aggregate intersections of the circles
 * 
 * A. The points moving on the screen are the center of each circle and the
 * lines connect the intersections on the perimeters of overlapping
 * circles. To emphasize the difference in line length, they increase in
 * value from white to black as they grow longer. Because the edge of a
 * circle is a nonlinear surface, the lines drawn from the intersections
 * begin to grow quickly, linger as they approach maximum length, and
 * diminish quickly. When three or more circles overlap, the illusion of
 * depth increases as the resulting lines construct a corner.
 * 
 * B. The aggregate version is like photographing the instantaneous version
 * with the shutter left open for an extended time. It gives a different
 * vision into the structure by compressing changes over time into the same
 * visual space. The transition of the line values from white to black is
 * critical to avoid that the screen saturates entirely with one value. The
 * image created by this software is continually changing and never
 * repeating.
 *
 * Source: http://artport.whitney.org/commissions/softwarestructures/text.html#structure 
 */

// Variables to track number and location of circles
int circles = 20;
float[] circleX = new float[circles]; 
float[] circleY = new float[circles];
float[] diameter = new float[circles];

// Variables to track movement of circles
float[] direction = new float[circles];

// Initial length of vector
float velocity = random(0.5, 1);

// Whether to show what's going on
boolean drawCircles = false;
boolean drawVectors = false;
boolean drawIntersections = false;

// Whether to show only the current intersections or create a fade effect
boolean aggregate = true;

// This runs once.
void setup() {

  // Create canvas
  size(700, 700);

  // Color mode
  colorMode(HSB, 360, 100, 100, 100);

  // Set initial positions, sizes of circles, and direction of circles
  for (int i = 0; i < circles; i ++) {
    diameter[i] = random(100, 300);
    circleX[i] = random(0 + diameter[i], width - diameter[i]);
    circleY[i] = random(0 + diameter[i], height - diameter[i]);
    direction[i] = random(0, 360);
  }

  // Draw circles at initial positions
  drawCircles();
}

// This runs repeatedly
void draw() {

  // Update position of circles
  drawCircles();
}

// drawCircles
//
// Purpose: Draw the circles at their current locations
//
void drawCircles() {

  // Erase prior drawing
  if (aggregate) {
    fill(0, 0, 100, 5);
  } else {
    fill(0, 0, 100, 100);
  }
  noStroke();
  rect(0, 0, width, height);

  // Set visual attributes
  strokeWeight(1);
  noFill();

  // Draw the circles and their centre points
  for (int i = 0; i < circles; i++) {

    // Determine new position
    float dX = cos(radians(direction[i]))*velocity;
    float dY = sin(radians(direction[i]))*velocity;

    // Right boundary and left boundary check
    if ( ((circleX[i] + dX) > (width - diameter[i]/2)) || ((circleX[i] + dX) < diameter[i]/2)) {
      direction[i] = 180 - direction[i]; // reflection in vertical axis
      dX = cos(radians(direction[i]))*velocity;
    }
    // Top boundary and lower boundary check
    if ( ((circleY[i] + dY) > (height - diameter[i]/2)) || ((circleY[i] + dY) < diameter[i]/2)) {
      direction[i] = 360 - direction[i]; // reflection in horizontal axis
      dY = sin(radians(direction[i]))*velocity;
    }

    // Update position
    circleX[i] += dX;
    circleY[i] += dY;

    // Draw the circles in new position
    if (drawCircles) {
      noFill();
      stroke((i*3) % 360, 80, 90);
      ellipse(circleX[i], circleY[i], diameter[i], diameter[i]);
    }

    // Determine whether circles are overlapping, if so, draw points where they intersect
    for (int j = 0; j < circles; j++) {
      if (j == i) {
        // Don't check circle we're currently on
        continue;
      } else if ((j > 0) && circlesOverlapping(j, i) ) {
        // Draw ellipses at the point where these two circles overlap
        drawIntersections(j, i);
      } else if ((j == 0) && circlesOverlapping(j, circles - 1) ) {

        // Draw ellipses at the point where these two circles overlap
        drawIntersections(j, circles - 1);
      }
    }
  }
}

// keyPressed
// 
// Purpose: Built-in Processing function that occurs when a key is pressed
//
void keyPressed() {

  // Reset the sketch when the 'r' key is pressed
  if (key == 'r') {
    setup();
  }

  if (key == 'a') {

    if (aggregate) {
      aggregate = false;
    } else {
      aggregate = true;
    }
  }
}

// circlesOverlapping
// 
// Purpose: Determines whether two given circles are overlapping.
//
// Parameters:       a      index of first circle in the arrays that, put together, represent the circles
//                   b      index of second circle in the arrays that, put together, represent the circles
//
// Returns: true if they are
//
boolean circlesOverlapping(int a, int b) {

  return dist(circleX[a], circleY[a], circleX[b], circleY[b]) < (diameter[a]/2 + diameter[b]/2);
}

// drawIntersections
//
// Purpose: Given two circles that are overlapping, draw their intersection points
//
// Parameters:       a      index of first circle in the arrays that, put together, represent the circles
//                   b      index of second circle in the arrays that, put together, represent the circles
//
// Returns:          null
//
void drawIntersections(int a, int b) {

  // Reference: http://mathforum.org/library/drmath/view/51710.html
  // The Dr. George suggestion, at bottom of page.
  PVector C1 = new PVector(circleX[a], circleY[a]);      // Centre of circle 1
  PVector C2 = new PVector(circleX[b], circleY[b]);  // Centre of cirlce 2

  // Creates a unit vector from C1 to C2
  PVector V1 = new PVector();
  V1 = C1.get();
  V1.sub(C2);
  if (drawVectors) {
    line(C1.x, C1.y, C1.x - V1.x, C1.y - V1.y); // line between centres
  }
  V1.normalize(); // make unit vector
  if (drawVectors) {
    stroke(10);
    V1.mult(50);
    line(C1.x, C1.y, C1.x - V1.x, C1.y - V1.y); // line between centres
    V1.normalize();
  }

  // Get vector perpendicular to V1
  PVector V2 = new PVector(-1*V1.y, V1.x);
  if (drawVectors) {
    line(C1.x, C1.y, C1.x - V2.x, C1.y - V2.y); // perpendicular to line between centres
    V2.mult(50);
    line(C1.x, C1.y, C1.x - V2.x, C1.y - V2.y); // perpendicular to line between centres
    V2.normalize();
  }

  // If a vector V3 is from C1 to one of the circle intersection points... calculate A,
  // the angle between those vectors
  // see hand drawn sketch at: http://russellgordon.ca/doodles/two-circles-intersection-diagram.jpg
  float R1 = diameter[a] / 2;
  float R2 = diameter[b] / 2;
  float d = C1.dist(C2);
  float A = acos( (pow(R2, 2) - pow(R1, 2) - pow(d, 2) ) / ( -2*R1*d )  );
  A = PI - A;

  // first intersection point
  PVector I1 = PVector.mult(V1, R1*cos(A));
  I1.add(PVector.mult(V2, R1*sin(A)));
  I1 = PVector.add(C1, I1);
  if (drawIntersections) {
    stroke(2);
    fill(0, 0, 0);
    ellipse(I1.x, I1.y, 2, 2);
  }

  // second intersection point
  PVector I2 = PVector.mult(V1, R1*cos(A));
  I2.sub(PVector.mult(V2, R1*sin(A)));
  I2 = PVector.add(C1, I2);
  if (drawIntersections) {
    stroke(2);
    fill(0, 0, 0);
    ellipse(I2.x, I2.y, 2, 2);
  }

  // Draw a line connecting the intersection points per rules at:
  // http://artport.whitney.org/commissions/softwarestructures/text.html#structure (#3)
  strokeWeight(1);
  float opacity = 100;
  if (aggregate) {
    opacity = map(I1.dist(I2), 0, 2400, 0, 100);
  } else {
    opacity = map(I1.dist(I2), 0, 400, 0, 100);
  }
  stroke(0, 0, 0, opacity);
  line(I1.x, I1.y, I2.x, I2.y);
}
