import ddf.minim.*;

Minim minim;
AudioPlayer song;

//Variable holding plane object
Plane airplane;

//Variables holding the button and landing strip object
Environment button;
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

// Start position of the plane
int startPositionX = 75;
int startPositionY = 215;

//create a Processing version of the font we want to use
PFont f; // declare a variable of type PFont
String title = "Flights of fury";

boolean pressed = false; // indicates whether the button is pressed

// Game level number
int levelCount = -1;
int crashCount;
int jumpCount = 0;

Button pause; // Pause button
Button restart; // Restart button

StopWatchTimer sw; // Stop watch for counting time

int time = -1; // setting time value to -1 indicating that timer has not been set yet; "impossible value"


void setup() {
  size (600, 600);
  background (255);
  smooth();

  // this loads file from the data folder
  minim = new Minim(this); // instantiating a Minim object
  song = minim.loadFile("The Royal Guardsmen - Airplane Song(My Airplane).wav"); // adding a file
  song.loop(); // loops or restarts the current song from the begining



  sw = new StopWatchTimer(); // Assigining stopWatchTimer class to the variable sw
  sw.start(); // calling the funtion start only once to record the time passed

  // load a font into that variable
  f = loadFont("KnarfArtFont-Bold-48.vlw");
  // tell processing to use the font you want and the size
  textFont(f, 48);

  pause = new Button(0, 570, width/2, 30, "Pause");
  restart = new Button(width/2, 570, width/2, 30, "Restart");

  airplane = new Plane (startPositionX, startPositionY, 30, 30);
  button = new Environment (width/2, 255, 50, 15, BUTTON, 0);
  landingStrip = new Environment (460, 435, 50, 10, LANDINGSTRIP, 0);
  landingStrip.hidden = true;

  // Adding clouds objects
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

  // Adding water objects
  addWater(100, 450, 100, 30);
  addWater(340, 450, 65, 30);

  // Adding airport objects
  addAirport(0, 120, 90, 80);
  addAirport(510, 370, 90, 80);

  // Adding mountains
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


void draw() {
  if(levelCount == -1) {
    bannerPlay();
    return;
  }

  // Reseting the image by applying white background
  background(245, 252, 252);

  // Drawing environment objects: clouds, mountains, water, and airports
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

  // Checking if the airpalne touched any of mountains or water and resetting the game if it did
  for (int i=0; i<mountains.length; i++) if (mountains[i].intersects(airplane)) {
    crashCount++;
    resetState();
  }
  for (int i=0; i<waters.length; i++) if (waters[i].intersects(airplane)) {
    if (levelCount == 4) {
      airplane.initialYSpeed = -12;
      airplane.moveUp = true;
    } 
    else {
      crashCount++;
      resetState();
    }
  }

  // Drawing button
  button.display();

  // Drawing header
  rectMode(CORNER);
  fill(75);
  noStroke();
  rect(0, 0, width, height/5);
  time(); // Drawing the timer

  // Write title to the screen using: text(data, xPosition, yPosition)
  fill(255);
  textSize(48);
  text(title, 20, 60);

  // Drawing footer
  fill(75);
  rect(0, height-height/5, width, height/5);
  pause.display(); //Draws the pause button
  restart.display(); //Draws the restart button 
  fill(255);
  // Display crash count as a text
  text("Crashes: "+crashCount, 438, 500);
  textSize(28);
  text("Stage: "+(levelCount+1), 20, 530);


  // Checking if the airplane pressed the button and displaying the landing strip if it did
  if (button.intersects(airplane)) {    
    if ( levelCount == 2) {
      landingStrip.hidden = true;
    }
    else {
      landingStrip.hidden = false;
    }
  }

  // Drawing landing strip
  landingStrip.display();

  // Checking if the airplan has touched a visible landing strip
  // if it did, reset the game indicating that the level has been successfully passed
  // and add a number to level count


  if (!landingStrip.hidden && landingStrip.intersects(airplane)) {
    // Setting the time of interestion if it hasn't been set yet, set only once so it doesn't receive the current time
    if (time == -1) {    // if time is at unsetable state
      time = millis();  // record time from the moment airpline got to the landing strip
    }
    // comparing current time to the time when intersection happened + the time of the holding period
    if (millis() <= time+1500) {
      bannerDisplay();
    } 
    else {
      levelCount++;
      resetState();
    }
  }
  if (levelCount == 7) {
    airplane.windSpeed = -0.35;
  } 
  else if (levelCount == 9) {
    airplane.antiGravity = 0.2;
  }
  // Drawing the airplane and updating its position
  airplane.display();
  airplane.updatePosition();

  // For the fourth level, have the airplane follow the mouse
  if (levelCount == 6) {
    airplane.x = mouseX;
    airplane.y = mouseY;
  } 
  else if (levelCount==10) {
    bannerEnd();
  }
}

void bannerDisplay() {
  fill(0);
  rect(0, 200, width, 200);
  fill(255);
  textSize(40);
  textAlign(CENTER, CENTER);
  text("Stage complete", width/2, height/2);
  textAlign(LEFT, BASELINE);
}

void bannerEnd() {
  fill(255);
  rect(0, 0, 1200, 1200);
  fill(0);
  textSize(26);
  textAlign(CENTER, CENTER);
  text("That's not the end", width/2, height/2-50);
  textSize(18);
  text("Continue questioning your habits", width/2, height/2+50);
  textAlign(LEFT, BASELINE);
}

void bannerPlay() {
  fill(255);
  rect(0, 0, 1200, 1200);
  fill(0);
  textSize(26);
  textAlign(CENTER, CENTER);
  text("Play", width/2, height/2);
  Button buttonPlay = new Button(width/2-50, height/2-25, 100, 50, " ");
  buttonPlay.hidden = true;
  buttonPlay.display();
  if(buttonPlay.isPressed()) {
    levelCount++;
  }
  textAlign(LEFT, BASELINE);
}

// Counts the seconds, minutes and hours of the time passed
void time() {
  fill(200);
  textSize(20);
  // Calling and formatting the time
  text(nf(sw.hour(), 2)+":"+nf(sw.minute(), 2)+":"+nf(sw.second(), 2), 438, 100);
  //  text(nf(sw.hour(), 2)+":"+nf(sw.minute(), 2)+":"+nf(sw.second(), 2)+":"+nf(sw.hundrensec(), 2), 438, 100);
}

void mousePressed() {
  if (pause.isPressed())
  {
    sw.pausePressed = !sw.pausePressed;
    ;
    sw.pause();
  }
  if (restart.isPressed())
  {
    sw.start();

    //restart the game
    levelCount = 0;
    crashCount = 0;
  }
}

// Resets states of the game
void resetState() {
  time = -1;
  // Putting airplane to its initial position
  airplane.x = startPositionX;
  airplane.y = startPositionY;
  // Hiding landing strip as it is not visible at the begining of the level
  if ( levelCount == 2) {
    landingStrip.hidden = false;
  } 
  else {
    landingStrip.hidden = true;
  }
  airplane.initialYSpeed = -7.5;
  airplane.windSpeed = 0;
  airplane.antiGravity = 0;
  jumpCount = 0;
}

// Checks if the plane can occupy the loactaion at xx and yy coordinates on the screen
// such that it does not intersect any of the Cloud or Airport objects
boolean placeFree(int xx, int yy) {
  // Assuming that initially the place is free
  boolean placeFree = true;
  // Checking for intersaction with all the clouds and airports.
  // If the airplane intersecta with any of the clouds, returning false
  for (int i=0; i<clouds.length; i++) if (clouds[i].intersects(xx, yy)) return false;
  // If the airplane intersecta with any of the airports, returning false
  for (int i=0; i<airports.length; i++) if (airports[i].intersects(xx, yy)) return false;
  // Checking if the airplane intersects header or footer
  if (yy-15<height/5 || yy+15>height-height/5) placeFree = false;
  // Checking if the airplane intersects left or right edges of the canvas
  if (xx-15<0 || xx+15>width) placeFree = false;
  // Returning the result
  return placeFree;
}

void keyPressed () {
  // For the first level...
  if (levelCount == 0) {
    // ...move the airplane LEFT, RIGHT, and/or UP on keys pressed
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
  // For the second level...
  if (levelCount == 1) {
    // ...switch LEFT and RIGHT movements on keys pressed, and keep UP movement
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
}

void mouseDragged() {
  // For the third level, drag the airplane along the mouse's x and y position
  if (levelCount == 3) {
    airplane.x = mouseX;
    airplane.y = mouseY;
  }
}

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

