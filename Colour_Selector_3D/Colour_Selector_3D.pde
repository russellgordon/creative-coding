void setup() {

  // Create canvas
  size(500, 500, P3D);
  
  // Colour mode is HSB
  colorMode(HSB, 360, 100, 100, 100);
  
  // White background
  background(0, 0, 100);
  
  // No borders
  noStroke();

}

void draw() {

  // Draw an ellipse in middle of screen
  translate(width/2, height/2);
  scale(1, -1);
  //rotateX(radians(100));
  drawLayer(width/4*3, 0, 360);
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
  
  // Sanity check: angles
  fromAngle = abs(fromAngle);
  toAngle = abs(toAngle);
  if (toAngle < fromAngle) {
    float tempAngle = toAngle;
    toAngle = fromAngle;
    fromAngle = tempAngle; 
  }
  

  // Draw the slice
  for (float angle = fromAngle; angle < toAngle; angle+=1) {
    
    // Set color and draw arc with this hue
    stroke(angle, 100, 100);
    arc(0, 0, diameter, diameter, radians(angle), radians(angle + 2));
    
  }
  
}
