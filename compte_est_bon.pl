/* Auteur : Romain Pascual
Le compte est bon est un jeu qui consiste à trouver une combinaison arithmétique de nombres afin d’obtenir un certain total
*/


ajout(A,L,[A|L]).

member(X,[X|T],T).
member(X,[A|T],[A|L]):- member(X,T,L).

calcul(A,B,C,[A + B = C]):- C is (A + B).
calcul(A,B,C,[A - B = C]):- A > B, C is (A - B).
calcul(A,B,C,[B - A = C]):- A < B, C is (B - A).
calcul(A,B,C,[A * B = C]):- C is (A * B).
calcul(A,B,C,[A / B = C]):- A > B, C is (A // B), A mod B = 0, B \= 0, C=\=0.
calcul(A,B,C,[B / A = C]):- A =< B, C is (B // A), B mod 1 = 0, A \= 0, C=\=0.

compte_est_bon(Nombres, But,Expr_rev) :- 
	member(But,Nombres,_),
	reverse(Expr_rev,Expr),
	write(Expr),!. % On a trouvé la solution.
compte_est_bon(Nombres, But, Expression) :-
	member(A,Nombres,Nombres_A),
	member(B,Nombres_A,Nombres_B),
	calcul(A,B,C,Calcul),
	ajout(C,Nombres_B,Nouveaux_Nombres),
	compte_est_bon(Nouveaux_Nombres,But,[Calcul|Expression]),!.

test_choisis([]).
test_choisis([A|L]) :- A is 1, test_choisis(L).
test_choisis([A|L]) :- A is 2, test_choisis(L).
test_choisis([A|L]) :- A is 3, test_choisis(L).
test_choisis([A|L]) :- A is 4, test_choisis(L).
test_choisis([A|L]) :- A is 5, test_choisis(L).
test_choisis([A|L]) :- A is 6, test_choisis(L).
test_choisis([A|L]) :- A is 7, test_choisis(L).
test_choisis([A|L]) :- A is 8, test_choisis(L).
test_choisis([A|L]) :- A is 9, test_choisis(L).
test_choisis([A|L]) :- A is 10, test_choisis(L).
test_choisis([A|L]) :- A is 25, test_choisis(L).
test_choisis([A|L]) :- A is 50, test_choisis(L).
test_choisis([A|L]) :- A is 75, test_choisis(L).
test_choisis([A|L]) :- A is 100, test_choisis(L).

longueur([],0).
longueur([_|T],N) :- longueur(T,M), N is M + 1.

test(L) :- test_choisis(L),longueur(L,N),N is 6.

solution(Nombres,But):-
	100 < But, But < 1000,
	test(Nombres),
	compte_est_bon(Nombres,But,[]).



