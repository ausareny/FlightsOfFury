import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class FlightsOfFury extends PApplet {



Minim minim;
AudioPlayer song;

//Variable holding plane object
Plane airplane;

//Variables holding the button and landing strip object
Environment button;
Environment landingStrip;

//Arrays holding the cloud, mountain, water and airport objects
Environment clouds[] = new Environment [15];
Environment mountains[] = new Environment [16];
Environment waters[] = new Environment [2];
Environment airports[] = new Environment [2];

// Array counters
int currentCloudIndex = 0;
int currentMountainIndex = 0;
int currentWaterIndex = 0;
int currentAirportIndex = 0;

// Start position of the plane
int startPositionX = 75;
int startPositionY = 215;

//create a Processing version of the font we want to use
PFont f; // declare a variable of type PFont
String title = "Flights of fury";

boolean pressed = false; // indicates whether the button is pressed

// Game level number
int levelCount = -1;
int crashCount;
int jumpCount = 0;

Button pause; // Pause button
Button restart; // Restart button

StopWatchTimer sw; // Stop watch for counting time

int time = -1; // setting time value to -1 indicating that timer has not been set yet; "impossible value"


public void setup() {
  size (600, 600);
  background (255);
  smooth();

  // this loads file from the data folder
  minim = new Minim(this); // instantiating a Minim object
  song = minim.loadFile("The Royal Guardsmen - Airplane Song(My Airplane).wav"); // adding a file
  song.loop(); // loops or restarts the current song from the begining



  sw = new StopWatchTimer(); // Assigining stopWatchTimer class to the variable sw
  sw.start(); // calling the funtion start only once to record the time passed

  // load a font into that variable
  f = loadFont("KnarfArtFont-Bold-48.vlw");
  // tell processing to use the font you want and the size
  textFont(f, 48);

  pause = new Button(0, 570, width/2, 30, "Pause");
  restart = new Button(width/2, 570, width/2, 30, "Restart");

  airplane = new Plane (startPositionX, startPositionY, 30, 30);
  button = new Environment (width/2, 255, 50, 15, BUTTON, 0);
  landingStrip = new Environment (460, 435, 50, 10, LANDINGSTRIP, 0);
  landingStrip.hidden = true;

  // Adding clouds objects
  addCloud(0, 300, 100, 180);
  addCloud(200, 445, 70, 35);
  addCloud(270, 380, 70, 100);
  addCloud(405, 400, 30, 80);
  addCloud(435, 450, 165, 30);
  addCloud(510, 350, 90, 20);
  addCloud(510, 325, 30, 25);
  addCloud(560, 120, 40, 100);
  addCloud(300, 120, 260, 15);
  addCloud(330, 135, 60, 25);
  addCloud(90, 120, 100, 20);
  addCloud(165, 350, 55, 20);
  addCloud(250, 260, 80, 20);
  addCloud(380, 200, 50, 25);
  addCloud(430, 300, 35, 20);

  // Adding water objects
  addWater(100, 450, 100, 30);
  addWater(340, 450, 65, 30);

  // Adding airport objects
  addAirport(0, 120, 90, 80);
  addAirport(510, 370, 90, 80);

  // Adding mountains
  addMountain(15, 215, 30, 30, 90);
  addMountain(15, 250, 30, 30, 90);
  addMountain(15, 285, 30, 30, 90);
  addMountain(208, 140, 34, 40, 180);
  addMountain(245, 140, 34, 40, 180);
  addMountain(283, 140, 34, 40, 180);
  addMountain(473, 147, 25, 25, 180);
  addMountain(498, 147, 25, 25, 180);
  addMountain(523, 147, 25, 25, 180);
  addMountain(548, 147, 25, 25, 180);
  addMountain(588, 232, 25, 25, 270);
  addMountain(588, 258, 25, 25, 270);
  addMountain(588, 285, 25, 25, 270);
  addMountain(588, 311, 25, 25, 270);
  addMountain(588, 337, 25, 25, 270);
  addMountain(447, 438, 25, 25, 0);
}

// Function that handles adding Cloud objects to the array
public void addCloud(int x, int y, int objectWidth, int objectHeight) {
  if (currentCloudIndex < clouds.length) clouds[currentCloudIndex++] = new Environment(x, y, objectWidth, objectHeight, CLOUD, 0);
  else println("Too many clouds!");
}

// Function that handles adding Mountain objects to the array
public void addMountain(int x, int y, int objectWidth, int objectHeight, int objectRotate) {
  if (currentMountainIndex < mountains.length) mountains[currentMountainIndex++] = new Environment(x, y, objectWidth, objectHeight, MOUNTAIN, objectRotate);
  else println("Too many mountains!");
}

// Function that handles adding Water objects to the array
public void addWater(int x, int y, int objectWidth, int objectHeight) {
  if (currentWaterIndex < waters.length) waters[currentWaterIndex++] = new Environment(x, y, objectWidth, objectHeight, WATER, 0);
  else println("Too many water objects!");
}

// Function that handles adding Airport objects to the array
public void addAirport(int x, int y, int objectWidth, int objectHeight) {
  if (currentAirportIndex < airports.length) airports[currentAirportIndex++] = new Environment(x, y, objectWidth, objectHeight, AIRPORT, 0);
  else println("Too many airports!");
}


public void draw() {
  if(sw.paused) {
    return;
  }
  if(levelCount == -1) {
    bannerPlay();
    return;
  }

  // Reseting the image by applying white background
  background(245, 252, 252);

  // Drawing environment objects: clouds, mountains, water, and airports
  for (int i=0; i<waters.length; i++) {
    waters[i].display();
  }
  for (int i=0; i<clouds.length; i++) {
    clouds[i].display();
  }
  for (int i=0; i<mountains.length; i++) {
    mountains[i].display();
  }
  for (int i=0; i<airports.length; i++) {
    airports[i].display();
  }

  // Checking if the airpalne touched any of mountains or water and resetting the game if it did
  for (int i=0; i<mountains.length; i++) if (mountains[i].intersects(airplane)) {
    crashCount++;
    resetState();
  }
  for (int i=0; i<waters.length; i++) if (waters[i].intersects(airplane)) {
    if (levelCount == 4) {
      airplane.initialYSpeed = -12;
      airplane.moveUp = true;
    } 
    else {
      crashCount++;
      resetState();
    }
  }

  // Drawing button
  button.display();

  // Drawing header
  rectMode(CORNER);
  fill(75);
  noStroke();
  rect(0, 0, width, height/5);
  time(); // Drawing the timer

  // Write title to the screen using: text(data, xPosition, yPosition)
  fill(255);
  textSize(48);
  text(title, 20, 60);

  // Drawing footer
  fill(75);
  rect(0, height-height/5, width, height/5);
  pause.display(); //Draws the pause button
  restart.display(); //Draws the restart button 
  fill(255);
  // Display crash count as a text
  text("Crashes: "+crashCount, 438, 500);
  textSize(28);
  text("Stage: "+(levelCount+1), 20, 530);


  // Checking if the airplane pressed the button and displaying the landing strip if it did
  if (button.intersects(airplane)) {    
    if ( levelCount == 2) {
      landingStrip.hidden = true;
    }
    else {
      landingStrip.hidden = false;
    }
  }

  // Drawing landing strip
  landingStrip.display();

  // Checking if the airplan has touched a visible landing strip
  // if it did, reset the game indicating that the level has been successfully passed
  // and add a number to level count


  if (!landingStrip.hidden && landingStrip.intersects(airplane)) {
    // Setting the time of interestion if it hasn't been set yet, set only once so it doesn't receive the current time
    if (time == -1) {    // if time is at unsetable state
      time = millis();  // record time from the moment airpline got to the landing strip
    }
    // comparing current time to the time when intersection happened + the time of the holding period
    if (millis() <= time+1500) {
      bannerDisplay();
    } 
    else {
      levelCount++;
      resetState();
    }
  }
  if (levelCount == 7) {
    airplane.windSpeed = -0.35f;
  } 
  else if (levelCount == 9) {
    airplane.antiGravity = 0.2f;
  }
  // Drawing the airplane and updating its position
  airplane.display();
  airplane.updatePosition();

  // For the fourth level, have the airplane follow the mouse
  if (levelCount == 6) {
    airplane.x = mouseX;
    airplane.y = mouseY;
  } 
  else if (levelCount==10) {
    bannerEnd();
  }
}

public void bannerDisplay() {
  fill(0);
  rect(0, 200, width, 200);
  fill(255);
  textSize(40);
  textAlign(CENTER, CENTER);
  text("Stage complete", width/2, height/2);
  textAlign(LEFT, BASELINE);
}

public void bannerEnd() {
  fill(255);
  rect(0, 0, 1200, 1200);
  fill(0);
  textSize(26);
  textAlign(CENTER, CENTER);
  text("That's not the end", width/2, height/2-50);
  textSize(18);
  text("Continue questioning your habits", width/2, height/2+50);
  textAlign(LEFT, BASELINE);
}

public void bannerPlay() {
  fill(255);
  rect(0, 0, 1200, 1200);
  fill(0);
  textSize(26);
  textAlign(CENTER, CENTER);
  text("Play", width/2, height/2);
  Button buttonPlay = new Button(width/2-50, height/2-25, 100, 50, " ");
  buttonPlay.hidden = true;
  buttonPlay.display();
  if(buttonPlay.isPressed()) {
    levelCount++;
  }
  textAlign(LEFT, BASELINE);
}

// Counts the seconds, minutes and hours of the time passed
public void time() {
  fill(200);
  textSize(20);
  // Calling and formatting the time
  text(nf(sw.hour(), 2)+":"+nf(sw.minute(), 2)+":"+nf(sw.second(), 2), 438, 100);
  //  text(nf(sw.hour(), 2)+":"+nf(sw.minute(), 2)+":"+nf(sw.second(), 2)+":"+nf(sw.hundrensec(), 2), 438, 100);
}

public void mousePressed() {
  if (pause.isPressed())
  {
    if(sw.paused) {
      sw.resume();
    } else {
     sw.pause(); 
    }
  }
  if (restart.isPressed())
  {
    sw.start();

    //restart the game
    levelCount = 0;
    crashCount = 0;
  }
}

// Resets states of the game
public void resetState() {
  time = -1;
  // Putting airplane to its initial position
  airplane.x = startPositionX;
  airplane.y = startPositionY;
  // Hiding landing strip as it is not visible at the begining of the level
  if ( levelCount == 2) {
    landingStrip.hidden = false;
  } 
  else {
    landingStrip.hidden = true;
  }
  airplane.initialYSpeed = -7.5f;
  airplane.windSpeed = 0;
  airplane.antiGravity = 0;
  jumpCount = 0;
}

// Checks if the plane can occupy the loactaion at xx and yy coordinates on the screen
// such that it does not intersect any of the Cloud or Airport objects
public boolean placeFree(int xx, int yy) {
  // Assuming that initially the place is free
  boolean placeFree = true;
  // Checking for intersaction with all the clouds and airports.
  // If the airplane intersecta with any of the clouds, returning false
  for (int i=0; i<clouds.length; i++) if (clouds[i].intersects(xx, yy)) return false;
  // If the airplane intersecta with any of the airports, returning false
  for (int i=0; i<airports.length; i++) if (airports[i].intersects(xx, yy)) return false;
  // Checking if the airplane intersects header or footer
  if (yy-15<height/5 || yy+15>height-height/5) placeFree = false;
  // Checking if the airplane intersects left or right edges of the canvas
  if (xx-15<0 || xx+15>width) placeFree = false;
  // Returning the result
  return placeFree;
}

public void keyPressed () {
  // For the first level...
  if (levelCount == 0) {
    // ...move the airplane LEFT, RIGHT, and/or UP on keys pressed
    switch(keyCode) {
    case RIGHT: 
      airplane.moveRight = true; 
      break;
    case LEFT: 
      airplane.moveLeft = true; 
      break;
    case UP: 
      airplane.moveUp = true; 
      break;
    }
  }
  // For the second level...
  if (levelCount == 1) {
    // ...switch LEFT and RIGHT movements on keys pressed, and keep UP movement
    switch(keyCode) {
    case RIGHT: 
      airplane.moveLeft = true; 
      break;
    case LEFT: 
      airplane.moveRight = true;
      break;
    case UP: 
      airplane.moveUp = true; 
      break;
    }
  }
  if (levelCount == 8) {
    // ...no going back
    switch(keyCode) {
    case RIGHT: 
      airplane.moveRight = true; 
      break;
    case LEFT: 
      airplane.moveLeft = false; 
      break;
    case UP: 
      airplane.moveUp = true; 
      break;
    }
  }
  if (levelCount == 2) {

    switch(keyCode) {
    case RIGHT: 
      airplane.moveRight = true; 
      break;
    case LEFT: 
      airplane.moveLeft = true; 
      break;
    case UP: 
      airplane.moveUp = true; 
      break;
    }
  }
  if (levelCount == 4) {
    switch(keyCode) {
    case RIGHT: 
      airplane.moveRight = true; 
      break;
    case LEFT: 
      airplane.moveLeft = true; 
      break;
    }
  }
  if (levelCount == 7) {
    switch(keyCode) {
    case RIGHT: 
      airplane.moveRight = true; 
      break;
    case LEFT: 
      airplane.moveLeft = true; 
      break;
    case UP: 
      airplane.moveUp = true; 
      break;
    }
  }
  if (levelCount == 9) {
    switch(keyCode) {
    case RIGHT: 
      airplane.moveRight = true; 
      break;
    case LEFT: 
      airplane.moveLeft = true; 
      break;
    case UP: 
      airplane.moveUp = true; 
      break;
    }
  }
  if (levelCount == 5) {
    switch(keyCode) {
    case RIGHT: 
      airplane.moveRight = true; 
      break;
    case LEFT: 
      airplane.moveLeft = true; 
      break;
    case UP: 
      if (jumpCount < 1) {
        airplane.moveUp = true; 
        jumpCount++;
      }
      break;
    }
  }
}

public void mouseDragged() {
  // For the third level, drag the airplane along the mouse's x and y position
  if (levelCount == 3) {
    airplane.x = mouseX;
    airplane.y = mouseY;
  }
}

public void keyReleased() {
  // Stop moving the airplane upon key release
  airplane.moveRight = false; 
  airplane.moveLeft = false; 
  airplane.moveUp = false;
}

public void stop()
{
  song.close();   // always close audio I/O classes
  minim.stop();   // always stop your Minim object

  super.stop();
}

// Button is a class that draws a clickable button with text
class Button {

  float positionX;  // x-coordinate of the button
  float positionY;  // y-coordinate of the button
  float buttonWidth;// width of the button
  float buttonHeight;// hight of the button

  String buttonText;
  /* methods */

  boolean hidden = false;

  // constructor 
  Button(float x, float y, float w, float h, String newButtonText) {
    positionX = x;
    positionY = y;
    buttonWidth = w;
    buttonHeight = h;
    buttonText = newButtonText;
  }

  // draws the button
  public boolean isPressed() {
    if (mousePressed && 
      mouseX>positionX && mouseX<positionX+buttonWidth && 
      mouseY>positionY && mouseY<positionY+buttonHeight) {
      return true;
    }
    else {
      return false;
    }
  }

  public void display() {
    if (hidden) return;
    // Checking if the button is clicked
    // Drawing the shape
    stroke(140);
    fill(215);
    textSize(16);
    rectMode(CORNER);
    rect(positionX, positionY, buttonWidth, buttonHeight);
    fill(0);
    text(buttonText, positionX+ buttonWidth/3, positionY + buttonHeight-buttonHeight/3);
  }
}

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
  int cloudFill = color(201, 229, 227);
  int buttonDarkFill = color(170, 0, 0);
  int buttonLightFill = color(209, 8, 12);
  int mountainDarkFill = color(155, 137, 123);
  int mountainLightFill = color(214, 193, 171);
  int waterFill = color(48, 180, 227);
  int airportDarkFill = color(180, 75, 136);
  int airportLightFill = color(255, 229, 244);
  int landingStripGray = color(98, 98, 98);
  int landingStripYellow = color(216,211,35);
  boolean hidden = false;

  Environment (int tempX, int tempY, int tempObjectWidth, int tempObjectHeight, int tempType, int tempRotateAngle) {
    x = tempX;
    y = tempY;
    objectWidth = tempObjectWidth;
    objectHeight = tempObjectHeight;
    type = tempType;
    rotateAngle = tempRotateAngle;
  }

  public void display() {
    // If hidden is true, returning from the method such that nothing is drawen
    if (hidden) return;

    // Drawing appropriate object according to the type 
    if (type == CLOUD) {cloudObject();}
    else if (type == MOUNTAIN) {mountainObject();}
    else if (type == WATER) {waterObject();}
    else if (type == AIRPORT) {airportObject();}
    else if (type == LANDINGSTRIP) {landingStripObject();}
    else if (type == BUTTON) {buttonObject();}
    else {println("Incorrect Object Defined");}
  }

  // Draws cloud object
  public void cloudObject() {
    noStroke();
    fill(cloudFill);
    rectMode(CORNER);
    rect (x, y, objectWidth, objectHeight);

    //top circles
    ellipse(x+objectWidth/6, y+objectHeight/60, objectWidth/2.5f, objectHeight/6);
    ellipse(x+3*(objectWidth/5.95f), y+objectHeight/60, objectWidth/2.5f, objectHeight/6);
    ellipse(x+5*(objectWidth/5.95f), y+objectHeight/60, objectWidth/2.5f, objectHeight/6);

    //bottom circles
    ellipse(x+objectWidth/6, y+objectHeight, objectWidth/3, objectHeight/6);
    ellipse(x+3*(objectWidth/5.95f), y+objectHeight, objectWidth/3, objectHeight/6);
    ellipse(x+5*(objectWidth/5.95f), y+objectHeight, objectWidth/3, objectHeight/6);

    //left circles
    ellipse(x, y+objectHeight/7.2f, objectWidth/3.8f, objectHeight/3.5f);
    ellipse(x, y+3*(objectHeight/8.25f), objectWidth/3.8f, objectHeight/3.5f);
    ellipse(x, y+5*(objectHeight/8.25f), objectWidth/3.8f, objectHeight/3.5f);
    ellipse(x, y+7*(objectHeight/8.25f), objectWidth/3.8f, objectHeight/3.5f);

    //right circles
    ellipse(x+objectWidth, y+objectHeight/7.2f, objectWidth/3.8f, objectHeight/3.5f);
    ellipse(x+objectWidth, y+3*(objectHeight/8.25f), objectWidth/3.8f, objectHeight/3.5f);
    ellipse(x+objectWidth, y+5*(objectHeight/8.25f), objectWidth/3.8f, objectHeight/3.5f);
    ellipse(x+objectWidth, y+7*(objectHeight/8.25f), objectWidth/3.8f, objectHeight/3.5f);
  }

  // Draws moutain
  public void mountainObject() {
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
    ellipse(0+objectWidth/8, 0, objectWidth/3.8f, objectHeight/7.5f);

    //draw dark brown ellipse fo curve
    fill(mountainDarkFill);
    ellipse(0-objectWidth/8, 0, objectWidth/3.8f, objectHeight/7.5f);

    //put the origin point back to its original point (relative to the window)
    popMatrix();
  }

  // Draws water
  public void waterObject() {
    noStroke();
    fill(waterFill);
    rectMode(CORNER);
    rect (x, y, objectWidth, objectHeight);
  }

  // Draws airport
  public void airportObject() {
    noStroke();
    rectMode(CORNER);

    //set fill and draw building
    fill(airportDarkFill);
    rect (x, y, objectWidth, objectHeight);

    //set fill for windows
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

    //draw third row of windows
    rect (x+2*(objectHeight/10), y+3*(objectHeight/5), 4*(objectWidth/5.7f), 2*(objectHeight/5));
  }

  // Draws landing strip
  public void landingStripObject() {
    noStroke();
    fill(landingStripGray);
    rectMode(CORNER);
    rect (x, y, objectWidth, objectHeight*1.5f);
    
    fill(landingStripYellow);
    rect (x+objectWidth/6, y+objectHeight/2, objectWidth/6, objectHeight/4);
    rect (x+3*(objectWidth/6), y+objectHeight/2, objectWidth/6, objectHeight/4);
    rect (x+5*(objectWidth/6), y+objectHeight/2, objectWidth/6, objectHeight/4);
  }

  // Draws button
  public void buttonObject() {
    noStroke();
    fill(buttonLightFill);
    ellipseMode(CENTER);
    ellipse (x, y, objectWidth, objectHeight);
    fill(buttonDarkFill);
    rectMode(CORNER);
    rect (x-objectWidth/2, y, objectWidth, objectHeight/1.75f);
  }

  // Checks if the plane intersects with the current object
  public boolean intersects(Plane plane) {
    if (!(plane.top() > bottom() || plane.bottom() < top() || plane.left() > right() || plane.right() < left())) return true;
    return false;
  }

  // Checks if the plane at coordinate xx and yy intersects with the current object
  public boolean intersects(int xx, int yy) {
    if (!(yy-15 > bottom() || yy+15 < top() || xx-15 > right() || xx+15 < left())) return true;
    return false;
  }

  // Returns the value of y at the top side of the object
  public int top() {
    if (type==MOUNTAIN || type==BUTTON) {return y-objectHeight/2;}
    return y;
  }

  // Returns the value of x at the right side of the object
  public int right() {
    if (type==MOUNTAIN || type==BUTTON) {return x+objectWidth/2;}
    return x+objectWidth;
  }

  // Returns the value of x at the bottom side of the object
  public int bottom() {
    if (type==MOUNTAIN || type==BUTTON) {return y+objectHeight/2;}
    return y+objectHeight;
  }

  // Returns the value of y at the left side of the object
  public int left() {
    if (type==MOUNTAIN || type==BUTTON) {return x-objectWidth/2;}
    return x;
  }
}

