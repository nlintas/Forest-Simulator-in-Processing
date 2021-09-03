Detailed Description:
    The forest simulator is a simulation game that combined research with the creation of a game that strongly simulates a real environment.
    
    The system will be a simulation of a forest trying to spread in a grid with numerous parameters that affect it (seasons, weather, parasites and temperature) with user interaction. Based on the concept of a cellular automaton where a two-dimensional array will act as a grid with positions, each filled with “blocks”. These blocks can be implemented as a new class with basic parameters such as x, y, and more. A special feature of this simulation is the introduction of weather as an object that affects the grid. The evolution of the forest can be determined by the future potential of various soils that would be found around the world and the flora that are actually present. 

    There was an attempt to use a Graphical User Interface for user interactivity, but due to time constraints it was changed to key presses and JOption panes. Nonetheless, The user will be able to control parameters like:
        ●	Adding/moving/removing blocks (including soil, ground and actual plants or seeds).
        ●	Set the size of the grid at the beginning of each playthrough.
        ●	Add threats(fires, parasites and radiation) after choosing a block to harbor them and in such a way affecting the plant or the block itself.
        ●	Change the time speed. Speed up time, slow down time and normal time.
        Things the player cannot change:   

        ●	Parameters of all plants, grounds, soils and the weather itself cannot be changed in any other way than previously mentioned.
        ●	Day/Night cycle which makes the sun shine at different rates depending on the time of day.
        ●	Plants have default behaviours according to the season.

    Lastly, the gameplay details are as follows:  

        ●	Seasons. Autumn: Higher chance of rain and cloudiness. Winter: Higher chance of cloudiness, rain and wind. Summer: Higher chance of sun and rain. Spring: Higher chance of sun and wind. Seasons change every 3 months.

        ●	Temperature and intensity of weather conditions are different according to the season. Specifically, temperature is limited within a specific valid range for each season.

        ●	Parasites appear on plants and use up their energy and spread. Parasites appear only during Spring and Summer and die any other season.

        ●	Fires can start in the forest, destroying vegetation and spreading rapidly if a plant is nearby.

        ●	Radiation decreases plant energy, depending on the amount afflicted and spreads when in excess.

        ●	Plants will spread and grow based on their attitude, the amount of energy and nutrients they possess. 

        ●	Soils contain nutrients that the plant can use to survive and thrive.

        ●	All plants will have energy, when the plants stored up energy depletes either due to weather conditions or threats, it dies. It is produced by photosynthesis with a trade off to water reserves everytime. 

        ●	Seeds also exist in the simulation to show that plants grow from them and they even have a spread distance from the specific plant they were thrown from. Seeds also have individual energy consumption struggles and survival, with passive usage of energy and use at every step of growth. If temperature conditions are too harsh, seeds die immediately since they are very sensitive to temperature.

        ●	Flowfields are used for simulating realistic wind and clouds.

        ●	Realistic implementation of soil which includes nutrients (phosphorus, sulfur), atmospheric components (like oxygen, temperature and water) and conditions (CEC).

        ●	Height and width of trees is implemented to simulate growth.

        ●	Rain will be changed to snow when the weather conditions are appropriate and trees can be covered by the snow.

    * Mechanics & Programming *
    For a guide to better understand how the underlying mechanisms of the game operate please refer to https://natureofcode.com/book/chapter-7-cellular-automata/.

Aims:
    • Analyse a given problem and propose a set of viable software requirements
    • Develop a complete and valid design of a software product from these requirements
    • Build a software system in accordance to the analysis and design models, and keep the models aligned
    • Plan the stages of software development and manage his time and effort as a member of a team over a long period
    • Adapt and evolve according to challenges and problems that are presented during the development of a software product

How to run:
    - Open the main folder in the Physics Processing IDE and click the run green arrow button.