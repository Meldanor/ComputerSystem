*-----------------------------------------------------------
* Program    :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
	ORG $0 			;Prozessor Init
	
	DC.L $400A 		;Stackpointer initialisieren
	DC.L START 		;Adr. fuer 1. ausfuehrbaren Befehl

	ORG $2000 		;Startadresse fuer Programmcode
START:
	MOVE.L 	#$400A ,SP 	;Stackpointer init. (EASY68k)
	MOVE.L 	#1,D0 		;Testwert fuer case
	MOVE.L 	D0,-(A7) 	;Push Parameter
	BSR 	CASE 		;UP Case
	MOVE.L 	(A7)+,D1 	;Pop 	Rueckgabeparameter
	STOP 	#$2700 		;Simulator anhalten

CASE	
	MOVE.L 	D0,-(A7) 	;benutzte Register sichern
	MOVE.L 	A0,-(A7)
	MOVE.L 	12(A7),A0 	;Parameter nach A0
	MOVE.L 	#0,D0		;Initialisieren mit 0, Wertebereich grenz.
	CMP.L 	#11,A0 		;Begrenzung des Wertebereichs
	BLS.S 	USETAB 		;wenn Parameter <=11 dann USETAB
	MOVE.L 	D0,12(A7) 	;Ergebnis zurueckgeben
	MOVE.L 	(A7)+,A0 	;Register wiederherstellen
	MOVE.L 	(A7)+,D0 	;Register wiederherstellen
	RTS 			;aus Unterfunktion zurueckkehren
USETAB	MOVE.B 	Tab(A0),D0 	;Tabellenwert fuer Param. in D0
	MOVE.L 	D0,12(A7) 	;Ergebnis zurueckgeben
	MOVE.L 	(A7)+,A0 	;Register wiederherstellen
	MOVE.L 	(A7)+,D0 	;Register wiederherstellen
	RTS 			;aus Unterfunktion zurueckkehren

	ORG $1000 		;Startadresse fuer Daten
Tab 	DC.B 0,7,3,0,0,0 	;LookupTabelle
	DC.B 0,2,0,0,0,12

	END START 

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
