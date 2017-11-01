/* main.c simple program to test assembler program */

#include <stdio.h>
#define GEN_COUNT 32
#define MASK_LAST 0x1
#define INITIAL_VALUE 0x8000000
#define RULES 0x7E

extern long long int binary_search(long long int sorted[], int, int);
extern void automata(long long int [], long, long long int, int);

//extern int huffman(FILE * inFp, FILE * outFp);

int main(void) {
	//code for part 2
	long long int sorted[15] = {1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29};
	long long int value_returned = binary_search(sorted, 15, 29);
	printf("Result of binary search is %ld\n", value_returned);

	long long int generations[GEN_COUNT];
	automata(generations, GEN_COUNT * 8, INITIAL_VALUE, RULES);
	int curGen = 0;
	while (curGen < GEN_COUNT) {
		for(int i = 0; i < 64; i++)
			printf("%lli", (generations[curGen] >> (63-i)) & MASK_LAST);

		printf("\n");
		curGen++;
	}
    return 0;
}




