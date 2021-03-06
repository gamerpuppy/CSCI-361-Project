	.globl automata
automata:
	mov x12, #0
	mov x10, #0 // byte offset = 0
	mov x8, x2	// move initiatl state into x8
make_gen:
	cmp x1, x10	// compare array size, array offset
 	b.eq exit	// exit if offset == size
 	mov x6, #62 // bit counter
	mov x9, #0	// current gen = 0
bit_loop:
	cbz x6, gen_finished
	and x11, x8, #7	// neighborhood into x11
	lsr x8, x8, #1	// shift prev gen right 1 bit
	mov x7, x3		// copy rules into x7
	cbz x11, end_shift	// if neighboorhood is 0 end shifting
shift_loop:
	lsr x7, x7, #1	// shift temp rules left 1
	sub x11, x11, #1	// subtract 1 neightborhood
	cbnz x11, shift_loop	// continue if neighborhood not 0
end_shift:
	and x7, x7, #1	// get only last bit of rules
	add x9, x9, x7	// add last bit to current gen
	lsl x9, x9, #1	// shift last gen left 1 bit
	sub x6, x6, #1	// bit idx--
	b bit_loop
gen_finished:
	add x12, x0, x10
	str x9, [x12, #0]
	mov x8, x9
	add x10, x10, #8
	b make_gen
exit:
	br	X30
