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
 * This is a complementary colour selection tool.
 * 
 * You can work in the Hue-Saturation-Brightness colour model, or, the Hue-Saturation-Lightness colour model.
 *
 * An overview of the difference between these models is available here:
 *
 * http://codeitdown.com/hsl-hsb-hsv-color/
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
 * Press the SHIFT key, then move up or down on the screen to change the brightness/lightness of the main colour. 
 *
 * Click the mouse button to store a pair of complementary colours.
 *
 * You can store up to six colour pairs before the first pair is replaced.
 *
 */

// Variables to control colour of markers
float a = 0;       // Current angle in standard position on colour cylinder
float d = 100;     // Current distance from centre of colour cylinder
float h = 100;     // Current height of displayed disc in colour cylinder

// Arrays to store HSB and HSL values
float[] hueValues, saturationHSBValues, saturationHSLValues, brightnessValues, lightnessValues;
int currentValue = 0;
int maxValues = 6;
boolean palettesFilled = false; // whether all "slots" to store values have been used yet

// Whether to adjust each type of value
boolean adjustHue = false;
boolean adjustSaturation = false;
boolean adjustBrightnessOrLightness = false;

// What colour model is being displayed
boolean HSBModel = true;    // HSB if true, HSL if flase

// This runs once only.
void setup() {

  // Create canvas
  size(1200, 500, P3D);

  // Reset variables
  currentValue = 0;
  palettesFilled = false;
  if (HSBModel) {
    a = 0;
    d = 100;
    h = 100;
  } else {
    a = 0;
    d = 100;
    h = 50;
  }

  // Colour mode is HSB
  colorMode(HSB, 360, 100, 100, 100);

  // Smoothness of drawing
  smooth(2);

  // Perspective mode
  ortho();

  // Initialize arrays
  hueValues = new float[maxValues];
  saturationHSBValues = new float[maxValues];
  saturationHSLValues = new float[maxValues];
  brightnessValues = new float[maxValues];
  lightnessValues = new float[maxValues];
}

