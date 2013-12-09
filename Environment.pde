/** 
* Title: Flights of Fury <br>
* Name: Amanda Lee and Justyna Ausareny <br>
* Date: December 9th, 2013 <br>
* Description: Environment class<br> 
**/

//Define variable names and numbers for each type of environment object
final int CLOUD        = 0;
final int MOUNTAIN     = 1;
final int WATER        = 2;
final int AIRPORT      = 3;
final int LANDINGSTRIP = 4;
final int BUTTON       = 5;

/**
 * This class represents all the environment objects that do not move in the game
 * The properties of the environment objects are called upon their class and array initializations 
   in the void setup function
 */
class Environment {
  
  // x and y position of the object
  int x;
  int y;
  
  // Width and height of the object
  int objectWidth;
  int objectHeight;
  
  // Type of object to be called
  int type;
  
  // Number of degrees to rotate the object by
  int rotateAngle;
  
  // Color values for the objects
  color cloudFill = color(201, 229, 227);
  color buttonDarkFill = color(170, 0, 0);
  color buttonLightFill = color(209, 8, 12);
  color mountainDarkFill = color(155, 137, 123);
  color mountainLightFill = color(214, 193, 171);
  color waterFill = color(48, 180, 227);
  color airportDarkFill = color(180, 75, 136);
  color airportLightFill = color(255, 229, 244);
  color landingStripGray = color(98, 98, 98);
  color landingStripYellow = color(216,211,35);
  
  //
  boolean hidden = false;

  // Class constructor. Builds a new environment object with given position, size type and angle
  // tempX: x-coordinate of the object
  // tempY: y-coordinate of the object
  // tempObjectWidth: width of the object (in pixels)
  // tempObjectHeight: height of the object (in pixels)
  // tempType: type of object to be used
  // tempRotateAngle: number of degrees to rotate the object by
  Environment (int tempX, int tempY, int tempObjectWidth, int tempObjectHeight, int tempType, int tempRotateAngle) {
    // Directly assign properties and values
    x = tempX;
    y = tempY;
    objectWidth = tempObjectWidth;
    objectHeight = tempObjectHeight;
    type = tempType;
    rotateAngle = tempRotateAngle;
  }

  //Renders the object to the screen
  void display() {
    // If hidden is true, returning from the method such that nothing is drawn
    if (hidden) return;

    // Draws appropriate object according to the type that is being called
    if (type == CLOUD) {cloudObject();}
    else if (type == MOUNTAIN) {mountainObject();}
    else if (type == WATER) {waterObject();}
    else if (type == AIRPORT) {airportObject();}
    else if (type == LANDINGSTRIP) {landingStripObject();}
    else if (type == BUTTON) {buttonObject();}
    else {println("Incorrect Object Defined");}
  }

  // Draws cloud object
  void cloudObject() {
    //set stroke, fill and rectMode
    noStroke();
    fill(cloudFill);
    rectMode(CORNER);
    
    //rectangle shape
    rect (x, y, objectWidth, objectHeight);

    //top circles
    ellipse(x+objectWidth/6, y+objectHeight/60, objectWidth/2.5, objectHeight/6);
    ellipse(x+3*(objectWidth/5.95), y+objectHeight/60, objectWidth/2.5, objectHeight/6);
    ellipse(x+5*(objectWidth/5.95), y+objectHeight/60, objectWidth/2.5, objectHeight/6);

    //bottom circles
    ellipse(x+objectWidth/6, y+objectHeight, objectWidth/3, objectHeight/6);
    ellipse(x+3*(objectWidth/5.95), y+objectHeight, objectWidth/3, objectHeight/6);
    ellipse(x+5*(objectWidth/5.95), y+objectHeight, objectWidth/3, objectHeight/6);

    //left circles
    ellipse(x, y+objectHeight/7.2, objectWidth/3.8, objectHeight/3.5);
    ellipse(x, y+3*(objectHeight/8.25), objectWidth/3.8, objectHeight/3.5);
    ellipse(x, y+5*(objectHeight/8.25), objectWidth/3.8, objectHeight/3.5);
    ellipse(x, y+7*(objectHeight/8.25), objectWidth/3.8, objectHeight/3.5);

    //right circles
    ellipse(x+objectWidth, y+objectHeight/7.2, objectWidth/3.8, objectHeight/3.5);
    ellipse(x+objectWidth, y+3*(objectHeight/8.25), objectWidth/3.8, objectHeight/3.5);
    ellipse(x+objectWidth, y+5*(objectHeight/8.25), objectWidth/3.8, objectHeight/3.5);
    ellipse(x+objectWidth, y+7*(objectHeight/8.25), objectWidth/3.8, objectHeight/3.5);
  }

