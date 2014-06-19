// Variables declared before setup() have global scope (can be used anywhere below)

// Will store width of a cell in the grid
int cellWidth = 0;

// Will store actual size of square (slightly smaller than cell)
int squareWidth = cellWidth;

// This runs once
void setup() {

  // Set canvas size
  size(600, 600);
  
  // Draw rectangles from top-left corner
  rectMode(CORNER);
  
  // Use Hue-Saturation-Brightness colour model
  // See: https://twitter.com/rgordon/status/406373396939673602/photo/1
  colorMode(HSB, 360, 100, 100, 100);
  
  // Thin black border for rectangles
  strokeWeight(1);
  stroke(0, 0, 0);
  
  // Reddish fill
  fill(10, 83, 72);
  
  // Slow animation - 1 frame per second
  frameRate(1);
  
  // Seed random number generator
  randomSeed(hour() + minute() + second() + millis());
  
  // Calculate width of cell, and size of square within cell   
  cellWidth = width / 5;
  
}

// This loops forever
void draw() {
  
  // Set a random square size for this run
  squareWidth = cellWidth;
  squareWidth -= (int) random(5, 10);

  // Reset background
  background(0, 0, 80);
  
  for (int col = 0; col < 5; col++) {
    for (int row = 0; row < 5; row ++) {
       pushMatrix();
       translate(row * cellWidth + (cellWidth - squareWidth) / 2, col * cellWidth + (cellWidth - squareWidth) / 2);
       rect(0, 0, squareWidth, squareWidth);
       popMatrix();
    }
  } 
  

} //end of draw 
