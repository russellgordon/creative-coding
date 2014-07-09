// create an object to store the image
PImage workingImage;

// variables to track position of sampling points
int x;
int y;

// divisions (number of sample points, or rows that will be sampled)
int verticalDivisions = 10;

// Make use of Perlin noise to vary the number of divisions
float perlinHorizontalStart = random(0, 1000); // Starting point on horizontal axis in Perlin noise space for horizontal sampling
float perlinHorizontalPosition = perlinHorizontalStart; // Current position on horizontal axis in Perlin noise space for horizontal sampling
float perlinVerticalStart = random(1001, 2000); // Starting point on horizontal axis in Perlin noise space for horizontal sampling
float perlinVerticalPosition = perlinVerticalStart; // Current position on horizontal axis in Perlin noise space for horizontal sampling

/*
 * SETTINGS: Vary the flags and values below to change output
 */
 
// Whether to show sampling points (helps to understand what's going on here...)
boolean showHorizontalSamplingPoints = true;
boolean showVerticalSamplingPoints = true;

// What type of rectangles to show
boolean showHorizontalBars = true;
boolean showVerticalBars = true;

// Opacity of rectangles
float horizontalOpacity = 5;
float verticalOpacity = 5;

// Whether to use Perlin noise to vary sampling resolution
boolean usePerlinNoiseToVaryHorizontalSamplingResolution = false;
boolean usePerlinNoiseToVaryVerticalSamplingResolution = false;

// Essentially, how drastically sampling resolution should change
// Lower value (0.004) means sampling resolution changes less often
// Higher value (0.01) means sampling resolution changes more often
float perlinHorizontalIncrement = 0.004; // for horizontal sampling
float perlinYIncrement = 0.010; // for vertical sampling

/*
 * RUNS ONCE
 */
void setup() {

  // create a canvas (702 pixels wide and 526 pixels high)
  size(1200, 600);

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

  // Move sampling points
  if (showVerticalBars) {
    y++;
    if (y > height) {
      y = 0;
    }
  }

  if (showHorizontalBars) {

    // Move sampling points
    x++;

    // Select how many divisions to have
    if (usePerlinNoiseToVaryHorizontalSamplingResolution) {
      perlinHorizontalPosition += perlinHorizontalIncrement;
      float noiseValue = noise(perlinHorizontalPosition);
      verticalDivisions = (int) map(noiseValue, 0, 1, 10, 20);
    } else {
      verticalDivisions = 10;
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
        stroke(255);
        noFill();
        ellipse(x, verticalPosition, 1, 1);
        ellipse(x, verticalPosition, 25, 25);
      } 

      // Draw rectangles on right side of screen
      noStroke();
      fill(workingImage.pixels[x+(verticalPosition)*width/2], horizontalOpacity); // Changing final argument (opacity) drastically changes output
      rect(width/2, verticalDistance*i, width, verticalDistance);
    }

    // Reset at edges
    if (x > width / 2) {
      x = 0;
    }
  }
}
