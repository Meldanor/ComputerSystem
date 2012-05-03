	ORG	$1000	Start an Position $1000
Start: 	CLR.L	D0	Register D0 loeschen
	CLR.L	D1
	Move.W	#0,Count	
	Move.L	#0,Erg		
	LEA	Count,A0
	LEA	Array,A1	Effektive Adresse von Array nach A1
	LEA	Erg,A2

* Hier soll die Berechnung des Mittelwertes erfolgen:
	Move.B  (A1),Erg
        Adda    #1,A1
        Add     #1,Count
       
LOOP:   Move.B  Erg,D2
        Move.B  (A1),D3
        Add.B   D3,D2
        Move.B  D2,Erg
       	Adda    #1,A1
        Add     #1,Count
        Move.B  (A1),D2
        Cmpi    #0,D2
        Bne     loop
       
       	Move.L	#0,D4
        Move	Erg,D4
        Move	Count,D5
        Divs    D5,D4
        Move.B  D4,Erg
        
* Ausgabe des Mittelwertes:
	move	#14,d0	
	lea	ErgStr,a1
	trap	#15	Text anzeigen
	move.l	Erg,d1	
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
