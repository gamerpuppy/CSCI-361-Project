//
//  Huffman.c
//  CSCI 361
//
//  Created by Keegan Millard on 10/31/17.
//  Copyright © 2017 gamerpuppy. All rights reserved.
//
#ifndef Huffman_c
#define Huffman_c

#include <stdio.h>

#define NUM_CHARS 128
#define NULL_PTR 0

#define BYTE_TO_BINARY_PATTERN "%c%c%c%c%c%c%c%c"
#define BYTE_TO_BINARY(byte)  \
(byte & 0x80 ? '1' : '0'), \
(byte & 0x40 ? '1' : '0'), \
(byte & 0x20 ? '1' : '0'), \
(byte & 0x10 ? '1' : '0'), \
(byte & 0x08 ? '1' : '0'), \
(byte & 0x04 ? '1' : '0'), \
(byte & 0x02 ? '1' : '0'), \
(byte & 0x01 ? '1' : '0')

typedef struct huff_Node{
    struct huff_Node * left;
    struct huff_Node * right;
    unsigned short weight;
    char character;
} HuffNode;

typedef struct {
    unsigned short code;
    int codeLen;
} Code;

char testText[] = "This is a test piece of text that is being used because the DS-5 simulator is dumb as balls";

HuffNode nodeMem[NUM_CHARS*3];
Code codes[NUM_CHARS];

void countChars(char[]);
int buildHeap(HuffNode *[]);
void buildHeapNode(HuffNode *, char, short, HuffNode *, HuffNode *);
void heapInsert(HuffNode *[], int);
HuffNode * buildTree(HuffNode *[], int);
void compareDown(HuffNode * [], int, int);
void fillCodes(HuffNode * cur, unsigned short code, int codeLen);
int encode(char source[], unsigned long long dest[]);
void decode(unsigned long long [], HuffNode *);
char getCodeHelper(HuffNode *, unsigned long long, int);


int main(int argc, const char * argv[]) {
    countChars(testText);
    HuffNode * heap[NUM_CHARS];
    int heapSize = buildHeap(heap);
//    for(int heapIdx = 0; heapIdx < heapSize; heapIdx++) {
//        printf("heap[%d] char: %c weight: %d\n", heapIdx, heap[heapIdx]->character, heap[heapIdx]->weight);
//    }
    HuffNode * root = buildTree(heap, heapSize);
    fillCodes(root, 0, 0);
    unsigned long long outArr[sizeof(testText)/8 + 1];
    printf("Printing Codes\n");
    for (int i = 0; i < NUM_CHARS; i++) {
        if (codes[i].codeLen > 0)
            printf("codes[%d] char: %c weight: %d codeLen: %d code: "BYTE_TO_BINARY_PATTERN"\n", i, i, nodeMem[i].weight, codes[i].codeLen, BYTE_TO_BINARY((char)codes[i].code));
    }
    
    int numOutLines = encode(testText, outArr);
    
    
    for (int outIdx = 0; outIdx <= numOutLines; outIdx++) {
        printf("%lli\n", outArr[outIdx]);
    }
    printf("Size of input: %d\n", sizeof(testText));
    printf("Size of output: %d\n", numOutLines*8);
    decode(outArr, root);
    printf("\n");
}

void decode(unsigned long long codedSource[], HuffNode * root) {
    int sourceIdx = 0;
    int wordIdx = 0;
    unsigned long long curCode = 0;
    int curLen = 0;
//    int maxCodeLen = 7;
    while (1) {
        if (wordIdx > 63) {
            wordIdx = 0;
            sourceIdx += 1;
        }
        // TODO build current code right to left so we can shift off one bit to get branch dir
        unsigned long long curDigit = (codedSource[sourceIdx] >> (63-wordIdx)) & 0x1;
        curCode = curCode + (curDigit << curLen);
        curLen++;
        wordIdx++;
        char codeChar = getCodeHelper(root, curCode, curLen);
        if (codeChar != 0xF) {
            if(codeChar == 0x0)
                return;
            printf("%c", codeChar);
            curCode = 0;
            curLen = 0;
        }
    }
}

