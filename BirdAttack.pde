/*
  * Bird Attack
  * by Erick Sauri
  * IGME 202 - Interactive Media Development
  * TuThu 11-12:15
  * Prof. Erin Cascioli
*/
Bird bird; //Ship
ArrayList<Mutant> mutant; //Asteroid
ArrayList<Fireball> fireball; //Bullet

int scene; //Aka start, game, or game over

PImage bg;
PImage radiationIcon;
PImage fireIcon;
PImage[] cloud = new PImage[3];
PFont titleFont, font;

/* Mover movement booleans */
boolean turnRight = false; //turn
boolean turnLeft = false; //turn
boolean accel = false; //accelerate
boolean shoot = false; //shooting
boolean flap = false; //flap wings
boolean damaged = false; //for red tint

int radiation; //how sick is the bird
int ammo; //How many bullets can we use
int score; //score int
boolean healthy; //if healthy bird is controllable

/* */

void setup() 
{
  size(960, 720);
  mutant = new ArrayList<Mutant>();
  fireball = new ArrayList<Fireball>();
  ammo = 3; //set ammo to 3

  /* Font */
  titleFont = loadFont("data/shadows.vlw");
  font = loadFont("data/Lato.vlw");

  /* Background */
  bg = loadImage("birds/sky.png");

  /* Death Sprites */
  cloud[0] = loadImage("birds/cloud0.png");
  cloud[1] = loadImage("birds/cloud1.png");
  cloud[2] = loadImage("birds/cloud2.png");

  /* Radiation */
  radiationIcon = loadImage("birds/radiation.png");

  /* Fireball*/
  fireIcon = loadImage("birds/fire.png");
  reset();
  scene = 0;
}

void draw() 
{
  image(bg, 0, 0);
  if (scene == 0)
  {
    startScene();
  }
  if (scene == 1)
  {
    gameScene();
  }
  if (scene == 2)
  {
    gameOverScene();
  }
  println(mouseX, mouseY);
}

/*-------Creating Instances of Objects-------------------------------------------------------------------------------------------------------------------------*/

/*-- Reset (Almost) Everything -- */
void reset()
{
  score = 0;
  radiation = 0;
  mutant.clear();
  scene = 1;
  bird = new Bird(3);
  healthy = true;
}

/* Create Mutant AKA Asteroid */
void createMutant()
{
  for (Mutant m : mutant)
  {
    m.updatePosition();
    m.display();
  }

  if (frameCount%30 == 0 && mutant.size() < 5)
  {
    mutant.add(new Mutant(
    random(-3, 3), //Random Speed
    random(width-20), //Random x position
    random(height-20), //Random y position
    random(width), //Random x direction
    random(height), //random y Direction
    50, 34, false)); //width, height, last var is for determining if it is final form (aka will it break when dead)
  }
}

/* Fire AKA Bullet */
void fire()
{
  //For every fireball update position and display them
  for (Fireball f : fireball) 
  {
    f.updatePosition();
    f.display();
  }
  //If we shoot and we there are less than 3 bullets create a new one
  if (shoot && fireball.size() < 3) 
  {
    fireball.add(new Fireball());
    ammo--; //since there is 1 bullet used decrease ammo
    shoot = false; //set back to false
  }

  //For every bullet...
  for (int i = fireball.size () -1; i >= 0; i--)
  {
    Fireball f = fireball.get(i);

    if (f.strayed()) // ...Gone off screen.. 
    {
      fireball.remove(i); //...Remove
      ammo++; //we have another bullet we can now use
    }
  }
}

/*-------Collision Detection-------------------------------------------------------------------------------------------------------------------------*/

/* Bird Collision detection*/

void birdCollision()
{
  for (int i = mutant.size ()-1; i >= 0; i--)
  {
    Mutant m = mutant.get(i);

    if (
    m.position.x < (bird.position.x + 50) &&
      (m.position.x + m.iSize.x) > bird.position.x &&
      m.position.y < (bird.position.y + 34) &&
      (m.position.y + m.iSize.y) > bird.position.y
      )
    {
      damaged = true; //this is for the red tint
      radiation++; //increase playable birds radiation
      if (radiation > 100) //Playable bird mutates
      {
        mutant.add(new Mutant(
        bird.speed, //Random Speed
        bird.position.x, //Random x position
        bird.position.y, //Random y position
        bird.direction.x, //Random x direction
        bird.direction.y, //random y Direction
        50, 34, true));
        radiation = 0; //let's not creating infinity birds
        healthy = false; //can't be controlled
        scene = 2; //game over
      }
    }
  }
}

/* Bullet collision */
void bulletCollision()
{
  for (int i = fireball.size ()-1; i >=0; i--)
  {
    Fireball f = fireball.get(i);
    for (int o = mutant.size ()-1; o >= 0; o--)
    {
      Mutant m = mutant.get(o);

      if (
      m.position.x < (f.position.x + f.iSize.x) &&
        (m.position.x + m.iSize.x) > f.position.x &&
        m.position.y < (f.position.y + f.iSize.y) &&
        (m.position.y + m.iSize.y) > f.position.y
        )
      {
        //Cloud sprites
        die(m.position.x, m.position.y, m.iSize.x, m.iSize.y); 
        
        //If it is a red not totally mutated...
        if (!m.finalForm)
        {
          //Mutate!
          mutant.add(new Mutant(
          random(-3, 3), //Random Speed
          random(m.position.x, m.position.x + m.iSize.x), //Random x position
          random(m.position.y, m.position.y + m.iSize.y), //Random y position
          random(width), //Random x direction
          random(height), //random y Direction
          m.iSize.x - 10, m.iSize.y - 7, true)); //width & height, true is saying bird is a mutant
        }
        mutant.remove(o); //remove from arraylist
        score++; //increase our score
      }
    }
  }
}

