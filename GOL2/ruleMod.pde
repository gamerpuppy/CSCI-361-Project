int getTotalPop(){
  int totalPop = 0;
  for(int i = 0; i < gridWidth; i++){
    for(int j = 0; j < gridHeight; j++){
      if(grid[i][j]){
        totalPop++;
      }
    }
  }
  //print("total population: " + totalPop + "\n");
  return totalPop;
}

void setPopBoost(int totalPop){
  // threshhold for starting population boost
  int threshhold = (int) (gridWidth * gridHeight)/thresholdParam;
  // if population is less than threshhold, set boost rule to true
  if (!populationBoost && totalPop < threshhold){
    print("enacting population boost" + "\n");
    populationBoost = true;
  }
  // if greater than threshhold, and boost is true, set it to false
  else if (populationBoost && totalPop > threshhold){
    populationBoost = false;
    print("ending populationBoost" + "\n");
  }
}
