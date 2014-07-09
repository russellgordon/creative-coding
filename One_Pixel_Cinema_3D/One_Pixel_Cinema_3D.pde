/*
 * CREDITS
 *
 * "Dog on vacation" photo by Mark Gilbert.
 * https://www.flickr.com/photos/thatkid/864513907/in/photolist-2joRSc-7kXG7M-7m2Lr3-9cZQW5-Ptv6w-5vmAnb-4fXMTi-dBTaNN-dBTerG-5M8zHd-cSNvuh-95oc5p-4a3Qy4-cFbfJb-dBzHzF-vGNL1-Ezz4W-47B9bA-8MynUm-8MynnJ-vq5eN-9dtEB3-o8Etfx-dQC9kt-724XK6-nRbhTW-5Q5JYy-dSyh9r-7mrv7b-dzT2i9-dZH5HY-71x31X-724Fnp-dQeLD-dDf2YT-7mrvhW-e16kRB-hH5B8s-o8EsQV-6BXKRW-cMJkf-7zaism-74XhhZ-e2C6sK-dZGxtA-dZWBKV-7mrwau-8Mvh8t-2GkEyF-8MvGzX
 * https://www.flickr.com/photos/thatkid/
 *
 */

// create an object to store the image
PImage workingImage;

// variables to track position of sampling points
int x;
int y;

// Arrays to track "HSB" co-ordinates of points sampled
float horizontalHues[], horizontalSaturations[], horizontalBrightnesses[];
float verticalHues[], verticalSaturations[], verticalBrightnesses[];

// Make use of Perlin noise to vary the number of divisions
float perlinStart = random(0, 1000); // Starting point on horizontal axis in Perlin noise space for sampling
float perlinPosition = perlinStart; // Current position on horizontal axis in Perlin noise space for sampling

/*
 * SETTINGS: Vary the flags and values below to change output
 */

// Whether to show sampling points (helps to understand what's going on here...)
boolean showHorizontalSamplingPoints = true;
boolean showVerticalSamplingPoints = true;

// Divisions (number of sample points that will be used, horizontally and vertically)
int divisions = 50;  // Maximum 100! (or you will get an array out of bounds exception)

// Whether to use Perlin noise to vary sampling resolution
boolean usePerlinNoiseToVarySamplingResolution = true;

// Essentially, how drastically sampling resolution should change
// Lower value (0.004) means sampling resolution changes less often
// Higher value (0.01) means sampling resolution changes more often
float perlinIncrement = 0.010;

// How wide a range of divisions should be allowed when using Perlin noise to vary sampling resolution
int perlinDivisionsMaximum = 25; // Maximum 100! (or you will get an array out of bounds exception)

/*
 * RUNS ONCE
 */
void setup() {

  // create a canvas
  size(1200, 600, P3D);

  // Color mode
  colorMode(HSB, 600, 600, 600, 100);

  // Black background
  background(0, 0, 0);

  // Load the picture file into the image object
  workingImage = loadImage("dog_on_vacation.jpg");

  // Initialize the arrays to store HSB co-ordinates
  horizontalHues = new float[100];
  horizontalSaturations = new float[100];
  horizontalBrightnesses = new float[100];
  verticalHues = new float[100];
  verticalSaturations = new float[100];
  verticalBrightnesses = new float[100];
  
}

/*
 * RUNS FOREVER
 */
