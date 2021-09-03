public class Block
{
  // Attributes
  int x, y;
  color colour;
  Flora flora;
  Ground ground;
  Weather weather;

  // Constructors
  //Only positions
  public Block(int x, int y)
  {
    this.x = x;
    this.y = y;
    this.colour = #050505;
    weather = new Weather();
    
    //Randomly decide if the block will have a flora (50% chance)
    if(random(1) >= 0.5){
      flora =  new Flora();
    }
    else{
      flora =  null;
    }
    ground = new Soil();
  }

  // Methods
  void iterateBlock(World world)
  {
    //iterates flora, ground, weather
    weather.iterateWeather(this, world);
    if (flora != null) {
      flora.iterateFlora(this, world);
    }
    ground.iterateGround(this, world);
    //Changes the colour
    changeColour();
  }

  //Changes the colour of the block depending on multiple conditions
  void changeColour()
  {
    if (flora == null) {

      if (ground != null) {
        if (ground.snowAmount > 1) {
            //Snow colour
          colour = #CECECE;
        }
        else if (ground.radiation >= 10){
          //Radiation colour
          colour = #225F0D;
        }
        else{
           //Ground colour
          colour = #76360D;
        }
      } else {
          //Testing colour showing "undesirable" conditions
        colour = #050404;
      }
    } else {
        //Parasite colour
      if (flora.parasiteAmount > 1000) {
        colour =  #F01BE5;
      }
      //Fire colour
      else if (flora.onFire) {
        colour =  #F7450A;
      }
      //Plant colour
      else {
        colour = #44F70A;
      }
    }
  }
}
