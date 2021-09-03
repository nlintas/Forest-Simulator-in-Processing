/*
    Theory/Calculation Facts:
    approximately 40% sand, 40% silt, and 20% clay is an average block of soil.
*/
public class Soil extends Ground
{
  // Attributes
  float cec, sulfur, phosphorus, water;
  final float waterCapacity;
  final float sand;
  final float clay;
  final float silt;
  Seed seeds[];

  // Constructors
  // Default
  public Soil()
  {
    //Gets the grounds radiation, radiationResist, temperature and snowAmount.
    super();
    //Starts with a reserve of nutrients, water and cec components as well as a water capacity according to the amount of sand, silt and clay.
    this.sulfur = 150;
    this.phosphorus = 150;
    this.water = 200;
    this.sand = 40;
    this.clay = 20;
    this.silt = 40;
    this.cec = (silt * 2 + sand * 0.02 + clay * 7) / 2;
    this.waterCapacity = clay * 2 + sand * 0.6 + silt * 1;
    seeds = new Seed[3];
  }

  // Methods
  //Iterates the methods of the soil class
  void iterateGround(Block block, World world)
  {
    //Iterates the methods of the ground class
    super.iterateGround(block, world);
    //All water operations
    waterAbsorption(block, world);
    waterEvaporation(block.weather);
    //CEC recalculation
    calculateCEC();
    //Sulfur recalculation
    calculateSulfur();
    //Phosphorus recalculation
    calculatePhosphorus(block.weather);
    //Checks to grow or kill seeds,
    for (int i = 0; i < seeds.length; i++) {
      if (seeds[i] != null && !seeds[i].grow(block)) {
        seeds[i] = null;
      }
    }
  }

  //Absorbs water from the clouds
  void waterAbsorption(Block block, World world) {

    if (block.weather.rainAmount > 0) {
      //Checking the clouds from water and taking it from them.
      water += block.weather.rainAmount / 2;
      block.weather.rainAmount = block.weather.rainAmount / 2;
      block.weather.cloudAmount -= block.weather.cloudAmount/2;
      constrain(block.weather.rainAmount, 0, 1000);

      //The difference of water capacity is kept in the soil
      if (water > waterCapacity) {
        float waterDif = waterCapacity - water;
        //Adds the difference in the whole grid
        for (int newY = (block.y - 1 + world.size) % world.size; newY <= (block.y + 1 + world.size) % world.size; newY++) {
          for (int newX = (block.x - 1 + world.size) % world.size; newX <= (block.x + 1 + world.size) % world.size; newX++) {
            if (world.grid[block.x][block.y].ground instanceof Soil) {
              ((Soil) world.grid[block.x][block.y].ground).water += waterDif;
            }
          }
        }
        water = waterCapacity;
      }
    }
  }

  //Evaporates water from the reserves
  void waterEvaporation(Weather weather)
  {
    float waterEvaporated = (((( 0.004 * sand ) + (0.001 * silt) + ( 0.003 * clay))/2));
    weather.waterVapour += waterEvaporated;
    water -= waterEvaporated;
    water = constrain(water, 0, 1000);
  }

  //Calculates the amount of sulfur depending on the water reserves
  void calculateSulfur() {
    if (water <= 0)
    {
      sulfur += 5;
    }
  }

  //Calculates the amount of phosphorus depending on the amount of clay
  void calculatePhosphorus(Weather weather) {
    int added = 0;
    added += (clay) * weather.rainAmount;
    added = constrain(added, 0, Integer.MAX_VALUE);
    phosphorus += added;
  }

  //Calculates the amount of cec depending on the amount of silt, sand and clay
  void calculateCEC()
  {
    int added = 0;
    added += (silt * 2 + sand * 0.02 + clay * 7);
    added = constrain(added, 0, Integer.MAX_VALUE);
    cec += added;
  }
}
