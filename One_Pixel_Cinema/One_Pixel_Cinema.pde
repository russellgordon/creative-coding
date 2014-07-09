// create an object to store the image
PImage workingImage;

// variables to track position of sampling points
int x;
int y;

// Make use of Perlin noise to vary the number of divisions
float perlinHorizontalStart = random(0, 1000); // Starting point on horizontal axis in Perlin noise space for horizontal sampling
float perlinHorizontalPosition = perlinHorizontalStart; // Current position on horizontal axis in Perlin noise space for horizontal sampling
float perlinVerticalStart = random(1001, 2000); // Starting point on horizontal axis in Perlin noise space for horizontal sampling
float perlinVerticalPosition = perlinVerticalStart; // Current position on horizontal axis in Perlin noise space for horizontal sampling

/*
 * SETTINGS: Vary the flags and values below to change output
 */

// Where to show shapes at right side of screen
boolean showHorizontalBars = true;
boolean showVerticalBars = false;

// Whether to show sampling points (helps to understand what's going on here...)
boolean showHorizontalSamplingPoints = false;
boolean showVerticalSamplingPoints = false;

// Opacity of rectangles
float horizontalOpacity = 5;
float verticalOpacity = 5;

// Divisions (number of sample points, or rows that will be sampled)
int verticalDivisions = 1; // for horizontal sampling, at least 2 required
int horizontalDivisions = 20; // for vertical sampling, at least 2 required

// What type of shape to draw with
boolean horizontalRectangle = false; // for horizontal sampling: rectangles when true, ellipses when false
boolean verticalRectangle = false; // for vertical sampling: rectangles when true, ellipses when false

// Whether to use Perlin noise to vary sampling resolution
boolean usePerlinNoiseToVaryHorizontalSamplingResolution = false;
boolean usePerlinNoiseToVaryVerticalSamplingResolution = false;

// Essentially, how drastically sampling resolution should change
// Lower value (0.004) means sampling resolution changes less often
// Higher value (0.01) means sampling resolution changes more often
float perlinHorizontalIncrement = 0.004; // for horizontal sampling
float perlinVerticalIncrement = 0.004; // for vertical sampling

// How wide a range of divisions should be allowed when using Perlin noise to vary sampling resolution
float perlinVerticalDivisionsMaximum = 20; // for horizontal sampling
float perlinHorizontalDivisionsMaximum = 50; // for vertical sampling

/*
 * RUNS ONCE
 */
void setup() {

  // create a canvas
  size(1200, 600);

  // Color mode
  colorMode(HSB, 360, 100, 100, 100);

  // White background
  background(0, 0, 100);

  // Load the picture file into the image object
  workingImage = loadImage("philosophers_walk.JPG");
}

/*
 * RUNS FOREVER
 */
void draw() {

  // Display the picture
  image(workingImage, 0, 0);

  // Get access to pixels in image
  workingImage.loadPixels();

  if (showHorizontalBars) {

    // Move sampling points
    x++;

    // Reset at right edge
    if (x > width / 2) {
      x = 0;
    }

    // Select how many divisions to have
    if (usePerlinNoiseToVaryHorizontalSamplingResolution) {
      perlinHorizontalPosition += perlinHorizontalIncrement;
      float noiseValue = noise(perlinHorizontalPosition);
      verticalDivisions = (int) map(noiseValue, 0, 1, 2, perlinVerticalDivisionsMaximum);
    }

    // Sample horizontally in rows (however many divisions is set to)
    for (int i = 0; i < verticalDivisions; i++) {

      // Get color from sampling position
      int verticalDistance = (height/verticalDivisions); // number of pixels, vertically, between each sampling line
      int offset = verticalDistance / 2;
      int verticalPosition = verticalDistance*i+offset;

      // Show sampling positions with an ellipse
      if (showHorizontalSamplingPoints) {
        strokeWeight(1);
        stroke(0, 0, 100);
        noFill();
        ellipse(x, verticalPosition, 1, 1);
        ellipse(x, verticalPosition, 25, 25);
      } 

      // Draw images on the right side of the screen based on samples from left
      noStroke();
      int index = x+(verticalPosition)*width/2;
      fill(workingImage.pixels[index], horizontalOpacity); // Changing final argument (opacity) drastically changes output
      if (horizontalRectangle) {
        rect(width/2, verticalDistance*i, width, verticalDistance);
      } else {
        float diameter = map(brightness(workingImage.pixels[index]), 0, 100, 5, verticalDistance);
        ellipse(x+width/2, verticalPosition, diameter, diameter);
      }
    }
  }

  // Move sampling points
  if (showVerticalBars) {

    // Move sampling points
    y++;

    // Reset at bottom edge
    if (y > height) {
      y = 0;
    }

    // Select how many divisions to have
    if (usePerlinNoiseToVaryVerticalSamplingResolution) {
      perlinVerticalPosition += perlinVerticalIncrement;
      float noiseValue = noise(perlinVerticalPosition);
      horizontalDivisions = (int) map(noiseValue, 0, 1, 2, perlinHorizontalDivisionsMaximum);
    }

    // Sample vertically in columns (however many divisions is set to)
    for (int i = 0; i < horizontalDivisions; i++) {

      // Get color from sampling position
      int horizontalDistance = ((width/2)/horizontalDivisions); // number of pixels, horizontally, between each sampling line
      int offset = horizontalDistance / 2;
      int horizontalPosition = horizontalDistance*i+offset;

      // Show sampling positions with an ellipse
      if (showVerticalSamplingPoints) {
        strokeWeight(1);
        stroke(0, 0, 100);
        noFill();
        ellipse(horizontalPosition, y, 1, 1);
        ellipse(horizontalPosition, y, 25, 25);
      } 

      // Draw images on the right side of the screen based on samples from left
      noStroke();
      int index = horizontalPosition+y*(width/2);
      if (index < workingImage.pixels.length) { 
        fill(workingImage.pixels[index], horizontalOpacity); // Changing final argument (opacity) drastically changes output
        if (verticalRectangle) {
          rect(horizontalDistance*i + width/2, 0, horizontalDistance, height);
        } else {
          float diameter = map(brightness(workingImage.pixels[index]), 0, 100, 5, horizontalDistance);
          ellipse(horizontalPosition + width/2, y, diameter, diameter);
        }
      }
    }
  }
}
