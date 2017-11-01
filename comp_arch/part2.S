	.globl binary_search
binary_search:
	mov x9, #0
	sub x1, x1, #1
loop:	// x9 start loc // x10 mid loc // x1 top loc // x11 array offset address // x12 loaded array value // x2 search term
	cmp x9, x1
	b.gt notFound 			// branch to not found if top loc is less than bottom loc
	add x10, x9, x1 		// mid = top + bottom
	lsr x10, x10, #1 		// divide mid by two
	mov x11, x10, lsl #3 	// multiply by 8 to get the byte shift
	add x11, x0, x11		// add the byte shift to the array address
	ldr x12, [x11, #0]		// load the array value at the array address
	cmp x2, x12				// if key = the array value
	b.eq found				// if eq branch to found
	b.lt less
	mov x9, x10
	add x9, x9, #1
	b loop
less:
	mov x1, x10
	sub x1, x1, #1
	b loop
notFound:
	mov x0, #-1
	br x30
found:
	mov x0, x10
	br x30
