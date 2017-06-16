/* Auteur : Valentin Noel et Romain Pascual

Le compte est bon est un jeu qui consiste à trouver une combinaison arithmétique de nombres afin d’obtenir un certain total. On résout le jeu en gérérant toutes les expressions arithmétiques à partir de la liste de départ puis en cherchant celles qui fournissent l'objectif désiré.

On peut ensuite chercher la meilleure solution en cherchant, dans l'ensemble des solutions une contenant le moins d'opérations.

Enfin on peut chercher une solution approchée par défaut ou par excès s'il est impossible de trouver un compte exacte.
*/

/* Manipulation des listes*/
% head (?A, ?L, ?L2) : L2 est la liste ayant pour tête A et pour queue L 
% Utilisé pour ajouter un élémént en tête de liste.
head(A,L,[A|L]).

% element(?A, ?L, ?L2) : L est la liste L2 à laquelle on a enlevé A
% Utilisé pour selectionner un élément dans une liste et vérifier l'appartenance d'un élément à la liste.
element(X,[X|T],T).
element(X,[A|T],[A|L]):- element(X,T,L).

% longueur(+L, ?N) :  N est la longueur de la liste L
longueur([],0).
longueur([_|T],N) :- longueur(T,M), N is M + 1.

% plus_courte_liste(+LL, +L, ?L*) : L* est la plus petite liste de la liste de liste LL, L est un élément utilisé comme comparateur (la plus petite liste trouvée pour l'instant).
plus_courte_liste([],M,M).
plus_courte_liste([A|L],M,N) :-
	longueur(A,LA), longueur(M,LM), LA < LM,
	plus_courte_liste(L,A,N),!.
plus_courte_liste([_|L],M,N) :- plus_courte_liste(L,M,N).


/* Modélisation du compte est bon */
% calcul(?A, ?B, ? C, ?Op) : C est le résultat de A Op B avec Op un opérateur arithmétique (+,-,*,/)
calcul(A,B,C,+):- C is (A + B).
calcul(A,B,C,-):- A > B, C is (A - B).
calcul(A,B,C,-):- A < B, C is (B - A).
calcul(A,B,C,*):- C is (A * B).
calcul(A,B,C,/):- A > B, C is (A // B), A mod B = 0, B \= 0, C=\=0.
calcul(A,B,C,/):- A =< B, C is (B // A), B mod 1 = 0, A \= 0, C=\=0.

% compte_est_bon(+Nombres, +But, +Liste, ?Calcul) : Calcul est la liste des opérations arithmétiques sur les nombres de la liste Nombres pour obtenir Bu. Liste contient les calculs déjà effectués, donc dans l'ordre inverse au calcul.
compte_est_bon(Nombres, But, List_calculs, Calcul) :- 
	element(But,Nombres,_), % On a trouvé une solution.
	reverse(List_calculs, Calcul).
	
compte_est_bon(Nombres, But, List_calculs, Calcul) :-
	element(A,Nombres,Nombres_A),
	element(B,Nombres_A,Nombres_B),
	calcul(A,B,C,Op),
	head(C,Nombres_B,Nouveaux_Nombres),
	compte_est_bon(Nouveaux_Nombres,But,[calcul(A,B,C,Op)|List_calculs], Calcul).

/* Vérification des contraintes sur la liste de départ */
% test_choisis(+L) : vérifie que les nombres de la liste L appatiennent à {1,2,3,4,5,6,7,8,9,10,25,50,75,100}.
test_choisis([]).
test_choisis([A|L]) :-
	element(A, [1,2,3,4,5,6,7,8,9,10,25,50,75,100],_),
	test_choisis(L).


% test_liste(+L) : vérifie que la loste L contient 6 nombres et qu'ils sont corrects.
test_liste(L) :- test_choisis(L), longueur(L,N), N is 6.

/* Vérification du but : compris entre 100 et 1000 */
test_but(B) :- 100 < B, B < 1000.

/* Appels aux solutions */
% write_calcul(+calcul) : affiche un calcul à l'écran.
write_operation(calcul(A,B,C,Op)) :-
	write(A), write(' '), write(Op), write(' '),
	write(B), write(' = '), write(C).

% write_solution(+Liste_calculs) : affiche la liste des calculs à l'écran.
write_calcul([]).
write_calcul([Calcul|L]):- write_operation(Calcul),nl,write_calcul(L).

% get_solution(+Nombres, +But, ?Calcul) : les opérations décrites dans Calcul permettent de trouver une solution pour obtenir But à partir des nombress de la liste Nombre
get_solution(Nombres,But,Calcul):-
	test_but(But),
	test_liste(Nombres),
	compte_est_bon(Nombres,But,[],Calcul).
	
% solution(+Nombres, +But) : Ecriture des solutions pour les nombres de la liste Nombre et l'objectif But.
solution(Nombres,But):-
	test_but(But),
	test_liste(Nombres),
	compte_est_bon(Nombres,But,[],Calcul),
	write('Le compte est bon.'), nl,
	write_calcul(Calcul), nl.
	
% get_solution(+Nombre, +But, ?Calcul) : les opérations décrites dans Calcul permettent de trouver la meilleure solution pour obtenir But à partir des nombress de la liste Nombre
get_meilleure_solution(Nombres, But, Calcul) :-
	test_but(But),
	test_liste(Nombres),
	findall(X, compte_est_bon(Nombres, But, [], X), L),
	L = [H|T],
	plus_courte_liste(T,H,Calcul),
	element(Calcul,L,_).
	
% meilleure_solution(+Nombres, +But) : Ecriture de la meilleure solution pour les nombres de la liste Nombre et l'objectif But.
meilleure_solution(Nombres, But) :-
	get_meilleure_solution(Nombres, But, Calcul),
	write('Le compte est bon.'), nl,
	write_calcul(Calcul).

% approchee(+Nombres, +But, +Erreurs_tolerees, ?Calcul) : Cherche le meilleur Calcul approché de l'objectif But avec les nombres de la liste Nombre avec comme listes d'erreurs possibles Erreurs_tolorees (ce sont les erreurs relatives et non les nouveaux objectifs). 
approchee(Nombres, But, Erreurs_tolerees, Calcul):-
	head(Erreur, _, Erreurs_tolerees),
	Valeur_moins is But - Erreur,
	100 < Valeur_moins,
	get_meilleure_solution(Nombres,Valeur_moins,Calcul),!.
approchee(Nombres, But, Erreurs_tolerees, Calcul):-
	head(Erreur, _, Erreurs_tolerees),
	Valeur_plus is But + Erreur,
	Valeur_plus < 1000,
	get_meilleure_solution(Nombres, Valeur_plus, Calcul),!.
approchee(Nombres, But, Erreurs_tolerees, Calcul):-
	head(_, Nouvelles_erreurs, Erreurs_tolerees),	
	approchee(Nombres, But, Nouvelles_erreurs, Calcul).

% meilleure_solution_approchee(+Nombres, +But, + Erreur_toleree) : Ecriture de la meilleure solution pour les nombres de la liste Nombre et l'objectif But avec Erreur_toleree comme erreur maximale tolérée vis à vis de l'objectif.
meilleure_solution_approchee(Nombres, But, Erreur_toleree) :-
	test_but(But),
	test_liste(Nombres),
	findall(X,between(0, Erreur_toleree, X), Erreurs_tolerees),
	approchee(Nombres, But, Erreurs_tolerees, Calcul),
	write("Le compte n'est pas bon, la meilleure solution trouvée est :"),nl,
	write_calcul(Calcul).
	
