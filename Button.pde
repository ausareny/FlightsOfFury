// Button is a class that draws a clickable button with text
class Button {

  float positionX;  // x-coordinate of the button
  float positionY;  // y-coordinate of the button
  float buttonWidth;// width of the button
  float buttonHeight;// hight of the button
  boolean pressed = false; // indicates whether the button is pressed
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
  void display() {
    // Checking if the button is clicked
    pressed = false;
    if (mousePressed) {
      if (mouseX>positionX && mouseX<positionX+buttonWidth && mouseY>positionY && mouseY<positionY+buttonHeight) {
        pressed = true;
      }
    }

    // Drawing the shape
    stroke(1);
    fill(255);
    textSize(16);
    rectMode(CORNER);
    rect(positionX, positionY, buttonWidth, buttonHeight);
    fill(0);
    text(buttonText, positionX+ buttonWidth/3, positionY + buttonHeight-buttonHeight/3);
  }
}

