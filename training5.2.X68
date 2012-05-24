*-----------------------------------------------------------
* Program    :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
	ORG	$1000
	
START	LEA 	SOURCE, A0	; SRC -> SOURCE
	LEA 	DESTIN, A1	; DEST -> DESTIN
	MOVE.B	CTSRC, D0
	EXT.W	D0
	JSR	KSP		; JUMPSR -> JSR
	MOVE	#9, D0
	TRAP	#15
	
KSP
	SUBQ	#1,D0

SCHL	
	MOVE.B	(A0)+, D1
	MOVE.B	D1, (A1)+
	DBRA	D0, SCHL	; DBRA -> DBF -> Decrement and branch as long as counter != 0
	RTS

	ORG $2000
	
SOURCE	DC.B	1, 10, 2, 20, 3, 30, 4, 40, 5, 50, 6, 60
CTSRC	DC.B	12

	ORG $3000
	
DESTIN	DS.B	1
* Variables and Strings

	END	START		; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
