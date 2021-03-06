//Based on exercize
//P_2_3_6_02.pde from
// 
// Generative Gestaltung, ISBN: 978-3-87439-759-9
// First Edition, Hermann Schmidt, Mainz, 2009
// Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
// Copyright 2009 Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
//
// http://www.generative-gestaltung.de
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/**
 * draw tool. draws a specific module according to 
 * its east, south, west and north neighbours.
 * with switchable tileset 
 * 
 * MOUSE
 * drag left           : draw new module
 * drag right          : delete a module
 * 
 * KEYS
 * del, backspace      : clear screen
 * g                   : toogle. show grid
 * d                   : toogle. show module values
 * r                   : start recording pdf
 * e                   : stop recording pdf
 * s                   : save frame
 */

//import libraries tools
import processing.pdf.*;
import java.util.Calendar;
// declare variables
float tileSize = 30;
int gridResolutionX, gridResolutionY;
boolean drawGrid = true;
char[][] tiles;
boolean randomMode = false;
PShape[] modulesA;
char[] modules  = {
  'A'
};
char activeModulsSet = 'A';
boolean debugMode = false;
boolean recordPDF = false;

// set up fixed element
void setup() {
  // use full screen size 
  size(displayWidth, displayHeight);
  smooth();
  colorMode(HSB, 360, 100, 100);
  cursor(CROSS);

  gridResolutionX = round(width/tileSize)+2;
  gridResolutionY = round(height/tileSize)+2;
  tiles = new char[gridResolutionX][gridResolutionY];
  initTiles();

  // load svg modules
  modulesA = new PShape[16];

  for (int i=0; i< modulesA.length; i++) { 
    modulesA[i] = loadShape("A_"+nf(i, 2)+".svg");

    //disable Style
    modulesA[i].disableStyle();
  }
}
//draw module
void draw() {
  smooth();
  colorMode(HSB, 360, 100, 100, 100);
  textAlign(CENTER, CENTER);
  background(0);
  // set or unset Tile for draw
  if (mousePressed && (mouseButton == LEFT)) setTile();
  if (mousePressed && (mouseButton == RIGHT)) unsetTile();
  if (drawGrid) drawGrid();
  drawModuls();

  //save frame for animation
  //  if (key =='s' || key =='S') {
  //    saveFrame("Animation01/anim-####.tga");
  //    println(frameCount);
}

// tiles at begin
void initTiles() {
  for (int gridY=0; gridY< gridResolutionY; gridY++) {
    for (int gridX=0; gridX< gridResolutionX; gridX++) {  
      tiles[gridX][gridY] = '0';
    }
  }
}

void setTile() {
  // convert mouse position to grid coordinates
  int gridX = floor((float)mouseX/tileSize) + 1;
  gridX = constrain(gridX, 1, gridResolutionX-2);
  int gridY = floor((float)mouseY/tileSize) + 1;
  gridY = constrain(gridY, 1, gridResolutionY-2);
  tiles[gridX][gridY] = activeModulsSet;
}

void unsetTile() {
  int gridX = floor((float)mouseX/tileSize) + 1;
  gridX = constrain(gridX, 1, gridResolutionX-2);
  int gridY = floor((float)mouseY/tileSize) + 1;
  gridY = constrain(gridY, 1, gridResolutionY-2);
  tiles[gridX][gridY] = '0';
}
// draw grid
void drawGrid() {
  rectMode(CENTER);
  for (int gridY=0; gridY< gridResolutionY; gridY++) {
    for (int gridX=0; gridX< gridResolutionX; gridX++) {  
      float posX = tileSize*gridX - tileSize/2;
      float posY = tileSize*gridY - tileSize/2;
      strokeWeight(0.55);
      fill(360);
      if (debugMode) {
        if (tiles[gridX][gridY] == '1') fill(220);
      }
      stroke(120);
      noFill();
      rect(posX, posY, tileSize+10, tileSize+10);
    }
  }
}

void drawModuls() {
  //how the modules are drawing, set the position inside the grid
  if (randomMode)activeModulsSet = modules[int(random(modules.length))];
  shapeMode(CENTER);
  for (int gridY=1; gridY< gridResolutionY-1; gridY++) {  
    for (int gridX=1; gridX< gridResolutionX-1; gridX++) { 
      // use only active tiles
      char currentTile = tiles[gridX][gridY];
      if (currentTile != '0') {
        String binaryResult = "";
        // check the four neighbours. is it active (not '0')? 
        // create a binary result out of it, eg. 1011
        // binaryResult = north + west + south + east;
        // north
        if (tiles[gridX][gridY-1] != '0') binaryResult = "1";
        else binaryResult = "0";
        // west
        if (tiles[gridX-1][gridY] != '0') binaryResult += "1";
        else binaryResult += "0";  
        // south
        if (tiles[gridX][gridY+1] != '0') binaryResult += "1";
        else binaryResult += "0";
        // east
        if (tiles[gridX+1][gridY] != '0') binaryResult += "1";
        else binaryResult += "0";

        // convert the binary string to a decimal value from 0-15
        int decimalResult = unbinary(binaryResult);
        float posX = tileSize*gridX - tileSize/2;
        float posY = tileSize*gridY - tileSize/2;
        //color of the modules and stroke
        fill(60, 100, 100);
        noStroke();


        // decimalResult is the also the index for the shape array
        switch(currentTile) {
        case 'A': 
          shape(modulesA[decimalResult], posX, posY, tileSize, tileSize);
          break;
        }
        if (debugMode) {
          fill(150);
          text(currentTile+"\n"+decimalResult+"\n"+binaryResult, posX, posY);
        }
      }
    }
  }
}

void keyReleased() {
  //module for reset screen
  if (key == DELETE || key == BACKSPACE) initTiles();
  //module for see or hide grid
  if (key == 'g' || key == 'G') drawGrid = !drawGrid;
  //module for debugMode
  if (key == 'd' || key == 'D') debugMode = !debugMode;
  // module for save frame, one push,one frame
  if (key =='s' || key =='S') {
    saveFrame("Animation01/anim-####.tga");
    println(frameCount);

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
}
