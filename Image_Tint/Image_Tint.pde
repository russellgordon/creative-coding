// create an object to store the image
PImage workingImage;

// variable to track horizontal position of sampling point
int x = 0;
int y = 0;

// track last 10 division counts
int[] divisionsList = new int[100];

// This code is run once
void setup() {

  // create a canvas (702 pixels wide and 526 pixels high)
  size(800, 600);

  // Load the picture file into the image object
  workingImage = loadImage("philosophers_walk.JPG");

  // Display the picture
  image(workingImage, 0, 0);
  
  // Vertical sampling position
  y = (height/4);
  
  // Slow down the animation
  frameRate(15);
}

void draw() {

  // Get access to pixels in image
  workingImage.loadPixels();
  
  // Sample the brightness of the current pixel and use this to decide on number of vertical divisions on screen
  int divisions = (int) map(brightness(workingImage.pixels[x+y*width]), 0, 255, 0, 100);
  // Shuffle then add new value
  if (x > divisionsList.length - 1) {
    // Shuffle values down
    for (int i = 0; i < divisionsList.length - 1; i++) {
      divisionsList[i] = divisionsList[i + 1];
    }
    divisionsList[divisionsList.length - 1] = divisions;
  } else {
    // Just add new value until array is full
    divisionsList[x] = divisions;
  }
    
  // Display the picture
  image(workingImage, 0, 0);
    
  // Show small circle at sampling position
  stroke(255);
  strokeWeight(1);
  noFill();
  ellipse(x, y, 1, 1);
  ellipse(x, y, 50, 50);
  
  // Get current average of divisions
  double sum = 0;
  for (int i = 0; i < divisionsList.length; i++) {
    sum += divisionsList[i];
  }
  int averageDivisions = (int) sum / divisionsList.length;
  
  
  // Show horizontal and vertical bars on lower half of image
  float barWidth = width / averageDivisions;
  float XOffset = barWidth / 2;
  float barHeight = height / averageDivisions;
  float YOffset = barWidth / 2;
  for (int i = 0; i < averageDivisions; i++) {
    noStroke();
    int barXPosition = round(i*barWidth + XOffset);
    fill(workingImage.pixels[barXPosition + (y*3)*width], 150);
    rect(i*barWidth, height/2, barWidth, height/2);
    rect(0, height/2 + i*barHeight + YOffset, width, barHeight);
  }
  
  // Change horizontal position of sample
  x++;
  
  // Stop at right edge of image
  if (x > width) {
    noLoop();
  }
}
