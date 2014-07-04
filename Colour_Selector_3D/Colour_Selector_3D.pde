// Variables to control colour of selection circle
float h = 0;
float s = 100;
float b = 100;

void setup() {

  // Create canvas
  size(600, 400, P3D);

  // Colour mode is HSB
  colorMode(HSB, 360, 100, 100, 100);
}

void draw() {

  noLights();
  // White background
  background(0, 0, 100);

  // Set the table so that a cylinder can be viewed slightly from the side
  translate(width/2, height/3);
  scale(1, -1);
  rotateX(radians(120));
  scale(1, -1);

  // Draw the cylinder
  pushMatrix();
  drawColourCylinder(height/4*3, 0, 360);
  popMatrix();

  // Change the hue
  h+=1;
  if (h > 360) {
    h = 0;
  }

  // Draw the handle
  strokeWeight(1.5);
  stroke(250);
  fill(h, s, b);
  translate(0, 0, (100-b));
  rotate(radians(h));
  ellipse((height/4*3)/2 + 40, 0, 25, 25);
}

// drawColourCylinder
//
// Purpose: Draws the colour cylinder
//
// Parameters:      diameter    How large the cylinder should be, across.
//                  fromAngle   Hue at which to start drawing a slice.
//                  toAngle     Hue at which to finish drawing a slice.
void drawColourCylinder(float diameter, float fromAngle, float toAngle) {

  // Sanity check: size of cylinder
  diameter = abs(diameter);
  if (diameter > width) {
    diameter = width/4*3;
  }
  if (diameter < 100) {
    diameter = 100;
  }

  // Sanity check: angles
  fromAngle = abs(fromAngle);
  toAngle = abs(toAngle);
  if (toAngle < fromAngle) {
    float tempAngle = toAngle;
    toAngle = fromAngle;
    fromAngle = tempAngle;
  }


  // Move down a "slice" in the cylinder
  translate(0, 0, (100-b));

  // Draw the current slice
  for (float currentDiameter = diameter; currentDiameter >= 0; currentDiameter -= diameter / 75) {

    float saturation = map(currentDiameter, 0, diameter, 0, 100);

    for (float angle = fromAngle; angle < toAngle; angle+=1) {

      // Only draw the edges of the cylinder for efficiency

      // Set color and draw arc with this hue
      fill(angle, saturation, b);
      stroke(angle, saturation, b);
      strokeWeight(4);
      arc(0, 0, currentDiameter, currentDiameter, radians(angle), radians(angle + 3));
    }
  }
  println("done");
}

void mouseMoved() {
   
  println(mouseY);
  b = map(mouseY, height, 0, 0, 100);
  println(b);
  
}
