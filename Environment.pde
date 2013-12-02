//Define variable names and numbers for each type of environment object
final int CLOUD        = 0;
final int MOUNTAIN     = 1;
final int WATER        = 2;
final int AIRPORT      = 3;
final int LANDINGSTRIP = 4;
final int BUTTON       = 5;

class Environment {
  int x;
  int y;
  int objectWidth;
  int objectHeight;
  int type;
  int rotateAngle;
  color cloudFill = color(201, 229, 227);
  color buttonFillDefault = color(209, 8, 12);
  color buttonFillPressed = color(0);
  color buttonFill = buttonFillDefault;
  color mountainFill = color(155, 137, 123);
  color waterFill = color(48, 180, 227);
  boolean hidden = false;

  Environment (int tempX, int tempY, int tempObjectWidth, int tempObjectHeight, int tempType, int tempRotateAngle) {
    x = tempX;
    y = tempY;
    objectWidth = tempObjectWidth;
    objectHeight = tempObjectHeight;
    type = tempType;
    rotateAngle = tempRotateAngle;
  }

  void display() {
    // If hidden is true, returning from the method such that nothing is drawen
    if(hidden) return;
    
    // Drawing appropriate object according to the type 
    if (type == CLOUD) cloudObject();
    else if (type == MOUNTAIN) mountainObject();
    else if (type == WATER) waterObject();
    else if (type == AIRPORT) airportObject();
    else if (type == LANDINGSTRIP) landingStripObject();
    else if (type == BUTTON) buttonObject();
    else println("Incorrect Object Defined");
  }

  // Draws cloud object
  void cloudObject() {
    noStroke();
    fill(cloudFill);
    rectMode(CORNER);
    rect (x, y, objectWidth, objectHeight);
  }

  // Draws moutain
  void mountainObject() {
    noStroke();
    fill(mountainFill);
    //change origin points
    pushMatrix();
    //set the origin point to where x and y are being called
    translate(x, y);
    //rotate the object by the number of degrees in the rotateAngle variable
    rotate(radians(rotateAngle));
    //draws triangle representing the mountain
    triangle(0-objectWidth/2, 0+objectHeight/2, 0, 0-objectHeight/2, 0+objectWidth/2, 0+objectHeight/2);
    //put the origin point back to its original point (relative to the window)
    popMatrix();
  }

  // Draws water
  void waterObject() {
    noStroke();
    fill(waterFill);
    rectMode(CORNER);
    rect (x, y, objectWidth, objectHeight);
  }
  
  // Draws airport
  void airportObject() {
    noStroke();
    fill(180, 75, 136);
    rectMode(CORNER);
    rect (x, y, objectWidth, objectHeight);
  }
  
  // Drwas landing strip
  void landingStripObject() {
    noStroke();
    fill(98, 98, 98);
    rectMode(CORNER);
    rect (x, y, objectWidth, objectHeight);
  }
  
  // Draws button
  void buttonObject() {
    noStroke();
    fill(buttonFill);
    ellipseMode(CENTER);
    ellipse (x, y, objectWidth, objectHeight);
  }
  
  // Checks if the plane intersects with the current object
  boolean intersects(Plane plane) {
    if (!(plane.top() > bottom() || plane.bottom() < top() || plane.left() > right() || plane.right() < left())) return true;
    return false;
  }
  
  // Checks if the plane at coordinate xx and yy intersects with the current object
  boolean intersects(int xx, int yy) {
    if (!(yy-15 > bottom() || yy+15 < top() || xx-15 > right() || xx+15 < left())) return true;
    return false;
  }

  // Returns the value of y at the top side of the object
  int top() {
    if(type==MOUNTAIN || type==BUTTON) return y-objectHeight/2;
    return y;
  }
  
  // Returns the value of x at the right side of the object
  int right() {
    if(type==MOUNTAIN || type==BUTTON) return x+objectWidth/2;
    return x+objectWidth;
  }
  
  // Returns the value of x at the bottom side of the object
  int bottom() {
    if(type==MOUNTAIN || type==BUTTON) return y+objectHeight/2;
    return y+objectHeight;
  }
  
  // Returns the value of y at the left side of the object
  int left() {
    if(type==MOUNTAIN || type==BUTTON) return x-objectWidth/2;
    return x;
  }
}
