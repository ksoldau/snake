int gridSize; //20 squares
int numSquares;
int left_wall;
int right_wall;
int top_wall;
int bottom_wall;
int food_x;
int food_y;
int score;
int restartx;
int restarty;
int restart_width;
int restart_height;
int frame_rate;

PImage katey;
PImage haley;
PImage nikki;
PImage ryan;
PImage katie;

PImage sloris;

//did the game end?
boolean END;

//is it on the start screen?
boolean START_SCREEN;

PFont font;

//snake moving
String direction;

//snake pieces
ArrayList snakex;
ArrayList snakey;

void setup() {
  //initializing variablesint gridSize = 20; //20 squares
  numSquares = 20;
  gridSize = 30;
  left_wall = 0;
  right_wall = numSquares * gridSize;
  top_wall = 0;
  bottom_wall = numSquares * gridSize;
  score = 0;
  restart_width = right_wall/2;
  restart_height = bottom_wall/8;
  restartx = (right_wall/2) - (restart_width/2);
  restarty = bottom_wall/2 + 70;
  frame_rate = 5;
  direction = "right";
  font = loadFont("SansSerif-70.vlw");
  END = false;
  textFont(font);
  randomFoodCoordinates();
  START_SCREEN = true;

  //set up the pictures
  katey = loadImage("data/katey.png");
  haley = loadImage("data/haley.png");
  nikki = loadImage("data/nikki.png");
  ryan = loadImage("data/ryan.png");
  katie = loadImage("data/katie.png");

  sloris = loadImage("data/sloris.png");

  //resize the images
  /*katey.resize(gridSize, gridSize);
   haley.resize(gridSize, gridSize);
   nikki.resize(gridSize, gridSize);
   ryan.resize(gridSize, gridSize);
   katie.resize(gridSize, gridSize);
   
   sloris.resize(gridSize, gridSize);*/



  snakex = new ArrayList();
  snakey = new ArrayList();

  size(gridSize * numSquares, gridSize * numSquares);
  background(184, 225, 232);

  //create the first x positions for snake
  snakex.add(5);
  snakex.add(4);
  snakex.add(3);
  snakey.add(15);
  snakey.add(15);
  snakey.add(15);
}

//draw method that creates the images each tick
void draw() {
  drawCursor();
  background(112, 199, 212);
  if (START_SCREEN) {
    drawSnake();
    drawWelcome();
    drawStartButton();
  }
  else if (END) {
    drawSnake();
    placeFood();
    fill(255);
    textSize(70);
    textAlign(CENTER);
    text("GAME OVER", right_wall/2, 200);
    text("score: " + score, right_wall/2, 300);
    drawRestartButton();
  }
  else {
    frameRate(10);
    updateSnake();
    collide();
    drawSnake();
    placeFood();
    updateFood();
    drawScore();
  }
}


void drawCursor() {
  if (END && cursorOverRestartButton()) {
    cursor(HAND);
  }
  else if (START_SCREEN && cursorOverStartButton()) {
    cursor(HAND);
  }
  else {
    cursor(ARROW);
  }
}

void drawWelcome() {
    fill(255);
    textSize(70);
    textAlign(CENTER);
    text("SLORIS SNAKE", right_wall/2, 200);
}

void drawRestartButton() {
  fill(255);    // Setting the background to white
  rect(restartx, restarty, restart_width, restart_height);
  fill(102);
  textSize(60);
  textAlign(CENTER, CENTER);
  text("RESTART", right_wall/2, restart_height/2 + restarty);
}
void drawStartButton() {
  fill(255);    // Setting the background to white
  rect(restartx, restarty, restart_width, restart_height);
  fill(102);
  textSize(60);
  textAlign(CENTER, CENTER);
  text("START", right_wall/2, restart_height/2 + restarty);
}

void mousePressed() {
  if (cursorOverRestartButton()) {
    setup();
  }
  if (cursorOverStartButton()) {
    START_SCREEN = false;
  }
}

