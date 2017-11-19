// initialize grid of points
void initGrid(){
  for(int i = 0; i < gridWidth; i++){
    for(int j = 0; j < gridHeight; j++){
      int rand = (int) random(2);
      grid[i][j] = (rand == 1);
      /* center point only grid:
      if(i == gridWidth / 2 && j == gridHeight / 2){
        grid[i][j] = false;
      }
      else{
        grid[i][j] = true;
      }
      */
    }
  }
}
// draw grid on screen
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