#include "stdio.h"
// global constants
#define RULE_SIZE 8 // always 8 possible neighborhoods, so 8 rules
// inputs to our program:
#define GEN_SIZE 39 // size of a population in a given generation
#define TOTAL_GENS 30 // number of generations run before result is printed



// function prototypes
int* run(int firstGen[], int ruleSet[]);
void copyInto(int arr1[], int arr2[]);
void printArr(int arr[], int n);
int getNext(int left, int middle, int right, int rules[]);
int equals(int arr1[3], int arr2[3]);

int main() {
  // first generation and rule set (also inputs to the algorithm)
  int firstGen[GEN_SIZE] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
  int ruleSet[RULE_SIZE] = {0,1,1,1,1,1,1,0};
  // process subsequent generations, and return last generation (our algorithm)
  int* finalGen = run(firstGen, ruleSet);
  return 0;
}

int* run(int firstGen[], int ruleSet[]){
  printArr(firstGen, GEN_SIZE);
  // array to store next generation
  int secondGen[GEN_SIZE];
  // first and last elements equal zero by default, and don't get updated (unless we make edge rules)
  secondGen[0] = 0;
  secondGen[GEN_SIZE -1] = 0;
  // loop for each generation (I used while loops to make it more like assembly)
  int i = 0;
  while (i < TOTAL_GENS) {
    // for every element in that particular generation
    int j = 1;
    while( j < GEN_SIZE -1) {
      // use getNext to compute next generation
      int next = getNext(firstGen[j-1], firstGen[j], firstGen[j+1], ruleSet);
      secondGen[j] = next;
      j++;
    }
    // secondGen becomes the new firstGen
    copyInto(firstGen, secondGen);
    printArr(firstGen, GEN_SIZE);
    i++;
  }
  printf("\n");
  return firstGen;
}

// uses rules to determine next generation
int getNext(int left, int middle, int right, int rules[]){
  	int next; // value for middle index in the next generation
  	int neighborhood = left*4+middle*2+right;
	next = rules[neighborhood];
  return next;
}

// helper method to see if two arrays are equal
int equals(int arr1[3], int arr2[3]){
  int equal = 1;
  for (int i = 0; i < 3; i++) {
    if(arr1[i] != arr2[i]){
      equal = 0;
    }
  }
  return equal;
}

// copy arr2 into arr1
void copyInto(int arr1[], int arr2[]){
  for (int i = 0; i < GEN_SIZE; i++) {
    arr1[i] = arr2[i];
  }
}

// for verifying the algorithm (this won't be part of our assembly code)
void printArr(int arr[], int n){
  printf("\n");
  for (int i = 0; i < n; i++) {
    printf("%d ", arr[i]);
  }
}