boolean cursorOverRestartButton() {
  return restartx <= mouseX && mouseX <= restartx + restart_width
    && restarty <= mouseY && mouseY <= restarty + restart_height;
}

boolean cursorOverStartButton() {
  return cursorOverRestartButton();
}

void drawScore() {
  textSize(30);
  text(score, 40, 40);
  fill(255);
}

// register key presses
void keyPressed() {
  if (keyCode == UP) {
    direction = "up";
  } 
  else if (keyCode == RIGHT) {
    direction = "right";
  } 
  else if (keyCode == DOWN) {
    direction = "down";
  } 
  else if (keyCode == LEFT) {
    direction = "left";
  }
}

//place a new food
void placeFood() {
  int new_x = food_x * gridSize;
  int new_y = food_y * gridSize;
  image(sloris, new_x, new_y);
  if (ateFood()) {
    score = score + 10;
    //create a new random position for the food
    randomFoodCoordinates();

    if (collideWithSnake(food_x, food_y)) {
      placeFood();
    }
  }
}

void randomFoodCoordinates() {
  food_x = (floor(random((right_wall/gridSize))));
  food_y = (floor(random((bottom_wall/gridSize))));
}

void updateFood() {
  if (ateFood()) {
    placeFood();
  }
}

boolean ateFood() {
  return ((Integer) snakex.get(0) == food_x) && ((Integer) snakey.get(0) == food_y);
}


//draw the snake
void drawSnake() {
  for (int i=0; i < snakex.size(); i++) {
    int xcord = (Integer) snakex.get(i);
    int ycord = (Integer) snakey.get(i);

    int new_x = xcord * gridSize;
    int new_y = ycord * gridSize;

    if (i % 5 == 0) {
      image(katey, new_x, new_y);
    }
    else if (i % 5 == 1) {
      image (haley, new_x, new_y);
    }
    else if (i % 5 == 2) {
      image (nikki, new_x, new_y);
    }
    else if (i % 5 == 3) {
      image (ryan, new_x, new_y);
    }
    else if (i % 5 == 4) {
      image (katie, new_x, new_y);
    }
  }
}

//update the snake based on direction 
void updateSnake() {
  updateHead();
  if (ateFood()) {
  }
  else {
    snakex.remove(snakex.size()-1);
    snakey.remove(snakey.size()-1);
  }
}

void updateHead() {
  if (direction == "up") {
    snakex.add(0, snakex.get(0));
    snakey.add(0, (Integer) snakey.get(0) - 1);
  }
  if (direction == "down") {
    snakex.add(0, snakex.get(0));
    snakey.add(0, (Integer) snakey.get(0) + 1);
  }
  if (direction == "right") {
    snakex.add(0, (Integer) snakex.get(0) + 1);
    snakey.add(0, (Integer) snakey.get(0));
  }
  if (direction == "left") {
    snakex.add(0, (Integer) snakex.get(0) - 1);
    snakey.add(0, (Integer) snakey.get(0));
  }
}

//sees if there's a collision and decides what to do with it
void collide() {
  int x = (Integer) snakex.get(0);
  int y =  (Integer) snakey.get(0);

  if (snakeCollide()) {
    END = true;
  }
  else if (0 > x || x >= numSquares) {
    END = true;
  }
  else if (0 > y || y >= numSquares) {
    END = true;
  }
}

//does the given x and y collide with the snake?
boolean snakeCollide() {
  int x = (Integer) snakex.get(0);
  int y =  (Integer) snakey.get(0);

  for (int i=1; i < snakex.size(); i++) {
    //int i 1 so it skips over the head
    int xval = (Integer) snakex.get(i);
    int yval = (Integer) snakey.get(i);
    if (x == xval && y == yval) {
      return true;
    }
  }
  return false;
}

boolean collideWithSnake(int x, int y) {
  for (int i=0; i < snakex.size(); i++) {
    //int i 1 so it skips over the head
    int xval = (Integer) snakex.get(i);
    int yval = (Integer) snakey.get(i);
    if (x == xval && y == yval) {
      println("collision is true");
      return true;
    }
  }
  return false;
}