  // Draws mountain object
  void mountainObject() {
    //set no stroke
    noStroke();

    //change origin points
    pushMatrix();
    //set the origin point to where x and y are being called
    translate(x, y);
    //rotate the object by the number of degrees in the rotateAngle variable
    rotate(radians(rotateAngle));

    //dark brown fill
    fill(mountainDarkFill);
    //draws triangle representing the mountain
    triangle(0-objectWidth/2, 0+objectHeight/2, 0, 0-objectHeight/2, 0+objectWidth/2, 0+objectHeight/2);

    //light brown fill
    fill(mountainLightFill);
    //draws triangle representing the mountain
    triangle(0-objectWidth/4, 0, 0+objectHeight/4, 0, 0, 0-objectHeight/2);

    //draw light brown ellipse for curve
    ellipse(0+objectWidth/8, 0, objectWidth/3.8, objectHeight/7.5);
    //draw dark brown ellipse for curve
    fill(mountainDarkFill);
    ellipse(0-objectWidth/8, 0, objectWidth/3.8, objectHeight/7.5);

    //put the origin point back to its original point (relative to the window)
    popMatrix();
  }

  // Draws water object
  void waterObject() {
    //set stroke, fill and rectMode
    noStroke();
    fill(waterFill);
    rectMode(CORNER);
    
    //rectangle shape
    rect (x, y, objectWidth, objectHeight);
  }

  // Draws airport object
  void airportObject() {
    //set stroke and rectMode
    noStroke();
    rectMode(CORNER);

    //set dark fill and draw the building
    fill(airportDarkFill);
    rect (x, y, objectWidth, objectHeight);

    //set light fill for windows
    fill(airportLightFill);

    //draw first row of windows
    rect (x+2*(objectHeight/10), y+objectHeight/5, objectWidth/6, objectHeight/6);
    rect (x+4*(objectHeight/10), y+objectHeight/5, objectWidth/6, objectHeight/6);
    rect (x+6*(objectHeight/10), y+objectHeight/5, objectWidth/6, objectHeight/6);
    rect (x+8*(objectHeight/10), y+objectHeight/5, objectWidth/6, objectHeight/6);

    //draw second row of windows
    rect (x+2*(objectHeight/10), y+2*(objectHeight/5), objectWidth/6, objectHeight/6);
    rect (x+4*(objectHeight/10), y+2*(objectHeight/5), objectWidth/6, objectHeight/6);
    rect (x+6*(objectHeight/10), y+2*(objectHeight/5), objectWidth/6, objectHeight/6);
    rect (x+8*(objectHeight/10), y+2*(objectHeight/5), objectWidth/6, objectHeight/6);

    //draw third row window
    rect (x+2*(objectHeight/10), y+3*(objectHeight/5), 4*(objectWidth/5.7), 2*(objectHeight/5));
  }

  // Draws landing strip object
  void landingStripObject() {
    //set stroke, grey fill and rectMode
    noStroke();
    fill(landingStripGray);
    rectMode(CORNER);
    
    //draw road
    rect (x, y, objectWidth, objectHeight*1.5);
    
    //set yellow fill
    fill(landingStripYellow);
    
    //draw striped road line
    rect (x+objectWidth/6, y+objectHeight/2, objectWidth/6, objectHeight/4);
    rect (x+3*(objectWidth/6), y+objectHeight/2, objectWidth/6, objectHeight/4);
    rect (x+5*(objectWidth/6), y+objectHeight/2, objectWidth/6, objectHeight/4);
  }

  // Draws red button object
  void buttonObject() {
    //set no stroke
    noStroke();
    
    //set light red fill for circular top
    fill(buttonLightFill);
    ellipseMode(CENTER);
    ellipse (x, y, objectWidth, objectHeight);
    
    //set dark red fill for rectangular bottom
    fill(buttonDarkFill);
    rectMode(CORNER);
    rect (x-objectWidth/2, y, objectWidth, objectHeight/1.75);
  }

  // Checks if the plane intersects with the current object
  boolean intersects(Plane plane) {
    if (!(plane.top() > bottom() || plane.bottom() < top() || plane.left() > right() || plane.right() < left())) {return true;}
    return false;
  }

  // Checks if the plane at coordinate xx and yy intersects with the current object
  boolean intersects(int xx, int yy) {
    if (!(yy-15 > bottom() || yy+15 < top() || xx-15 > right() || xx+15 < left())) {return true;}
    return false;
  }
  
  // Returns the value of y at the top side of the object
  int top() {
    if (type==MOUNTAIN || type==BUTTON) {return y-objectHeight/2;}
    return y;
  }
  // Returns the value of x at the right side of the object
  int right() {
    if (type==MOUNTAIN || type==BUTTON) {return x+objectWidth/2;}
    return x+objectWidth;
  }
  // Returns the value of x at the bottom side of the object
  int bottom() {
    if (type==MOUNTAIN || type==BUTTON) {return y+objectHeight/2;}
    return y+objectHeight;
  }
  // Returns the value of y at the left side of the object
  int left() {
    if (type==MOUNTAIN || type==BUTTON) {return x-objectWidth/2;}
    return x;
  }
}

