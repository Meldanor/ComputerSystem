*-----------------------------------------------------------
* Program    :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
	ORG	$1000
START:				; first instruction of program

	MOVE.L 	#$FFFFFFFF, ERG	; Maximaler Wert in ERG speichern
	ADDI.L	#2,ERG		; Ueberlauf erzeugen; Bei BigEndian steht dann 00 00 00 01 , bei LittleEndian 01 00 00 00
	LEA	ERG, A1		; Addresse vom ersten Byte der Zahl in A1 laden
	MOVE.B	(A1),D1		; Erstes Byte der Zahl in D1 laden
	CMPI	#$00,D1		; Erstes Byte der Zahl mit 00 vergleichen - Bei BigEndian ist das True, bei LittleEndian ist das False

	BEQ	BE		; Ist BigEndian und springe zu springe zur Ausgabe fuer BigEndian

	LEA	LETEXT, A1	; Sprung erfolgte nicht -> Little Endian. Lade Addresse des Strings in A1
	JMP	OUT
BE:	
	LEA	BETEXT, A1	; Sprung erfolgte -> Big Endian. Lade Addresse des Strings in A1
OUT:
	MOVE	#14, D0		; Signal fuer Ausgabe
	trap	#15		; Aktiviere die Ausgabe

	MOVE.B	#9,D0		; Beende den Simulator
	TRAP	#15		; halt simulator
	
	STOP	#$2000
* Variables and Strings
ERG DS.L 1
BETEXT DC.B 'Speicherung erfolgt in BigEndian',0
LETEXT DC.B 'Speicherung erfolgt in LittleEndian',0



	END	START		; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