void draw() {

  // Display the picture
  image(workingImage, 0, 0);

  // Get access to pixels in image
  workingImage.loadPixels();

  // Select how many divisions to have if using Perlin noise to vary how much sampling is done
  if (usePerlinNoiseToVarySamplingResolution) {
    perlinPosition += perlinIncrement;
    float noiseValue = noise(perlinPosition);
    divisions = (int) map(noiseValue, 0, 1, 2, perlinDivisionsMaximum);
  }

  // Move sampling points
  x++;

  // Reset at right edge
  if (x > width / 2) {
    x = 0;
  }

  // Sample horizontally in rows (however many divisions is set to)
  for (int i = 0; i < divisions; i++) {

    // Get color from sampling position
    int verticalDistance = (height/divisions); // number of pixels, vertically, between each sampling line
    int offset = verticalDistance / 2;
    int verticalPosition = verticalDistance*i+offset;

    // Show sampling positions with an ellipse
    if (showHorizontalSamplingPoints) {
      strokeWeight(1);
      stroke(0, 0, 600);
      noFill();
      ellipse(x, verticalPosition, 1, 1);
      ellipse(x, verticalPosition, 25, 25);
    } 

    // Draw images on the right side of the screen based on samples from left
    noStroke();
    int index = x+(verticalPosition)*width/2;

    // Store "HSB co-ordinates" for sampled point
    horizontalHues[i] = hue(workingImage.pixels[index]) - 300;
    horizontalSaturations[i] = saturation(workingImage.pixels[index]) - 300;
    horizontalBrightnesses[i] = brightness(workingImage.pixels[index]) - 300;
  }


  // Move vertical sampling points 
  y++;

  // Reset at bottom edge
  if (y > height) {
    y = 0;
  }

  // Sample vertically in columns (however many divisions is set to)
  for (int i = 0; i < divisions; i++) {

    // Get color from sampling position
    int horizontalDistance = ((width/2)/divisions); // number of pixels, horizontally, between each sampling line
    int offset = horizontalDistance / 2;
    int horizontalPosition = horizontalDistance*i+offset;

    // Show sampling positions with an ellipse
    if (showVerticalSamplingPoints) {
      strokeWeight(1);
      stroke(0, 0, 600);
      noFill();
      ellipse(horizontalPosition, y, 1, 1);
      ellipse(horizontalPosition, y, 25, 25);
    } 

    // Draw images on the right side of the screen based on samples from left
    noStroke();
    int index = horizontalPosition+y*(width/2);
    if (index < workingImage.pixels.length) { 

      // Store "HSB co-ordinates" for sampled point
      verticalHues[i] = hue(workingImage.pixels[index]) - 300;
      verticalSaturations[i] = saturation(workingImage.pixels[index]) - 300;
      verticalBrightnesses[i] = brightness(workingImage.pixels[index]) - 300;
    }
  }

  // Display lines between sampled "HSB co-ordinates"
  if (x % 10 == 0) {

    // Slowly fade right side of image
    noStroke();
    fill(0, 0, 0, 10);
    rect(width/2, 0, width/2, height);

    // Move origin so we can render lines between the HSB co-ordinates in 3D space
    pushMatrix();
    translate((width/4)*3, height/2, 0); // Move origin to middle of right side of screen
    ortho();

    // DEBUG -- to help figure out 3D space on right side of canvas
    //    stroke(0, 0, 0);
    //    stroke(0, 600, 600); // red
    //    line(-300, 0, 0, 300, 0, 0); // x-axis
    //    stroke(400, 600, 600); // blue
    //    line(0, -300, 0, 0, 300, 0); // y-axis
    //    stroke(200, 600, 600); // green
    //    strokeWeight(6);
    //    line(0, 0, -300, 0, 0, 300); // z-axis
    //    stroke(0, 0, 0, 5);
    //    fill(0, 0, 0, 1);
    //    box(600, 600, 600); 

    // Draw 10 segments between the two HSB co-ordinates, progressively changing colour from starting value to ending value
    noFill();
    strokeWeight(2);
    for (int i = 0; i < divisions; i++) {
      float priorX = horizontalHues[i];
      float priorY = horizontalSaturations[i];
      float priorZ = horizontalBrightnesses[i];
      for (int j = 0; j <= 10; j++) {
        float x = lerp(horizontalHues[i], verticalHues[i], j/10.0);
        float y = lerp(horizontalSaturations[i], verticalSaturations[i], j/10.0);
        float z = lerp(horizontalBrightnesses[i], verticalBrightnesses[i], j/10.0);
        stroke(priorX+300, priorY+300, priorZ+300, 50); // Change colour for this segment
        line(priorX, priorY, priorZ, x, y, z); // Draw the segment
        priorX = x;
        priorY = y;
        priorZ = z;
      }
    }
    popMatrix();
  }
}
