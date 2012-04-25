*-----------------------------------------------------------
* Program    :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
	ORG	$1000
START:				; first instruction of program
	
	MOVE.W #16000,D0	; given by task
	MOVE.W #30000,D1	; *	-	*
	ADD.W D1, D0		; *	-	*

	* GET 
	move	SR, TEMP

	lea SREG, a1		
	move #13, d0
	trap #15	

	* extract the CCR from SR
	lea     TEMP, a2	; load address from temp to a2 register
	adda    #1, a2		; increment address number to get the second byte of CCR

	* C-FLAG
	* compare first flag
	move.b	(a2), d1	; move ccr to d1 
	AND	#1, d1		; masks CFLAG with d1 and puts result to d1

	* display first flag

	move	#3, d0
	trap	#15

	* V-FLAG
	* compare second flag
	move.b	(a2), d1	; move ccr to d1 
	AND	#2, d1		; masks V-FLAG with d1 and puts result to d1
	LSR	#1, d1		; 1 shift to the right -> 2 to 1

	* display second flag
	trap	#15

	* Z-FLAG
	* compare third flag
	move.b	(a2), d1	; move ccr to d1 
	AND	#4, d1		; masks Z-FLAG with d1 and puts result to d1
	LSR	#2, d1		; 2 shift to the right -> 4 to 1

	* display third flag
	trap	#15

	* N-FLAG
	* compare fourth flag
	move.b	(a2), d1	; move ccr to d1 
	AND	#8, d1		; masks Z-FLAG with d1 and puts result to d1
	LSR	#3, d1		; 3 shift to the right -> 8 to 1
	
	* display fourth flag
	trap	#15
	
	* X-FLAG
	* compare fifth flag
	move.b	(a2), d1	; move ccr to d1 
	AND	#16, d1		; masks X-FLAG with d1 and puts result to d1
	LSR	#4, d1		; 4 shift to the right -> 16 to 1

	* display fifth flag
	trap	#15

	STOP #$2000

* Variables and Strings
TEMP DS.B 2		 ; allocate 2 byte memory to store the CCR
SREG DC.B 'cvznx', 0

	END	START		; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
