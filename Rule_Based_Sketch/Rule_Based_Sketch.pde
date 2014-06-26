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
