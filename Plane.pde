/** 
* Title: Flights of Fury <br>
* Name: Amanda Lee and Justyna Ausareny <br>
* Date: December 9th, 2013 <br>
* Description: Plane class represents the airplane object in the game, as well as provides functionality that controlls its movements <br> 
**/

// Plane class represents the airplane object in the game, as well as provides functionality that controlls its movements
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
  float accel = 0.5, deccel = 0.5; // Acceleration and deccelleration of the speed along x
  float gravity = 0.25;            // Gravity, the rate of change of the speed along y
  float maxXspd = 2, maxYspd = 52; // Limits horizontal and vertical speed
  float xSave = 0, ySave = 0;      // Holds the decimal points of the distnace the object should move along the x and y axis
  int xRep = 0, yRep = 0;          // Holds the integer value of the distnace the object should move along the x and y axis
  
  PImage photo;                    // Image that represents the airplane on the screen in the game
  float initialYSpeed = -7.5;      // Initial speed of the jump
  float windSpeed = 0;             // Windspeed, initially is 0, but could be set to positive or negative value to add movement along the x-axis
  float antiGravity = 0;           // Anti gravity, initially is 0 but can be set to positive value to slow down the fall of the object along the y-axis

  // Constructs the object with x and y position, widh, and height
  Plane (int tempX, int tempY, int tempObjectWidth, int tempObjectHeight) {
    x = tempX;
    y = tempY;
    objectWidth = tempObjectWidth;
    objectHeight = tempObjectHeight;
    photo = loadImage("airplane-cartoon2.png");
  }
  
  // Displays the object on the screen
  void display() {
    noStroke();
    fill(175, 175, 175);
    rectMode(CENTER);
    
    
    //rect(x, y, objectWidth, objectHeight); // Here for testing
    
    // Displays image of the airplane at x and y position
    image(photo, x-30, y-32);
  }

  // Animates movements of the object
  void updatePosition() {

    // Right pressed
    if (moveRight) {
      // Increasing speed to move right
      xSpeed += accel;
      
      // Limiting speed to maximmu speed
      if (xSpeed>maxXspd) {
        xSpeed = maxXspd;
      }
    }

    // Left presssed
    else if (moveLeft) {
      // Increasing speed to move left
      xSpeed -= accel;
      
      // Limiting speed to maximmu speed
      if (xSpeed<-maxXspd) {
        xSpeed = -maxXspd;
      }
    }

    // Neither right nor left pressed, decelerate
    else {
      if (xSpeed>0) {
        // Decreasing speed to move left
        xSpeed -= deccel;
        
        // Limiting decrease in speed if the speed reached 0
        if (xSpeed<0) {
          xSpeed = 0;
        }
      } 
      else if (xSpeed<0) {
        // Decreasing speed to move right
        xSpeed += deccel;
        
        // Limiting decrease in speed if the speed reached 0
        if (xSpeed>0) {
          xSpeed = 0;
        }
      }
    }
    
    // Adjusting xSpeed with the speed of the wind
    xSpeed += windSpeed;

    // Up presssed
    if (moveUp) {
      // Checking if object is not in the air and landed by testing for collision
      // with another object one pixel below to avoid jumps in the air
      boolean placeFree = placeFree(x, y+1);
      
      // If jump is in not in the air, setting ySpeed to create a jump
      if (!placeFree) ySpeed = initialYSpeed;
      moveUp = false;
    }

    // On jump, start decreasing the speed and then return object back to the ground
    ySpeed += gravity;
    
    // Adjusting ySpeed with the antiGravity to slow down the fall (if antiGravity is not 0)
    if (ySpeed > -2.5) {
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
  int top() {
    return y-objectHeight/2;
  }

  // Returns the value of x at the right side of the object
  int right() {
    return x+objectWidth/2;
  }

  // Returns the value of y at the bottom side of the object
  int bottom() {
    return y+objectHeight/2;
  }

  // Returns the value of x at the left side of the object
  int left() {
    return x-objectWidth/2;
  }
}

