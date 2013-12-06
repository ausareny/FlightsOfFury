// Button is a class that draws a clickable button with text
class Button {

  float positionX;  // x-coordinate of the button
  float positionY;  // y-coordinate of the button
  float buttonWidth;// width of the button
  float buttonHeight;// hight of the button

  String buttonText;
  /* methods */
  
  // constructor 
  Button(float x, float y, float w, float h, String newButtonText) {
    positionX = x;
    positionY = y;
    buttonWidth = w;
    buttonHeight = h;
    buttonText = newButtonText;
  }

  // draws the button
  boolean isPressed() {
    if (mousePressed && 
       mouseX>positionX && mouseX<positionX+buttonWidth && 
       mouseY>positionY && mouseY<positionY+buttonHeight) {
       return true;
    }
    else {
      return false;
    }
  }
  
  void display() {
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

