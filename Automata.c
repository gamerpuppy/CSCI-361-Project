//
//  AutoMata.c
//  CSCI 361
//
//  Created by Keegan Millard on 10/30/17.
//  Copyright © 2017 gamerpuppy. All rights reserved.
//
#define MASK_LAST 0x00000001
#define GENERATION_COUNT 16
#define RULES 0x7E

#include <stdio.h>

int generations[GENERATION_COUNT];

int nextGen(int prevGen) {
    int nextGen = 0;
    for(int i = 1; i < 31; i++) {
        int left = (prevGen >> (32-i)) & MASK_LAST;
        int middle = prevGen >> (31-i) & MASK_LAST;
        int right = prevGen >> (30-i) & MASK_LAST;
        int result = (RULES >> (left*4+middle*2+right) & MASK_LAST);
        nextGen += result << i;
    }
    return nextGen;

}

// modifys the input
void printGens(){
    int curGen = 0;
    while (curGen < GENERATION_COUNT) {
        for(int i = 0; i < 32; i++) {
            printf("%d", generations[curGen] & MASK_LAST);
            generations[curGen] = generations[curGen] >> 1;
        }
        printf("\n");
        curGen++;
    }
}

int main(int argc, const char * argv[]) {
    
    generations[0] = 0x00008000;
    for(int gen = 1; gen < GENERATION_COUNT; gen++) {
        generations[gen] = nextGen(generations[gen-1]);
    }
    printGens();
    return 0;
}




