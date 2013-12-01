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

  Environment (int tempX, int tempY, int tempObjectWidth, int tempObjectHeight, int tempType, int tempRotateAngle) {
    x = tempX;
    y = tempY;
    objectWidth = tempObjectWidth;
    objectHeight = tempObjectHeight;
    type = tempType;
    rotateAngle = tempRotateAngle;
  }

  void display() {
    if (type == CLOUD) {
      cloudObject();
    }
    else if (type == MOUNTAIN) {
      mountainObject();
    }
    else if (type == WATER) {
      waterObject();
    }
    else if (type == AIRPORT) {
      airportObject();
    }
    else if (type == LANDINGSTRIP) {
      landingStripObject();
    }
    else if (type == BUTTON) {
      buttonObject();
    }
    else {
      println("Incorrect Object Defined");
    }
  }

  //  boolean collides(Plane plane) {
  //    return true;
  //  }

  //  int getType() {
  //    return type;
  //  }

  void cloudObject() {
    noStroke();
    fill(cloudFill);
    rectMode(CORNER);
    rect (x, y, objectWidth, objectHeight);
  }

  void mountainObject() {
    noStroke();
    fill(155, 137, 123);

    //change origin points
    pushMatrix();
    //set the origin point to where x and y are being called
    translate (x, y);
    //rotate the text by the number of degrees in the rotate variable
    rotate (radians(rotateAngle));


    triangle(0-objectWidth/2, 0+objectHeight/2, 0, 0-objectHeight/2, 0+objectWidth/2, 0+objectHeight/2);

    //put the origin point back to its original point (relative to the window)
    popMatrix();
  }

  void waterObject() {
    noStroke();
    fill(48, 180, 227);
    rectMode(CORNER);
    rect (x, y, objectWidth, objectHeight);
  }

  void airportObject() {
    noStroke();
    fill(180, 75, 136);
    rectMode(CORNER);
    rect (x, y, objectWidth, objectHeight);
  }

  void landingStripObject() {
    noStroke();
    fill(98, 98, 98);
    rectMode(CORNER);
    rect (x, y, objectWidth, objectHeight);
  }

  void buttonObject() {
    noStroke();
    fill(209, 8, 12);
    ellipseMode(CENTER);
    ellipse (x, y, objectWidth, objectHeight);
  }

  boolean intersects(Plane plane) {
    if (!(plane.top() > bottom() || plane.bottom() < top() || plane.left() > right() || plane.right() < left())) return true;
    return false;
  }

  int top() {
    return y;
  }

  int right() {
    return x+objectWidth;
  }

  int bottom() {
    return y+objectHeight;
  }

  int left() {
    return x;
  }
}

