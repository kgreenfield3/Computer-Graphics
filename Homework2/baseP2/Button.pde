//Found online - creates a simple button dependent on some features
class Button {
  String label; // button label
  float x;      // top left corner x position
  float y;      // top left corner y position
  float w;      // width of button
  float h;      // height of button
  float r;
  
  // constructor
  Button(String labelB, float xpos, float ypos, float widthB, float heightB, float rad) {
    label = labelB;
    x = xpos;
    y = ypos;
    w = widthB;
    h = heightB;
    r = rad;
  }
  
  void Draw() {
    fill(218);
    stroke(141);
    rectMode(CENTER);
    rect(x, y, w, h, r);
    textAlign(CENTER);
    fill(0);
    text(label, x, y + 4); 
  }
  
  boolean mouseOver() {
    if (mouseX > x - (w/2) && mouseX < (x + w/2) && mouseY > y - (h/2) && mouseY < (y + h/2)) {
      return true;
    }
    return false;
  }
}