*-----------------------------------------------------------
* Program    :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
	ORG	$1000
START:				; first instruction of program
	LEA VAR1,A1
	MOVE.W (A1), D5 	; <.. a ) Indirekte Addressierung -> In A1 Steht eine Addresse und den Wert der Addresse in D5 laden
	MOVE.W 2(A1), D1 	; <.. b ) Indirektindizierte Addressierung -> In A1 steht eine Addresse und von dieser +2 den Wert auslesen und in D1 packen
	MOVE.W #4, D2 		; <.. c ) Unmittelbare Addressierung -> In D2 den Wert 4 schreiben
	LEA    FELD, A2
	MOVE.W (A2,D2), D3 	; <.. d ) Addresse von A2 + Wert aus D2 in D3 speichern
	MOVE.W $1000, D4 	; <.. e ) Wert von Addresse in Speicherzelle 1000 in D4 schreiben
	MOVE.B #9, D0
	TRAP #15

			; halt simulator

* Variables and Strings
VAR0 DC.W $A
VAR1 DC.W $B
VAR2 DC.W $C
FELD DC.W 0 ,1 ,2 ,3 ,4 ,5 ,6 ,7 ,8 ,9
RESULT DS.L 1

	END	START		; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
