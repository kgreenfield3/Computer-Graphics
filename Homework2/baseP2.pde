// Template for 2D projects
// Author: Jarek ROSSIGNAC
import processing.pdf.*;    // to save screen shots as PDFs, does not always work: accuracy problems, stops drawing or messes up some curves !!!
// straight lines and dots: http://www.openprocessing.org/sketch/33770
// line intersection https://forum.processing.org/two/discussion/90/point-and-line-intersection-detection
// network https://processing.org/tutorials/network/
//**************************** global variables ****************************
pts P = new pts(); // class containing array of points, used to standardize GUI
float t=0, f=0;
boolean animate=true, fill=false, timing=false;
boolean lerp=true, slerp=true, spiral=true; // toggles to display vector interpoations
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
float w = 35;
float h = 35;
pt startingPoint, endingPoint;
//**************************** initialization ****************************
void setup()               // executed once at the begining 
  {
  size(500, 500);            // window size
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  P.declare(); // declares all points in P. MUST BE DONE BEFORE ADDING POINTS 
  // P.resetOnCircle(4); // sets P to have 4 points and places them in a circle on the canvas
 // P.loadPts("data/pts");  // loads points form file saved with this program
  background(255);
} // end of setup

//**************************** display current frame ****************************
void draw()      // executed at each frame
  {
  if(recordingPDF) startRecordingPDF(); // starts recording graphics to make a PDF

    //pen(black, 3); 
    //fill(yellow); 
    //P.drawCurve(); 
    //P.IDs(); // shows polyloop with vertex labels
    //stroke(red); 
    //pt G=P.Centroid(); 
    //show(G,10); // shows centroid
    //pen(green,5); 
    //arrow(A,B);            // defines line style with (5) and color (green) and draws starting arrow from A to B
  if (shapeDraw == true) {
    drawShape(); 
  }
  if (edgeDraw == true) {
    drawEdge();
  }
 

  if(recordingPDF) endRecordingPDF();  // end saving a .pdf file with the image of the canvas

  fill(black); displayHeader(); // displays header
  //if(scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 

  if(filming && (animating || change)) snapFrameToTIF(); // saves image on canvas as movie frame 
  if(snapTIF) snapPictureToTIF();   
  if(snapJPG) snapPictureToJPG();   
  change=false; // to avoid capturing movie frames when nothing happens
  }  // end of draw
  
void drawShape() {
   if (mousePressed) {
    x[numOfClicks] = mouseX;
    y[numOfClicks] = mouseY;
    numOfClicks++;
    mousePressed = false;
    
  }
  beginShape();
  stroke(0);
  for (int i = 0; i < numOfClicks; i++) {

    if (i == 0) {
      fill(255);
      ellipseMode(CENTER);
      ellipse(x[i], y[i], w, h);
      vertex(x[i], y[i]);
      P.G[i] = P(x[i], y[i]);
      //showId(P.G[i], i);
      
    }
    if (i > 0) {
      if (((x[i] > x[0] - w/2) && (x[i] < x[0] + w/2)) && ((y[i] > x[0] - h/2) && (y[i] < y[0] + h/2))) {
        fill(0, 255, 153);
        vertex(x[0], y[0]);
        shapeDraw = false;
        
        
        
       
      } else {
        fill(255);
        ellipseMode(CENTER);
        ellipse(x[i], y[i], w, h);
        vertex(x[i], y[i]);
        P.G[i] = P(x[i], y[i]);
        //showId(P.G[i], i);
        
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


void drawEdge() {
  for (int i = 0; i < numOfClicks; i++) {
    if ((mouseX > P.G[i].x - w/2 && mouseX < P.G[i].x + w/2) && (mouseY > P.G[i].y - h/2 && mouseY < P.G[i].y + h/2)) {
     startingPoint = P.G[i];
    }
    if ((pmouseX > P.G[i].x - w/2 && pmouseX < P.G[i].x + w/2) && (pmouseY > P.G[i].y - h/2 && pmouseY < P.G[i].y + h/2)) {
     endingPoint = P.G[i];
    }
   
  }
  edge(startingPoint, endingPoint);
  
}