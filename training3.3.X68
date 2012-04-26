*-----------------------------------------------------------
* Program    :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
	ORG	$1000
START:				; first instruction of program
	MOVE	#14, D0		; Signal fuer Ausgabe
	
	LEA	NUMBER, A1	; Lade Addresse von der Zahl in A1
	MOVE.B	(A1),D1		; Verschiebe den Wert an der Addresse A1 nach D1
	CMPI	#$00,D1		; Vergleiche den Wert mit 00 
	BEQ	BE		; Springe zu BE wenn das erste byte der Zahl 00 ist
	

	LEA	LETEXT, A1	; Sprung erfolgte nicht -> Little Endian. Lade Addresse des Strings in A1
BE:	

	LEA	BETEXT, A1	; Sprung erfolgte -> Big Endian. Lade Addresse des Strings in A1
	trap	#15		; Aktiviere die Ausgabe

	MOVE.B	#9,D0		; Beende den Simulator
	TRAP	#15		; halt simulator
	
	STOP	#$2000
* Variables and Strings
NUMBER DC.L $00009C40		; Test Zahl - In BigEndian 40.000, in LittleEndian 1083965440
BETEXT DC.B 'Speicherung erfolgt in BigEndian',0
LETEXT DC.B 'Speicherung erfolgt in LittleEndian',0



	END	START		; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
