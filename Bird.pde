class Bird
{
  PImage[] bluebird = new PImage[4]; //Normal flying bird
  PImage[] birdAttack = new PImage[4]; //Attacking bird
  PVector position, velocity, direction, box;
  float speed;
  float maxSpeed;
  float friction;   
  color d;
  Bird(float s) {
    position = new PVector(width/2, height/2);
    velocity = new PVector(0, 0);
    direction = new PVector(0, 0);
    box = new PVector(0, 0);

    //fromAngle sets a vector to a specific angle (in radians)
    PVector.fromAngle(0, direction);
    speed = s;
    d = color(231, 76, 60);
    maxSpeed = speed + 3;
    friction = 0.9;

    bluebird[0] = loadImage("birds/bluebird0.png");
    bluebird[1] = loadImage("birds/bluebird1.png");
    bluebird[2] = loadImage("birds/bluebird2.png");
    bluebird[3] = loadImage("birds/bluebird3.png");

    birdAttack[0] = loadImage("birds/birdOpen0.png");
    birdAttack[1] = loadImage("birds/birdOpen1.png");
    birdAttack[2] = loadImage("birds/birdOpen2.png");
    birdAttack[3] = loadImage("birds/birdOpen3.png");
  }

  /*--Position Method--*/
  void updatePosition() {

    //rotate the direction vector when arrow keys are pressed
    if (turnRight) {
      direction.rotate(radians(2));
    }
    if (turnLeft) {
      direction.rotate(radians(-2));
    }
    //slow down the Mover with "friction"
    if (!accel) {
      speed *= friction;
    }
    //"speed up" the Mover by using a constant acceleration value
    if (accel) {
      speed += 0.1;
    }

    //calculate velocity, limit the velocity's magnitude, and change position
    velocity = PVector.mult(direction, speed);
    velocity.limit(maxSpeed);
    position.add(velocity);


    //wrap Mover around window
    if (position.x > width) {
      position.x = 0;
    }
    if (position.x < 0) {
      position.x = width;
    }
    if (position.y > height) {
      position.y = 0;
    }
    if (position.y < 0) {
      position.y = height;
    }
  }

  /*--Display method--*/
  void display() {    

    pushMatrix();
    //set grid to correct spot then rotate
    translate(position.x, position.y);
    rotate(direction.heading());

    if (damaged)
    {
      tint(d);
    }

    if (flap && shoot) //show bird attacking and flying
    {
      attack();
    } else if (flap) //Show bird flyinh
    {
      fly();
    } else //Show Bird Stationary
    {
      image(bluebird[2], box.x, box.y);
    }
    noTint();

    popMatrix();
    damaged = false;
  }
  /*--Fly Method show bluebird depending on remainder of frameCount and array length--*/
  void fly()
  { 

    int index = frameCount/6 % (bluebird.length);
    image(bluebird[index], box.x, box.y);
  }

  void attack()
  {
    int index = frameCount/6 % (birdAttack.length);
    image(birdAttack[index], box.x, box.y);
  }
}

