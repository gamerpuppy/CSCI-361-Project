// generate random set of boolean rules
boolean[] genRandomRules(){
  boolean[] ruleStore = new boolean[64];
  for (int i = 0; i < 64; i++){
    int randRule = (int) random(2);
    boolean outState = (randRule == 1);
    ruleStore[i] = outState;
  }
  // to prevent overflow
  //ruleStore[63] = false;
  return ruleStore;
}

// add rules to the Hashtable
void initRules(boolean[] ruleArr){
  // for every possible state
  for (long i = 0; i < 64; i++){
    rules.put(i,ruleArr[(int)i]);
  }
  // trying to make negative numbers work by setting last binary digit to true
  rules.put((long)63,true);
  print("rule: " + toDecimal(ruleArr));
}
