import java.util.*;

int gridWidth = 100;
int gridHeight = 100;
boolean[][] grid = new boolean[gridWidth][gridHeight];
Hashtable<Integer,Boolean> rules = new Hashtable<Integer,Boolean>();

void setup(){
  size(1000,1000);
  initGrid();
  initRules();
}

void draw(){
  drawGrid();
  grid = getNext();
  delay(10);

}

boolean[][] getNext(){
  boolean[][] nextGen = new boolean[gridWidth][gridHeight];
  for(int i = 0; i < gridWidth; i++){
    for(int j = 0; j < gridHeight; j++){
      if(i == 0 || j == 0 || i == gridWidth-1 || j == gridHeight-1){
        nextGen[i][j] = false;
      }
      else{
        boolean[] neighborhood = getNeighborhood(i,j);
        int binary = getBinary(neighborhood);
        boolean rule = rules.get(binary);
        nextGen[i][j] = rule;
      }
    }
  }
  return nextGen;
}

int getBinary(boolean[] neighborhood){
  int binary = 0;
  for(int i = 0; i < neighborhood.length; i++){
    if (neighborhood[i]){
      binary += Math.pow(2,i);
    }
  }
  return binary;
}

boolean[] getNeighborhood(int i, int j){
  boolean[] neighborhood = new boolean[9];
  int index = 0;
  for (int k = i-1; k <= i+1; k++){
    for (int l = j-1; l <= j+1; l++){
      neighborhood[index] = grid[k][l];
      index++;
    }
  }

  return neighborhood;
}

void initGrid(){
  for(int i = 0; i < gridWidth; i++){
    for(int j = 0; j < gridHeight; j++){
      //int rand = (int) random(2);
      //grid[i][j] = (rand == 1);
      if(i == gridWidth / 2 && j == gridHeight / 2){
        grid[i][j] = true;
      }
      else{
        grid[i][j] = false;
      }
    }
  }
}

void drawGrid(){
  for(int i = 0; i < gridWidth; i++){
    for(int j = 0; j < gridHeight; j++){
      if(grid[i][j] == false){
        fill(255);
      }
      else{
        fill(0);
      }
      rect(i*10,j*10,10,10);
    }
  }
}

void initRules(){
  // for every possible state
  for (int i = 0; i < 512; i++){
    int randRule = (int) random(2);
    boolean outState = (randRule == 1);
    rules.put(i,outState);
  }
}
