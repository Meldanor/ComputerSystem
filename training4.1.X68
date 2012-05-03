*-----------------------------------------------------------
* Program    :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
	ORG	$1000
START:				; first instruction of program

	MOVE	#13, D0		; Display "Enter Your Name:"
	LEA	COMMAND, A1	; *
	TRAP	#15		; *

	MOVE.B	#2, D0		; Starte das einlesen 
	LEA	NAME, A1	; Signalisiere dass die Eingabe ab Addresse von Name gespeichert wird
	TRAP	#15		; Beginne das Einlesen
	
	MOVE	#14, D0		; Display "Hello"
	LEA	WELCOME, A1	; *
	TRAP	#15		; *
	
	MOVE	#1, D0		; Display the name
	LEA	NAME, A1	; *
	TRAP	#15		; *

	MOVE.B	#9,D0
	TRAP	#15		; halt simulator

* Variables and Strings
NAME	DS.W    80
COMMAND	DC.W	'Enter your name:',0
WELCOME	DC.W	'Hallo ',0

	END	START		; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
