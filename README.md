# BirdAttack
## Processing
### Spring 2015
![Bird Attack Screenshot](https://people.rit.edu/ejs3863/oldportfolio2/birdattack/media/birdattack.png "Bird Attack")

#### Asteroids with an avian flu

##### List of user functionality:
* Click certain buttons which takes him to a different scene
* Accelerate using the UP arrow key, ‘w’, or ‘W’
* Rotate left using the LEFT arrow key, ‘a’, or ‘A’
* Rotate right using the RIGHT arrow key, ‘d’, or ‘D’
* Shoot fireballs using the SPACEBAR

##### Reasoning behind design choices:

I decided to make this Asteroids remake a little different from usual, though keeping the same basic functionality. For the Start scene I simply added the title and a button which changes its fill when hovered over to give some response to the user. In the Game Over scene I added a “You Lose!”, the user’s score during that time and a button to play again. Same as with the previous one this one also has a hover effect. In both these scenes I added random mutant birds to fly around. 

In the main game I added a bar at the top and it includes a radiation meter on the left side. If this meter turns red then are mutating. In the center is a scoreboard that increases when you kill a bird. In the right side is the ammo indicator that tells you how many fireballs you can shoot. To make it easier I used an int that tracked the number of bullets not there and made a loop to create the three fireball icons. 

The rest of the game was a playable bird character which is blue in color. He flaps his wings when flying and shooting to simulate flying in the sky. When it shoots it also opens its mouth simulating spitting a fireball. There are two types of enemies. Red birds that look exactly like the playable bird, except red, and mutant purple color birds with multiple eyes. Red birds are the standard, their location, direction and speed are randomly chosen.  When they are killed they explode into a cloud(which happens way too fast) and a smaller mutant bird arises, the starting position of this new mutant bird is supposed to be between the parent bird’s position and size, everything else is randomly chosen. When these mutant birds die they do not produce more birds.

For collision I used the box model. Each bird is within it’s own “box” and if the player bird’s “box” comes into contact with the enemy he is stricken with radiation, his radiation int increases and he turns red for the collision duration. If the radiation reaches a certain point then the playable bird will mutate and become uncontrollable. For fireball (bullet) collision it is the same. If the bullet’s “box” touches the enemy bird “box” then the bird dissipates into a cloud, a new mutant bird is formed (if the bird stricken was a red bird) and the bird is then removed from its ArrayList.
