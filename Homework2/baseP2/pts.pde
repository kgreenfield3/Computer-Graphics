//*****************************************************************************
// TITLE:         Point sequence for editing polylines and polyloops  
// AUTHOR:        Prof Jarek Rossignac
// DATE CREATED:  September 2012
// EDITS:         Last revised Sept 10, 2016
//*****************************************************************************
class pts 
  {
  int nv=0;                                // number of vertices in the sequence
  int pv = 0;                              // picked vertex 
  int iv = 0;                              // insertion index 
  int maxnv = 100*2*2*2*2*2*2*2*2;         //  max number of vertices
  Boolean loop=true;                       // is a closed loop
  float label;
  pt[] G = new pt [maxnv];                 // geometry table (vertices)

 // CREATE


  pts() {}
  
  void declare() {for (int i=0; i<maxnv; i++) G[i]=P(); }               // creates all points, MUST BE DONE AT INITALIZATION

  void empty() {nv=0; pv=0; }                                                 // empties this object
  
  void addPt(pt P) { G[nv].setTo(P); pv=nv; nv++;  }                    // appends a point at position P
  
  void addPt(float x,float y) { G[nv].x=x; G[nv].y=y; pv=nv; nv++; }// appends a point at position (x,y)
  
  float getLabel(pt P) {
    for (int i = 0; i < nv; i++) {
      if (G[i].x == P.x && G[i].y == P.y)  {
        label = P.label;
        //return label;
      } 
    }
    return label;
  }
  void setLabel(pt P, float s) {
    for (int i = 0; i < nv; i++) {
      if (G[i].x == P.x && G[i].y == P.y)  {
        G[i].label = s;
      } 
    }
  }
  void insertPt(pt P)  // inserts new point after point pv
    { 
    for(int v=nv-1; v>pv; v--) G[v+1].setTo(G[v]); 
    pv++; 
    G[pv].setTo(P);
    nv++; 
    }
     
  void insertClosestProjection(pt M) // inserts point that is the closest to M on the curve
    {
    insertPt(closestProjectionOf(M));
    }
  
  void resetOnCircle(int k)                                                         // init the points to be on a well framed circle
    {
    empty();
    pt C = ScreenCenter(); 
    for (int i=0; i<k; i++)
      addPt(R(P(C,V(0,-width/3)),2.*PI*i/k,C));
    } 
  
  void makeGrid (int w) // make a 2D grid of w x w vertices
   {
   empty();
   for (int i=0; i<w; i++) 
     for (int j=0; j<w; j++) 
       addPt(P(.7*height*j/(w-1)+.1*height,.7*height*i/(w-1)+.1*height));
   }    


  // PICK AND EDIT INDIVIDUAL POINT
  
  void pickClosest(pt M) 
    {
    pv=0; 
    for (int i=1; i<nv; i++) 
      if (d(M,G[i])<d(M,G[pv])) pv=i;
    }

  void dragPicked()  // moves selected point (index pv) by the amount by which the mouse moved recently
    { 
    G[pv].moveWithMouse(); 
    }     
  
  void deletePickedPt() {
    for(int i=pv; i<nv; i++) 
      G[i].setTo(G[i+1]);
    pv=max(0,pv-1);       // reset index of picked point to previous
    nv--;  
    }
 pts copyOf(pts P, pts Q, float x) {
   for (int i = 0; i <= x; i++) {
     P.G[i] = Q.G[i];
   }
   return Q;
 }
  void setPt(pt P, int i) 
    { 
    G[i].setTo(P); 
    }
  
  
  // DISPLAY
  
  void IDs() 
    {
    for (int v=0; v<nv; v++) 
      { 
      fill(white); 
      show(G[v],13); 
      fill(black); 
      if(v<10) label(G[v],str(v));  
      else label(G[v],V(-5,0),str(v)); 
      }
    noFill();
    }
  
  void showPicked() 
    {
    show(G[pv],13); 
    }
  
  void drawVertices(color c) 
    {
    fill(c); 
    drawVertices();
    }
  
  void drawVertices()
    {
    for (int v=0; v<nv; v++) show(G[v],13); 
    }
   
  void drawCurve() 
    {
    if(loop) drawClosedCurve(); 
    else drawOpenCurve(); 
    }
    
  void drawOpenCurve() 
    {
    beginShape(); 
      for (int v=0; v<nv; v++) G[v].v(); 
    endShape(); 
    }
    
  void drawClosedCurve()   
    {
    beginShape(); 
      for (int v=0; v<nv; v++)  G[v].v(); 
    endShape(CLOSE); 
    }

  // EDIT ALL POINTS TRANSALTE, ROTATE, ZOOM, FIT TO CANVAS
  
  void dragAll() // moves all points to mimick mouse motion
    { 
    for (int i=0; i<nv; i++) G[i].moveWithMouse(); 
    }      
  
  void moveAll(vec V) // moves all points by V
    {
    for (int i=0; i<nv; i++) G[i].add(V); 
    }   

  void rotateAll(float a, pt C) // rotates all points around pt G by angle a
    {
    for (int i=0; i<nv; i++) G[i].rotate(a,C); 
    } 
  
  void rotateAllAroundCentroid(float a) // rotates points around their center of mass by angle a
    {
    rotateAll(a,Centroid()); 
    }
    
  void rotateAllAroundCentroid(pt P, pt Q) // rotates all points around their center of mass G by angle <GP,GQ>
    {
    pt G = Centroid();
    rotateAll(angle(V(G,P),V(G,Q)),G); 
    }

  void scaleAll(float s, pt C) // scales all pts by s wrt C
    {
    for (int i=0; i<nv; i++) G[i].translateTowards(s,C); 
    }  
  
  void scaleAllAroundCentroid(float s) 
    {
    scaleAll(s,Centroid()); 
    }
  
  void scaleAllAroundCentroid(pt M, pt P) // scales all points wrt centroid G using distance change |GP| to |GM|
    {
    pt C=Centroid(); 
    float m=d(C,M),p=d(C,P); 
    scaleAll((p-m)/p,C); 
    }

  void fitToCanvas()   // translates and scales mesh to fit canvas
     {
     float sx=100000; float sy=10000; float bx=0.0; float by=0.0; 
     for (int i=0; i<nv; i++) {
       if (G[i].x>bx) {bx=G[i].x;}; if (G[i].x<sx) {sx=G[i].x;}; 
       if (G[i].y>by) {by=G[i].y;}; if (G[i].y<sy) {sy=G[i].y;}; 
       }
     for (int i=0; i<nv; i++) {
       G[i].x=0.93*(G[i].x-sx)*(width)/(bx-sx)+23;  
       G[i].y=0.90*(G[i].y-sy)*(height-100)/(by-sy)+100;
       } 
     }   
     
  // MEASURES 
  float length () // length of perimeter
    {
    float L=0; 
    for (int i=nv-1, j=0; j<nv; i=j++) L+=d(G[i],G[j]); 
    return L; 
    }
    
  float area()  // area enclosed
    {
    pt O=P(); 
    float a=0; 
    for (int i=nv-1, j=0; j<nv; i=j++) a+=det(V(O,G[i]),V(O,G[j])); 
    return a/2;
    }   
    
  pt CentroidOfVertices() 
    {
    pt C=P(); // will collect sum of points before division
    for (int i=0; i<nv; i++) C.add(G[i]); 
    return P(1./nv,C); // returns divided sum
    }
  
  //pt Centroid() // temporary, should be updated to return centroid of area
  //  {
  //  return CentroidOfVertices();
  //  }

  
  pt closestProjectionOf(pt M) 
    {
    int c=0; pt C = P(G[0]); float d=d(M,C);       
    for (int i=1; i<nv; i++) if (d(M,G[i])<d) {c=i; C=P(G[i]); d=d(M,C); }  
    for (int i=nv-1, j=0; j<nv; i=j++) 
      { 
      pt A = G[i], B = G[j];
      if(projectsBetween(M,A,B) && disToLine(M,A,B)<d) 
        {
        d=disToLine(M,A,B); 
        c=i; 
        C=projectionOnLine(M,A,B);
        }
      } 
     pv=c;    
     return C;    
     }  

  Boolean contains(pt Q) {
    Boolean in=true;
    // provide code here
    return in;
    }
  
  pt Centroid () 
      {
      pt C=P(); 
      pt O=P(); 
      float area=0;
      for (int i=nv-1, j=0; j<nv; i=j, j++) 
        {
        float a = triangleArea(O,G[i],G[j]); 
        area+=a; 
        C.add(a,P(O,G[i],G[j])); 
        }
      C.scale(1./area); 
      return C; 
      }
        
  float alignentAngle(pt C) { // of the perimeter
    float xx=0, xy=0, yy=0, px=0, py=0, mx=0, my=0;
    for (int i=0; i<nv; i++) {xx+=(G[i].x-C.x)*(G[i].x-C.x); xy+=(G[i].x-C.x)*(G[i].y-C.y); yy+=(G[i].y-C.y)*(G[i].y-C.y);};
    return atan2(2*xy,xx-yy)/2.;
    }


  // FILE I/O  - CREATED BY US
  void savePts(String fn, int num) {
    println("Saving: " + fn); 
    String[] inppts = new String[num + 1];
    int s = 0;
    num -= 1;
    inppts[s++] = str(num);
    for (int i=0; i< num -1; i++) {
       inppts[s++]=str(G[i].x)+","+str(G[i].y);
    }
    //inppts[s++]=str(G[0].x)+","+str(G[0].y);
     saveStrings(fn, inppts);
    
 };
   void savePts2(String fn) {
    println("Saving: " + fn); 
    String[] inppts = new String[nv + 1];
    int s = 0;
    //nv -= 1;
    inppts[s++] = str(nv);
    for (int i=0; i< nv; i++) {
       inppts[s++]=str(G[i].x)+","+str(G[i].y);
    }
    //inppts[s++]=str(G[0].x)+","+str(G[0].y);
    //inppts[s++]=str(G[0].x)+","+str(G[0].y);
     saveStrings(fn, inppts);
    
 };
 //save intersection pts 
void savePts1(String fn) {
    println("Saving: " + fn); 
    nv -= 1;
    String[] inppts = new String[nv];
    int s = 0;
    inppts[s++] = str(nv - 1);
    for (int i=1; i< nv; i++) {
       inppts[s++]=str(G[i].label) + ":" + str(G[i].x)+","+str(G[i].y);
       //println(G[i].label);
    }
    //inppts[s++]=str(G[0].x)+","+str(G[0].y);
     saveStrings(fn, inppts);
     //createPolygons(fn);
    
 };
 //Creates the right most piece
 void createPolygonsRight(String fn) {
   println("loading: "+fn); 
    String [] ss = loadStrings(fn);
    String subpts;
    int s = 0;   float x0 = 0, y0 = 0, xn = 0, yn = 0;   int a, b, c; int j = (int) (start + .5);
    nv = int(ss[s++]); print("nv = " +nv);
    fill(0, 255, 153);
    strokeWeight(1);
    stroke(black);
   //start = float(ss[0].substring(0, colon));
   //end = float(ss[nv].substring(0, colon));
   float difference = newP.G[nv].getLabel() - newP.G[1].getLabel();
   println("dif: " + difference);
    beginShape();
    vertex(newP.G[0].x, newP.G[0].y);
    poly.addPt(newP.G[0]);
    
    while (j <= difference) {
      //vertex(P.G[j].x, P.G[j].y);
      poly.addPt(P.G[j]);
      vertex(P.G[j].x, P.G[j].y);
      println("\n" + P.G[j].x + "," + P.G[j].y);
      j++;
    }
    poly.addPt(newP.G[nv]);
    vertex(newP.G[nv].x, newP.G[nv].y);
    endShape(CLOSE);
    poly.savePts2("data/temp");
}
   
   
 
  void saveLines(String fn) {
    println("Saving: " + fn); 
    String[] inppts = new String[nv + 1];
    int s = 0;
    inppts[s++] = str(nv);
    for (int i = 1; i < nv; i++) {
       float m = (G[i].y - G[i - 1].y)/(G[i].x - G[i - 1].x);
       float b = G[i].y - m * G[i].x;
       inppts[s++]=m + "," + b;
    }
    float m = (G[0].y - G[nv].y)/(G[0].x - G[nv].x);
    float b = G[0].y - m * G[0].x;
    inppts[s++]=m + "," + b;
     saveStrings(fn, inppts);
  }
  void findIntersection(pts P, pt A, pt B) { 
    float m1, b1, x, y;
    float m = (A.y - B.y) / (A.x - B.x);
    float b = A.y - m * A.x;
    float x0, y0, xn, yn;
    for(int k = 1; k <= nv; k++) {
        m1 = (P.G[k].y - P.G[k - 1].y) / (P.G[k].x - P.G[k - 1].x);
        b1 = P.G[k].y - m1 * P.G[k].x;
        x = (b1 - b) / (m - m1);
        y = m * x + b;
        //copyP.addPt(P.G[k].x, P.G[k].y);
        if (det(V(P.G[k], P.G[k-1]), V(P.G[k], A)) > 0 == det(V(P.G[k], P.G[k-1]), V(P.G[k], B)) > 0) {
           float t = - det(V(P.G[k], P.G[k-1]), V(P.G[k], A)) / det(V(P.G[k], P.G[k-1]), V(P.G[k], B));
           
           
        }
        //if ((x > min(A.x, B.x)) && (x < max(A.x, B.x)) && (y > min(A.y, B.y)) && (y < max(A.y, B.y))
        //&& (x > min(P.G[k].x, P.G[k-1].x)) && (x < max(P.G[k].x, P.G[k-1].x)) && (y > min(P.G[k].y, P.G[k-1].y)) && (y < max(P.G[k].y, P.G[k-1].y))) {
        //  labelNum = ((k) + (k-1))*.5;
        //  //endingPt++;
        //  fill(255, 0, 0);
        //  ellipse(x, y, 20, 20);
        //  if (isSet) {
        //    noLoop();
        //    newPt.setTo(x, y);
        //    newPt.setLabel(labelNum);
        //    newPt.label(labelNum);
        //    println(newPt.label + "- X: " + newPt.x + "Y: " + newPt.y);
        //    newP.addPt(newPt);
        //    newP.addPt(newPt);
        //  //newP.addPt(P.G[k]);
        //  }
       //}// 
    
     
    };
    
  }
  void loadPts(String fn) 
    {
    println("loading: "+fn); 
    String [] ss = loadStrings(fn);
    String subpts;
    int s = 0;   int comma, comma1, comma2;   float x, y;   int a, b, c;
    nv = int(ss[s++]); print("nv = " +nv);
    fill(0, 255, 153);
    strokeWeight(1);
    stroke(black);
    beginShape();
    for(int k = 0; k < nv; k++) {
      int i = k + s; 
      comma = ss[i].indexOf(',');   
      x = float(ss[i].substring(0, comma));
      y = float(ss[i].substring(comma + 1, ss[i].length()));
      G[k].setTo(x,y);
      vertex(G[k].x, G[k].y);
     
    };
    endShape(CLOSE);
    addEllipse(nv);
    pv = 0;
    }; 
void loadPts1(String fn) 
    {
    println("loading: "+fn); 
    String [] ss = loadStrings(fn);
    String subpts;
    int s = 0;   int comma, comma1, comma2;   float x, y;   int a, b, c;
    nv = int(ss[s++]); print("nv = " +nv);
    //fill(0, 255, 153);
    strokeWeight(1);
    stroke(red);
    fill(blue);
    beginShape();
    for(int k = 0; k < nv; k++) {
      int i = k + s; 
      comma = ss[i].indexOf(',');   
      x = float(ss[i].substring(0, comma));
      y = float(ss[i].substring(comma + 1, ss[i].length()));
      G[k].setTo(x,y);
      stroke(green);
      vertex(G[k].x, G[k].y);
     
    };
    endShape(CLOSE);
    }
void addEllipse(int nv) {
 for(int j = 0; j < nv; j++) {
    ellipseMode(CENTER);
    fill(255);
    stroke(black);
    ellipse(G[j].x, G[j].y, 35, 35);
    showId(G[j], j);  
  }
}

void getCuts(PShape poly1, pts newP) {
        println("Making cuts");
        poly1.beginShape();
        fill(green);
        stroke(black);
        for (int j = 0; j <= P.length() + 1; j++) {
           
           if (j == 0) {
             vertex(newP.G[j].x, newP.G[j].y);
           } 
           vertex(P.G[j].x, P.G[j].y);
           if (j == P.length() + 1) {
             vertex(newP.G[j].x, newP.G[j].y);
           }
        }
         poly1.beginShape(CLOSE);
         //poly1.loadPts("data/poly");
}
void getNewP() {
  int len = (int)copy.length();
    copy.addPt(newP.G[len - 1]);
     copy.addPt(newP.G[len]);
     copyOf(copy, newP, 2);
     newP.savePts("data/poly", numOfClicks); 
  
}


//Arrow stuff
int n(int v) {return (v+1)%nv;}
int p(int v) {return (v+nv-1)%nv;}
boolean splitBy(pt A, pt B) {
boolean isSplit = true;
int r = 0, g = 0, b = 0;
  vec V = V(A, B);
  
  for(int v = 0; v < nv; v++) {
   if (LineStabsEdge(A, V, G[v], G[n(v)])) {
     float t = RayEdgeCrossParameter(A, V, G[v], G[n(v)]);
      pt X = P(A, t, V);
     if (t < 0 ) {
       pen(red, 2);
       r++;
       println("t < 0");
       //return true;
     }
     if (0 <= t && t <=1) {
       pen(green, 5);
       g++;
       //isSplit = false;
        println("0 <= t && t <=1");
        //isSplit = false;
     }
     if (1 < t) {
        pen(blue, 2); 
        b++;
        println("t > 1");
         //return true;
     }
     
     //return true;
     show(X, 4);
     pen(green, 4);
     edge(G[v], G[n(v)]);
   }
   
   
  
  }
  if ((r % 2) != 0 && (g % 2) == 0 && (b % 2) != 0) {
    return true;  
  } 
  return false;
}

void makeCuts() {
  //getPen();
 // A = P((x[0]+x[1])/2, (y[0]+y[1])/2);
 // B = P((x[1]+x[2])/2, (y[1]+y[2])/2);
  arrow(A, B);
  buttonA = new Button("A", A.x, A.y, w, h, 10);
  buttonB = new Button("A", B.x, B.y, w, h, 10);
 // ellipse(A.x, A.y, w, h);
 ////showId(A, "A");
 // ellipse(B.x, B.y, w, h);
  //showId(B, "B");
  pen(black, 1);
}

boolean LineStabsEdge(pt A, vec V, pt C, pt D) {
   if ((det(V(C, D), V(A, C)) > 0 && det(V(C, D), V) > 0) == (det(V(C, D), V(A, D)) > 0 && det(V(C, D), V) > 0)) {
      return true; 
    } 
    return false;
}

  }  // end class pts

float RayEdgeCrossParameter(pt A, vec V, pt C, pt D) {
   float t = - det(V(C, D), V(C, A)) / (det(V(C, D), V));
   return t;
}