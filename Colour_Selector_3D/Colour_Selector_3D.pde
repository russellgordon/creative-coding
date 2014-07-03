float diameter = 0;  // diameter of cylinder

void setup() {

  // Create canvas
  size(500, 500, P3D);

  // Set diameter of cylinder
  diameter = width/4*3;  
  
}

void draw() {

  // Draw an ellipse in middle of screen
  translate(width/2, height/2); 
  rotateX(radians(100));
  ellipse(0, 0, diameter, diameter);
}
