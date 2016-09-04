import processing.pdf.*; 
// Template for 2D projects
// Author: Jarek ROSSIGNAC
// Edited: Kyrsten Greenfield and Ben French 
 
//**************************** global variables ****************************
pts P = new pts(); // class containing array of points, used to standardize GUI
float t = -1, f = 0;
float direction = 0.025;
boolean animate = true, fill = false, timing = false;
boolean lerp = true, slerp = true, spiral = true; // toggles to display vector interpoations
int ms = 0, me = 0; // milli seconds start and end for timing
int npts = 40000; // number of points

//All variables we added
boolean spiralPat = false;
int i;
float num = .95;
float degOfChange;
float innerRad = 5;
float outerRad = 150;
float iRadChange = 0.5;
float oRadChange = 5;
float colorChange = 0.0125;
color startingColor = color (random (255), random (255), random (255));
color endingColor = color (255 - random (255), 255 - random (255), 255 - random (255));
//**************************** initialization ****************************
void setup() {
    size(500, 500);            // window size
    frameRate(30);             // render 30 frames per second
    smooth();                  // turn on antialiasing
    P.declare(); // declares all points in P. MUST BE DONE BEFORE ADDING POINTS 
    P.loadPts("data/pts");  // loads points form file saved with this program
    P.fitToCanvas();
} 

//**************************** display current frame ****************************
void draw() {
  if(recordingPDF) startRecordingPDF(); // starts recording graphics to make a PDF
    
    background(black); 
    
    //Handles all the main points A, B, C, and Center
    pt A=P.G[0], B=P.G[1], C=P.G[2], D=P.G[3];     // crates points with more convenient names 
    //pt A1 = P.copyOfG[0], B1 = P.copyOfG[1], C1 = P.copyOfG[2], D1 = P.copyOfG[3];
    
    //Draws inner spiral pattern
    if (spiralPat == true) {
        pen(white, 5.5);
        edge(A,B);  
        pen(white, 1); 
        edge(C,D); 
        showSpiralPattern(A, B, C, D); 
    }
    
    //Draws center point
    pt F = SpiralCenter1(A,B,C,D);
        pen(black,2); 
        showId(A); 
        showId(B); 
        showId(D); 
        showIdCenter(F,"Center");
   
    //Colors the ellipses
    fill(lerpColor(startingColor, endingColor, degOfChange));
    stroke(lerpColor(startingColor, endingColor, degOfChange));
    showSpiralThrough3Points(A,B,D,t, innerRad, outerRad);
    noFill();
    strokeWeight(5);
    showSpiralThrough3Points(A, B, D);
    
    //Update values
    outerRad += oRadChange;
    if (outerRad > 550 || outerRad < 150 ) {
      oRadChange = -oRadChange;
    }
    innerRad += iRadChange;
    if (innerRad > 45 || innerRad < 5) {
      iRadChange = -iRadChange;
    }
    i += num;
    t += direction;
    if ((t > 1) || (t < -1)) {
      direction = -direction;
    }
    degOfChange += colorChange;
    if (degOfChange >= 1 || degOfChange <= 0) { 
      colorChange = -colorChange;
    } 
     
    //Drag all via right click
    if (mousePressed && (mouseButton == RIGHT)) {
      P.dragAll();
    } 
     
    //Headers and recordings - DID NOT USE OTHER THAN HEADER
    if(recordingPDF) endRecordingPDF();  // end saving a .pdf file with the image of the canvas
    fill(black); displayHeader(); // displays header
    if(filming && (animating || change)) snapFrameToTIF(); // saves image on canvas as movie frame 
    if(snapTIF) snapPictureToTIF();   
    if(snapJPG) snapPictureToJPG();   
    change = false; // to avoid capturing movie frames when nothing happens
}  // end of draw
  
