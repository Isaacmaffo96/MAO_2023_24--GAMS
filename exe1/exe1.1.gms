$Title Pianificazione della produzione

$Ontext
Soluzione dell'esercizio 1 (Modelli 1)
*** Punto a)
Produzione in Serie
    xj                     xj
MP --> A --> B --> C --> D --> PF
$Offtext

Sets
 J insieme dei prodotti /P1*P4/
 I insieme dei reparti /A*D/
;
* Plurale se son pi� di uno o singolare se singolo
Parameters
 D(j) domanda del prodotto j
/
P1 800
P2 750
P3 600
P4 500
/

 Pr(j) profitto unitario di j
/
P1 30
P2 40
P3 20
P4 10
/

 Pen(j) penalit� unitaria di j
/
P1 15
P2 20
P3 10
P4  8
/
;

Scalar C capacit� [h] dei reparti /1000/ ;

* Table sempre singolare perch� bisogna definire ogni matrice di input
* con un proprio comando Table
Table tl(i,j) tempo di lavorazione di j in i
    P1   P2   P3   P4
A  0.3  0.3 0.25 0.15
B 0.25 0.35  0.3  0.1
C 0.45  0.5  0.4 0.22
D 0.15 0.15  0.1 0.05
;
* � necessario l'allineamento
* carattere decimale � il punto (.)
* la virgola (,) � il carattere separtore

$Ontext
Table � per matrici con dati
Parameter � per matrici che rielaborano i dati
* esempio:
Parameter tl_min(i,j) tempo lav. in minuti ;
tl_min(i,j) = tl(i,j)*60 ;
$Offtext

Variables
 x(j) Quantit� di j prodotta
 s(j) Domanda di j non soddisfatta
 z    Variabile obiettivo (Profitti totali)
;

* dominio di appartenenza
Positive Variables x,s ;
* z � libera

Equations
 obiettivo  Funzione obiettivo
 cap(i)     Vincolo di capacit� nel reparto i
 dom(j)     Vincolo di domanda per il prodotto j
;

obiettivo.. z =e= sum(j,Pr(j)*x(j)) - sum(j,Pen(j)*s(j)) ;
cap(i)..  sum(j,tl(i,j)*x(j)) =l= C ;
dom(j)..  x(j) + s(j) =e= D(j) ;

$Ontext
Vincolo  "=" ---> "=e="
Vincolo "<=" ---> "=l="
Vincolo ">=" ---> "=g="

Vincolo "<" ---> Non modellabile (Non lineare)
$Offtext

* Modello ha nome e insieme di vincoli
* Model Production /obiettivo,cap,dom/;
Model Production /all/ ;
Solve Production using LP maximizing z ;

Scalar Xtot Produzione totale ;
Xtot = sum(j,x.l(j)) ;

Parameter Sat(i) Saturazione nel reparto i ;
Sat(i) = sum(j,tl(i,j)*x.l(j)) / C ;

*x.l ---> Accedere al "Level" della variabile x (i.e., livello ottimo)

Display Xtot,Sat,x.l,s.l,z.l ;

* Controllare nel file di log: ***Status: Normale completion

***Punto b)
$OnText
Produzione in Parallelo
 yA,j |-> A -| yA,j
      |-> B -|
MP ---+-> C -+--> PF (--> sum(i,Yi,j) )
      |-> D -|
$OffText
Positive Variables y(i,j) Produzione di j nel reparto i ;

Equations
 obiettivo_b  Funzione obiettivo al punto b
 cap_b(i)     Vincolo di capacit� nel reparto i al punto b
 dom_b(j)     Vincolo di domanda per il prodotto j al punto b
;

obiettivo_b.. z =e= sum(j,Pr(j)*sum(i,y(i,j))) - sum(j,Pen(j)*s(j)) ;
cap_b(i)..  sum(j,tl(i,j)*y(i,j)) =l= C ;
dom_b(j)..  sum(i,y(i,j)) + s(j) =e= D(j) ;

Model Production_b /obiettivo_b,cap_b,dom_b/ ;
Solve Production_b using LP maximizing z ;

Scalar Ytot Produzione totale ;
Ytot = sum(j,sum(i,y.l(i,j))) ;

Parameter Sat2(i) Saturazione nel reparto i ;
Sat2(i) = sum(j,tl(i,j)*y.l(i,j)) / C ;

Display Ytot,Sat2,y.l,s.l,z.l ;




