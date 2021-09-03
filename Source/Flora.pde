/*
    Theory/Calculation Facts:
    sulfur lost = 0.2 per hour to live for a month
    phosphorus = 0.02 per hour to live for a month
    cec lost = 200 per hour to live
    Temperature makes water evaporate even at temperatures as low as above 0, also higher temperatures have significantly higher impact.
*/

//Cloneable Plants are used in order for seeds to grow into them
class Flora implements Cloneable {

  //Attributes
  boolean onFire;
  String attitude;
  float floraHeight, floraWidth, energy, highTemp, lowTemp, water;
  int spreadLength, timeUntilDeath, amountOfSeeds, parasiteAmount;

  //Constructors
  //Full
  public Flora(boolean onFire, String attitude, float floraHeight, float floraWidth, int parasiteAmount,
    float energy, float highTemp, float lowTemp, float water, int spreadLength, int timeUntilDeath,
    int amountOfSeeds)
  {
    this.onFire = onFire;
    this.attitude = attitude;
    this.floraHeight = floraHeight;
    this.floraWidth = floraWidth;
    this.parasiteAmount = parasiteAmount;
    this.energy = energy;
    this.highTemp = highTemp;
    this.lowTemp = lowTemp;
    this.water = water;
    this.spreadLength = spreadLength;
    this.timeUntilDeath = timeUntilDeath;
    this.amountOfSeeds = amountOfSeeds;
  }
  //Default
  public Flora()
  {
    this.onFire = false;
    //Starts like this so that plants can spread
    this.attitude = "Expansionist";
    this.floraHeight = 1.2;
    this.floraWidth = 0.3;
    this.parasiteAmount = 0;
    //Energy pool for plant to survive until it can make its own
    this.energy = 5000;
    //Temperature resistances
    this.highTemp = 30;
    this.lowTemp = -40;
    //Water pool for plant to survive until it can make its own
    this.water = 20;
    //Random spread length for non-predictable behaviour
    this.spreadLength = 3;
    //Standard death of a plant of "old age"
    this.timeUntilDeath = 1728000;
    //Amount of seeds thrown at each spread
    this.amountOfSeeds = 5;
  }

  //Clone trick for seed growth to a plant
  public Object clone()throws CloneNotSupportedException {
    return (Flora)super.clone();
  }

  //Methods
  //Iterates all flora methods to be executed at each step.
  void iterateFlora(Block block, World world)
  {
    if (onFire)
    {
      attitude = "Conservative";
      //traverse around the block and set fire to a neighbour
      for (int newY = (block.y - 1 + world.size) % world.size; newY <= (block.y + 1 + world.size) % world.size; newY++)
      {
        for (int newX = (block.x - 1 + world.size) % world.size; newX <= (block.x + 1 + world.size) % world.size; newX++)
        {
          if(world.grid[newX][newY].flora != null){
            world.grid[newX][newY].flora.onFire = true;
          }
        }
      }
      
      energy -= 50;
    }
    
    //Radiation Damage
    if(block.ground.radiation > 0){
      energy -= block.ground.radiation * 0.25;
    }

    //Any amount of rain stops fires
    if (block.weather.rainAmount > 0)
    {
      onFire = false;
    }

    //Kills parasites if the season is innapropriate
    if (block.weather.currentSeason.equals("Winter") || block.weather.currentSeason.equals("Autumn")) {
      parasiteAmount = 0;
    }

    //Parasite reproduction and production of bio-material
    else
    {
      parasiteAmount += (int) parasiteAmount/10;
      ((Soil) block.ground).cec -= parasiteAmount * 0.000001;
      ((Soil) world.grid[block.x][block.y].ground).sulfur += parasiteAmount * 0.01;
    }

    //Changes the attitude of plants
    changeAttitude(block.weather);

    //absorb nutrients useful from Soil
    absorbNutrients((Soil) block.ground);

    //Evaporate water
    waterEvaporation(block.ground);

    //grows the plant with a trade of energy and if the attitude is correct
    if (attitude.equals("Expansionist")) {
      //Produces energy
      photosynthesis(block.weather);
      //Plant grows
      grow();
      //Plant spreads
      if (world.currentTime % 72 == 0) {
        spread(block, world);
      }
    }
    //Plants gains extra nutrients during this time, because of the bio-material in the forest (Example: leaves)
    else if (attitude.equals("Shedding"))
    {
      for (int newY = (block.y - 1 + world.size) % world.size; newY < (block.y + 2 + world.size) % world.size; newY++)
      {
        for (int newX = (block.x - 1 + world.size) % world.size; newX < (block.x + 2 + world.size) % world.size; newX++)
        {
          if (world.grid[newX][newY].ground instanceof Soil)
          {
            ((Soil) world.grid[newX][newY].ground).sulfur += 1.5;
            ((Soil) world.grid[newX][newY].ground).phosphorus += 0.5;
          }
        }
      }
    }
    //Winter survival
    else if (attitude.equals("Conservative")&& !block.weather.currentSeason.equals("Winter")) {
      //Produces energy after using water
      photosynthesis(block.weather);
    }

    //Spreads parasites around
    spreadParasite(block, world);

    //Passive use of energy
    consumeEnergy(block);
  }

