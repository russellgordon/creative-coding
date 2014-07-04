/*
 * This work is published under the Creative Commons ShareAlike 4.0 International License.
 *
 * Summary of licensing terms: http://creativecommons.org/licenses/by-sa/4.0/
 *
 * This work is published by Russell Gordon, from Toronto, Ontario, Canada.  July 2014.
 */

/*
 * PURPOSE
 *
 * This is a complementary colour selection tool, based on the Hue-Saturation-Brightness colour model.
 *
 * A static summary of how colours are selected using this model is available here:
 *
 * https://twitter.com/rgordon/status/406373396939673602/photo/1
 *
 * The "main" colour follows the position of the mouse; the complementary colour appears on the opposite side
 * of the colour wheel.
 *
 *
 * NOTES ON USE
 *
 * Press the CONTROL key, then move around the colour wheel to change the hue of the main colour.
 *
 * Press the ALT key, then move toward or away from the centre of the colour wheel to change the saturation of the main colour.
 * 
 * Press the SHIFT key, then move up or down on the screen to change the brightness of the main colour. 
 *
 * Click the mouse button to store a pair of complementary colours.
 *
 * You can store up to six colour pairs before the first pair is replaced.
 *
 */

// Variables to control colour of markers
float h = 0;
float s = 100;
float b = 100;

// Arrays to store HSB values
float[] hValues, sValues, bValues;
int currentValue = 0;
int maxValues = 6;
boolean palettesFilled = false; // whether all "slots" to store values have been used yet

// Whether to adjust each type of value
boolean adjustHue = false;
boolean adjustSaturation = false;
boolean adjustBrightness = false;

// This runs once only.
void setup() {

  // Create canvas
  size(1200, 500, P3D);

  // Reset variables
  h = 0;
  s = 100;
  b = 100;
  currentValue = 0;
  palettesFilled = false;

  // Colour mode is HSB
  colorMode(HSB, 360, 100, 100, 100);

  // Smoothness of drawing
  smooth(2);

  // Perspective mode
  ortho();

  // Initialize arrays
  hValues = new float[maxValues];
  sValues = new float[maxValues];
  bValues = new float[maxValues];
}

// This runs repeatedly, allowing for the animation to occur.
void draw() {

  // White background
  background(0, 0, 100);

  // Transformations so that "cylinder" can be viewed slightly from the side
  pushMatrix();
  translate(width/2, (height - 100)/3 + 100, (100-b));
  scale(1, -1);
  rotateX(radians(120));
  scale(1, -1);

  // Draw a "slice" of the colour cylinder
  drawColourCylinderSlice((height - 100)/4*3, 0, 360);

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

  // Display saved HSB values
  displaySavedValues();
  
  // Draw the help text
  drawHelpText();
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

  float cylinderWidth = (height - 100)/4*3+6;

  pushMatrix();
  strokeWeight(4);
  stroke(325);
  translate(0, 0, -1);
  noFill();
  ellipse(0, 0, cylinderWidth, cylinderWidth); // top circle
  translate(0, 0, 100);
  ellipse(0, 0, cylinderWidth, cylinderWidth); // bottom circle
  translate(cylinderWidth/2, 0, 0);
  line(0, 0, 0, 0, 0, -100); // right line
  translate(-1*(cylinderWidth), 0, 0);
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
  translate(((height - 100)/4*3)/2 + 60, 0); // move origin to middle of marker circle

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
  textAlign(CENTER, CENTER); // Text alignment for text boxes (centered vertically and horizontally)
  textSize(24);
  fill(0, 0, 0);
  stroke(0, 0, 0);
  text("hue: " + round(h) + "\u00B0  saturation: " + round(s) + "%" + "  brightness: " + round(b) + "%", width/2, height - 50, 0);
}

