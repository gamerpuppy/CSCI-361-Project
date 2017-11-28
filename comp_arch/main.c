/*
		Keegan Millard
		Brett Layman
		Brandom May
		~ Team 1
	*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>



extern void huff(char[], short[]);
void printCodes(short[]);

char test[] = "Hello World, this is a placeholder piece of text for "
		"before I bother writing something long enough to really test the algorithm.";

char test2[] = "EEEEEEE  DFFFFFFFF EEEE HI!";

int main(void) {

	short codes[256];
	memset(codes, '\0', 256*sizeof(short));	// sets all codes to 0

	huff(test, codes);		// call assembly
	printCodes(codes);		// print the huffman codes

	return 0;
}

void printCodes(short codes[]) {
	char string [16];
		for(int i = 0; i < 256; i+=2) {	// code
			if(codes[i+1] > 0) {// valid codes are all greater than 0 length
				int z = 0;
				for (; z < codes[i+1]; z++){
					int shift = codes[i+1]-z-1;
					string[z] = codes[i] & (1 << shift) ? '1' : '0';
				}
				string[z] = '\0';
				printf("char: %d codeL: %d code: %s\n", (char)(i/2), codes[i+1], string);
			}
		}
		return;
}




