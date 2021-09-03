//Used for controls
import javax.swing.JOptionPane;
World world;

void setup() {
  
  size(700, 700);
  int value = 0;
  String input;
  boolean isDone = false;

  do {
    try {
      input = JOptionPane.showInputDialog("Please enter the size of the world (Note: a provided value of \"5\" would make a world of 5x5)");
      if (input == null) {
        System.exit(0);
      } else {

        value = Integer.parseInt(input);

        if (value <= 1) {
          JOptionPane.showMessageDialog(null, "Invalid Input, the value must be bigger than one");
        } else {
          world = new World(value);
          isDone = true;
        }
      }
    }
    catch (NumberFormatException e)
    {
      JOptionPane.showMessageDialog(null, "Invalid Input, Must be a number");
    }
  } while (!isDone);



  frameRate(30);
}

void draw() {
  //Methods that progress the simulation at each step and draw it.
  world.iterateWorld();
  world.drawWorld();
}

//User Interactivity controls
void keyPressed() {
  if (key =='X' || key =='x') {
    exit();
  }
  //Speed controls
  else if (key == '0') {
    int value = 0;
    String input;
    boolean isDone = false;

    do {
      try {
        input = JOptionPane.showInputDialog("Please enter \"1\" for normal speed, \"2\" for 2x speed and \"3\" for highest speed");
        if (input == null) {
          isDone = true;
        } else {

          value = Integer.parseInt(input);

          if (!world.changeSpeed(value)) {
            JOptionPane.showMessageDialog(null, "Invalid Input");
          } else {
            isDone = true;
          }
        }
      }
      catch (NumberFormatException e)
      {
        JOptionPane.showMessageDialog(null, "Invalid Input, Must be a number");
      }
    } while (!isDone);
  }
  //Parasite controls
  else if (key == '1') {

    int x = 0;
    int y = 0;
    int amount = 0;
    String firstInput;
    String secondInput;
    String thirdInput;
    boolean isDone = false;

    do {
      try {
        firstInput = JOptionPane.showInputDialog("Please enter a valid number for the X position");
        secondInput = JOptionPane.showInputDialog("Please enter a valid number for the Y position");
        thirdInput = JOptionPane.showInputDialog("Please enter a  number for the amount of parasites");
        if (firstInput == null || secondInput == null || thirdInput == null) {
          isDone = true;
        } else {

          x = Integer.parseInt(firstInput);
          y = Integer.parseInt(secondInput);
          amount = Integer.parseInt(thirdInput);

          if (!world.startParasite(x, y, amount)) {
            JOptionPane.showMessageDialog(null, "Invalid Input");
          } else {
            isDone = true;
          }
        }
      }
      catch (NumberFormatException e)
      {
        JOptionPane.showMessageDialog(null, "Invalid Input, Must be a number");
      }
    } while (!isDone);
  }
  //Plant Seed controls
  else if (key == '2') {


    int x = 0;
    int y = 0;
    String firstInput;
    String secondInput;
    boolean isDone = false;

    do {
      try {
        firstInput = JOptionPane.showInputDialog("Please enter a valid number for the X position");
        secondInput = JOptionPane.showInputDialog("Please enter a valid number for the Y position");
        if (firstInput == null || secondInput == null) {
          isDone = true;
        } else {

          x = Integer.parseInt(firstInput);
          y = Integer.parseInt(secondInput);

          if (!world.plantSeed(x, y)) {
            JOptionPane.showMessageDialog(null, "Invalid Input");
          } else {
            isDone = true;
          }
        }
      }
      catch (NumberFormatException e)
      {
        JOptionPane.showMessageDialog(null, "Invalid Input, Must be a number");
      }
    } while (!isDone);
  }
  //Move controls
  else if (key == '3') {


    int x = 0;
    int y = 0;
    int newX = 0;
    int newY = 0;
    String firstInput;
    String secondInput;
    String thirdInput;
    String fourthInput;
    boolean isDone = false;

    do {
      try {
        firstInput = JOptionPane.showInputDialog("Please enter a valid number for the X position");
        secondInput = JOptionPane.showInputDialog("Please enter a valid number for the Y position");
        thirdInput = JOptionPane.showInputDialog("Please enter a valid number for the new X position");
        fourthInput = JOptionPane.showInputDialog("Please enter a valid number for the new Y position");
        if (firstInput == null || secondInput == null || thirdInput == null || fourthInput == null) {
          isDone = true;
        } else {

          x = Integer.parseInt(firstInput);
          y = Integer.parseInt(secondInput);
          newX = Integer.parseInt(thirdInput);
          newY = Integer.parseInt(fourthInput);

          if (!world.movePlant(x, y, newX, newY)) {
            JOptionPane.showMessageDialog(null, "Invalid Input");
          } else {
            isDone = true;
          }
        }
      }
      catch (NumberFormatException e)
      {
        JOptionPane.showMessageDialog(null, "Invalid Input, Must be a number");
      }
    } while (!isDone);
  }
  //Remove Plant controls
  else if (key == '4') {
    int x = 0;
    int y = 0;
    String firstInput;
    String secondInput;
    boolean isDone = false;

    do {
      try {
        firstInput = JOptionPane.showInputDialog("Please enter a valid number for the X position");
        secondInput = JOptionPane.showInputDialog("Please enter a valid number for the Y position");
        if (firstInput == null || secondInput == null) {
          isDone = true;
        } else {

          x = Integer.parseInt(firstInput);
          y = Integer.parseInt(secondInput);

          if (!world.removePlant(x, y)) {
            JOptionPane.showMessageDialog(null, "Invalid Input");
          } else {
            isDone = true;
          }
        }
      }
      catch (NumberFormatException e)
      {
        JOptionPane.showMessageDialog(null, "Invalid Input, Must be a number");
      }
    } while (!isDone);
  }
  //Plant Flora controls
  else if (key == '5') {

    int x = 0;
    int y = 0;
    String firstInput;
    String secondInput;
    boolean isDone = false;

    do {
      try {
        firstInput = JOptionPane.showInputDialog("Please enter a valid number for the X position");
        secondInput = JOptionPane.showInputDialog("Please enter a valid number for the Y position");
        if (firstInput == null || secondInput == null) {
          isDone = true;
        } else {

          x = Integer.parseInt(firstInput);
          y = Integer.parseInt(secondInput);

          if (!world.addPlant(x, y)) {
            JOptionPane.showMessageDialog(null, "Invalid Input");
          } else {
            isDone = true;
          }
        }
      }
      catch (NumberFormatException e)
      {
        JOptionPane.showMessageDialog(null, "Invalid Input, Must be a number");
      }
    } while (!isDone);
  }
  //Planting Soil controls
  else if (key == '6') {

    int x = 0;
    int y = 0;
    String firstInput;
    String secondInput;
    boolean isDone = false;

    do {
      try {
        firstInput = JOptionPane.showInputDialog("Please enter a valid number for the X position");
        secondInput = JOptionPane.showInputDialog("Please enter a valid number for the Y position");
        if (firstInput == null || secondInput == null) {
          isDone = true;
        } else {

          x = Integer.parseInt(firstInput);
          y = Integer.parseInt(secondInput);

          if (!world.addSoil(x, y)) {
            JOptionPane.showMessageDialog(null, "Invalid Input");
          } else {
            isDone = true;
          }
        }
      }
      catch (NumberFormatException e)
      {
        JOptionPane.showMessageDialog(null, "Invalid Input, Must be a number");
      }
    } while (!isDone);
  }
  //Remove Soil controls
  else if (key == '7') {


    int x = 0;
    int y = 0;
    String firstInput;
    String secondInput;
    boolean isDone = false;

    do {
      try {
        firstInput = JOptionPane.showInputDialog("Please enter a valid number for the X position");
        secondInput = JOptionPane.showInputDialog("Please enter a valid number for the Y position");
        if (firstInput == null || secondInput == null) {
          isDone = true;
        } else {

          x = Integer.parseInt(firstInput);
          y = Integer.parseInt(secondInput);

          if (!world.removeSoil(x, y)) {
            JOptionPane.showMessageDialog(null, "Invalid Input");
          } else {
            isDone = true;
          }
        }
      }
      catch (NumberFormatException e)
      {
        JOptionPane.showMessageDialog(null, "Invalid Input, Must be a number");
      }
    } while (!isDone);
  }
  //Move Ground controls
  else if (key == '8') {

    int x = 0;
    int y = 0;
    int newX = 0;
    int newY = 0;
    String firstInput;
    String secondInput;
    String thirdInput;
    String fourthInput;
    boolean isDone = false;

    do {
      try {
        firstInput = JOptionPane.showInputDialog("Please enter a valid number for the X position");
        secondInput = JOptionPane.showInputDialog("Please enter a valid number for the Y position");
        thirdInput = JOptionPane.showInputDialog("Please enter a valid number for the new X position");
        fourthInput = JOptionPane.showInputDialog("Please enter a valid number for the new Y position");
        if (firstInput == null || secondInput == null || thirdInput == null || fourthInput == null) {
          isDone = true;
        } else {

          x = Integer.parseInt(firstInput);
          y = Integer.parseInt(secondInput);
          newX = Integer.parseInt(thirdInput);
          newY = Integer.parseInt(fourthInput);

          if (!world.moveGround(x, y, newX, newY)) {
            JOptionPane.showMessageDialog(null, "Invalid Input");
          } else {
            isDone = true;
          }
        }
      }
      catch (NumberFormatException e)
      {
        JOptionPane.showMessageDialog(null, "Invalid Input, Must be a number");
      }
    } while (!isDone);
  }
  //Set Fires controls
  else if (key == '9') {
    int x = 0;
    int y = 0;
    String firstInput;
    String secondInput;
    boolean isDone = false;

    do {
      try {

        firstInput = JOptionPane.showInputDialog("Please enter a valid number for the X position");
        secondInput = JOptionPane.showInputDialog("Please enter a valid number for the Y position");

        if (firstInput == null || secondInput == null) {
          isDone = true;
        } else {
          x = Integer.parseInt(firstInput);
          y = Integer.parseInt(secondInput);

          if (!world.startFire(x, y)) {
            JOptionPane.showMessageDialog(null, "Invalid Input");
          } else {
            isDone = true;
          }
        }
      }
      catch (NumberFormatException e)
      {
        JOptionPane.showMessageDialog(null, "Invalid Input, Must be a number");
      }
    } while (!isDone);
  }
  //Radiation Adding controls
  else if (key == '-') {
    int x = 0;
    int y = 0;
    int amount = 0;
    String firstInput;
    String secondInput;
    String thirdInput;
    boolean isDone = false;

    do {
      try {

        firstInput = JOptionPane.showInputDialog("Please enter a valid number for the X position");
        secondInput = JOptionPane.showInputDialog("Please enter a valid number for the Y position");
        thirdInput = JOptionPane.showInputDialog("Please enter a valid number for the amount of radiation");
        if (firstInput == null || secondInput == null || thirdInput == null) {
          isDone = true;
        } else {

          x = Integer.parseInt(firstInput);
          y = Integer.parseInt(secondInput);
          amount = Integer.parseInt(thirdInput);


          if (! world.addRadiation(x, y, amount)) {
            JOptionPane.showMessageDialog(null, "Invalid Input");
          } else {
            isDone = true;
          }
        }
      }
      catch (NumberFormatException e)
      {
        JOptionPane.showMessageDialog(null, "Invalid Input, Must be a number");
      }
    } while (!isDone);
  }
}
