	/*
		Keegan Millard
		Brett Layman
		Brandom May
		~ Team 1
	*/

	memBase .req x19
	firstHeap .req X20
	lastHeap .req X21
	strBase .req X22
	codeBase .req X23

	tempW .req W26
	tempX .req X26
	tempW2 .req W27
	tempX2 .req X27

	// w_idx, w_ret
	.macro GET_WEIGHT i, r
		LSL tempW, \i, #2
		LDRH \r,[memBase, tempW, UXTW]
	.endm

	// x_idx
	.macro GET_PARENT_LOC i
		SUB \i, \i , #1
		LSR \i, \i, #1
		SUB \i, firstHeap, \i
	.endm

	.macro SET_LEFT i, p
		LSL tempW, \i, #2
		ADD tempW, tempW, #3
		STRB \p, [memBase, tempw, UXTW]
	.endm

	.macro SET_RIGHT i, p
		LSL tempW, \i, #2
		ADD tempW, tempW, #2
		STRB \p, [memBase, tempw, UXTW]
	.endm

	.macro SET_WEIGHT i, w
		LSL tempW, \i, #2
		STRH \w,[memBase, tempW, UXTW]
	.endm

	.macro GET_LEFT i, r
		LSL tempW, \i, #2
		ADD tempW, tempW, #3
		LDRB \r, [memBase, tempW, UXTW]
	.endm

	.macro GET_RIGHT i, r
		LSL tempW, \i, #2
		ADD tempW, tempW, #2
		LDRB \r, [memBase, tempW, UXTW]
	.endm

	.global huff
