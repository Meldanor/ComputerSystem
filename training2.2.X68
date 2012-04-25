*-----------------------------------------------------------
* Description   : Converts a long word from big-endian-order to little-endian-order 
* 
* This program is public domain.
*
* Note! asterisk '*' in first column for comments
*-----------------------------------------------------------
* labels must start in first column

START	ORG	$1000	the program will load into address $1000
	
	move.l	#$00009C40,d1	
	move.l  d1,d0	
	move.l  d1,d2
* -----------------------------------------------------
* D1 contains the the 32 bit number
* The result in big-endian order should stay in d2
* The result in little-endian order should be placed in d3
* ------------ Please add your algorithm here: --------

TEMP DS.L $00000000 ; Reserve memory for swapping the bytes
	MOVE.B $1005,$100A ; swap first byte
	MOVE.B $1004,$100B ; swap second byte
	MOVE.B $1003,$100C ; swap third byte
	MOVE.B $1002,$100D ; swap fourth byte
	MOVE.L TEMP,d3

* -----------------------------------------------------
* Display Big-Endian
	move	#14,d0	load task number 14 (display null-terminated string)
	lea	textD2,a1	address of string
	trap	#15	trap #15 activates input/output task
	move.l	d2,d1	put d2 into d1
	move	#3,d0	load task number 3, it is used to display the contents of D1.L as a number
	trap	#15

* Display Little-Endian:
	move	#14,d0	task number 14 (display null string)
	lea	textD3,a1	address of string
	trap	#15	display it
	move.l	d3,d1	put d3 into d1
	move	#3,d0	task number 3 (display number in D0)
	trap	#15	display it


* Stop execution
	STOP	#$2000

*------------------------------------
* Variable storage and strings
* ds (define storage) is used to reserve memory for variables
* dc (define constant) is used to place data in memory
textD2	dc.b	'Big-Endian: ',0	null terminated string
textD3	dc.b	$d,$a,'Little-Endian: ',0	null terminated string
crlf	dc.b	$d,$a,0	carriage return & line feed, null

	END	START	end of program with start address specified


*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~8~

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
