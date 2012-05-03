*-----------------------------------------------------------
* Program    :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
	ORG	$1000
START:				; first instruction of program

	MOVE	#14, D0		; Print welcome message
	LEA	WELCOME, A1	; *
	TRAP	#15		; *

	MOVE.B	#4, D0		; Reader number from keyboard and store it in D1
	TRAP	#15		; *
	
	MOVE.L	D1, INPUT	; Move read number from D1 to input
	
	LSR.L	#1, D1		; Divide the input with 2 (same as one bit shift to the right) to get the limit
	MOVE.L	D1, LIMIT	; Store the limit in LIMIT
	
	MOVE.L	#2, COUNTER	; Initiate the counter with 2

LOOP:
	MOVE.L	INPUT, D1	; Store the input temponary
	MOVE.L	COUNTER, D2	; Store the counter temponary

	DIVU	D2, D1		; Divide the possible prime number with the current counter
	ANDI.L	#%1111111111111111000000000000000, D1	; Seperate the quotient from the remainder
	
	CMPI.L	#0, D1		; Check whether it has a remainder or not
	BEQ NOPRIM		; Has no remainder -> can't be a prime number
	
	ADDQ.L	#1,COUNTER	; Can be a prime number -> increase counter

	MOVE.L	COUNTER, D1
	MOVE.L	LIMIT, D2				
	CMP	D1, D2		; Is the limit reached or the counter bigger than the limit (can happen by numbers < 8)
	BLE ISPRIM		; If it is reached the number is a prime number
	
	JMP LOOP		; If not continue the Loop
ISPRIM:
	MOVE	#14, D0		; Print out it is a prime number
	LEA	ISPRIME, A1	; *
	TRAP	#15		; *
	JMP	END		; *
	
NOPRIM:	
	MOVE	#14, D0		; Print out it isn't a prime number
	LEA	NOPRIME, A1	; *
	TRAP	#15		; *
	JMP	END		; *
	
END:
	MOVE.B	#9,D0
	TRAP	#15		; halt simulator

* Variables and Strings
INPUT	DS.L 1			; Read possible number
LIMIT	DS.L 1			; Border for checking numbers - Limit = Input/2
COUNTER	DS.L 1			; The counter going from 2 to Limit

WELCOME	DC.W 'Zahl: ',0
NOPRIME DC.W 'Es ist keine Primzahl',0
ISPRIME DC.W 'Es ist eine Primzahl',0

	END	START		; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