huff:
	SUB SP, SP, #(10*8) 	// make room for savedRegs on stack
	STUR X19, [SP, #0]		// storing saved regs
	STUR X20, [SP, #8]
	STUR X21, [SP, #16]
	STUR X22, [SP, #24]
	STUR X22, [SP, #32]
	STUR X23, [SP, #40]
	STUR X24, [SP, #48]
	STUR X25, [SP, #56]
	STUR X26, [SP, #64]		// end store saved regs
	STUR X30, [SP, #72]		// store LR
	MOV strBase, X0
	MOV codeBase, X1

	MOV X1, SP				// x3 is top pointer
	SUB SP, SP, #(256*4)	// make room for character data
	MOV memBase, SP			// init nodeBase
	MOV X0, SP				// x2 is the pointer for set
	MOVN W2, #65535			// w4 should be FFFF0000 65535 is 16 1s = 1111...
set:
	STUR W2,[X0]		// stores placeholder word
	ADD X0, X0, #4		// incremenents
	CMP X0, X1 			// is countPtr less than topPtr
	B.LT set

	MOV X0, strBase		// x0 will be character ptr
count:
	LDURB W2,[X0]		// loads a byte from the string
	LSL W2, W2, #2		// holds the char * 4 to get address offset
	LDRH W3,[SP, W2, UXTW]	// loads charWeight
	ADD W3, W3, 1				// adds 1
	STRH W3,[SP, W2, UXTW]	// stores the new  weight
	ADD X0, X0, #1		// increments string
	CMP W2, WZR			// compares byte vs null
	B.GT count			// if byte is not null continue

// init vars for building heap
	SUB firstHeap, SP, #1	// init heap var
	MOV lastHeap, SP	// init last heap to -1 b/c adding element adds 1
	SUB SP, SP, #128	// make room on stack for heap
	curIdx .req W0
	topIdx .req W1
	curW .req W2
	curElem .req X3
	MOV curIdx, #-1			// w1 is curIdx
	MOV topIdx, #128		// w2 is topIdx

build:
	ADD curIdx, curIdx, #1		// increments build pointer to next loc
	CMP curIdx, topIdx			// compare curIdx and topIdx
	B.EQ build_tree				// if buildptr = top goto next step
	GET_WEIGHT curIdx, curW
	CBZ curW, build				// if weight is zero continue;
	BL heap_insert
	B build

heap_insert:
	SUB lastHeap, lastHeap, #1	//  make room on heap
	STURB curIdx,[lastHeap]			// stores pointer to huff node in heap
	MOV curElem, lastHeap		// update current element location

compare_up:
	SUBS X4, firstHeap, curElem	// first elelement_loc - this elemnentloc
	B.EQ ret_reg					// if this is first element cant compare up
	GET_PARENT_LOC X4			// gets the address of the cur parent
	LDURB W5, [X4]				// loads the parent's ptr
	GET_WEIGHT W5, W6			// gets parent's weight
	CMP W6, curW
	B.LE ret_reg			// if parent is less or eq heap is correct
// parent weight is greater than current
	STURB curIdx, [X4]		// swaps bytes in heap
	STURB W5, [curElem]		// swaps bytes in heap
	MOV curElem, X4			// cur element address is parentAddres
	B compare_up

	nodeId .req W1
	nodeW .req W3
	childId .req W4
	childW .req W5
	// curIdx, W0
	curId .req W6
	// curW, W2
	heapSize .req X7
	compIdx .req W8
	compId .req W10
	compW .req W11
	compAddr .req X12

build_tree:
	MOV nodeId, #128		//current intermediate node
build_loop:
	SUBS heapSize, firstHeap, lastHeap 	// if first heap == last heap size == 1
	CBZ heapSize, create_codes			// if size is one then the element is the root

	LDURB childId, [firstHeap]			// take left child from min heap
	LDURB curId, [lastHeap]				// load last heap element
	STURB curId, [firstHeap]			// store it at the beginning of heap
	GET_WEIGHT curId, curW				// gets weight of new first heap element
	ADD lastHeap, lastHeap, #1			// heapsize --
	MOV curIdx, #0						// heap index of current is now 0
	BL compare_dn						// call subroutine to balance heap with new element

	SET_LEFT nodeId, childId			// sets the left child of the intermediate node to the element taken from heap
	GET_WEIGHT childId, nodeW			// nodeW is now left child weight

	LDURB childId, [firstHeap]			// take left child from min heap
	LDURB curId, [lastHeap]				// load last heap element
	STURB curId, [firstHeap]			// store it at the beginning of heap
	GET_WEIGHT curId, curW				// gets weight of new first heap element
	ADD lastHeap, lastHeap, #1			// heapsize --
	MOV curIdx, #0						// heap index of current is now 0
	BL compare_dn						// call subroutine to balance heap with new element
//
	SET_RIGHT nodeId, childId			// sets the right child of the intermediate node to the element taken from heap
	GET_WEIGHT childId, childW			// gets weight of child
	ADD nodeW, nodeW, childW			// nodeW += childW
	SET_WEIGHT nodeId, nodeW			// stores nodeW as weight of the node
	MOV curIdx, nodeId					// curIdx = nodeId because we need it for heapinsert subroutine
	MOV curW, nodeW						// curW = nodeW for heapinsert
	BL heap_insert						// do heap_insert subroutine, (puts node into the heap)
	ADD nodeId, nodeId, #1				// nodeId = next empty node
	B build_loop


compare_dn:
	LSL compIdx, curIdx, #1 	// multiply heap idx by 2
	ADD compIdx, compIdx, #1	// add 1 to get left child
	SUBS XZR, heapSize, compIdx, UXTW	// is the left child out of heap size?
	B.LT ret_reg 				// heap size is less than compIdx then done
	SUB compAddr, firstHeap, compIdx, UXTW 	// address is firstloc - idx
	LDURB compId, [compAddr]			// loads the id of the comparison
	GET_WEIGHT compId, compW

	ADD tempW, compIdx, #1			// add one to the comparison idx to get the right child idx
	SUBS XZR, heapSize, tempW, UXTW	// is the right child out of heap size?
	CSEL compIdx, compIdx, tempW, LT	// if right child is out of bounds select left again
	SUB compAddr, firstHeap, compIdx, UXTW	// address is firstloc - idx
	LDURB compId, [compAddr]		// loads the id of the comparison
	GET_WEIGHT compId, tempW
	CMP compW, tempW				// compare left and right weight
	CSEL compW, compW, tempW, LE	// select leftWeight if it's weight is less or equal
	SUB tempW, compIdx, #1			// tempW now holds leftIdx, compIdx holds rightIdx
	CSEL compIdx, tempW, compIdx, LE	// select leftIdx if it's weight is less or equal

	CMP curW, compW					// compare current weight to smallest child weight
	B.LE ret_reg					// if cur weight is less or equal heap is correct so return
	SUB compAddr, firstHeap, compIdx, UXTW	// address is firstloc - idx
	SUB tempX, firstHeap, curIdx, UXTW		// get current address in temp register
	LDURB compId,[compAddr]			// loads the id of the smaller child
	STURB compId,[tempX]		// move the larger id into current heap spot
	STURB curId, [compAddr]		// store current id into higher heap location
	MOV curIdx, compIdx			// current idx is now child idx
	B compare_dn

ret_reg:
	BR X30

	cur .req W0
	code .req W1
	codeLen .req W2

create_codes:
	LDURB cur, [firstHeap]	// current node is the root off the heap
	ADD SP, SP, #128		// return space on stack for heap

	MOV code, #0			// init code
	MOV codeLen, #0			// init codeLen
	BL visit_node			// link and visit root
	B exit					// exit

visit_node:
	SUBS WZR, cur, #128		// compare current Node Idx with 128
	B.LT fill_code			// if cur is less than 128 then it is a leaf

	SUB SP, SP, #16			//  make room on stack for node info
	STUR cur, [SP, #0]
	STURH code, [SP, #4]
	STURH codeLen, [SP, #6]
	STUR X30, [SP, #8]				// store node for visiting left child

	GET_LEFT cur, cur		// replace cur with its left child
	ADD codeLen, codeLen, #1	// codeLen for next node will be codeLen+1
	BL visit_node			// link and visit

	LDUR cur, [SP, #0]
	LDURH code, [SP, #4]
	LDURH codeLen, [SP, #6]		// restore registers

	GET_RIGHT cur, cur
	MOV tempW, #1
	LSLV tempW, tempW, codeLen
	ADD code, code, tempW
	ADD codeLen, codeLen, #1	// codeLen for next node will be codeLen+1
	BL visit_node

	LDUR X30, [SP, #8]
	ADD SP, SP, #16
	BR X30

fill_code:
	LSL cur, cur, #2
	STRH code, [codeBase, cur, UXTW]
	ADD cur, cur, #2
	STRH codeLen, [codeBase, cur, UXTW]
	BR X30

exit:
	ADD SP, SP, #(256*4)	// return space on stack for main mem
	LDUR X19, [SP, #0]		// restore saved regs
	LDUR X20, [SP, #8]
	LDUR X21, [SP, #16]
	LDUR X22, [SP, #24]
	LDUR X22, [SP, #32]
	LDUR X23, [SP, #40]
	LDUR X24, [SP, #48]
	LDUR X25, [SP, #56]
	LDUR X26, [SP, #64]
	LDUR X30, [SP, #72]		// end restore saved regs
	ADD SP, SP, #(10*8)		// return space on stack for saved regs
	RET

