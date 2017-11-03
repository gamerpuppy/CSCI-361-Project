// convert boolean array to decimal
long toDecimal(boolean[] bitArr){
  long decimal = 0;
  for(int i = 0; i < bitArr.length; i++){
    if (bitArr[i]){
      // was having problem with Math.pow returning innacurate float, so using loop
      long product;
      if (i == 0){
        product = 1;
      }
      else{
        product = 2;
        for (int j = 1; j < i; j++){
          product *= (long)2; // 2 ^ i
        }
      }
      decimal += product;
      //print(i + "\n");
      //print(decimal + "\n");
    }
  }
  return decimal;
}

// convert decimal to boolean array (binary), ordered from right to left (instead of usual left to right)
boolean[] toBinary(long num){
  LinkedList<Boolean> binaryQueue = new LinkedList<Boolean>();
  while (num > 0){
    long remain = (num % 2);
    binaryQueue.add(remain == 1);
    num /= 2;
  }
  boolean[] binary = new boolean[64];
  for (int i = 0; i < binary.length; i++){
    if(!(binaryQueue.size() == 0)){
      binary[i] = binaryQueue.remove();
    }
    else{
      binary[i] = false; // fill in end of array
    }
  }
  return binary;
}
