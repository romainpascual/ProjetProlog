member(X,[X|_]).
member(X,[_|T]):- member(X,T).

supp(_,[],[]).
supp(X,[X|T],T).
supp(X,[A|T],[A|L]):-supp(X,T,L), X =\= A.

remove_litteral(L,[Clause|Clauses],Solution):-
	L is P,
	supp(P,Clause,Clause_P),
	remove_litteral(L,Clauses,[Clause_P|Solution]).
remove_litteral(L,[Clause|Clauses],Solution):-
	L is -P,
	supp(P,Clause,Clause_P),
	remove_litteral(L,Clauses,[Clause_P|Solution]).

get_unitaire([],Litteraux) :- Litteraux \== [].
get_unitaire([[X]|Clauses],Litteraux):- get_unitaire(Clauses,[X|Litteraux]).
get_unitaire([_|Clauses],Litteraux):- get_unitaire(Clauses,Litteraux).
	
polarity_positiv(L,[Clause|Clauses]):-
	L is -P,
	not(member(P,Clause)),
	polarity_positiv(L,Clauses).
	
polarity_positiv(L,[Clause|Clauses]):-
	L is P,
	member(P,Clause),
	polarity_positiv(L,Clauses).

polarity_negativ(L,[Clause|Clauses]):-
	L is P,
	not(member(P,Clause)),
	polarity_negativ(L,Clauses).
	
polarity_negativ(L,[Clause|Clauses]):-
	L is -P,
	member(P,Clause),
	polarity_negativ(L,Clauses).

	
/* Autre pt de vue*/

partage_un([H1|_],[H1|_]).
partage_un([H1|T1],[_|T2]):-partage_un([H1|T1],T2).
partage_un([_|T1],[H2|T2]):-partage_un(T1,[H2|T2]).

verif_dpll([Clause|Clauses],Solution):-
	partage_un(Clause,Solution),
	verif_dpll(Clauses,Solution).
