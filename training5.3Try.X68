	ORG	$2000
* Die Matrizen etc.
MatrixA	DC.W	1,0,1,1,2,3,0,1,2	;Erste Matrix
MatrixB	DC.W	2,-2,5,3,0,-1,3,2,10	;zweite Matrix
MatrixC	DC.L	0,0,0,0,0,0,0,0,0	;Ergebnismatrix 
N	DC.L	3			;Breite/Hoehe der Matrix

*erste Schleife 0 - 8
	*zweite Schleife 0 - 2
	
	ORG	$3000
start
	MOVE.L	#$3000,SP	;Stackpointer setzen
			
	JSR	matrixMult
	
	JSR	gleichAusg	;Matrizen ausgeben
	JMP	ende



*******************************************
*******************************************
** Subprogramme fuer die Matrixmultiplikation
**
*******************************************
*******************************************

******************************************
* matrixMult multipliziert die gegebenen Matrizen
******************************************
matrixMult	nop	;ab hier bitte selbst programmieren
	
	LEA MatrixA, A1
	LEA MatrixB, A2
	LEA MatrixC, A3
	CLR.L   D3 	; D3 ist temporäres summe

	MOVE.L	(N),d5
	EXT.W 	D5

FUNC
	CLR.L 	D6
LOOP
	CLR.L	D0		; Loop um eine Zeile mit einer Spalte zu berechnen
	ADD.B 	COUNTER1, d0	
	MULS.W	D5, D0
	MULS.W	#2, D0
	MOVE.W 	(A1)+,D1		; Eine Spalte ausrechnen
	MOVE.W 	(A2,D0),D2	; 
	MULS.W 	D1,D2
	ADD.W	D2,D3

	ADDI.L	#1, D6
	CMPI.B 	#3, D6
	BNE LOOP

	EXT.L 	D3		; D3 extenden - Aus Angst vor negativen Zahlen :)
	MOVE.L	D3, (A3)+	; D3 in Matrixaddresse schubsen und matrixaddresse inkrementieren	

	SUBA.L	#6, A1		; MatrixA Pointer reseten

	ADDA.L	#2, A2		; MatrixB Pointer verschieben um 2 um auf naechste spalte zuzugreifen

	CLR.L	D3		; Reset der Temporären Summe

	ADDI.B	#1, COUNTER1	; Counter 1 inkrementieren
	CMPI.B	#3, COUNTER1	; Counter 1 checken auf 3
	BNE	FUNC		; Wenn Counter1 3 ist, dann weiter die spalte ausrechnen

	MOVE.B	#0, COUNTER1	; Spaltencounter reseten, wenn Spaltencounter 1 > 3

	ADDA.L	#6, A1		; Wenn wir eine Spalte ausgerechnet haben, rechnen wir nun eine zeile aus
	SUBA.L	#6, A2		; 

	ADDI.B	#1, COUNTER2	; Zeilencounter erhoehen
	CMPI.B	#3, COUNTER2	; Wenn Zeilencounter dimension N erreicht hat, ist alles berechnet
	BNE	FUNC

	RTS
COUNTER1 DC.B 0
COUNTER2 DC.B 0

*******************************************
*******************************************
** Hilfssubprogramme fuer die Ausgabe
** Oben benoetigte Variablen
** darunter die Subroutinen
*******************************************
*******************************************
	ORG	$4000
NrBreite	DC.W	7	;Breite pro Ergebniszahl (wird aufgefuellt, falls Zahl kleiner)
Umbr	DC.B	0,0
SPC	DC.B	' ',0
Mal	DC.B	'x',0
Gleich	DC.B	'=',0
AusgMG	DC.B	0	Ausgabe von Mal und Gleich

******************************************
* gleichAusg ist die Obersubroutine fuer die Ausgabe der Matrix-Gleichung (Einsprungpunkt)
*
* Erwartet: Matrizen entspr. der Eingangsdef.
* Funktionsweise: D4 enthaelt die Zaehlvariable (zeilennummer). Es wird gezaehlt, bis D5 erreicht ist (max Zeilen = n)
******************************************
gleichAusg	MOVEM.L D0-D7/A0-A6,-(A7)	;sichern saemtlicher Register auf Stack
	CLR.L	D4	;D4 ist Zeilenzaehler
	MOVE.L	N,D5	;N=D5=Zeilenmax.
