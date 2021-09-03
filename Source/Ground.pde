/*
    Theory/Calculation Facts:
    Change temperature of the ground depending on the weather. Increases by 0 - 4 degrees warmer according to research.
    Setting the temperature of the ground to 24 according to research
*/
public class Ground
{
    // Attributes
    float radiation, radiationResist, temperature, snowAmount;

    // Constructors
    //Full
    public Ground(float radiation, float radiationResist, float temperature, float snowAmount)
    {
        this.radiation = radiation;
        this.radiationResist = radiationResist;
        this.temperature = temperature;
        this.snowAmount = snowAmount;
    }
    //Default
    public Ground()
    {
        // Setting the temperature to 24
        this.radiation = 0;
        this.radiationResist = 13.2;
        this.temperature = 24;
        this.snowAmount = 0;
    }

    // Methods
    void iterateGround(Block block, World world)
    {
        // calculate the amount of radiation ground takes.
        this.radiation += block.weather.radiation - block.weather.radiation * radiationResist;
        // radiation decreases each hour and spreads
        spreadRadiation(block.x, block.y, world);
        // Change temperature depending on the weather.
        this.temperature = (random(0, 4) + block.weather.temperature);
        // Effects of snow on the block
        snowAmount = snowAmount + block.weather.snowAmount;
        if (temperature > 0)
        {
            // snow that melts every hour
            snowAmount -= 0.4 * snowAmount;
        }
    }

    //Spreads radiation around plants
    void spreadRadiation(int x, int y, World world)
    {
        // radiation reaches a specific point in order to spread.
        if (this.radiation > 1000)
        {
            float difference = (this.radiation - 1000) / 8;
            this.radiation = 1000;
            //traverse around the block and give it part of the spare radiation
            for (int newY = (y - 1 + world.size) % world.size; newY <= (y + 1 + world.size) % world.size; newY++)
            {
                for (int newX = (x - 1 + world.size) % world.size; newX <= (x + 1 + world.size) % world.size; newX++)
                {
                    world.grid[newX][newY].ground.radiation += difference;
                }
            }
        }
    }
}
