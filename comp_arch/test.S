	.globl test
test:
	SUB SP, SP, #16
	STUR LR, [SP,#8]
	STUR X0, [SP, #0]
	mov x0, #5
	mov LR, #6
	LDUR X0, [SP, #0]
	LDUR LR,[SP,#8]
	BR X30