// This runs repeatedly, allowing for the animation to occur.
void draw() {

  // White background
  background(0, 0, 100);

  // Transformations so that "cylinder" can be viewed slightly from the side
  pushMatrix();
  translate(width/2, (height - 100)/3 + 100, (100-h));
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

  // Stop drawing until mouse is moved to save CPU cycles
  noLoop();
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
  translate(0, 0, (100-h));

  // Draw the current slice
  for (float currentDiameter = diameter; currentDiameter >= 0; currentDiameter -= diameter / 75) {

    float radius = map(currentDiameter / 2, 0, diameter / 2, 0, 100);

    for (float angle = fromAngle; angle < toAngle; angle+=1) {

      // Set color and draw arc with this hue
      if (HSBModel) {
        // HSB colours
        fill(angle, radius, h);
        stroke(angle, radius, h);
      } else {
        // HSL colours (whoa, this was hard to figure out... I *think* I've got it correct)
        // Using:
        // 
        //       http://hslpicker.com/ 
        //       ... and ...
        //       http://codeitdown.com/hsl-hsb-hsv-color/
        //       ... and ...
        //       http://en.wikipedia.org/wiki/File:Color_cones.png
        //
        // ... for reference material. 
        float brightness = getBrightness(h, radius);
        float saturationHSB = getHSBSaturation(brightness, h);
        fill(angle, saturationHSB, brightness);
        stroke(angle, saturationHSB, brightness);
      }
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

  float colour = a;
  if (!mainColour) {
    colour = (a + 180) % 360;
  }
  pushMatrix();
  strokeWeight(1.5);
  stroke(250);
  if (HSBModel) {
    fill(colour, d, h);
  } else {
    float brightness = getBrightness(h, d);
    float saturationHSB = getHSBSaturation(brightness, h);
    fill(colour, saturationHSB, brightness);
  }
  translate(0, 0, (100-h));  // make sure markers move if the brightness/lightness is changed
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
// Purpose: Display the hue, saturation, and brightness/lightness values on-screen.
//
// Parameters: none
//
void displayValues() {
  textAlign(CENTER, CENTER); // Text alignment for text boxes (centered vertically and horizontally)
  textSize(24);
  fill(0, 0, 0);
  stroke(0, 0, 0);
  if (HSBModel) {
    text("hue: " + round(a) + "\u00B0  saturation: " + round(d) + "%" + "  brightness: " + round(h) + "%", width/2, height - 50, 0);
  } else {
    text("hue: " + round(a) + "\u00B0  saturation: " + round(d) + "%" + "  lightness: " + round(h) + "%", width/2, height - 50, 0);
  }
}

// mouseReleased
//
// Purpose: Built-in Processing function that is run when the mouse button. 
//
void mouseReleased() {
}

// mouseMoved
//
// Purpose: Built-in Processing function that is run when the mouse moves.
//
void mouseMoved() {

  // Start animating again
  loop();

  // Change brightness/lightness based on vertical mouse position
  if (adjustBrightnessOrLightness) {
    if (mouseY >= 150 && mouseY <= 405) {
      h = map(mouseY - 150, 255, 0, 0, 100);
    }
  }

  // Determine distance of mouse cursor from centre of circle
  float xPos = mouseX - width/2;
  float yPos = (mouseY - ((height - 100)/3 + 100) - (100-h))*-1;

  // Base hue on angle, calculated from current x, y position relative to centre of colour wheel
  if (!adjustBrightnessOrLightness) {
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
        a = 360 - abs(hue);
      } else {
        a = hue;
      }
    }
  }

  // Base saturation on distance from centre of colour circle
  if (adjustSaturation) {
    float armLength = dist(xPos, yPos, 0, 0);
    armLength = armLength / (0.5*abs(cos(radians(a))) + 0.5); // adjust for effect of tilted circle
    if (armLength > 150) {
      armLength = 150;
    }
    d = map(armLength, 0, 150, 0, 100);
  }
}

// keyPressed
//
// Purpose: Built-in Processing function that is run when a key on the keyboard is pressed.
//
void keyPressed() {

  // Toggle for brightness/lightness adjustment; allow when Shift key is pressed
  if (key == CODED) {
    if (keyCode == SHIFT) {
      adjustBrightnessOrLightness = true;
    } else if (keyCode == CONTROL) {
      adjustHue = true;
    } else if (keyCode == ALT) {
      adjustSaturation = true;
    }
  }

  // Reset the sketch if requested
  if (key == 'r' || key == 'R') {
    setup();
    loop();
  } else if (key == 'm' || key == 'M') {
    if (HSBModel) {
      HSBModel = false;
      // Switch position in HSB cylinder to equivalent position in HSL cylinder
      float brightness = h; 
      h = getLightness(h, d);
      d = getHSLSaturation(brightness, h, d);
    } else {
      HSBModel = true;
      // Switch position in HSL cylinder to equivalent position in HSB cylinder
      float lightness = h; 
      h = getBrightness(h, d);
      d = getHSBSaturation(h, lightness);
    }
    loop();
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
  adjustBrightnessOrLightness = false;
}

// mousePressed
//
// Purpose: Built-in Processing function that is run when the mouse button is pressed.
//
void mousePressed() {

  // Save current HSB values
  hueValues[currentValue] = a;
  if (HSBModel) {
    brightnessValues[currentValue] = h;
    float lightness = getLightness(h, d);
    lightnessValues[currentValue] = lightness;
    saturationHSBValues[currentValue] = d;
    saturationHSLValues[currentValue] = getHSLSaturation(h, lightness, d);
  } else {
    lightnessValues[currentValue] = h;
    float brightness = getBrightness(h, d);
    brightnessValues[currentValue] = brightness;
    saturationHSLValues[currentValue] = d;
    saturationHSBValues[currentValue] = getHSBSaturation(brightness, h);
  }

  // Move to next postion in HSB value storage arrays
  currentValue++;
  if (currentValue == maxValues) {
    currentValue = 0;
    palettesFilled = true;
  }
  
  // Update display
  loop();
}

// getHSLSaturation
//
// Purpose: Provide saturation value for HSL colour model.
//          Using http://codeitdown.com/hsl-hsb-hsv-color/ for conversion formulas.
//
// Parameters:     Brightness value, as a percentage between 0 and 100.
//                 Lightness value, as a percentage between 0 and 100.
//                 HSB saturation, as a percentage between 0 and 100.
//
// Returns:        HSL colour model saturation, as a percentage between 0 and 100.
//
float getHSLSaturation(float brightness, float lightness, float saturationHSB) {

  return (((brightness/100) * (saturationHSB/100)) / (1 - abs(2*(lightness/100) - 1))) * 100;
}

// getLightness
//
// Purpose: Provide lightness value for HSL colour model.
//          Using http://codeitdown.com/hsl-hsb-hsv-color/ for conversion formulas.
//
// Parameters:     Brightness value, as a percentage between 0 and 100.
//                 HSB saturation, as a percentage between 0 and 100.
//
// Returns:        HSL colour model lightness, as a percentage between 0 and 100.
//
float getLightness(float brightness, float saturationHSB) {

  return (((brightness/100)*(2-(saturationHSB/100))) / 2) * 100;
}

// getBrightness
//
// Purpose: Convert HSL colour model lightness to HSB colour model brightness. 
//          Using http://codeitdown.com/hsl-hsb-hsv-color/ for conversion formulas.
//
// Parameters:     Lightness value for HSL colour model, as a percentage between 0 and 100.
//                 HSL colour model saturation, as a percentage between 0 and 100.
//
// Returns:        Brightness value for HSB colour model, as a percentage between 0 and 100.
//
float getBrightness(float lightness, float saturationHSL) {

  return ( ( 2*(lightness/100) + (saturationHSL/100)*(1 - abs(2*(lightness/100) - 1)) ) / 2) * 100;
}

// getHSBSaturation
//
// Purpose: Provide saturation value for HSB colour model.
//          Using http://codeitdown.com/hsl-hsb-hsv-color/ for conversion formulas.
//
// Parameters:     Brightness value, as a percentage between 0 and 100.
//                 Lightness value, as a percentage between 0 and 100.
//
// Returns:        HSB colour model saturation, as a percentage between 0 and 100.
//
float getHSBSaturation(float brightness, float lightness) {

  return (2*((brightness/100) - (lightness/100)) / (brightness/100)) * 100;
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
    displayMax = hueValues.length;
  }

  // Show the palettes
  for (int i = 0; i < displayMax; i++) {

    // Check if in second column
    if (i == hueValues.length / 2) {
      translate(1050, -375, 0); // Reset for second column
      textAlign(RIGHT, CENTER); // Text alignment for text boxes (centered vertically and horizontally)
      offset = -12.5;
    }
    translate(0, 125, 0);

    // "Main" colour
    noStroke();
    fill(hueValues[i], saturationHSBValues[i], brightnessValues[i]);
    rect(0, 0, 100, 100);

    // Display HSB values for "main" color
    textSize(12);
    fill(0, 0, 0);
    stroke(0, 0, 0);
    translate(offset, 12.5, 0);
    if (HSBModel) { 
      text("H: " + round(hueValues[i]) + "\u00B0  S: " + round(saturationHSBValues[i]) + "%" + "  B: " + round(brightnessValues[i]) + "%", 0, 0, 0);
    } else {
      text("H: " + round(hueValues[i]) + "\u00B0  S: " + round(saturationHSLValues[i]) + "%" + "  L: " + round(lightnessValues[i]) + "%", 0, 0, 0);
    }
    translate(-1*offset, -12.5, 0);

    // Complementary colour
    noStroke();
    fill((hueValues[i] + 180) % 360, saturationHSBValues[i], brightnessValues[i]);
    rect(25, 25, 50, 50);

    // Display HSB values for complementary color
    textSize(12);
    fill(0, 0, 0);
    stroke(0, 0, 0);
    translate(offset, 50, 0); 
    if (HSBModel) {
      text("H: " + round((hueValues[i] + 180) % 360) + "\u00B0  S: " + round(saturationHSBValues[i]) + "%" + "  B: " + round(brightnessValues[i]) + "%", 0, 0, 0);
    } else {
      text("H: " + round((hueValues[i] + 180) % 360) + "\u00B0  S: " + round(saturationHSLValues[i]) + "%" + "  L: " + round(lightnessValues[i]) + "%", 0, 0, 0);
    }
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
  if (HSBModel) {
    text("Press 'SHIFT' and move up/down to adjust brightness.  Click mouse button to save colours.  'M' to change colour mode.  'R' to reset.", width/2, 70);
  } else {
    text("Press 'SHIFT' and move up/down to adjust lightness.  Click mouse button to save colours.  'M' to change colour mode.  'R' to reset.", width/2, 70);
  }
}
