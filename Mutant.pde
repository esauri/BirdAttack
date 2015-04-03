class Mutant
{
  /* Add Direction */
  PVector position, direction, velocity, box, iSize;
  float speed, maxSpeed;
  /* Images for our birds. 's' stands for "Special" or "Simple" */
  PImage[] redBird = new PImage[4];
  PImage[] sredBird = new PImage[4]; 
  PImage[] smutantBird = new PImage[4];
  PImage[] mutantBird = new PImage[4]; 
  boolean finalForm; //is it done with mutation?

  Mutant(float s, float x, float y, float d1, float d2, float w, float h, boolean f)
  {
    speed = s;
    maxSpeed = speed + 3;

    direction = new PVector(d1, d2);
    position = new PVector(x, y);
    iSize = new PVector(w, h);
    velocity = new PVector(0, 0);
    box = new PVector(0, 0);
    finalForm = f;

    /* Normal Red Bird Sprites */
    redBird[0] = loadImage("birds/redbird0.png");
    redBird[1] = loadImage("birds/redbird1.png");
    redBird[2] = loadImage("birds/redbird2.png");
    redBird[3] = loadImage("birds/redbird3.png");

    /* Special Red Bird Sprites */
    sredBird[0] = loadImage("birds/redbird0s.png");
    sredBird[1] = loadImage("birds/redbird1s.png");
    sredBird[2] = loadImage("birds/redbird2s.png");
    sredBird[3] = loadImage("birds/redbird3s.png");

    /* Special Mutant Sprites */
    smutantBird[0] = loadImage("birds/mutant0s.png");
    smutantBird[1] = loadImage("birds/mutant1s.png");
    smutantBird[2] = loadImage("birds/mutant2s.png");
    smutantBird[3] = loadImage("birds/mutant3s.png");

    /* Normal Mutant Sprites */
    mutantBird[0] = loadImage("birds/mutant0.png");
    mutantBird[1] = loadImage("birds/mutant1.png");
    mutantBird[2] = loadImage("birds/mutant2.png");
    mutantBird[3] = loadImage("birds/mutant3.png");
  }

  void fly()
  {     
    int index = frameCount/10 % redBird.length;
    /* If moviing left use special sprites else use normal sprites*/
    if (speed < 0) 
    {
      image(sredBird[index], box.x, box.y, iSize.x, iSize.y);
    } else
    {
      image(redBird[index], box.x, box.y, iSize.x, iSize.y);
    }
  }

  void mutantFly()
  {    
    int index = frameCount/6 % mutantBird.length;
    /* If moving left use special sprites else use normal sprites*/

    if (speed < 0)
    {
      image(smutantBird[index], box.x, box.y, iSize.x, iSize.y);
    } else
    {
      image(mutantBird[index], box.x, box.y, iSize.x, iSize.y);
    }
  }

  void updatePosition()
  {
    if (speed >= 0)
    {
      speed += 0.1;
    } else
    {
      speed -= 0.5;
    }

    velocity = PVector.mult(direction, speed);
    velocity.limit(maxSpeed);
    position.add(velocity);
    /* Wrap */
    if (position.x > width)
    {
      position.x = 0;
    }
    if (position.x < 0)
    { 
      position.x = width;
    }

    if (position.y > height)
    {
      position.y = 0;
    }
    if (position.y < 0)
    {
      position.y = height;
    }
  }

  void display()
  {    
    pushMatrix();
    translate(position.x, position.y);
    rotate(direction.heading());

    if (finalForm) //if this is final form
    {
      mutantFly(); //he is 100% mutant
    } else
    {
      fly(); //This isn't even my final form
    }
    popMatrix();
  }
}

