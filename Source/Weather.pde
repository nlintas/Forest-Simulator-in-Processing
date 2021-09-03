class Weather {
  //Attributes
  float temperature, cloudAmount, radiation, waterVapour, noise_scale, sunlightAmount, rainAmount, snowAmount, 
    seasonMaxTemp, seasonMinTemp, seasonMaxSun, seasonMaxWind, seasonMaxCloud, 
    seasonMaxRain, thunderChance, rotation;
  int windForce;
  PVector direction;
  String currentSeason;
  Boolean hasThunder;

  //Constructors
  //Default
  public Weather() {
    //Start at summer to allow plants to thrive
    currentSeason = "Summer";
    temperature = random(20, 30);
    cloudAmount = random(0, 10);
    radiation = 0;
    waterVapour = random(0, 10);
    noise_scale = 0.02;
    sunlightAmount = 100;
    rainAmount = 0;
    snowAmount = 0;
    rotation = 0;
    direction = new PVector(1, 0);
    thunderChance = 0.03;
    windForce = 0;
    //Season limits
    seasonMinTemp = 20;
    seasonMaxTemp = 40;
    seasonMaxSun  = 200;
    seasonMaxWind  = 1;
    seasonMaxCloud = 80;
    seasonMaxRain = 50;
    thunderChance = 0.03;
  }

  //Methods
  //Executing all methods of the weather at each step
  void iterateWeather(Block block, World world) {
    //Changes the season
    iterateSeason(world.currentTime);
    //Calculates the random behaviour of weather
    perlinWeather(block, world);
    //Changes the flowfields direction
    updateRotation(block.x, block.y, world);
  }

  //Changes the season, setting all vlaues appropriatelly
  void iterateSeason(int hours) {
    if (hours  >= 2160) {
      switch(currentSeason) {
      case "Winter" :
        currentSeason = "Spring";
        seasonMinTemp = 10;
        seasonMaxTemp = 20;
        seasonMaxSun  = 100;
        seasonMaxWind  = 4;
        seasonMaxCloud = 80;
        seasonMaxRain = 50;
        thunderChance = 0.03;
        break;

      case "Autumn" :
        currentSeason = "Winter";
        seasonMinTemp = -15;
        seasonMaxTemp = 15;
        seasonMaxSun  = 50;
        seasonMaxWind  = 3;
        seasonMaxCloud = 80;
        seasonMaxRain = 50;
        thunderChance = 0;
        break;

      case "Spring" :
        currentSeason = "Summer";
        seasonMinTemp = 20;
        seasonMaxTemp = 40;
        seasonMaxSun  = 200;
        seasonMaxWind  = 1;
        seasonMaxCloud = 80;
        seasonMaxRain = 50;
        thunderChance = 0.03;
        break;

      case "Summer" :
        currentSeason = "Autumn";
        seasonMinTemp = -5;
        seasonMaxTemp = 15;
        seasonMaxSun  = 80;
        seasonMaxWind  = 5;
        seasonMaxCloud = 80;
        seasonMaxRain = 50;
        thunderChance = 0;
        break;
      }
    }
  }

  //Patternized random weather conditions using perlin noise
  void perlinWeather(Block block, World world) {

    int hour = world.currentTime;
    noise_scale += 0.02;
    windForce = (int) random(seasonMaxWind);
    //Checks if its day time to set the conditions appropriatelly
    if ((hour % 24 > 18) || (hour % 24 < 6 && hour % 24  > 0))
    {
      sunlightAmount += random(0, 7);
      sunlightAmount = constrain(sunlightAmount, 5, 150);
      if (temperature < seasonMinTemp)
      {
        temperature += temperature * 0.75;
      } else
      {
        temperature += random(0, 4);
      }
      temperature = constrain(temperature, seasonMinTemp, seasonMaxTemp);
    }
    //Night time conditions
    else
    {
      sunlightAmount -= random(0, 5);
      sunlightAmount = constrain(sunlightAmount, 5, 150);
      if (temperature > seasonMaxTemp)
      {
        temperature -= temperature * 0.75;
        temperature = constrain(temperature, seasonMinTemp, seasonMaxTemp);
      } else
      {
        temperature = map(noise(noise_scale), 0, 1, seasonMinTemp, temperature);
      }
    }

    //Cloud Creation
    if (temperature <= 25 && waterVapour >= 25) {
      cloudAmount += random(5, 10);
      waterVapour -= 10;
    } else {
      cloudAmount -= 0.001 * temperature;
      cloudAmount = constrain(cloudAmount, 0, 1000);
    }
    //Adds rain from water vapour because of the cloud amount
    if (cloudAmount >= 100) {
      rainAmount += waterVapour/2;
      waterVapour = waterVapour/2;
    }
    //Snow creation
    if (temperature <= 0 && rainAmount > 0) {
      snowAmount += rainAmount/4;
      rainAmount -= rainAmount/4;
    }
    //Changes flowfields
    updateRotation(block.x, block.y, world);
    //Changes clouds positions according to wind direction
    if (degrees(direction.heading()) >= 45  &&  degrees(direction.heading()) < 135) {
      world.grid[(block.x - 1 + world.size) % world.size][block.y].weather.cloudAmount += cloudAmount;
      world.grid[(block.x - 1 + world.size) % world.size][block.y].weather.rainAmount += rainAmount;
      world.grid[(block.x - 1 + world.size) % world.size][block.y].weather.snowAmount += snowAmount;
      cloudAmount = 0;
      rainAmount = 0;
      snowAmount = 0;
      
    } else if (degrees(direction.heading()) >= 135  &&  degrees(direction.heading()) < 225) {
      world.grid[block.x][(block.y + 1) % world.size].weather.cloudAmount += cloudAmount;
      world.grid[block.x][(block.y + 1) % world.size].weather.rainAmount += rainAmount;
      world.grid[block.x][(block.y + 1) % world.size].weather.snowAmount += snowAmount;
      cloudAmount = 0;
      rainAmount = 0;
      snowAmount = 0;
      
    } else if (degrees(direction.heading()) >= 225  &&  degrees(direction.heading()) < 315) {
      world.grid[(block.x + 1) % world.size][block.y].weather.cloudAmount += cloudAmount;
      world.grid[(block.x + 1) % world.size][block.y].weather.rainAmount += rainAmount;
      world.grid[(block.x + 1) % world.size][block.y].weather.snowAmount += snowAmount;
      cloudAmount = 0;
      rainAmount = 0;
      snowAmount = 0;
      
    } else if (degrees(direction.heading()) >= 315   &&  degrees(direction.heading()) < 45) {
      world.grid[block.x][(block.y - 1 + world.size) % world.size].weather.cloudAmount += cloudAmount;
      world.grid[block.x][(block.y - 1 + world.size) % world.size].weather.rainAmount += rainAmount;
      world.grid[block.x][(block.y - 1 + world.size) % world.size].weather.snowAmount += snowAmount;
      cloudAmount = 0;
      rainAmount = 0;
      snowAmount = 0;
      
    }
  }

  //Changes the rotation of the flow field wind arrows according to noise.
  void updateRotation(int x, int y, World world) {
    float noisex = noise_scale + world.xoff;
    float noisey = noise_scale + world.yoff;
    rotation = noise(noisex, noisey) * TWO_PI;
    direction.rotate(rotation);
    noise_scale += 0.0035;
    PVector directionSum = new PVector();
    
    //Combine the force of all nearby wind directions
    for (int newY = (y - 1 + world.size) % world.size; newY <= (y + 1 + world.size) % world.size; newY++) {
      for (int newX = (x - 1 + world.size) % world.size; newX <= (x + 1 + world.size) % world.size; newX++) {
        directionSum.add(world.grid[newX][newY].weather.direction);
      }
    }
    //Calculates the direction
    directionSum.sub(direction);
    directionSum.div(8);
    direction.add(directionSum);
  }
}
