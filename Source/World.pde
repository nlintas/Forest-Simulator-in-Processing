public class World
{
  // Attributes
  Block grid[][];
  int size, currentTime, timeIncrement, resolution;
  float xoff, yoff;

  // Constructors
  // Default
  World()
  {
    //Default grid is a comfortable 20 x 20
    size = 15;
    resolution = width / size;
    currentTime = 0;
    timeIncrement = 1;
    grid = new Block[size][size];
    //Initialises the grid
    for (int y = 0; y < size; y++)
    {
      for (int x = 0; x < size; x++)
      {
        grid[x][y] = new Block(x, y);
      }
    }
  }

  // For resizable grid
  World(int size)
  {
    this.size = size;
    currentTime = 0;
    resolution = height / size;
    grid = new Block[size][size];
    //Traverse and add the blocks
    for (int y = 0; y < size; y++)
    {

      for (int x = 0; x < size; x++)
      {
        grid[x][y] = new Block(x, y);
      }
    }
  }

  // Methods
  // Recalculate and draw the grid
  void iterateWorld()
  {
    iterateTime();
    //iterates block
    yoff = 0;
    for (int y = 0; y < size; y++)
    {
      xoff = 0;
      for (int x = 0; x < size; x++)
      {
        grid[x][y].iterateBlock(this);
        xoff += 0.03;
      }
      yoff += 0.03;
    }
  }

  // Increases the in-game timer
  void iterateTime()
  {
    currentTime += timeIncrement;
  }

  // Draw the world
  void drawWorld()
  {
    //At every position
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        //Colors the clouds
        if (grid[x][y].weather.cloudAmount > 20) {
          stroke(#AFF2F5);
        }
        //Colors the squares of the grid
        else {
          stroke(#020303);
        }
        //Prints the direction of the wind
        pushMatrix();
        translate(x * resolution, y * resolution);
        rotate(grid[x][y].weather.rotation);
        line(0, 0, resolution, 0);
        popMatrix();
        stroke(0);
        fill(world.grid[x][y].colour);
        rect( x * resolution, y * resolution, (x+1) * resolution, (y+1) * resolution);
      }
    }
  }

  // Changes the speed of time in the game
  boolean changeSpeed(int speed)
  {
    switch (speed)
    {
    //Slowdown time
    case 1:
      timeIncrement = 1;
      frameRate(30);
      break;
    //Normal time
    case 2:
      timeIncrement = 2;
      break;
    //Fast forward time
    case 3:
      timeIncrement = 1;
      frameRate(120);
      break;

    default :
      return false;
    }
    return true;
  }


  // Start a fire on the selected block
  boolean startFire(int x, int y)
  {
    if (( y >= 0 && x >= 0 && x < size && y < size ) && grid[x][y].flora != null)
    {
      grid[x][y].flora.onFire = true;
      return true;
    } else {
      return false;
    }
  }

  // Start a parasite colony on the selected block or increases the amount of parasites on a plant
  boolean startParasite(int x, int y, int amount)
  {
    if (( y >= 0 && x >= 0 && x < size && y < size ) && amount > 0)
    {
      // get how many parasites were already there and increase it by how much the
      // user enters
      if (grid[x][y].flora != null) {
        grid[x][y].flora.parasiteAmount += amount;
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  // Add radiation to the ground
  boolean addRadiation(int x, int y, float amount)
  {
    if (( y >= 0 && x >= 0 && x < size && y < size ) && amount > 0)
    {
      // get how much radiation was already there and increase it by how much the user enters
      grid[x][y].ground.radiation += amount;
      return true;
    } else {
      return false;
    }
  }

  // Plant a seed at a specific spot
  boolean plantSeed(int x, int y)
  {
    if (( y >= 0 && x >= 0 && x < size && y < size ) && grid[x][y].ground instanceof Soil) {
      Seed seeds[] = ((Soil )grid[x][y].ground).seeds;

      // Check for free spots for the seed to grow
      for (int j = 0; j < seeds.length; j++)
      {
        if (seeds[j] == null)
        {
          // When a free spot is found place the new seed
          seeds[j] = new Seed();
          return true;
        }
      }
    }
    return false;
  }

  // Swap the positions of 2 grounds around.
  boolean moveGround(int x, int y, int newX, int newY)
  {
    if (( y >= 0 && x >= 0 && x < size && y < size )) {
      Ground swapTemp = grid[x][y].ground;
      grid[x][y].ground = grid[newX][newY].ground;
      grid[newX][newY].ground = swapTemp;
      return true;
    }
    return false;
  }

  // Swap the positions of 2 plants around.
  boolean movePlant(int x, int y, int newX, int newY)
  {

    if ((x < size && y < size ) && !(grid[x][y].ground instanceof Soil) || !(grid[newX][newY].ground instanceof Soil)) {
      return false;
    }

    Flora swapTemp = grid[x][y].flora;
    grid[x][y].flora = grid[newX][newY].flora;
    grid[newX][newY].flora= swapTemp;
    return true;
  }

  // removes a piece of ground and replaces it with a default
  boolean removeSoil(int x, int y)
  {
    if (( y >= 0 && x >= 0 && x < size && y < size )) {
      grid[x][y].ground = new Ground();
      return true;
    }
    return false;
  }

  // removes a plant from a piece of ground
  boolean removePlant(int x, int y)
  {
    if (( y >= 0 && x >= 0 && x < size && y < size )) {
      grid[x][y].flora = null;
      return true;
    }
    return false;
  }

  // Add a ground or soil on a block
  boolean addSoil(int x, int y)
  {
    if (( y >= 0 && x >= 0 && x < size && y < size )) {
      grid[x][y].ground = new Soil();
      return true;
    }
    return false;
  }

  // Add a plant to a block on the grid
  boolean addPlant(int x, int y)
  {
    if ( ( y >= 0 && x >= 0 && x < size && y < size ) && grid[x][y].ground instanceof Soil) {
      grid[x][y].flora = new Flora();
      return true;
    }
    return false;
  }
}
