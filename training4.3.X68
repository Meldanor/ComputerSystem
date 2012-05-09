MAIN	ORG	$400		Main Program origin
	MOVEA.L	#$07FFE,SP	Initialize Stack Pointer
	MOVE.B	Base,D1		Put base number into D1
	EXT.W	D1		Sign extend base to word length
	MOVE.W	D1,-(SP)	push base B onto the stack
	CLR.W	D2		Clear D2 before loading exponent
	MOVE.B	Exp,D2		Put exponent number into D2
	MOVE.W	D2,-(SP)	push exponent E onto the stack
	* start insert	
	LEA	Result, A1	Load address of Result in A1
	MOVE.L	A1,-(SP)	Push result address on stack
	* stop insert	
	BSR	POWER		Call subroutine POWER
	ADD.L	#4,SP		resetting SP
	* removed
	STOP	#$2700		Done
	ORG	$600
Base	DC.B	4		Base number stored here
Exp	DC.B	2		Exponent number stored here
Result	DS.L	1		answer to be stored here


	ORG	$800		Subroutine POWER origin
POWER	CLR.W	D1		Clear D2 before loading exponent
	MOVE.W	10(SP),D1	copy base from stack to D1 | Modified from 6 to 10
	CLR.W	D2		Clear D2 before loading exponent
	MOVE.W	8(SP),D2	copy exponent from to D2 | Modified from 4 to 8
	* start insert	
	MOVE.L	#0,A1		Clear A1
	MOVE.L	4(SP),A1	Load Address of result in A1
	* stop insert	
	MOVE.L	#1,D3		initialize result in D3 to 1
LOOP	MULS	D1,D3		multiply result D3 with base D1
	SUB	#1,D2		decrement power in D2 by one
	BNE	LOOP		and repeat as long as power > 0
	MOVE.L	D3,(A1)		Move result into D0
	RTS			Done, return to calling program
	
	End	MAIN



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
