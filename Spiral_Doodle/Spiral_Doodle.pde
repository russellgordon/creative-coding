/* Global variables – can be used anywhere below */

// Radius of circle
float radius = 0.0;

// Angle for circle
float angle = 0.0;

// Co-ordinates for prior point
float priorX = 0.0;
float priorY = 0.0;

float[] perlinPosition = new float[10];
float xIncrement = 0.17;

/* This runs once. */
void setup() {

  // Create the canvas
  size(600, 600);

  // Use Hue-Saturation-Brightness colour model
  // See: https://twitter.com/rgordon/status/406373396939673602/photo/1
  colorMode(HSB, 360, 100, 100, 100);

  // No border
  noStroke();

  // White background
  background(0, 0, 100);

  // Black fill
  fill(0, 0, 0);

  // Smooth jaggies?
  smooth(8);
  
  // Set Perlin noise start points
  for (int i = 0; i < 10; i++) {
    perlinPosition[i] = random(5, 10) * i;
  }
}

/* This runs forever. */
void draw() {

  // Translate origin to middle of screen
  translate(width/2, height/2);

  // Flip y-axis so it behaves like a regular Cartesian plane
  scale(1, -1);

  // Increase the radius by 1
  radius+=0.01;

  // Increase the angle 
  angle += 1;

  // Draw a series of 10 spirals
  for (float i = 1; i < 2; i+=0.1) {
    
    // Move to new position in Perlin noise space
    perlinPosition[(int) ((i-1)*10)] += xIncrement; 
    
    // Find co-ordinates for point to draw
    float x = (radius + map(noise(perlinPosition[(int) ((i-1)*10)]), 0, 1, 0, 5))*i*cos(radians(angle));
    float y = (radius + map(noise(perlinPosition[(int) ((i-1)*10)]), 0, 1, 0, 5))*i*sin(radians(angle));

    // Change brightness of fill and stroke
    stroke(0, 0, i*50);
    strokeWeight(1);

    // Draw a line from priorX to new X
    line(priorX, priorY, x, y);
    
    // Update prior x and y values
    priorX = x;
    priorY = y;
  }

}
