// Variables to control colour of markers
float h = 0;
float s = 100;
float b = 100;

// Whether to adjust each type of value
boolean adjustHue = false;
boolean adjustSaturation = false;
boolean adjustBrightness = false;

// This runs once only.
void setup() {

  // Create canvas
  size(1000, 400, P3D);

  // Colour mode is HSB
  colorMode(HSB, 360, 100, 100, 100);
  
  // Text alignment for text boxes (centered vertically and horizontally)
  textAlign(CENTER, CENTER);
  
  // Smoothness of drawing
  smooth(2);

  // Perspective mode
  ortho();
}

// This runs repeatedly, allowing for the animation to occur.
void draw() {

  // White background
  background(0, 0, 100);
  
  // Transformations so that "cylinder" can be viewed slightly from the side
  pushMatrix();
  translate(width/2, height/3, (100-b));
  scale(1, -1);
  rotateX(radians(120));
  scale(1, -1);

  // Draw a "slice" of the colour cylinder
  drawColourCylinderSlice(height/4*3, 0, 360);
  
  // Draw a grey outline of the colour cylinder
  drawCylinderOutline();
  
  // Draw the markers
  pushMatrix();
  drawMarker(true); // main colour
  drawMarker(false);  // complementary colour
  popMatrix();
  
  // Back to origin at top left
  popMatrix();
  
  // Display current HSB values
  displayValues();

}

// drawColourCylinderSlice
//
// Purpose: Draws a "slice" of the HSB colour cylinder
//
// Parameters:      diameter    How large the cylinder should be, across.
//                  fromAngle   Hue at which to start drawing a slice.
//                  toAngle     Hue at which to finish drawing a slice.
void drawColourCylinderSlice(float diameter, float fromAngle, float toAngle) {

  pushMatrix();

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
  
  popMatrix();

}

// drawCylinderOutline
//
// Purpose: Draws an outline of the HSB colour cylinder
//
// Parameters: none
//
void drawCylinderOutline() {

  pushMatrix();
  strokeWeight(4);
  stroke(325);
  translate(0, 0, -1);
  noFill();
  ellipse(0, 0, height/4*3+6, height/4*3+6); // top circle
  translate(0, 0, 100);
  ellipse(0, 0, height/4*3+6, height/4*3+6); // bottom circle
  translate((height/4*3+6)/2, 0, 0);
  line(0, 0, 0, 0, 0, -100); // right line
  translate(-1*(height/4*3+6), 0, 0);
  line(0, 0, 0, 0, 0, -100); // right line
  popMatrix();

}

// drawMarker
//
// Purpose: Draws the main and complementary markers
//
// Parameters:      mainColour    True when drawing the "main" colour, false when drawing the complementary colour.
//
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


// displayValues
//
// Purpose: Display the hue, saturation, and brightness values on-screen.
//
// Parameters: none
//
void displayValues() {
  textSize(16);
  fill(0, 0, 0);
  stroke(0, 0, 0);
  text("hue: " + round(h) + "\u00B0  saturation: " + round(s) + "%" + "  brightness: " + round(b) + "%", width/2, height - 50, 0); 
}

// mouseMoved
//
// Purpose: Built-in processing function used to track current mouse position.
//
void mouseMoved() {

  // Change brightness based on vertical mouse position
  if (adjustBrightness) {
    b = map(mouseY, height, 0, 0, 100);
  }

  // Determine distance of mouse cursor from centre of circle
  float xPos = mouseX - width/2;
  float yPos = (mouseY - height/3 - (100-b))*-1;

  // Base hue on angle, calculated from current x, y position relative to centre of colour wheel
  if (!adjustBrightness) {
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
    if (adjustHue) {
      float hue = degrees(atan2(yPos, xPos));
      if (hue < 0) {
        h = 360 - abs(hue);
      } else {
        h = hue;
      }
    }
  }


  // Base saturation on distance from centre of colour circle
  if (adjustSaturation) {
    float armLength = dist(xPos, yPos, 0, 0);
    armLength = armLength / (0.5*abs(cos(radians(h))) + 0.5); // adjust for effect of tilted circle
    if (armLength > 150) {
      armLength = 150;
    }
    s = map(armLength, 0, 150, 0, 100);
  }
}

// keyPressed
//
// Purpose: Built-in processing function used to track when a key is pressed on the keyboard
//
void keyPressed() {

  // Toggle for brightness adjustment; allow when Shift key is pressed
  if (key == CODED) {
    if (keyCode == SHIFT) {
      adjustBrightness = true;
    } else if (keyCode == CONTROL) {
      adjustHue = true;
    } else if (keyCode == ALT) {
      adjustSaturation = true;
    }
  }
}

// keyReleased
//
// Purpose: Built-in processing function used to track when a key is pressed on the keyboard
//
void keyReleased() {

  // When keys are not pressed, do not adjust anything
  adjustHue = false;
  adjustSaturation = false;
  adjustBrightness = false;
}
