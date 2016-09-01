// Author: Jarek ROSSIGNAC
// Edited by Kyrsten Greenfield and Ben French
import processing.pdf.*;    // to save screen shots as PDFs, does not always work: accuracy problems, stops drawing or messes up some curves !!!

//**************************** global variables ****************************
pts P = new pts(); // class containing array of points, used to standardize GUI
float t = 0, f = 0;
boolean animate = true, fill = false, timing = false;
boolean lerp = true, slerp = true, spiral = true; // toggles to display vector interpoations
int ms = 0, me = 0; // milli seconds start and end for timing
int npts = 16; // number of points

int i;
int num = 15;
float degOfChange = 0;
color startingColor, endingColor;



//**************************** initialization ****************************
void setup() {
  size(500, 500); 
  frameRate(30);             
  smooth();                  
  //myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  P.declare(); // declares all points in P. MUST BE DONE BEFORE ADDING POINTS 
  // P.resetOnCircle(4); // sets P to have 4 points and places them in a circle on the canvas
  P.loadPts("data/pts");  // loads points form file saved with this program
  //Setup the colors
  background(black);
  startingColor = color (random (255), random (255), random (255));
  endingColor = color (255 - random (255), 255 - random (255), 255 - random (255));
 
} 

//**************************** display current frame ****************************
void draw() {
 //background(black); 
  if(recordingPDF) startRecordingPDF(); // starts recording graphics to make a PDF
  
 
  //pt A = P.G[0], B = P.G[1], C = P.G[2], D = P.G[3];     // crates points with more convenient names 
    
  //pen(green, 3); 
  //edge(A, B);  
  //pen(red, 3); 
  //edge(C, D); 
  //pt F = SpiralCenter1(A, B, C, D);
 
  //pen(black, 2); 
  //showId(A,"A"); 
  //showId(B,"B"); 
  //showId(C,"C"); 
  //showId(D,"D"); 
  //showId(F,"F");
  fill(0);
  rect(0, 0, width, 50);
  
 logSpiral(width/2, height/2, 10, 5, 150);
     
 

  //noFill(); 
  //pen(blue, 2); 
  //show(SpiralCenter2(A, B, C, D), 16);
  //pen(magenta, 2); 
  //show(SpiralCenter3(A, B, C, D), 20);
  
  //pen(255, 2); 
  //showSpiralPattern(A, B, C, D);     
  //pen(blue, 2); 
  //showSpiralThrough3Points(A, B, D); 

  if(recordingPDF) endRecordingPDF();  // end saving a .pdf file with the image of the canvas

  displayHeader(); // displays header
  if(scribeText && !filming) 
  //displayFooter(); // shows title, menu, & name 

  if(filming && (animating || change)) snapFrameToTIF(); // saves image on canvas as movie frame 
  if(snapTIF) snapPictureToTIF();   
  if(snapJPG) snapPictureToJPG();   
  change = false; // to avoid capturing movie frames when nothing happens
}  
  
void logSpiral(float x, float y, int numOfTurns, float innerRad, float outerRad){
  
 // for(int a = 0; a < 15; a++) {
     fill (lerpColor(startingColor, endingColor, degOfChange));
     float newNum = map( i, 0, (360 * numOfTurns), innerRad, outerRad);
      //Weird galaxy spiral; a = i, not radians(i)
     //ellipse(x + cos(i) * newNum, y + sin(i) * newNum, 3 + newNum/num, 5 + newNum/num);
     //Normal log spiral
     ellipse(x + cos(radians(i)) * newNum, y + sin(radians(i)) * newNum, 3 + newNum/num, 3 + newNum/num );
     //Update values
     i += num;
     degOfChange += 0.005;
     if (degOfChange >= 1) { 
       degOfChange = 1;
     }
     
     
     
 // }  
}