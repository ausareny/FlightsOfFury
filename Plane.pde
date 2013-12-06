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

  Plane (int tempX, int tempY, int tempObjectWidth, int tempObjectHeight) {
    x = tempX;
    y = tempY;
    objectWidth = tempObjectWidth;
    objectHeight = tempObjectHeight;
  }

  void display() {
    noStroke();
    fill(175, 175, 175);
    rectMode(CENTER);
    rect(x, y, objectWidth, objectHeight);
  }

  // animates movements of the object
  void updatePosition() {

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

    // up presssed
    if (moveUp) {
      // checking if object is not in the air and landed by testing for collision
      // with another object one pixel below
      boolean placeFree = placeFree(x, y+1);
      // jumpig in not already in the air
      if (!placeFree) ySpeed = -7.5;
    }

    // on jump, start decreasing the speed and then return object back to the ground
    ySpeed += gravity;

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