class Plane {

  int x;            // Position x
  int y;            // Position y
  int objectWidth;  // Width of the object
  int objectHeight; // Height of the object

  // Variables indicate the direction where the object should move
  boolean moveUp = false;
  boolean moveRight = false;
  boolean moveLeft = false;

  float xSpeed = 0, ySpeed = 0;    // Horizontal and vertical speed
  float accel = 0.5f, deccel = 0.5f; // Acceleration and deccelleration of the speed along x
  float gravity = 0.25f;            // Gravity, the rate of change of the speed along y
  float maxXspd = 2, maxYspd = 52; // Limits horizontal and vertical speed
  float xSave = 0, ySave = 0;      // Holds the decimal points of the distnace the object should move along the x and y axis
  int xRep = 0, yRep = 0;          // Holds the integer value of the distnace the object should move along the x and y axis
  
  PImage photo;
  float initialYSpeed = -7.5f;
  float windSpeed = 0;
  float antiGravity = 0;

  Plane (int tempX, int tempY, int tempObjectWidth, int tempObjectHeight) {
    x = tempX;
    y = tempY;
    objectWidth = tempObjectWidth;
    objectHeight = tempObjectHeight;
    photo = loadImage("airplane-cartoon2.png");
  }

  public void display() {
    noStroke();
    fill(175, 175, 175);
    rectMode(CENTER);
    //rect(x, y, objectWidth, objectHeight);
    image(photo, x-30, y-32);
  }

