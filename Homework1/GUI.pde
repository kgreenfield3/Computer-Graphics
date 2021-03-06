// Edited by Kyrsten Greenfield and Ben French

//**************************** user actions ****************************
//Key presses - USED 'S' to show/hide spiral pattern
void keyPressed() {
  
    if(key=='~') recordingPDF = true; // to snap an image of the canvas and save as zoomable a PDF, compact and great quality, but does not always work
    if(key=='!') snapJPG = true; // make a .PDF picture of the canvas, compact, poor quality
    if(key=='@') snapTIF = true; // make a .TIF picture of the canvas, better quality, but large file
    if(key=='#') ;
    if(key=='$') ;
    if(key=='%') ; 
    if(key=='^') ;
    if(key=='&') ;
    if(key=='*') ;    
    if(key=='(') ;
    if(key==')') ;  
    if(key=='_') ;
    if(key=='+') ;

    if(key=='`') filming = !filming;  // filming on/off capture frames into folder IMAGES/MOVIE_FRAMES_TIF/
    if(key=='1') lerp = !lerp;               // toggles what should be displayed at each fram
    if(key=='2') slerp = !slerp;
    if(key=='3') spiral = !spiral;
    if(key=='4') ;
    if(key=='5') ;
    if(key=='6') ;
    if(key=='7') ;
    if(key=='8') ;
    if(key=='9') ;
    if(key=='0') ; 
    if(key=='-') ;
    if(key=='=') ;

    if(key=='a') ; 
    if(key=='b') ; 
    if(key=='c') P.resetOnCircle(P.nv);
    if(key=='d') ; 
    if(key=='e') ;
    if(key=='f') ;
    if(key=='g') ; 
    if(key=='h') ;
    if(key=='i') ; 
    if(key=='j') ;
    if(key=='k') ;   
    if(key=='l') ;
    if(key=='m') ;
    if(key=='n') ;
    if(key=='o') ;
    if(key=='p') ;
    if(key=='q') ; 
    if(key=='r') ; // used in mouseDrag to rotate the control points 
    if(key=='s') spiralPat = !spiralPat;
    if(key=='t') ; // used in mouseDrag to translate the control points 
    if(key=='p') ;
    if(key=='v') ; 
    if(key=='w') ;  
    if(key=='x') ;
    if(key=='y') ;
    if(key=='z') ; // used in mouseDrag to scale the control points

    if(key=='A') ;
    if(key=='B') ; 
    if(key=='C') ; 
    if(key=='D') ;  
    if(key=='E') ;
    if(key=='F') ;
    if(key=='G') ; 
    if(key=='H') ; 
    if(key=='I') ; 
    if(key=='J') ;
    if(key=='K') ;
    if(key=='L') P.loadPts("data/pts");    // load current positions of control points from file
    if(key=='M') ;
    if(key=='N') ;
    if(key=='O') ;
    if(key=='P') ; 
    if(key=='Q') exit();  // quit application
    if(key=='R') ; 
    if(key=='S') P.savePts("data/pts");    // save current positions of control points on file
    if(key=='T') ;
    if(key=='U') ;
    if(key=='V') ;
    if(key=='W') ;  
    if(key=='X') ;  
    if(key=='Y') ;
    if(key=='Z') ; 

    if(key=='{') ;
    if(key=='}') ;
    if(key=='|') ; 
    
    if(key=='[') ; 
    if(key==']') P.fitToCanvas();  
    if(key=='\\') ;
    
    if(key==':') ; 
    if(key=='"') ; 
    
    if(key==';') ; 
    if(key=='\''); 
    
    if(key=='<') ;
    if(key=='>') ;
    if(key=='?') scribeText=!scribeText; // toggle display of help text and authors picture
   
    if(key==',') ;
    if(key=='.') ;  // used in mousePressed to tweak current frame f
    if(key=='/') ;
  
    if(key==' ') ;
    //UP, DOWN, RIGHT, and LEFT arrows manipulate the spiral
    if (key == CODED) 
       {
       String pressed = "Pressed coded key ";
       if (keyCode == UP) {
         pressed="UP"; 
         float frame = 30; 
         frameRate(frame += 15); 
       }
       if (keyCode == DOWN) { 
         pressed="DOWN"; 
         float frame = 30; 
         if (frame < 0) {
             frameRate(5);
         } else {
           frameRate(frame -= 15);
         }
         
       };
       if (keyCode == LEFT) {
         pressed = "LEFT"; 
         P.rotateAll(-5, ScreenCenter()); 
         redraw();  
       };
       if (keyCode == RIGHT) {
         pressed="RIGHT"; 
         P.rotateAll(5, ScreenCenter()); 
         redraw();  
       };
       if (keyCode == ALT) {pressed = "ALT";   };
       if (keyCode == CONTROL) {pressed = "CONTROL";   };
       if (keyCode == SHIFT) {pressed = "SHIFT";   };
       println("Pressed coded key = " + pressed); 
       } 
  
    change = true; // to make sure that we save a movie frame each time something changes
    println("key pressed = " + key);

    }
    
void mousePressed()   // executed when the mouse is pressed
  {
  P.pickClosest(Mouse()); // pick vertex closest to mouse: sets pv ("picked vertex") in pts
  if (keyPressed) 
     {
     if (key=='a')  P.addPt(Mouse()); // appends vertex after the last one
     if (key=='i')  P.insertClosestProjection(Mouse()); // inserts vertex at closest projection of mouse
     if (key=='d')  P.deletePickedPt(); // deletes vertex closeset to mouse
     }  
  change=true;
  }

//Mouse drag the points around screen
void mouseDragged() {
  if (!keyPressed || (key=='a')|| (key=='i')) {
    P.dragPicked();   
    change = true;
  }
}
  

//**************************** text for name, title and help  ****************************
String title = "HW 1: Spiral Interpolations",            name = "Students: Ben French & Kyrsten Greenfield",
       subtitle = "CS3451 class (Fall 2016)";
       
