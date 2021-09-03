class Seed {
  //Attributes
  Flora type;
  float growthCompletion, growthRate, energy, water, lowTemp, highTemp;
  //Constructors
  //Default
  public Seed()
  {
    //Seeds given starting energy reserves and water to survive, also given temperature resistances
    type = new Flora();
    growthCompletion = 0;
    growthRate = 2.5;
    energy = 200;
    water = 0.25;
    lowTemp = 1;
    highTemp = 35;
  }
  //Full
  public Seed(Flora type, float growthCompletion, float growthRate, float energy, float water, float lowTemp, float highTemp)
  {
    this.type = type;
    this.growthCompletion = growthCompletion;
    this.growthRate = growthRate;
    this.energy = energy;
    this.water = water;
    this.lowTemp = lowTemp;
    this.highTemp = highTemp;
  }
  //Methods
  //Grows a seed into a plant
  boolean grow(Block block)
  {
     //Very sensitive to temperature
    if(block.ground.temperature < lowTemp || block.ground.temperature > highTemp){
     return false;
    }

    //Uses nutrients from the soil
    absorbNutrients((Soil) block.ground);

    //Check if seed is still alive
    if (energy <= 0)
    {
      return false;
    }

    //Updates energy resources and growth completion
    else
    {
      growthCompletion += growthRate;
      calculateEnergy();
      //Clones the plant on the block
      if (growthCompletion >= 100)
      {
        try{
         block.flora =  (Flora) type.clone();
        }
        catch(Exception e){
          new Exception(e.getMessage());
        }
        return false;
      }
    }
    return true;
  }

  //Use the soils nutrients to replenish energy
  void absorbNutrients(Soil soil)
  {
      //Gain nutrients and Punish the plant for starving for nutrients
      //Water intake
      if(soil.water >= 0.2)
      {
        water += 0.2;
        soil.water -= 0.2;
      }
      //CEC intake
      if(soil.cec > 200)
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
      if(soil.sulfur >= 1)
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
      if(soil.phosphorus > 0)
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

  //Calculates the energy for the seed
  void calculateEnergy()
  {
    //Energy used for survival purposes
    energy -= 1;
    //Penalty of water depravation
    if(water <= 0)
    {
      energy -= 50;
    }
  }
}