zeilenLoop	CMP.L	D4,D5
	BEQ	ausgEnde	;Hat die Zaehlvariable D4 N erreicht, ist das Prog fertig
	BSR	zeileAusg	;Zeile Nr. (D4) ausgeben	
	ADD.L	#1,D4	;Zeilenzaehler erhoehen
	BSR	zeilenUmbr	;Zeilenumbruch nach Zeilen
	JMP	zeilenLoop	;naechste Zeile oder Ende
ausgEnde	MOVEM.L (A7)+,D0-D7/A0-A6	;wiederherstellen der Register
	RTS		;Sprungziel nach letzter Zeile


******************************************
* zeileAusg gibt eine Zeile aus (Matrixzeile, Abstand, Mtrxz., Abst., Mtrxz.)
*
* Erwartet: die auszugebende Zeilennummer in D4 (ab 0)
******************************************
zeileAusg	MOVEM.L D0-D3,-(A7)	;Hier veraenderte Register auf Stack sichern

	BSR	testMittRow	;AusgMG setzen (ob mittlere Zeile)
	*MatrixZaehler D3: 0 - Matrix 1; 1 - Matrix 2
	MOVE.L	#-1,D3
matrixLoop	ADD.L	#1,D3	;-1+1=0, startet also mit D3=0
	BSR	matrxAusg	;j. Matrix ausgeben (siehe D3)
	BSR	abstAusg	;hinter erster Matrix ggf. "x", Abstand sonst
			;hinter zweiter Matrix ggf. "=", Abstand sonst
	CMPI.L	#1,D3	;Fußgesteuerte Schleife
	BNE	matrixLoop
	
	
	
	BSR	ergMxAsg 
	
	MOVEM.L	(A7)+,D0-D3	;Hier veraenderte Register wiederherstellen
	RTS

******************************************
* matrxAusg gibt die i. Zeile der j. Matrix aus.
*
* Erwartet i in D4, j in D3
******************************************
matrxAusg 	MOVEM.L	D0-D2/D5/A3-A4,-(A7)
	CMP	#1,D3	;Fallunterscheidung Matrixauswahl. (Adresse soll in A3)
	BEQ	mxB	;Matrix #1 ist Matrix B
	BGT	mxC	;Matrix >#1 ist Matrix C
	LEA	MatrixA,A3	;sonst Matrix A
	JMP	mxWeiter
mxB
	LEA	MatrixB,A3
	JMP	mxWeiter
mxC
	LEA	MatrixC,A3
	JMP	mxWeiter
	
mxWeiter	MOVE.L	N,D2	;Adresse der Matrix ist nun in A3; weiter
	MULU	D4,D2	;Versatz durch schon ausgegebene Zeilen i*N
	MOVE.L	#0,D0	;Zaehlvariable Spalten
rowLoop	CMP.L	N,D0	;Ist Spalte N erreicht, fertig
	BEQ	rowDone
	MOVE	D2,D5	; Zeilenversatz..
	ADD	D0,D5	; + Spaltencounter ..
	ASL	#1,D5	;verdoppl. wg. wortlaenge der Matrixwerte
	MOVE	D5,A4
	ADD	A3,A4	;+ Basisadresse Matrix
	MOVE	(A4),D1	; = aktuelle Zahl
	EXT.L	D1	;Die Zahlenausgabe erwartet Long
	BSR	ausZahl2	
	ADD	#1,D0
	JMP 	rowLoop
rowDone	MOVEM.L	(A7)+,D0-D2/D5/A3-A4
	RTS

******************************************
* ergMxAsg gibt die i. Zeile der Ergebnismatrix aus.
*
* Erwartet i in D4, j in D3
******************************************
ergMxAsg 	MOVEM.L	D0-D2/D5/A3-A4,-(A7)

	LEA	MatrixC,A3	Matrixadresse in A3

	
	MOVE.L	N,D2	;Adresse der Matrix ist nun in A3; weiter
	MULU	D4,D2	;Versatz durch schon ausgegebene Zeilen i*N
	MOVE.L	#0,D0	;Zaehlvariable Spalten
eRowLoop	CMP.L	N,D0	;Ist Spalte N erreicht, fertig
	BEQ	eRowDone
	MOVE	D2,D5	; Zeilenversatz..
	ADD	D0,D5	; + Spaltencounter ..
	ASL	#2,D5	;vervierfachen. wg. doppelwortlaenge der Matrixwerte
	MOVE	D5,A4
	ADD	A3,A4	;+ Basisadresse Matrix
	MOVE.L	(A4),D1	; = aktuelle Zahl
	BSR	ausgZahl	
	ADD	#1,D0
	JMP 	eRowLoop
