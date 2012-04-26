*-----------------------------------------------------------
* Program    :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
	ORG	$1000	Start an Position $1000
Start: 	CLR.L	D0	Register D0 loeschen
	CLR.L	D1
	Move.W	#0,Count
	Move.L	#0,Erg		
	LEA	Count,A0
	LEA	Array,A1	Effektive Adresse von Array nach A1
	LEA	Erg,A2

* Hier soll die Berechnung des Mittelwertes erfolgen:
	LEA	Array,A3	; Effektive Addresse vom Array in A3 ablegen
	MOVE.B	(A3), Erg
	ADDA	#1, A3
	ADDI	#1,Count

LOOP:
	MOVE.B	Erg,D2
	ADD.B	(A3), D2
	MOVE.B	D2, Erg
	ADDA	#1,A3
	ADDI	#1,Count
	MOVE.B	(A3),D2
	CMPI	#0,D2
	BNE	LOOP
	
	MOVE.B	Erg, D4
	MOVE.B	1(A0), D5
	DIVS	D5,D4
	MOVE.B	D4, Erg

* Ausgabe des Mittelwertes:
	move	#14,d0	
	lea	ErgStr,a1
	trap	#15	Text anzeigen
	move.b	Erg,d1	
	move	#3,d0	
	trap	#15	Dezimalwert anzeigen
* Ausfuehrung stoppen
	STOP	#$2000

* Variablen und Kostanten
	ORG	$2000
Count:	DS.B	1
Erg:	DS.L	1
ErgStr:	DC.B	'Der Mittelwert ist: ',0
Array:	DC.B	1,-4,5,9,-2,3,-8,7,8,2,4,-7,-3,4,6,9,5,3,0	(Null gibt Ende an)

	End	Start



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
