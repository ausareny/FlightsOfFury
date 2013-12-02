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

Button pause; // Pause button
Button restart; // Restart button

StopWatchTimer sw; // Stop watch for counting time

void setup() {
  size (600, 600);
  background (255);
  smooth();

  println (millis());
  sw = new StopWatchTimer();
  sw.start();

  // load a font into that variable
  f = loadFont("KnarfArtFont-Bold-48.vlw");
  // tell processing to use the font you want and the size
  textFont(f, 48);

  pause = new Button(0, 570, width/2, 30, "Pause");
  restart = new Button(width/2, 570, width/2, 30, "Restart");

  airplane = new Plane (startPositionX, startPositionY, 30, 30);
  button = new Environment (width/2, 255, 50, 15, BUTTON, 0);
  landingStrip = new Environment (460, 440, 50, 10, LANDINGSTRIP, 0);
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

  // Reseting the image by applying white background
  background(255);

  // Drawing header
  rectMode(CORNER);
  fill(120);
  noStroke();
  rect(0, 0, width, height/5);

  // write some text to te screen using text(data, xPosition, yPosition), where data is  string
  fill(255);
  textSize(48);
  text(title, 20, 60);

  // Drawing footer
  fill(120);
  rect(0, height-height/5, width, height/5);
  pause.display();
  restart.display();

  time();

  // Drawing environment objects: clouds, mountains, water, and airports
  for (int i=0; i<clouds.length; i++) clouds[i].display();
  for (int i=0; i<mountains.length; i++) mountains[i].display();
  for (int i=0; i<waters.length; i++) waters[i].display();
  for (int i=0; i<airports.length; i++) airports[i].display();

  // Checking if the airpalne touched any of mountains or water and resetting the game if it did
  for (int i=0; i<mountains.length; i++) if (mountains[i].intersects(airplane)) resetState();
  for (int i=0; i<waters.length; i++) if (waters[i].intersects(airplane)) resetState();

  // Drawing button
  button.display();

  // Checking if the airpalne pressed the button and showing landing strip if it did
  if (button.intersects(airplane)) {
    button.buttonFill = button.buttonFillPressed;
    landingStrip.hidden = false;
  }

  // Drawing landing strip
  landingStrip.display();

  // Checking if the airplain touched a visible landing strip and resetting the game if it did
  // indicating that the lavvel has been successfully passed
  if (!landingStrip.hidden && landingStrip.intersects(airplane)) resetState();

  // Drawing thr airplane
  airplane.updatePosition();
  airplane.display();
}

void time() {
  fill(200);
  // textFont(words, 100);
  //
  //  text(second()+ , 350, 175);
  //
  //  text(":", 300, 175);
  //
  //  text(minute(), 250, 175);
  //
  //  text(":", 200, 175);
  //  text(hour(), 150, 175);
  textSize(20);
  text(nf(sw.hour(), 2)+":"+nf(sw.minute(), 2)+":"+nf(sw.second(), 2), 438, 100);
}

// Resets states of the game
void resetState() {
  // Putting airplane to its initial position
  airplane.x = startPositionX;
  airplane.y = startPositionY;
  // Hiding landing strip as it is not visible at the begining of the level
  landingStrip.hidden = true;
  // Resetting the button by applying its default color
  button.buttonFill = button.buttonFillDefault;
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
  // Start moving the airplane on LEFT, RIGHT, and/or UP keys pressed
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

void keyReleased() {
  // Stop moving the airplane on LEFT, RIGHT, and UP keys released
  switch(keyCode) {
  case RIGHT: 
    airplane.moveRight = false; 
    break;
  case LEFT: 
    airplane.moveLeft = false; 
    break;
  case UP: 
    airplane.moveUp = false; 
    break;
  }
}

