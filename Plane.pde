class Plane {
  int x;
  int y;
  int objectWidth;
  int objectHeight;
  boolean moveDown = false; 
  boolean moveUp = false;
  boolean moveRight = false;
  boolean moveLeft = false;
  
  float xSpeed, ySpeed;
  float accel, deccel;
  float maxXspd, maxYspd;
  float xSave, ySave;
  int xRep, yRep;
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
    maxYspd = 55;
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
    if(moveRight) {
      xSpeed += accel;
      if(xSpeed>maxXspd) xSpeed = maxXspd;
    } else if(moveLeft) {
      xSpeed -= accel;
      if(xSpeed<-maxXspd) xSpeed = -maxXspd;
    } else { //neither right or left pressed, decelerate
      if(xSpeed>0) {
        xSpeed -= deccel;
        if(xSpeed<0) xSpeed = 0;
      } else if(xSpeed<0) {
        xSpeed += deccel;
        if(xSpeed>0) xSpeed = 0;
      }
    }

    if(moveUp) {
      boolean placeFree = placeFree(x, y+1);
      if(!placeFree) ySpeed = -8;
    }
    
    ySpeed += gravity;
    xRep = 0; //should be zero because the for loops count it down but just as a safety
    yRep = 0;
    xRep += floor(abs(xSpeed));
    yRep += floor(abs(ySpeed));
    xSave += abs(xSpeed)-floor(abs(xSpeed));
    ySave += abs(ySpeed)-floor(abs(ySpeed));
    int signX = (xSpeed<0) ? -1 : 1;
    int signY = (ySpeed<0) ? -1 : 1;
    //when the player is moving a direction collision is tested for only in that direction
    //the offset variables are used for this in the for loops below
    int offsetX = (xSpeed<0) ? 0 : 0;
    int offsetY = (ySpeed<0) ? 0 : 0;

    if (xSave>=1) {
      xSave -= 1;
      xRep += 1;
    }
    if (ySave>=1) {
      ySave -= 1;
      yRep += 1;
    }

    for(; xRep>0; xRep--) {
      if(placeFree(x+offsetX+signX,y)) x+=signX;
      else xSpeed = 0;
    }

    for(; yRep>0;yRep--) {
      if(placeFree(x,y+offsetY+signY)) y += signY;
      else ySpeed = 0;
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
