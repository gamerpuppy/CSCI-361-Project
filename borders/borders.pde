import java.util.*;
// global variables
int gridWidth = 150;
int gridHeight = 150;
// -1 for random rule, or set custom rule with "L" at the end (limited to pos rules)
long ruleNum = -1;
// our grid of cells
boolean[][] grid = new boolean[gridWidth][gridHeight];
// our table of rules
Hashtable<Long,Boolean> rules = new Hashtable<Long,Boolean>();

// setup runs when program starts
void setup(){
  size(1500,1500);
  // use random rules
  if (ruleNum == -1){
    boolean[] randRules = genRandomRules();
    initRules(randRules);
  }
  // use custom rules
  else{
    boolean[] setRules = toBinary(ruleNum);
    initRules(setRules);
  }
  // initialize grid
  initGrid();
}
// draw runs every frame
void draw(){
  drawGrid(); // display grid on screen
  grid = getNext(); // get next generation
  delay(10);
}

// method for getting the next generation
boolean[][] getNext(){
  boolean[][] nextGen = new boolean[gridWidth][gridHeight];
  for(int i = 0; i < gridWidth; i++){
    for(int j = 0; j < gridHeight; j++){
      // if on border, set to false
      if(i == 0 || j == 0 || i == gridWidth-1 || j == gridHeight-1){
        nextGen[i][j] = false;
      }
      else{
        // borders actually means column and row states
        boolean[] borders = getBorders(i,j);
        // convert borders to a number between 0 and 63 (must be long because of toDecimal parameter)
        long decimal = toDecimal(borders);
        // use decimal to look up rule in table
        boolean rule = rules.get(decimal);
        // apply rule
        nextGen[i][j] = rule;
      }
    }
  }
  return nextGen;
}

// get states of columns and rows using sums and threshholds
boolean[] getBorders(int i, int j){
  // neighborhood is actually row and column states
  boolean[] neighborhood = new boolean[6];
  int index = 0; // index in neighborhood
  int sum;
  // summing row elements
  for (int k = i-1; k <= i+1; k++){
    sum = 0;
    for (int l = j-1; l <= j+1; l++){
      if(grid[k][l] == true){
        sum++;
      }
    }
    // threshhold of 2 for true state
    if(sum >= 2){
      neighborhood[index] = true;
    }
    else{
      neighborhood[index] = false;
    }
    index++;
  }
  // summing column elements
  for (int k = j-1; k <= j+1; k++){
    sum = 0;
    for (int l = i-1; l <= i+1; l++){
      if(grid[k][l] == true){
        sum++;
      }
    }
    // threshhold of 2
    if(sum >= 2){
      neighborhood[index] = true;
    }
    else{
      neighborhood[index] = false;
    }
    index++;
  }
  return neighborhood;
}