  // animates movements of the object
  public void updatePosition() {

    // right pressed
    if (moveRight) {
      xSpeed += accel;
      if (xSpeed>maxXspd) {
        xSpeed = maxXspd;
      }
    }

    // left presssed
    else if (moveLeft) {
      xSpeed -= accel;
      if (xSpeed<-maxXspd) {
        xSpeed = -maxXspd;
      }
    }

    //neither right or left pressed, decelerate
    else {
      if (xSpeed>0) {
        xSpeed -= deccel;
        if (xSpeed<0) {
          xSpeed = 0;
        }
      } 
      else if (xSpeed<0) {
        xSpeed += deccel;
        if (xSpeed>0) {
          xSpeed = 0;
        }
      }
    }
    //if (xSpeed >
    xSpeed += windSpeed;

    // up presssed
    if (moveUp) {
      // checking if object is not in the air and landed by testing for collision
      // with another object one pixel below
      boolean placeFree = placeFree(x, y+1);
      // jumpig in not already in the air
      if (!placeFree) ySpeed = initialYSpeed;
      moveUp = false;
    }

    // on jump, start decreasing the speed and then return object back to the ground
    ySpeed += gravity;
    if (ySpeed > -2.5f) {
    ySpeed -= antiGravity;
    }

    // Separating int value and the decimal points of the distance to move such that the object would
    // always end up at the exact pixel on the screen
    xRep = floor(abs(xSpeed));
    yRep = floor(abs(ySpeed));
    xSave += abs(xSpeed)-floor(abs(xSpeed));
    ySave += abs(ySpeed)-floor(abs(ySpeed));

    // Changing the direction of the moovement depending on wheter speed is positive or negative
    int signX = (xSpeed<0) ? -1 : 1;
    int signY = (ySpeed<0) ? -1 : 1;

    // If decimal points of the distace to move in xSave or ySave are bigger than 1,
    // moving 1 to xRep or yRep correspondigly
    if (xSave>=1) {
      xSave -= 1;
      xRep += 1;
    }
    if (ySave>=1) {
      ySave -= 1;
      yRep += 1;
    }

    // Moving object along the x axis and checking for collisions at each pixel
    for (; xRep>0; xRep--) {
      if (placeFree(x+signX, y)) {
        x+=signX;
      }
      // Stopping animation/movement if collision is deteced by setting the speed to 0
      else {
        xSpeed = 0;
      }
    }

    // Moving object along the y axis and checking for collisions at each pixel
    for (; yRep>0; yRep--) {
      if (placeFree(x, y+signY)) {
        y += signY;
      }
      // Stopping animation/movement if collision is deteced by setting the speed to 0
      else {
        ySpeed = 0;
      }
    }
  }

