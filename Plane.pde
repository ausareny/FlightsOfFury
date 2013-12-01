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
      if(!placeFree(x,y+60) || !placeFree(x,y+60)) ySpeed = -5.3;
    }
    
    ySpeed += gravity;

    /*
    // The technique used for movement involves taking the integer (without the decimal)
     // part of the player's xSpeed and ySpeed for the number of pixels to try to move,
     // respectively.  The decimal part is accumulated in xSave and ySave so that once
     // they reach a value of 1, the player should try to move 1 more pixel.  This jump
     // is not normally visible if it is moving fast enough.  This method is used because
     // is guarantees that movement is pixel perfect because the player's position will
     // always be at a whole number.  Whole number positions prevents problems when adding
     // new elements like jump through blocks or slopes.
     */
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
    //int offsetX = (xSpeed<0) ? 0 : 15;
    //int offsetY = (ySpeed<0) ? 0 : 15;

    if (xSave>=1) {
      xSave -= 1;
      xRep += 1;
    }
    if (ySave>=1) {
      ySave -= 1;
      yRep += 1;
    }

    for(; xRep>0; xRep--) {
      if(placeFree(x+signX,y)) x+=signX;
      else xSpeed = 0;
    }

    for (; yRep>0;yRep--) {
      if(placeFree(x,y+signY)) y += signY;
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

