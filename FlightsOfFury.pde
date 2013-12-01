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

void setup() {
  size (600, 600);
  background (255);
  smooth();

  airplane = new Plane (75,215,30,30);
  button = new Environment (width/2, 255, 50, 15, BUTTON, 0);
  landingStrip = new Environment (460,440,50,10,LANDINGSTRIP,0);

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

  addWater(100, 450, 100, 30);
  addWater(340, 450, 65, 30);

  addAirport(0, 120, 90, 80);
  addAirport(510, 370, 90, 80);
  
  addMountain(15,215,30,30,90);
  addMountain(15,250,30,30,90);
  addMountain(15,285,30,30,90);
  addMountain(208,140,34,40,180);
  addMountain(245,140,34,40,180);
  addMountain(283,140,34,40,180);
  addMountain(473,147,25,25,180);
  addMountain(498,147,25,25,180);
  addMountain(523,147,25,25,180);
  addMountain(548,147,25,25,180);
  addMountain(588,232,25,25,270);
  addMountain(588,258,25,25,270);
  addMountain(588,285,25,25,270);
  addMountain(588,311,25,25,270);
  addMountain(588,337,25,25,270);
  addMountain(447,438,25,25,0);
}

int currentCloudIndex = 0;
void addCloud(int x, int y, int objectWidth, int objectHeight) {
  if (currentCloudIndex < clouds.length) {
    clouds[currentCloudIndex] = new Environment(x, y, objectWidth, objectHeight, CLOUD, 0);
    currentCloudIndex++;
  }
  else {
    println("Too many clouds!");
  }
}

int currentMountainIndex = 0;
void addMountain(int x, int y, int objectWidth, int objectHeight, int objectRotate) {
  if (currentMountainIndex < mountains.length) {
    mountains[currentMountainIndex] = new Environment(x, y, objectWidth, objectHeight, MOUNTAIN, objectRotate);
    currentMountainIndex++;
  }
  else {
    println("Too many mountains!");
  }
}

int currentWaterIndex = 0;
void addWater(int x, int y, int objectWidth, int objectHeight) {
  if (currentWaterIndex < waters.length) {
    waters[currentWaterIndex] = new Environment(x, y, objectWidth, objectHeight, WATER, 0);
    currentWaterIndex++;
  }
  else {
    println("Too many water objects!");
  }
}

int currentAirportIndex = 0;
void addAirport(int x, int y, int objectWidth, int objectHeight) {
  if (currentAirportIndex < airports.length) {
    airports[currentAirportIndex] = new Environment(x, y, objectWidth, objectHeight, AIRPORT, 0);
    currentAirportIndex++;
  }
  else {
    println("Too many airports!");
  }
}


void draw() {
  background(255);
  
  //header
  rectMode(CORNER);
  fill(150);
  noStroke();
  rect (0, 0, width, height/5);

  //footer
  fill(150);
  rect (0, height-height/5, width, height/5);

  //environment
  for(int i=0; i<clouds.length; i++) {clouds[i].display();}
  for(int i=0; i<mountains.length; i++) mountains[i].display();
  for(int i=0; i<waters.length; i++) waters[i].display();
  for (int i=0; i<airports.length; i++) airports[i].display();
  
  //button
  button.display();
  
  //nalding strip
  landingStrip.display();
  
  //airplane
  airplane.updatePosition();
  airplane.display();
}

boolean placeFree() {
  boolean intersects = false; 
  for(int i=0; i<clouds.length; i++) {
    if(clouds[i].intersects(airplane)) return false;
  }
  if(airplane.top()<height/5 || airplane.bottom()>height-height/5) intersects = true;
  return !intersects;
}

void keyPressed () {
  switch(keyCode) {
    case RIGHT: airplane.moveRight = true; break;
    case LEFT: airplane.moveLeft = true; break;
    case UP: airplane.moveUp = true; break;
  }
}

void keyReleased() {
  switch(keyCode) {
    case RIGHT: airplane.moveRight = false; break;
    case LEFT: airplane.moveLeft = false; break;
    case UP: airplane.moveUp = false; break;
  }
}
