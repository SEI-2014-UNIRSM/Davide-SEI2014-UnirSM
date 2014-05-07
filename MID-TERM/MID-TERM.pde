//declare variables
int xp = 0;
int yp = 0;
int xp1=0;
int yp1=0;
// set up fixed elements
void setup() {
  //frameRate(24);
  size(800, 600);
  background(0);
  stroke(255, 255, 0);
  strokeWeight (8);
  smooth();
}
// mouse pressed instruction for drawing 2 parallels lines
void draw() {
  if (mousePressed) {
    line(mouseX, mouseY-50, xp, yp);
    line(mouseX, mouseY+50, xp1, yp1);
  }
  // distance between lines
  xp = mouseX;
  yp = mouseY-50;
  xp1 = mouseX;
  yp1 = mouseY+50;
}
