import java.util.*;
// global variables
int gridWidth = 150;
int gridHeight = 150;
// count used to keep track of generations
int count = 0;
// alternative rule for boosting poulation durring lull
boolean populationBoost = false;
// n is the boost factor: chance of random birth is 1/n when neighborSum == 2
// (we can just have the probability equal 1 if we implement this in assembly, aka n = 1)
int n = 1;
int checkpoint = 10; // number of iterations before checking total population
int thresholdParam = 10; // enact boost threshold = totalcells/thresholdParam

// our grid of cells
boolean[][] grid = new boolean[gridWidth][gridHeight];

// setup runs when program starts
void setup(){
  size(1500,1500);
  // initialize grid
  initGrid();
}
// draw runs every frame
void draw(){
  drawGrid(); // display grid on screen
  count++;
  // every 10 generations, check to see if rules need to be modified
  if (count > checkpoint){
    count = 0;
    int totalPop = getTotalPop();
    setPopBoost(totalPop);
  }
  grid = getNext(); // get next generation
  delay(10);
}

// method for getting the next generation
boolean[][] getNext(){
  boolean[][] nextGen = new boolean[gridWidth][gridHeight];
  for(int i = 0; i < gridWidth; i++){
    for(int j = 0; j < gridHeight; j++){
      //int rand = (int) random(2);
      //nextGen[i][j] = (rand == 1);
      // if we're not on the boarder
      if(i > 0 && i < gridWidth - 1 && j > 0 && j < gridHeight - 1){
        // get sum of neighborhood states
        int neighborhoodSum = getNeighborhoodSum(i, j);
        nextGen[i][j] = getNextState(neighborhoodSum, i, j);
      }
    }
  }
  return nextGen;
}

// get sum of states of neighborhood
int getNeighborhoodSum(int centerI, int centerJ){
  int neighborSum = 0;
  for(int i = centerI - 1; i <= centerI + 1; i++){
    for(int j = centerJ - 1; j <= centerJ + 1; j++){
      // if not in the center point
      if(!(i == centerI && j == centerJ)){
        // add to sum whenever state is true
        if (grid[i][j]){
          neighborSum++;
        }
      }
    }
  }
  return neighborSum;
}

// get next state of cell
boolean getNextState(int sum, int i, int j){
  boolean state = false;
  if(sum < 2){
    // dies from lonelyness
    state = false;
  }
  else if(sum > 3){
    // dies from overpopulation
    state = false;
  }
  else if(sum == 3){
    // remain alive or become born
    state = true;
  }
  else if(sum == 2){
    // if populationBoost is in effect, there is a chance of birth from death
    if(populationBoost && grid[i][j] == false){
      int rand = (int) random(n);
      state = (rand == 0);
      //print("state: " + state + "\n");
    }
    else{
      // state remains unchanged
      state = grid[i][j];
    }
  }
  return state;
}
