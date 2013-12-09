/** 
* Title: Flights of Fury <br>
* Name: Amanda Lee and Justyna Ausareny <br>
* Date: December 9th, 2013 <br>
* Description: Option 2 - Open Brief <br> 
**/

//Import music library
import ddf.minim.*;

//Variables holding minim and song to be played
Minim minim;
AudioPlayer song;

//Variable holding plane object
Plane airplane;

//Variables holding the button and landing strip object
Environment redButton;
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

// Start position of the airplane in the initial airport
int startPositionX = 75;
int startPositionY = 215;

// Declare a variable of type PFont
PFont f; 
// String holding the title of the game
String title = "Flights of fury";

// Indicates whether the button has been pressed
boolean pressed = false;

// Level counter that hold different stages
// it starts at the -1 property which displays the start banner
int levelCount = -1;

// Counter holding how many times the player has crashed into a mountain or water
int crashCount;
int jumpCount = 0;

// Variables holding pause and restart buttons
Button pause; 
Button restart;

// Variable holding the stop watch
StopWatchTimer sw; 

// Holds the exact time that a level was completed at.
// Set time value to -1 indicating that timer has not been set yet; "impossible value"
// it will only be set at the moment the plane touches the landingStrip indicating the end of a level
int time = -1;

// Initializes environment
void setup() {
  // Resize window.
  size (600, 600);
  
  //set background color and smoothness
  background (255);
  smooth();

  // this loads the music file from the data folder
  minim = new Minim(this); // instantiating a Minim object
  song = minim.loadFile("The Royal Guardsmen - Airplane Song(My Airplane).wav"); // adding a file
  song.loop(); // loops or restarts the current song from the begining


  // Assigining stopWatchTimer class to the variable sw
  sw = new StopWatchTimer();
  // calling the funtion start only once to record the time passed
  sw.start();

  // Load the vlw font file from the data folder into a variable
  f = loadFont("KnarfArtFont-Bold-48.vlw");
  // tell processing which font and size to use for the text
  textFont(f, 48);

  // Instantiating the Button class into the pause and restart variables, and defining its positions and properties 
  pause = new Button(0, 570, width/2, 30, "Pause");
  restart = new Button(width/2, 570, width/2, 30, "Restart");

  // Instantiating the Plane class into the airplane variable, and defining its position and size
  airplane = new Plane (startPositionX, startPositionY, 30, 30);
  
  // Instantiating the Environment class into the redButton and landingStrip variables, and defining its position and properties
  redButton = new Environment (width/2, 255, 50, 15, BUTTON, 0);
  landingStrip = new Environment (460, 435, 50, 10, LANDINGSTRIP, 0);
  // Telling the landing strip to start off hidden
  landingStrip.hidden = true;

  // Adding clouds objects and defining their positions and sizes
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

  // Adding water objects and defining their positions and sizes
  addWater(100, 450, 100, 30);
  addWater(340, 450, 65, 30);

  // Adding airport objects and defining their positions and sizes
  addAirport(0, 120, 90, 80);
  addAirport(510, 370, 90, 80);

  // Adding mountains and defining their positions, sizes, and angles of rotation
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
void addCloud(int x, int y, int objectWidth, int objectHeight) {
  if (currentCloudIndex < clouds.length) clouds[currentCloudIndex++] = new Environment(x, y, objectWidth, objectHeight, CLOUD, 0);
  else println("Too many clouds!");
}

// Function that handles adding Mountain objects to the array
void addMountain(int x, int y, int objectWidth, int objectHeight, int objectRotate) {
  if (currentMountainIndex < mountains.length) mountains[currentMountainIndex++] = new Environment(x, y, objectWidth, objectHeight, MOUNTAIN, objectRotate);
  else println("Too many mountains!");
}

// Function that handles adding Water objects to the array
void addWater(int x, int y, int objectWidth, int objectHeight) {
  if (currentWaterIndex < waters.length) waters[currentWaterIndex++] = new Environment(x, y, objectWidth, objectHeight, WATER, 0);
  else println("Too many water objects!");
}

// Function that handles adding Airport objects to the array
void addAirport(int x, int y, int objectWidth, int objectHeight) {
  if (currentAirportIndex < airports.length) airports[currentAirportIndex++] = new Environment(x, y, objectWidth, objectHeight, AIRPORT, 0);
  else println("Too many airports!");
}

// Draws the animation
void draw() {
  
  if(sw.paused) {
     return;
   }
 
  //For the first screen, display the start banner holding the play button
  if(levelCount == -1) {
    bannerPlay();
    return;
  }

  // Resets the background to the given color
  background(245, 252, 252);

  // Displays environment objects (clouds, mountains, water, and airports) within its proper array
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
  
  // Draws the landing strip
  landingStrip.display();
  
  // Draws the red button
  redButton.display();
  
  // Draws the airplane and updates its position
  airplane.display();
  airplane.updatePosition();


  // Checking if the airplane has collided with any of mountain or water objects
  // resets the level and adds a number to the crash counter if it does collide
  for (int i=0; i<mountains.length; i++) {
    if (mountains[i].intersects(airplane)) {
    crashCount++;
    resetState();
    }
  }
  for (int i=0; i<waters.length; i++) {
    if (waters[i].intersects(airplane)) {
      // However, if it is the Fifth level, make the airplane jump up when it collides with the water
      if (levelCount == 4) {
        airplane.initialYSpeed = -12;
        airplane.moveUp = true;
      } 
      else {
        crashCount++;
        resetState();
      }
    }
  }

  // Draws header and sets its fill, stroke and rectMode values
  fill(75);
  noStroke();
  rectMode(CORNER);
  rect(0, 0, width, height/5);
  
  // Draws the timer
  time();

  // Write game title to the screen using: text(data, xPosition, yPosition)
  fill(255);
  textSize(48);
  textAlign(LEFT, BASELINE);
  text(title, 20, 60);

  // Drawing footer and sets its fill, stroke and rectMode values
  fill(75);
  noStroke();
  rectMode(CORNER);
  rect(0, height-height/5, width, height/5);
  
  //Draws the pause and restart buttons
  pause.display(); 
  restart.display();
  
  // Displays crash count and stage count as a text on the screen and sets it color, size, alignment and position values
  fill(255);
  textAlign(LEFT, BASELINE);
  text("Crashes: "+crashCount, 438, 500);
  textSize(28);
  text("Stage: "+(levelCount+1), 20, 530);

  // Checks if the airplane has collided with the button, and displays the landing strip when it does
  if (redButton.intersects(airplane)) {  
    // However, if it is the third level, have the landing strip hide when the airplane collides with the button 
    if ( levelCount == 2) {
      landingStrip.hidden = true;
    }
    else {
      landingStrip.hidden = false;
    }
  }
  
  /**
  * Checking if the airplane has touched a visible/unhidden landing strip
  * if it did, reset the airplane, display the banner indicating that the level has been successfully passed
  * and continue on to the next level by increasing the level count
  **/
  //If the airplane has collided with the landing strip
  if (!landingStrip.hidden && landingStrip.intersects(airplane)) {
    
    // if time is still at unsettable state
    if (time == -1) { 
      // record the time that the airpline collided with landing strip
      time = millis();
    }
    
    // Display the banner for 1.5 seconds from the time of the collision
    if (millis() <= time+1500) {
      bannerStage();
    } 
    else {
      levelCount++;
      resetState();
    }
  }

  // For the seventh level, have the airplane follow the mouse
  if (levelCount == 6) {
    airplane.x = mouseX;
    airplane.y = mouseY;
  } 
  // For the eighth level, have the x value of the airplane move backwards creating a simulation of strong wind
  if (levelCount == 7) {
    airplane.windSpeed = -0.35;
  } 
  // For the tenth level, create a floating effect where gravity does not seem as dominant
  if (levelCount == 9) {
    airplane.antiGravity = 0.2;
  }
  // At the end of all 10 levels, display the end banner
  if (levelCount==10) {
    bannerEnd();
  }
}

// Function holding the start banner
void bannerPlay() {
  // Setting fill, stroke, size and position for rectangle banner
  fill(255);
  noStroke();
  rect(0, 0, 1200, 1200);
  
  // Setting color, size, alignment, and position for "Play" text
  fill(0);
  textSize(26);
  textAlign(CENTER, CENTER);
  text("Play", width/2, height/2);
  
  // Declare variable to hold play button instance and initialize it with the given properties
  Button buttonPlay = new Button(width/2-50, height/2-25, 100, 50, " ");
  buttonPlay.hidden = true;
  // Draw the play button
  buttonPlay.display();
  
  // When the play button is pressed, start level one
  if(buttonPlay.isPressed()) {
    levelCount++;
  }
}

// Function holding the stage complete banner
void bannerStage() {
  // Setting properties for black banner
  fill(0);
  noStroke();
  rect(0, 200, width, 200);
  
  // Setting color, size, alignment, and position for "Stage complete" text
  fill(255);
  textSize(40);
  textAlign(CENTER, CENTER);
  text("Stage complete", width/2, height/2);
}

// Function holding the end banner
void bannerEnd() {
  // Setting fill, stroke, size and position for rectangle banner
  fill(255);
  noStroke();
  rect(0, 0, 1200, 1200);
  
  // Setting color, size, alignment, and position for end banner text
  fill(0);
  textSize(26);
  textAlign(CENTER, CENTER);
  text("That's not the end", width/2, height/2-50);
  textSize(18);
  text("Continue questioning your habits", width/2, height/2+50);
}

// Function holding the stop watch timer
void time() {
  // Setting color, size, and alignment for text
  fill(200);
  textAlign(LEFT, BASELINE);
  textSize(20);
  
  // Calling, formatting and positioning the time
  text(nf(sw.hour(), 2)+":"+nf(sw.minute(), 2)+":"+nf(sw.second(), 2), 438, 100);
}

// Function to reset the states of the game
void resetState() {
  // Resets time variable by erasing the time that was recorded when the airpline collided with landing strip in the previous level
  time = -1;
  
  // Puts airplane back to its start position in the initial airport
  airplane.x = startPositionX;
  airplane.y = startPositionY;
  
  // For the third level, have to landing strip visible from the start
  if ( levelCount == 2) {
    landingStrip.hidden = false;
  } 
  else {
    // Otherwise, hide landing strip as it is not visible at the begining of the level
    landingStrip.hidden = true;
  }
  
  // Making sure individual level features are not passed on to other levels
  airplane.initialYSpeed = -7.5;
  airplane.windSpeed = 0;
  airplane.antiGravity = 0;
  jumpCount = 0;
}

// Checks if the plane has free space to occupy the locataion at xx and yy coordinates on the screen
// such that it does not intersect any of the Cloud or Airport objects
boolean placeFree(int xx, int yy) {
  // Assuming that initially the place is free
  boolean placeFree = true;
  
  // Checking for intersection with all objects:
  // If the airplane intersects with any of the clouds, return false
  for (int i=0; i<clouds.length; i++) {
    if (clouds[i].intersects(xx, yy)) {
      return false;
    }
  }
  // If the airplane intersects with any of the airports, return false
  for (int i=0; i<airports.length; i++) {
    if (airports[i].intersects(xx, yy)) {
      return false;
    }
  }
  
  // If the airplane intersects header or footer, return false
  if (yy-15<height/5 || yy+15>height-height/5) {
    placeFree = false;
  }
  // If the airplane intersects left or right edges of the canvas, return false
  if (xx-15<0 || xx+15>width) {
    placeFree = false;
  }
  
  // Return the result
  return placeFree;
}

// This function is triggered by a mouse event: 
// when the mouse is pressed on the pause button, it will pause the stop watch timer and display the pause time... 
// ...or continue the counter of the stop watch timer from the pause time
// when the mouse is pressed on the restart button, it will reset the stop watch timer, the entire game, and the crash count
void mousePressed() {

  if(sw.paused) {
       sw.resume();
     } 
  else {
       sw.pause(); 
     }
     
  if (restart.isPressed())
  {
    //resets stop watch
    sw.start();

    //restarts the game
    levelCount = 0;
    crashCount = 0;
  }
}

// This function is triggered by a key event: when a key is pressed, it will set the trigger
// the airplane to move in certain ways/directions depending on which level is being played
void keyPressed () {
  
  // For the first level, move the airplane LEFT, RIGHT, and UP on its corresponding left, right and up keys
  if (levelCount == 0) {
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
  // For the second level, switch LEFT and RIGHT movements on keys pressed, and keep UP movement the same
  if (levelCount == 1) {
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
  // For the third level, move the airplane LEFT, RIGHT, and UP on its corresponding left, right and up keys
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
  // For the fifth level, only move the airplane LEFT or RIGHT on its corresponding left or right keys
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
  // For the sixth level, move the airplane LEFT or RIGHT on its corresponding left or right keys
  // and only allow the player to use the UP key once on its corresponding up key
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
  // For the eighth level, move the airplane LEFT, RIGHT, and UP on its corresponding left, right and up keys
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
  // For the ninth level, only move the airplane RIGHT, or UP on its corresponding right and up keys
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
  // For the first level, move the airplane LEFT, RIGHT, and UP on its corresponding left, right and up keys
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
}

// This function is triggered by a mouse event: when the mouse is dragged, it will move the airplane
// along the mouse's x and y coordinates
void mouseDragged() {
  // For the third level, drag the airplane along the mouse's x and y position
  if (levelCount == 3) {
    airplane.x = mouseX;
    airplane.y = mouseY;
  }
}

// This function is triggered by a key event: when the key is released, it will stop 
// the airplane from moving in that given direction
void keyReleased() {
  // Stop moving the airplane upon key release
  airplane.moveRight = false; 
  airplane.moveLeft = false; 
  airplane.moveUp = false;
}

void stop()
{
  song.close();   // always close audio I/O classes
  minim.stop();   // always stop your Minim object

  super.stop();
}