char getCodeHelper(HuffNode * cur, unsigned long long curCode, int codeLen) {
    if(cur->character == 0xF) {
        if (codeLen == 0)
            return 0xF;
        else {
            if ((curCode & 0x1) == 1)
                return getCodeHelper(cur->right, curCode >> 1, codeLen-1);
            else
                return getCodeHelper(cur->left, curCode >> 1, codeLen-1);
        }
    } else {
        return cur->character;
    }
}

int encode(char source[], unsigned long long dest[]) {
    int sourceIdx = 0;
    int destIdx = 0;
    int wordIdx = 0;
    while (1) {
        Code * code = &codes[source[sourceIdx]];
        unsigned long long codeTemp = code->code;
        for(int codeIdx = 0; codeIdx < code->codeLen; codeIdx++) {
            if (wordIdx > 63) {
                wordIdx = 0;
                destIdx++;
            }
            dest[destIdx] += (codeTemp & 0x1) << 63-wordIdx;
            codeTemp = codeTemp >> 1;
            wordIdx++;
        }
        if (source[sourceIdx] == '\0')
            return destIdx;
        
        sourceIdx++;
    }
    return destIdx;
}

void fillCodes(HuffNode * cur, unsigned short code, int codeLen) {
    if (cur->character == 0xF) { // NOT A LEAF
        fillCodes(cur->left, code, codeLen+1);
        fillCodes(cur->right, code + (1 << codeLen), codeLen+1);
    } else {
        codes[cur->character].code = code;
        codes[cur->character].codeLen = codeLen;
    }
}

HuffNode * buildTree(HuffNode * heap[], int size) {
    int memIdx = NUM_CHARS;
    while(size > 1) {
        nodeMem[memIdx].character = 0xF;
        nodeMem[memIdx].left = heap[0];
        heap[0] = heap[size-1];
        size--;
        compareDown(heap, size, 0);
        nodeMem[memIdx].right = heap[0];
        nodeMem[memIdx].weight = nodeMem[memIdx].right->weight + nodeMem[memIdx].left->weight;
        heap[0] = &nodeMem[memIdx];
        compareDown(heap, size, 0);
        memIdx++;
    }
    return heap[0];
}

void compareDown(HuffNode * heap[], int size, int idx) {
    int leftIdx = idx*2+1;
    int rightIdx = idx*2+2;
    int smallestIdx;
    
    if (leftIdx < size) {
        if (rightIdx < size && heap[rightIdx]->weight < heap[leftIdx]->weight)
                smallestIdx = rightIdx;
        else
            smallestIdx = leftIdx;
    } else if (rightIdx < size) {
        smallestIdx = rightIdx;
    } else {
        return;
    }
    
    if (heap[smallestIdx]->weight < heap[idx]->weight) {
        HuffNode * temp = heap[idx];
        heap[idx] = heap[smallestIdx];
        heap[smallestIdx] = temp;
        compareDown(heap, size, smallestIdx);
    }
}


int buildHeap(HuffNode * heap[]) {
    int size = 0;
    for (int i = 0; i < NUM_CHARS; i++) {
        if (nodeMem[i].weight == 0) continue;
        heap[size] = &nodeMem[i];
        heapInsert(heap, size);
        size++;
    }
    return size;
}
         
void heapInsert(HuffNode * heap[], int idx) {
    if (idx > 0) {
        int parentIdx = (idx-1)/2;
        HuffNode * parent = heap[parentIdx];
        HuffNode * this = heap[idx];
        if ( parent->weight > this->weight) {
            heap[parentIdx] = this;
            heap[idx] = parent;
            heapInsert(heap, parentIdx);
        }
    }
}


void countChars(char arr[]) {
    int i = 0;
    while (arr[i] != '\0') {
        char charAtIdx = arr[i];
        nodeMem[charAtIdx].character = charAtIdx;
        nodeMem[charAtIdx].weight += 1;
        i++;
    }
    nodeMem[0].character = '\0';
    nodeMem[0].weight = 1;
}

#endif
