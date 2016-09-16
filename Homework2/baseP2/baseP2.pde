// Template for 2D projects
// Author: Jarek ROSSIGNAC
import processing.pdf.*;    // to save screen shots as PDFs, does not always work: accuracy problems, stops drawing or messes up some curves !!!
// straight lines and dots: http://www.openprocessing.org/sketch/33770
// line intersection https://forum.processing.org/two/discussion/90/point-and-line-intersection-detection
// network https://processing.org/tutorials/network/
//**************************** global variables ****************************
pts P = new pts(); // class containing array of points, used to standardize GUI
pts copyP = new pts();
pts poly = new pts();
int nv = int(P.length());
pts Q = new pts();
float t=0, f=0;
boolean animate=true, fill=false, timing=false;
boolean lerp=true, slerp=true, spiral=true, v1Pressed = false; // toggles to display vector interpoations
int ms=0, me=0; // milli seconds start and end for timing
int npts=20000; // number of points
pt A=P(100,100), B=P(300,300);

// straight lines and dots: http://www.openprocessing.org/sketch/33770
// line intersection https://forum.processing.org/two/discussion/90/point-and-line-intersection-detection

float x[] = new float[1000];
float y[] = new float[1000];
int numOfClicks = 0;
boolean shapeDraw = true;
boolean edgeDraw = false;
boolean selectSave = false;
boolean selectLoad = true;
boolean goodSplit = false;
boolean dragA = false;
boolean dragB = false;
float w = 35;
float h = 35;
pt startingPoint, endingPoint;
float buttW = 75;
float buttH = 25;
Button save, load, buttonA, buttonB, buttonV1;
int nodes = 0;

pts newP = new pts();
pt newPt = new pt();
pt endPt = new pt();
pts copy = new pts();
PShape poly1;
float labelNum = 0;
//poly1.beginShape();
float startingPt;
int endingPt;
boolean isSet = false;
int comma, colon;   
float start, end;
//**************************** initialization ****************************
void setup()               // executed once at the begining 
  {
  size(600, 600);            // window size
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  //myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  P.declare(); // declares all points in P. MUST BE DONE BEFORE ADDING POINTS 
  newP.declare();
  copy.declare();
  poly.declare();
  // P.resetOnCircle(4); // sets P to have 4 points and places them in a circle on the canvas
  //P.loadPts("data/pts");  // loads points form file saved with this program
  background(255);
  save = new Button("Save", width/2 - 75, height - 30, buttW, buttH, 10);
  load = new Button("Load Puzzle", width/2 + 75, height - 30, buttW, buttH, 10);
  buttonA = new Button("", 0, 0, w, h, 10);
  buttonB = new Button("", 0, 0, w, h, 10);
  buttonV1 = new Button("", 0, 0, w, h, 10);
  poly1 = createShape();
} // end of setup

//**************************** display current frame ****************************
void draw()      // executed at each frame
  {
  background(255);
  if(recordingPDF) startRecordingPDF(); // starts recording graphics to make a PDF
  //Draw save button
   if (nodes > 4) {
     save.Draw();  
   }
  //Draw load button
  load.Draw();
  //Hover features
  if(load.mouseOver() || save.mouseOver()) {
    cursor(HAND);
  } else {
   cursor(ARROW); 
  }
  //Draws actual puzzle shape
  if (shapeDraw == true) {
    drawShape(); 
  } else if (!shapeDraw) {
    editShape();
  }

  if(recordingPDF) endRecordingPDF();  // end saving a .pdf file with the image of the canvas

  fill(black); //displayHeader(); // displays header
  if(scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 

  if(filming && (animating || change)) snapFrameToTIF(); // saves image on canvas as movie frame 
  if(snapTIF) snapPictureToTIF();   
  if(snapJPG) snapPictureToJPG();   
  change=false; // to avoid capturing movie frames when nothing happens
  
  //Draws arrow and deals with all related stuff
  if(!shapeDraw && selectSave) {
    
     goodSplit = P.splitBy(A, B);
     if (goodSplit) {
       pen(green, 4); 
     } else {
      pen(red, 4); 
     }
    
 P.makeCuts();
     P.findIntersection(P, A, B);
   }

}  // end of draw

//Draws the shape
void drawShape() {
   if (mousePressed) {
    x[numOfClicks] = mouseX;
    y[numOfClicks] = mouseY;
    if (numOfClicks == 1) {
      buttonV1 = new Button("BUTTON", x[1], y[1], w, h, 10);
    }
    P.addPt(x[numOfClicks], y[numOfClicks]);
    //println("Point " + numOfClicks + ": " + x[numOfClicks] + ", " + y[numOfClicks]);
    numOfClicks++;
    mousePressed = false;
  }
  editShape();
}

void editShape() {
  beginShape();
 
  stroke(0);
  for (int i = 0; i < numOfClicks; i++) {
    if (i == 0) {
      fill(255);
      ellipseMode(CENTER);
      ellipse(x[0], y[0], w, h);
      vertex(x[0], y[0]); 
    }
    if (i > 0 || v1Pressed) {
      if (((x[i] > x[0] - w/2) && (x[i] < x[0] + w/2)) && ((y[i] > x[0] - h/2) && (y[i] < y[0] + h/2))) {
        fill(0, 255, 153);
        vertex(x[0], y[0]);
        x[numOfClicks] = P.G[0].x;
        y[numOfClicks] = P.G[0].y;
        P.addPt(x[numOfClicks], y[numOfClicks]);
        nodes += 1;
        shapeDraw = false;
 
      } else {
        fill(255);
        ellipseMode(CENTER);
        ellipse(x[i], y[i], w, h);
        vertex(x[i], y[i]);
        nodes += 1;
      }
    } 
     
  }
   endShape();
   for (int i = 0; i < numOfClicks - 1; i++) {
      fill(255);
      ellipseMode(CENTER);
      ellipse(x[i], y[i], w, h);
      showId(P.G[i], i); 
   }
}

//Handles mouse press events
void mousePressed() {
  
  if (save.mouseOver()) {
    P.savePts("data/pts", numOfClicks);
    //P.saveLines("data/lines");
    println("\n Your puzzle is saved.");
    shapeDraw = false;
    selectSave = true;
  }
  if (load.mouseOver()) {
    //P.loadPts("data/pts");
    poly.loadPts1("data/temp");
    println("\n Your puzzle is loaded.");
    shapeDraw = false;
    selectLoad = true;
  }
  if(buttonV1.mouseOver()) {
    v1Pressed = true;
  }
  if(buttonA.mouseOver()) {
    dragA = true;
  } else {
    dragA = false;
  }
  if(buttonB.mouseOver()) {
    dragB = true;
  } else {
    dragB = false;
  }
}




  