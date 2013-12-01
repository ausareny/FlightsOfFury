class Plane {
  int x;
  int y;
  int objectWidth;
  int objectHeight;
  boolean move = false;
  boolean moveDown = false; 
  boolean moveUp = false;
  boolean moveRight = false;
  boolean moveLeft = false;
  float speedX = 1;
  float speedY = 1;
  
  float xSpeed, ySpeed;
  float accel,deccel;
  float maxXspd,maxYspd;
  float xSave,ySave;
  int xRep,yRep;
  float gravity;

  Plane (int tempX, int tempY, int tempObjectWidth, int tempObjectHeight) {
    x = tempX;
    y = tempY;
    objectWidth = tempObjectWidth;
    objectHeight = tempObjectHeight;
    xSpeed = 0;
    ySpeed = 0;
    accel = 0.5;
    deccel = 0.5;
    maxXspd = 2;
    maxYspd = 12;
    xSave = 0;
    ySave = 0;
    xRep = 0;
    yRep = 0;
    gravity = 0.25;
  }

  void display() {
    pushMatrix();
    noStroke();
    fill(175, 175, 175);
    rectMode(CENTER);
    rect(x, y, objectWidth, objectHeight);
    popMatrix();
  }

  void updatePosition() {
    if (moveRight == true) {
      x += speedX;
      moveRight = false;
    } 
    else if (moveLeft == true) {
      x -= speedX;
      moveLeft = false;
    } else {
      
    }
    
    if (moveUp == true) {
      y -= speedY;
      moveUp = false;
    }  

    if (placeFree()) {
      y += speedY;
    }
  }

  int top() {
    return y-objectHeight/2;
  }

  int right() {
    return x+objectWidth/2;
  }

  int bottom() {
    return y+objectHeight/2;
  }

  int left() {
    return x-objectWidth/2;
  }
}

