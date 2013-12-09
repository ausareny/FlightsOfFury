/**
 * This class represents a clickable button that can be found on the "Play", "Pause" and "Resume" buttons in the game
 * This button detects whether the mouse has been clicked inside its boundries by triggering the isPressed boolean to true
 * The action(s) following the click of the button are defined in the bannerPlay and mousePressed functions
 * The properties of the buttons are called upon their initializations in the void setup and bannerPlay functions
 */
class Button {

  // x-coordinate and y-coordinate of the button
  float positionX; 
  float positionY; 
  
  // Width and height of the button
  float buttonWidth;
  float buttonHeight;

  // String holding the text to be displayed in the button
  String buttonText;

  boolean hidden = false;

  // Class constructor. Builds a new button with given starting position, size and string.
  // x: x-coordinate of the button
  // y: y-coordinate of the button
  // w: width of the button (in pixels)
  // h: height of the button (in pixels)
  // newButtonText: text to be displayed in the button
  Button(float x, float y, float w, float h, String newButtonText) {
    // Directly assign properties and values
    positionX = x;
    positionY = y;
    buttonWidth = w;
    buttonHeight = h;
    buttonText = newButtonText;
  }

  // Checks to see if mouse has been pressed within the boundries of the button
  boolean isPressed() {
    if (mousePressed && 
      mouseX>positionX && mouseX<positionX+buttonWidth && 
      mouseY>positionY && mouseY<positionY+buttonHeight) {
      //if it has been pressed, make the boolean true
      return true;
    }
    else {
      //if not, make the boolean false
      return false;
    }
  }
  
  // Renders the button to the screen
  void display() {
    
    if (hidden) {
      return;
    }

    // Draw the object as a light grey rectangle, with a dark grey stroke
    stroke(140);
    fill(215);
    rectMode(CORNER);
    rect(positionX, positionY, buttonWidth, buttonHeight);
    
    // Draw the text in black, size 16, with the given string and position
    fill(0);
    textSize(16);
    text(buttonText, positionX+ buttonWidth/3, positionY + buttonHeight-buttonHeight/3);
  }
}