eRowDone	MOVEM.L	(A7)+,D0-D2/D5/A3-A4
	RTS


******************************************
* testMittRow setzt die Variable AusgMG, ob mittlere Zeile (Ausgabe von Mal und Gleich)
*
* Erwartet: akt. Zeilennr. i in D4
* Funktionsweise: N wird ganzzahlig halbiert. Annaeherung an mittlere Zeile. Vergleich mit akt. Zeilennr.
******************************************
testMittRow	MOVEM.L	D3-D4,-(A7)
	MOVE.L	N,D3
	ASR	#1,D3	;halbiere max Zeilenanzahl
	CMP	D4,D3
	BEQ	setAusgMG
	MOVE.B	#0,AusgMG
	JMP	testFertig
setAusgMG	MOVE.B	#1,AusgMG
testFertig	MOVEM.L	(A7)+,D3-D4
	RTS


******************************************
* abstAusg gibt horiz. Abstand zwischen Matrizen, "x" und "=" aus
*
* Erwartet Matrixnr. j in D3, Zeilennr. i in D4
* AusgMG zeigt an (=1), dass mittlere Zeile in Bearbeitung ist
******************************************
abstAusg	MOVEM.L	D0/A1,-(A7)
	CMP	#2,D3	;hinter der Ergebnismatrix keine Leerstellen
	BEQ	abstRet	;sondern zurueck
	BSR	ausgSP	;drei Leerzeichen ausgeben
	BSR	ausgSP
	BSR	ausgSP
	CMP.B	#1,AusgMG	;gucken, ob mittlere Zeile
	BEQ	ausgSond	;falls ja, x oder = ausgeben
	BSR	ausgSP	;sonst Leerzeichen ausgeben
	JMP	abstEnd
ausgSond	CMP	#0,D3	;entweder x oder =. Bei D3=0 x, sonst =
	BEQ	ausgX
	
	LEA	Gleich,A1	; = ausgeben
	MOVE	#14,D0
	TRAP	#15
	JMP	abstEnd
	
ausgX	LEA	Mal,A1	; x ausgeben
	MOVE	#14,D0
	TRAP	#15
	
abstEnd	BSR	ausgSP	;Leerzeichen ausgeben
	
abstRet	MOVEM.L	(A7)+,D0/A1
	RTS

******************************************
* ausgSP gibt eine Leerstelle aus
******************************************
ausgSP	MOVEM.L	D0/A1,-(A7)
	LEA	SPC,A1
	MOVE	#14,D0	Display String in (A1) 
	TRAP	#15
	MOVEM.L	(A7)+,D0/A1
	RTS

******************************************
* ausgZahl gibt eine Zahl vorzeichenbehaftet mit fester Breite aus
*
* erwartet die Zahl in D1
******************************************
ausgZahl	MOVEM.L	D0-D2,-(A7)	;Hier veraenderte Register auf Stack sichern
	MOVE.L	#20,D0	;Zahl fester Breite ausgeben
	CLR	D2	;D2 nullen
	MOVE	NrBreite,D2	;feste Breite festlegen
	TRAP	#15
	MOVEM.L	(A7)+,D0-D2	;Hier veraenderte Register wiederherstellen
	RTS

******************************************
* ausZahl2 gibt eine Zahl vorzeichenbehaftet mit fester Breite aus
*
* erwartet die Zahl in D1
******************************************
ausZahl2	MOVEM.L	D0-D2,-(A7)	;Hier veraenderte Register auf Stack sichern
	MOVE.L	#20,D0	;Zahl fester Breite ausgeben
	CLR	D2	;D2 nullen
	MOVE	#6,D2	;feste Breite festlegen (breiteste zahl -32000, also 6 zeichen)
	TRAP	#15
	MOVEM.L	(A7)+,D0-D2	;Hier veraenderte Register wiederherstellen
	RTS

******************************************
* zeilenUmbr bricht die Zeile der Bildschirmausgabe um
******************************************
zeilenUmbr	MOVEM.L	D0/A1,-(A7)
	LEA	Umbr,A1
	MOVE	#13,D0	Display nullterminierten String in (A1) 
	TRAP	#15
	MOVEM.L	(A7)+,D0/A1
	RTS

******************************************
* ende haelt den Simulator an
******************************************

ende	MOVE.B	#9,D0
	TRAP	#15	; Simulator anhalten

	END	start	; Letzte Zeile der Quelle




*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~8~
