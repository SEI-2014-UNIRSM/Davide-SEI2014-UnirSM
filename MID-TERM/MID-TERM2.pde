//declare variables
int xp = 0;
int yp = 0;
int xp1=0;
int yp1=0;
boolean recordPDF = false;

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

  //save frame for animation
  if (key =='s' || key =='S') {
    saveFrame("Animation01/anim-####.tga");
    println(frameCount);
  }
}


//reset background, deleting all in the window

void keyReleased() {
  if (key == DELETE || key == BACKSPACE) background(0); 


  // module for save pdf

  if (key =='r' || key =='R') {
    if (recordPDF == false) {
      beginRecord(PDF, "####.pdf");
      println("recording started");
      recordPDF = true;
    }
  }
  else if (key == 'e' || key =='E') {
    if (recordPDF) {
      println("recording stopped");
      endRecord();
      recordPDF = false;
    }
  }
}
