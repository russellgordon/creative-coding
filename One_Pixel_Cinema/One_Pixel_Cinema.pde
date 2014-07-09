// create an object to store the image
PImage workingImage;

// variables to track position of sampling points
int x;
int y;

// divisions (number of sample points)
int divisions = 10;

// This code is run once
void setup() {

  // create a canvas (702 pixels wide and 526 pixels high)
  size(1200, 600);
  
  // Load the picture file into the image object
  workingImage = loadImage("philosophers_walk.JPG");

}

void draw() {
  
  // Display the picture
  image(workingImage, 0, 0);

  // Get access to pixels in image
  workingImage.loadPixels();
  
  // Move sampling points
  x++;
  y++;
  
  // Sample vertically (however many divisions is set to)
  for (int i = 0; i < divisions; i++) {
    
    // Get color from sampling position
    int verticalDistance = (height/divisions); // number of pixels, vertically, between each sampling line
    int offset = verticalDistance / 2;
    int verticalPosition = verticalDistance*i+offset;
    if (i == 0) {
      println(x+(verticalPosition)*width/2);
    }
    //color colorValue = workingImage.pixels[x+(verticalPosition)*width];
    //color colorValue = color(0, 0, 0);
    
    // Show sampling positions with an ellipse
    strokeWeight(1);
    stroke(255);
    noFill();
    ellipse(x, verticalPosition, 1, 1);
    ellipse(x, verticalPosition, 25, 25); 
    
    // Draw rectangles on right side of screen
    noStroke();
    //fill(colorValue);
    fill(workingImage.pixels[x+(verticalPosition)*width/2], 10);
    rect(width/2, verticalDistance*i, width, verticalDistance);
  }
  
  // Reset at edges
  if (x > width / 2) {
    x = 0;
  }
  if (y > height) {
    y = 0;
  }
}
