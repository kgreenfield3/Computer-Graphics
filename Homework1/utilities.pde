// LecturesInGraphics: utilities
// Author: Jarek ROSSIGNAC, last edited on August, 2016 
// Edited by Kyrsten Greenfield and Ben French

// ******************  COLORS ******************
color black = #000000, white = #FFFFFF, 
   red = #FF0000, green = #00FF01, blue = #0300FF, yellow = #FEFF00, cyan = #00FDFF, magenta = #FF00FB, grey = #5F5F5F;

// ***************** GRAPHICS *****************
void pen(color c, float w) { 
  stroke(c); 
  strokeWeight(w);
}
void showDisk(float x, float y, float r) {
  ellipse(x, y, r*2, r*2);
}
// ***************** SAVING INDIVIDUAL IMAGES OF CANVAS *****************
int pictureCounter = 0;

// these three save number image files with the canvas image at the end of draw

boolean recordingPDF = false; // most compact and great, but does not always work
void startRecordingPDF() {
  beginRecord(PDF, "IMAGES/PICTURES_PDF/P"+nf(pictureCounter++,3)+".pdf"); 
}
void endRecordingPDF() {
  endRecord(); 
  recordingPDF=false;
}

boolean snapJPG=false;
void snapPictureToJPG() {
  saveFrame("IMAGES/PICTURES_JPG/P"+nf(pictureCounter++,3)+".jpg"); 
  snapJPG=false;
}

boolean snapTIF=false;   
void snapPictureToTIF() {
  saveFrame("IMAGES/PICTURES_TIF/P"+nf(pictureCounter++,3)+".tif"); 
  snapTIF=false;
}


//***************************************************************************************** MAKING A MOVIE
boolean filming=false;  // when true frames are captured in FRAMES for a movie
boolean change=false;   // true when the user has presed a key or moved the mouse
boolean animating=false; // must be set by application during animations to force frame capture
int frameCounter=0;

void snapFrameToTIF(){
  saveFrame("IMAGES/MOVIE_FRAMES_TIF/F"+nf(frameCounter++,4)+".tif");
} 
/*
To make a movie : 
reduce canvas size to produce smaller size movie file, for example size(400, 400) if more resolution is not needed        
Press '~' to start filming, 
act the movie or start an animation, 
press '~' to pause/stop (you can restart to add frames)
Then, from within your Processing sketch, 
from the processing menu, select Tools > Movie Maker. 
Click on Choose… Navigate to your Sketch Folder. 
Select, but do not open, the FRAMES folder.
Press Create Movie, 
Select the parameters you want. 

May not work for a large canvas!
MAKE SURE THAT YOU DELETE THE FRAMES_TIF folder in the IMAGES folder of your sketch!
*/

// ********************** TEXT **********************
Boolean scribeText = true; // toggle for displaying of help text

void scribe(String S, float x, float y) { // writes on screen at (x,y) with current fill color
  fill(255); 
  textSize(13);
  text(S, x, y); 
} 

void scribeHeader(String S, int i) { 
  fill(255);
  textSize(13);
  text(S, 10, 20+i*20); 
}

void scribeHeaderRight(String S) { 
  fill(255); 
  textSize(13);
  text(S, width-6.95*S.length(), 20); 
} 

void scribeFooter(String S, int i) { 
  fill(255); 
  textSize(12);
  text(S, 10, height-10-i*20); 
} 

void scribeAtMouse(String S) { 
  fill(255); 
  textSize(12);
  text(S, mouseX, mouseY); 
}

void scribeMouseCoordinates() {
  fill(255); 
  textSize(12);
  text("("+mouseX+","+mouseY+")", mouseX+7, mouseY+25); 
}

void displayHeader() {
    scribeHeader(title, 0);       
    scribeHeaderRight(name); 
    scribeHeader(subtitle, 1);
    //image(myFace, width-myFace.width/2,25,myFace.width/2,myFace.height/2); 
}

//void displayFooter() {
//    scribeFooter(guide, 1); 
//    scribeFooter(menu, 0); 
//}
