// Variables to control colour of selection circle
float h = 0;
float s = 100;
float b = 100;

// Whether to adjust brightness
boolean adjustBrightness = false;

void setup() {

  // Create canvas
  size(1000, 400, P3D);

  // Colour mode is HSB
  colorMode(HSB, 360, 100, 100, 100);

  ortho();
}

void draw() {

  // White background
  background(0, 0, 100);

  // Set the table so that a cylinder can be viewed slightly from the side
  translate(width/2, height/3, (100-b));
  scale(1, -1);
  rotateX(radians(120));
  scale(1, -1);

  // Draw the cylinder
  pushMatrix();
  drawColourCylinderSlice(height/4*3, 0, 360);
  popMatrix();

  // Draw the handles
  drawMarker(true); // main colour
  drawMarker(false);  // complementary colour
}

// drawMarker
//
// Purpose: Draws the main and complementary markers
//
// Parameters:      diameter    How large the cylinder should be, across.
//                  fromAngle   Hue at which to start drawing a slice.
//                  toAngle     Hue at which to finish drawing a slice.
void drawMarker(boolean mainColour) {

  float colour = h;
  if (!mainColour) {
    colour = (h + 180) % 360;
  }
  pushMatrix();
  strokeWeight(1.5);
  stroke(250);
  fill(colour, s, b);
  translate(0, 0, (100-b));  // make sure markers move if the brightness is changed
  rotate(radians(colour)); // rotate around centre of colour circle
  translate((height/4*3)/2 + 60, 0); // move origin to middle of marker circle
  
  // keep handles "facing" viewer while they rotate
  rotateX(radians(90));  
  if ((colour > 0 && colour <= 90) || (colour > 270 && colour <= 360)) {
    rotateY(radians(-90*sin(radians(colour))));
  } else if ((colour > 90 && colour <= 180) || (colour > 180 && colour <= 270)) {
    rotateY(radians(90*sin(radians(colour))));
  }
  
  // draw the actual marker
  ellipse(0, 0, 50, 50);
  popMatrix();
}

// drawColourCylinderSlice
//
// Purpose: Draws a "slice" of the HSB colour cylinder
//
// Parameters:      diameter    How large the cylinder should be, across.
//                  fromAngle   Hue at which to start drawing a slice.
//                  toAngle     Hue at which to finish drawing a slice.
void drawColourCylinderSlice(float diameter, float fromAngle, float toAngle) {

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
}

void mouseMoved() {

  // Change brightness based on vertical mouse position
  if (adjustBrightness) {
    b = map(mouseY, height, 0, 0, 100);
  }

  // Determine distance of mouse cursor from centre of circle
  float xPos = mouseX - width/2;
  float yPos = (mouseY - height/3 - (100-b))*-1;

  // Base hue on angle, calculated from current x, y position relative to centre of colour wheel
  if (xPos > 150) {
    xPos = 150;
  }
  if (yPos > 75) {
    yPos = 75;
  }
  if (xPos < -150) {
    xPos = -150;
  }
  if (yPos < -75) {
    yPos = -75;
  }
  float hue = degrees(atan2(yPos, xPos));
  if (hue < 0) {
    h = 360 - abs(hue);
  } else {
    h = hue;
  }

  // Base saturation on distance from centre of colour circle
  float armLength = dist(xPos, yPos, 0, 0);
  armLength = armLength/(0.25*cos(h)+0.75); // adjust for effect of tilted circle
  //println(armLength);
  s = 100;
  //s = map(armLength, 0, 150, 0, 100);
}

void keyPressed() {

  // Toggle for brightness adjustment; allow when Shift key is pressed
  if (keyCode == SHIFT) {
    adjustBrightness = true;
  }
}

void keyReleased() {

  // When shift is not pressed, do not adjust the brightness
  adjustBrightness = false;
}