// mouseMoved
//
// Purpose: Built-in Processing function that is run when the mouse moves.
//
void mouseMoved() {

  // Change brightness based on vertical mouse position
  if (adjustBrightness) {
    b = map(mouseY, height, 0, 0, 100);
  }

  // Determine distance of mouse cursor from centre of circle
  float xPos = mouseX - width/2;
  float yPos = (mouseY - ((height - 100)/3 + 100) - (100-b))*-1;

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
// Purpose: Built-in Processing function that is run when a key on the keyboard is pressed.
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

  // Reset the sketch if requested
  if (key == 'r') {
    setup();
  }
}

// keyReleased
//
// Purpose: Built-in Processing function that is run when a key on the keyboard is released.
//
void keyReleased() {

  // When keys are not pressed, do not adjust anything
  adjustHue = false;
  adjustSaturation = false;
  adjustBrightness = false;
}

// mousePressed
//
// Purpose: Built-in Processing function that is run when the mouse button is pressed.
//
void mousePressed() {

  // Save current HSB values
  hValues[currentValue] = h;
  sValues[currentValue] = s;
  bValues[currentValue] = b;

  // Move to next postion in HSB value storage arrays
  currentValue++;
  if (currentValue == maxValues) {
    currentValue = 0;
    palettesFilled = true;
  }
}

// displaySavedValues
//
// Purpose: Display all saved HSB values on screen
//
void displaySavedValues() {

  textAlign(LEFT, CENTER); // Text alignment for text boxes (centered vertically and horizontally)
  float offset = 112.5;

  pushMatrix();
  translate(25, 0, 0);

  // Determine how many palettes to show
  int displayMax = 0;
  if (currentValue > 0 && palettesFilled == false) {
    displayMax = currentValue;
  } else if (palettesFilled == true) {
    displayMax = hValues.length;
  }

  // Show the palettes
  for (int i = 0; i < displayMax; i++) {

    // Check if in second column
    if (i == hValues.length / 2) {
      translate(1050, -375, 0); // Reset for second column
      textAlign(RIGHT, CENTER); // Text alignment for text boxes (centered vertically and horizontally)
      offset = -12.5;
    }
    translate(0, 125, 0);

    // "Main" colour
    noStroke();
    fill(hValues[i], sValues[i], bValues[i]);
    rect(0, 0, 100, 100);

    // Display HSB values for "main" color
    textSize(12);
    fill(0, 0, 0);
    stroke(0, 0, 0);
    translate(offset, 12.5, 0); 
    text("H: " + round(hValues[i]) + "\u00B0  S: " + round(sValues[i]) + "%" + "  B: " + round(bValues[i]) + "%", 0, 0, 0);
    translate(-1*offset, -12.5, 0);

    // Complementary colour
    noStroke();
    fill((hValues[i] + 180) % 360, sValues[i], bValues[i]);
    rect(25, 25, 50, 50);

    // Display HSB values for complementary color
    textSize(12);
    fill(0, 0, 0);
    stroke(0, 0, 0);
    translate(offset, 50, 0); 
    text("H: " + round((hValues[i] + 180) % 360) + "\u00B0  S: " + round(sValues[i]) + "%" + "  B: " + round(bValues[i]) + "%", 0, 0, 0);
    translate(-1*offset, -50, 0);
  }

  popMatrix();
}

// drawHelpText
//
// Purpose: Draws the instructions on screen.
//
// Parameters:     (none)
//
void drawHelpText() {

  // Box with light grey fill
  noStroke();
  fill(325); // pale yellow
  rect(0, 0, width, 100);

  // Separating line
  stroke(250);
  strokeWeight(2);
  line(0, 100, width, 100);

  // Help text
  textAlign(CENTER, CENTER); // Text alignment for text boxes (centered vertically and horizontally)
  textSize(18);
  fill(0);
  text("Press 'CONTROL' key and move mouse pointer around colour wheel to adjust hue.", width/2, 20);
  text("Press 'ALT' key and move to and from center of colour wheel to adjust saturation.", width/2, 45);
  text("Press 'SHIFT' and move up/down to adjust brightness.  Click mouse button to save colours.  'R' to reset.", width/2, 70);
}