  // Returns the value of y at the top side of the object
  public int top() {
    return y-objectHeight/2;
  }

  // Returns the value of x at the right side of the object
  public int right() {
    return x+objectWidth/2;
  }

  // Returns the value of y at the bottom side of the object
  public int bottom() {
    return y+objectHeight/2;
  }

  // Returns the value of x at the left side of the object
  public int left() {
    return x-objectWidth/2;
  }
}

// StopWatchTimer is a class that counts the time passed
class StopWatchTimer {
  int startTime = 0;
  int pauseTime = 0;
  boolean paused = false;
  
  public void start() {
    startTime = millis();
  }
  
  public void pause() {
    pauseTime = millis();
    paused = true;
  }
  
  public void resume() {
    startTime += (millis() - pauseTime);
    paused = false;
  }
  

  // Counting how much time has passed since the start, if not runing showing the time it stopped at
  public int getElapsedTime() {
    return millis( )- startTime;
  }


  // Tourining milliseconds into seconds
  public int second() {
    return (getElapsedTime() / 1000) % 60;
  }
  // Tourining milliseconds into minutes
  public int minute() {
    return (getElapsedTime() / (1000*60)) % 60;
  }
  // Tourining milliseconds into hours
  public int hour() {
    return (getElapsedTime() / (1000*60*60)) % 24;
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "FlightsOfFury" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