  //Spreads plants around
  void spread(Block block, World world)
  {
    int posX, posY, loopAroundX, loopAroundY;
    Seed seeds[];

    // For each seed to spread
    for (int i = 0; i < amountOfSeeds; i++)
    {

      posX = 0;
      posY = 0;

      //Follow the wind direction when throwing seeds
      if (degrees(block.weather.direction.heading()) >= 45  &&  degrees(block.weather.direction.heading()) < 135) {
        posX = (int) random(0, spreadLength);
      } else if (degrees(block.weather.direction.heading()) >= 225  &&  degrees(block.weather.direction.heading()) < 315) {
        posX = (int) - random(0, spreadLength);
      }
      if (degrees(block.weather.direction.heading()) >= 135  &&  degrees(block.weather.direction.heading()) < 225) {
        posY = (int) - random(0, spreadLength);
      } else if (degrees(block.weather.direction.heading()) >= 315   &&  degrees(block.weather.direction.heading()) < 45) {
        posY = (int) random(0, spreadLength);
      }

      // Create X,Y coordinates that are loop around friendly in the grid
      loopAroundX = ((block.x + posX) + world.size) % world.size;
      loopAroundY = ((block.y + posY) + world.size) % world.size;

      if (world.grid[loopAroundX][loopAroundY].ground instanceof Soil && world.grid[loopAroundX][loopAroundY].flora == null )
      {
        // Get seeds array from growable
        seeds = ((Soil) world.grid[loopAroundX][loopAroundY].ground).seeds;
        // Check for free spots for the seed to grow
        for (int j = 0; j < seeds.length; j++)
        {
          if (seeds[j] == null)
          {
            // When a free spot is found place the new seed
            seeds[j] = new Seed();
            break;
          }
        }
      }
    }
  }

  //Does energy calculations do determine punishments of undesirable conditions for a plant to grow and kills plants
  void consumeEnergy(Block block) {

    energy -= 5 + parasiteAmount * 0.005;

    if (onFire) {
      energy -= 50;
    }

    if (water <=0) {
      energy -= 10;
    }

    if (block.weather.temperature > highTemp) {
      energy -= 50;
    } else if (block.weather.temperature < lowTemp)
      energy -= 50;

    if (energy <= 0) {
      block.flora = null;
    }
  }

  //Produces energy for plants
  void photosynthesis(Weather weather)
  {
    float tempEnergy;
    //Can only perform photosynthesis if I have at least a small supply of water
    if (water >= 0.2)
    {
      //Consume water
      water -= water * 0.2;
      //Take energy from the sun
      tempEnergy = 10000 + ((weather.sunlightAmount - ((weather.cloudAmount * weather.sunlightAmount))));
      tempEnergy = constrain(tempEnergy, 0, Integer.MAX_VALUE);
      energy += tempEnergy;
    }
  }

  //absorb nutrients useful from Soil and use them to replenish energy
  void absorbNutrients(Soil soil)
  {
    //Gain nutrients and Punish the plant for starving for nutrients
    //Water intake
    if (soil.water >= 0.2)
    {
      water += 0.2;
      soil.water -= 0.2;
    }
    //CEC intake
    if (soil.cec > 200)
    {
      energy += 1;
      soil.cec -= 200;
    }
    //CEC energy punishment if starved
    else
    {
      energy -= 3;
    }
    //Sulfur intake
    if (soil.sulfur >= 1)
    {
      energy += 1;
      soil.sulfur -= 1;
    }
    //Sulfur energy punishment if starved
    else
    {
      energy -= 2;
    }
    //Phosphorus intake
    if (soil.phosphorus > 0)
    {
      energy += 1;
      soil.phosphorus -= 1;
    }
    //Phosphorus energy punishment if starved
    else
    {
      energy -= 5;
    }
  }

  //Passive water evaporation depended on conditions
  void waterEvaporation(Ground ground)
  {
    float waterEvaporated = 0;
    //Check the temperature to determine how severe the loss of water supplies is
    if (ground.temperature > 0)
    {
      waterEvaporated = ground.temperature * 0.0000625;
    } else if (ground.temperature > 15 && ground.temperature < 25)
    {
      waterEvaporated = ground.temperature * 0.000125;
    } else if (ground.temperature > 25)
    {
      waterEvaporated = ground.temperature * 0.00025;
    }
    //Remove the water from the plant at this point
    water -= waterEvaporated;
  }

  //Spreads parasites from other plants
  void spreadParasite(Block block, World world)
  {
    if (parasiteAmount > 0)
    {
      for (int newY = (block.y - 1 + world.size) % world.size; newY <= (block.y + 1 + world.size) % world.size; newY++)
      {
        for (int newX = (block.x - 1 + world.size) % world.size; newX <= (block.x + 1 + world.size) % world.size; newX++)
        {
          if (world.grid[newX][newY].flora != null)
          {
            if (world.grid[newX][newY].flora.energy > energy)
            {
              world.grid[newX][newY].flora.parasiteAmount += parasiteAmount / 4;
              parasiteAmount -= parasiteAmount/4;
              parasiteAmount = constrain(parasiteAmount, 0, 100000);
            }
          }
        }
      }
    }
  }

  //Changes the attitude of plants according to season and energy conditions
  void changeAttitude(Weather weather)
  {
    //If the plant is close to running out of energy, it changes its behaviour
    if ((energy < 10))
    {
      attitude = "Conservative";
    } else
    {
      //Flora selects behaviour based on season
      switch(weather.currentSeason)
      {
      case "Winter" :
        attitude = "Conservative";
        break;

      case "Autumn" :
        attitude = "Shedding";
        break;

      case "Spring" :
        attitude = "Expansionist";
        break;

      case "Summer" :
        attitude = "Expansionist";
        break;
      }
    }
  }

  //Makes plants grow at the expense of energy
  void grow()
  {
    energy -= energy * 0.05;
    constrain(floraHeight, 0, 16.5);
    floraHeight += 0.001;
    floraWidth += 0.001;
  }
}
