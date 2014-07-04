void setup() {

  // Create canvas
  size(1000, 800, P3D);

  // Colour mode is HSB
  colorMode(HSB, 360, 100, 100, 100);

  // White background
  background(0, 0, 100);

  // No fill
  noFill();

  // Draw an ellipse in middle of screen
  translate(width/2, height/3);
  scale(1, -1);
  rotateX(radians(120));
  rotateZ(radians(30));
  scale(1, -1);
  drawLayer(height/4*3, 0, 300);
}

void draw() {
}

// drawLayer
//
// Purpose: Draws a layer of the colour cylinder
//
// Parameters:      diameter    How large the cylinder should be, across.
//                  fromAngle   Hue at which to start drawing a slice.
//                  toAngle     Hue at which to finish drawing a slice.
void drawLayer(float diameter, float fromAngle, float toAngle) {

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


  // Draw the cylinder
  for (int brightness = 100; brightness > 0; brightness--) {

    // Move down a "slice" in the cylinder
    translate(0, 0, (100-brightness)/25);

    // Draw the current slice
    for (float currentDiameter = diameter; currentDiameter > 0; currentDiameter -= diameter / 100) {

      float saturation = map(currentDiameter, 0, diameter, 0, 100);

      for (float angle = fromAngle; angle < toAngle; angle+=1) {

        // Set color and draw arc with this hue
        stroke(angle, saturation, brightness);
        strokeWeight(4);
        arc(0, 0, currentDiameter, currentDiameter, radians(angle), radians(angle + 2));
      }
    }
  }
  println("done");
}