//Display cloud sprites for dead birdies
void die(float x, float y, float w, float h)
{
  float x1 = x;
  float y1 = y;
  float w1 = w;
  float h1 = h;

  int index = frameCount/12 % cloud.length;  
  image(cloud[index], x1, y1, w1, h1);
}
/*-------Game Scenes and UI-------------------------------------------------------------------------------------------------------------------------*/

void startScene()
{
  //Create some birds just for fun
  createMutant();
  for (Mutant m : mutant)
  {
    m.finalForm = true;
  }

  //Title
  fill(#231f20);
  textFont(titleFont);
  textSize(72);
  text("Bird Attack", width/2 - 110, 100);

  //Play Button
  textFont(font);
  stroke(0);
  if (mouseX > 400 && mouseX < 600 && //If hover
  mouseY > 400 && mouseY < 460)
  {
    fill(#231f20);
    if (mousePressed) //and if mouse is pressed
    {
      reset();
    }
  } else
  {
    //fill(124, 128, 129, 100);
    noFill();
  }
  rect(400, 400, 200, 60);
  textSize(32);
  fill(#ecf0f1);
  text("Start Game", width/2 - 60, height/2 + 80);
}

/* UI */
void ui()
{
  //Top Bar
  noStroke();
  fill(124, 128, 129, 100);
  rect(0, 0, width, height/10);

  //Radiation Icon
  if (healthy) //As bird is getting infected increase red opacity
  {
    float a = map(radiation, 0, 100, 0, 140);
    tint(a, 15, 38);
  } 
  image(radiationIcon, 25, 10);
  noTint();

  /* Score */
  fill(#231f20);
  textSize(36);
  text(score, width/2 - 25, 60);
  textSize(21);  
  text("Score:", width/2 - 31, 25);

  /* Fire Icons */
  //Display them side by side
  for (int i = ammo; i >= 0; i--)
  {
    image(fireIcon, width - 50 * i, 25);
  }
}

/*-- Game Scene --*/
void gameScene()
{
  birdCollision(); //check bird collision
  bulletCollision(); //check bullet collision
  createMutant(); //make some bad birds
  if (healthy) //If controllable
  {
    bird.updatePosition(); 
    bird.display();
  }
  fire(); //bullet
  ui(); //top bar with radiation, score, bullet icons
}

/*-- Game Over Scene --*/
void gameOverScene()
{
  createMutant();
  for (Mutant m : mutant)
  {
    m.finalForm = true;
  }

  noStroke();
  fill(124, 128, 129, 81);
  rectMode(CENTER);
  rect(width/2, height/2, 400, 200);
  rectMode(CORNER);

  //You lose
  textFont(titleFont);
  textSize(60);
  fill(#231f20);
  text("You Lose!", width/2 - 110, height/2 - 40);

  //Score
  textFont(font);
  textSize(32);
  text("Score : " + score, 380, 370);

  // Play Again Button
  stroke(#231f20);
  if (mouseX > 380 && mouseX < 560 && //If hover
  mouseY > 390 && mouseY < 450)
  {
    fill(#231f20);
    if (mousePressed) //and if mouse is pressed
    {
      reset();
    }
  } else
  {
    noFill();
  }
  rect(380, 390, 180, 60);

  fill(#ecf0f1);
  noStroke();
  text("Play Again", width/2 - 90, height/2 + 70);
}

/*-------Key Press and Release-------------------------------------------------------------------------------------------------------------------------*/
/*--Key Presses--*/

void keyPressed() {
  if (healthy)
  {
    switch(keyCode) { //If a key is pressed...
    case RIGHT:  //right arrow key
      turnRight = true; //turn right
      flap = true;
      break;
    case LEFT: //left arrow key
      turnLeft = true; //turn right
      flap = true;
      break;
    case UP: // up arrow key
      accel = true; //turn right
      flap = true;
      break;
    }

    switch(key) {
    case 'd':
      turnRight = true; //turn right
      flap = true;
      break;
    case 'D':
      turnRight = true; //turn right
      flap = true;
      break;
    case'a':
      turnLeft = true; //turn right
      flap = true;
      break;
    case'A':
      turnLeft = true; //turn right
      flap = true;
      break;    
    case 'w':
      accel = true; //turn right
      flap = true;
      break;
    case 'W':
      accel = true; //turn right
      flap = true;
      break;
    case ' ':
      shoot = true;
      flap = true;
      break;
    }
  }
}


/*--Key Releases--*/
void keyReleased() {
  if (healthy)
  {
    switch(keyCode) {
    case RIGHT: //right arrow key
      turnRight = false; //stop turning
      break; 
    case LEFT: //left arrow key
      turnLeft = false; //stop turning
      break;
    case UP: //up arrow key
      accel = false; //stop moving
      break;
    }  
    switch(key) {
    case 'd':
      turnRight = false; //turn right
      break;
    case 'D':
      turnRight = false; //turn right
      break;
    case'a':
      turnLeft = false; //turn right
      break;
    case'A':
      turnLeft = false; //turn right
      break;
    case 'w':
      accel = false; //turn right
      break;
    case 'W':
      accel = false; //turn right
      break;
    case ' ':
      shoot = false;
      flap = false;
      break;
    }
    flap = false;
  }
}

