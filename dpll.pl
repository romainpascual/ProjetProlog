/* Auteur : Valentin Noel et Romain Pascual

Problème de satisfiabilité de contraintes modélisé avec l'algorithme DPLL qui prend en entrée une formule mise sous forme normale conjonctive. Cette formule sera manipulée comme une liste de clauses elles mêmes manipulés comme des listes.

Les variables sont manipulées à l'aide d'entiers, positifs s'il s'agit de variables et négatifs pour les négations de variables.

Exemple de Fnc pour tester :
[[1,2,-3,-4],[-5],[-1,-2,3,5],[1,3,-4],[2],[6,5],[2,-4,6]]

[[27,28,29,30,31],[32,33,34,35,36],[37,38,39,40,41],[42],[43,44,45],[46,47,48,49,50],[51,52,53,54,55],[56,57,58],[59,60,61, 62],[63,64],[65,66,67],[68,69,70,71,72],[73,74],[75,76,77,78],[-27,-31],[-29,-27],[-28,-27],[-30,-27],[-29,-31],[-28,-31],[-30,-31],[-29,-28],[-30,-29],[-30,-28],[-35,-33],[-35,-36],[-35,-34],[-35,-32],[-33,-36],[-34,-33],[-33,-32],[-34,-36],[-32,-36],[-34,-32],[-37,-40],[-39,-40],[-41,-40],[-38,-40],[-39,-37],[-37,-41],[-38,-37],[-39,-41],[-39,-38],[-38,-41],[-43,-45],[-44,-45],[-44,-43],[-47,-50],[-48,-47],[-47,-46],[-49,-47],[-48,-50],[-46,-50],[-49,-50],[-48,-46],[-49,-48],[-49,-46],[-53,-52],[-53,-55],[-54,-53],[-53,-51],[-52,-55],[-54,-52],[-52,-51],[-54,-55],[-51,-55],[-54,-51],[-57,-56],[-57,-58],[-56,-58],[-59,-62],[-60,-62],[-62,-61],[-60,-59],[-59,-61],[-60,-61],[-64,-63],[-66,-65],[-66,-67],[-65,-67],[-68,-72],[-70,-68],[-69,-68],[-71,-68],[-70,-72],[-69,-72],[-71,-72],[-70,-69],[-71,-70],[-71,-69],[-73,-74],[-78,-77],[-77,-75],[-77,-76],[-78,-75],[-78,-76],[-76,-75],[-35,-27],[-33,-27],[-35,-31],[-33,-31],[-36,-31],[-35,-29],[-29,-33],[-29,-36],[-34,-29],[-35,-28],[-33,-28],[-28,-36],[-34,-28],[-32,-28],[-35,-30],[-30,-33],[-30,-36],[-30,-34],[-30,-32],[-35,-40],[-35,-37],[-33,-40],[-33,-37],[-39,-33],[-36,-40],[-37,-36],[-39,-36],[-41,-36],[-34,-40],[-34,-37],[-34,-39],[-34,-41],[-34,-38],[-32,-40],[-32,-37],[-39,-32],[-32,-41],[-38,-32],[-53,-47],[-52,-47],[-53,-50],[-52,-50],[-55,-50],[-53,-48],[-48,-52],[-48,-55],[-54,-48],[-53,-46],[-52,-46],[-46,-55],[-54,-46],[-51,-46],[-49,-53],[-49,-52],[-49,-55],[-49,-54],[-49,-51],[-66,-68],[-66,-72],[-66,-70],[-66,-69],[-65,-68],[-65,-72],[70,-65],[-65,-69],[-71,-65],[-68,-67],[-72,-67],[-70,-67],[-69,-67],[-71,-67],[1,-27],[2,-31],[3,-29],[4,-28],[-30,5],[-35,1],[2,-33],[3,-36],[-34,4],[-32,5],[1,-40],[2,-37],[-39,3],[4,-41],[-38,5],[-42,6],[-42,7],[-42,8],[9,-42],[10,-42],[11,-45],[12,-45],[13,-45],[12,-43],[13,-43],[-43,14],[-44,13],[-44,14],[-44,15],[-47,16],[17,-50],[-48,18],[19,-46],[-49,20],[-53,16],[-52,17],[18,-55],[-54,19],[20,-51],[-57,21],[-57,22],[-57,23],[-56,22],[-56,23],[24,-56],[23,-58],[24,-58],[25,-58],[1,-62],[6,-62],[6,-59],[11,-59],[-60,11],[-60,16],[16,-61],[21,-61],[2,-63],[-63,7],[12,-63],[-63,17],[-64,7],[-64,12],[-64,17],[-64,22],[-66,3],[-66,8],[-66,13],[-65,8],[13,-65],[-65,18],[13,-67],[18,-67],[-67,23],[3,-68],[8,-72],[13,-70],[-69,18],[-71,23],[4,-73],[9,-73],[-73,14],[19,-73],[9,-74],[14,-74],[19,-74],[24,-74],[-77,5],[10,-77],[10,-78],[-78,15],[-75,15],[20,-75],[20,-76],[25,-76],[27,-1,35,40],[37,33,-2,31],[-3,29,39,36],[-4,28,34,41],[-5,32,38,30],[-6,42],[42,-7],[42,-8],[42,-9],[42,-10],[-11,45],[43,-12,45],[43,-13,45,44],[43,44,-14],[44,-15],[47,53,-16],[-17,52,50],[-18,48,55],[46,-19,54],[51,-20,49],[-21,57],[56,57,-22],[56,57,-23,58],[56,-24,58],[-25,58],[-1,62],[63,-2],[68,-3,66],[73,-4],[-5,77],[59,-6,62],[63,64,-7],[65,72,66,-8],[73,-9,74],[77,78,-10],[59,-11,60],[64,63,-12],[65,-13,66,70,67],[73,74,-14],[75,78,-15],[60,61,-16],[-17,63,64],[-18,65,69,67],[73,-19,74],[75,76,-20],[-21,61],[64,-22],[71,-23,67],[-24,74],[76,-25]]

*/
% is_empty(+L) : détermine si la liste L est vide.
is_empty([]).

% head (?A, ?L, ?L2) : L2 est la liste ayant pour tête A et pour queue L 
% Utilisé pour ajouter un élémént en tête de liste.
head(A,L,[A|L]).

% element(?A, ?L, ?L2) : L est la liste L2 à laquelle on a enlevé A
% Utilisé pour selectionner un élément dans une liste et vérifier l'appartenance d'un élément à la liste.
element(X,[X|T],T).
element(X,[A|T],[A|L]):- element(X,T,L).

% unique_occurrence(+L,?L2) : L2 est la liste L privée de ses doublons
unique_occurrence([],[]).
unique_occurrence([X|L], L2) :- element(X,L,_), unique_occurrence(L,L2),!.
unique_occurrence([X|L], [X|L2]) :- unique_occurrence(L,L2).

% unique_par_clause(+LL, ? LL2) : LL2 est la liste des listes de LL privées de leur doublons
unique_par_clause([],[]).
unique_par_clause([A|L],[B|L2]) :- unique_occurrence(A,B), unique_par_clause(L,L2).

% union(+L1, ?L2, ?L3) : L3 est obtenue en ajoutant à L2 les éléments de L1 qui ne sont pas déjà dans L2.
union([],L2,L2) :- !.
union(L,[],L):- !.
union([X|L1], L2, L3) :- element(X,L2,_), union(L1,L2,L3),!.
union([X|L1], L2, [X|L3]) :- union(L1,L2,L3).

% get_litteraux(+Fnc, ?Litt) :  Litt est la liste des littéraux présents dans la Fnc. 
get_litteraux([],[]).
get_litteraux([Clause|Fnc], Liste_litt) :-
	get_litteraux(Fnc, Nouvelle_liste_litt),
	union(Clause, Nouvelle_liste_litt, Liste_litt).

% enleve_litt(Clause, Litt, Clause2) : Clause2 est obtenue en affectant la valuation décrite par Litt à Clause.
enleve_litt(Clause, [], Clause).
enleve_litt(Clause, [A|_], []) :- integer(A), element(A,Clause,_),!.
enleve_litt(Clause, [A|_], Clause_sans_B) :- integer(A), B is -A, element(B,Clause,Clause_sans_B),!.
enleve_litt(Clause, [_|Litt], Res) :- enleve_litt(Clause, Litt, Res).

% remove_litteraux(Fnc, Litt, LL) : La formule LL est la formule Fnc privée des littéraux de la liste Litt en accord avec leur valuation telle que décrite dans la liste Litt.
remove_litt([], _, []).
remove_litt([Clause|Fnc], Litt, LL) :-  enleve_litt(Clause, Litt, Clause_sans_litt), Clause_sans_litt == [], remove_litt(Fnc, Litt, LL),!.
remove_litt([Clause|Fnc], Litt, [Clause_sans_litt|LL]) :-  enleve_litt(Clause, Litt, Clause_sans_litt), remove_litt(Fnc, Litt, LL).

% get_variables(+L, ?L2) : L2 est la liste des variables présentes dans L, liste de littéraux. Les éléments de L2 sont uniques.
get_variables([],[]).
get_variables([A|L],L2) :- element(A,L,_), get_variables(L,L2),!.
get_variables([A|L],L2) :- B is -A, element(B,L,_), get_variables(L,L2),!.
get_variables([A|L],[A|L2]) :- A >= 0, get_variables(L,L2),!.
get_variables([A|L],[B|L2]) :- B is -A, get_variables(L,L2).

% get_unitaire(+LL, +L, ?L2) : L2 est la liste des éléments présents dans LL sous la forme d'une liste à un unique élément. L est ici un auxiliaire qui permet de constuire L2, les éléments éventuellement présents dans L seront ajoutés à L2.
get_unitaire([], L, L) :- not(is_empty(L)).
get_unitaire([[A]| LL], L, L2) :- get_unitaire(LL, [A|L], L2), !.
get_unitaire([_|LL], L, L2) :- get_unitaire(LL, L, L2).

% enleve_non_positifs(+L, ?L2) : L2 est la liste des littéraux de L présents uniquement sous forme positive dans L.
enleve_non_positifs([],[]).
enleve_non_positifs([A|L], [A|L2]) :- integer(A), A >= 0, B is -A, not(element(B,L,_)), enleve_non_positifs(L,L2),!.
enleve_non_positifs([A|L], L2) :- integer(A), A < 0, B is -A, element(B,L,L_sans_B), enleve_non_positifs(L_sans_B,L2),!.
enleve_non_positifs([_|L], L2) :- enleve_non_positifs(L,L2).

% get_polarisation_positive(+Fnc, ? Varibles) : Variables est la liste des variables présentes uniquement comme des littéraux positifs dans la Fnc.
get_polarisation_positive(Fnc, Variables) :-
	get_litteraux(Fnc, Litt),
	enleve_non_positifs(Litt, Variables),
	not(is_empty(Variables)).

% enleve_non_negatifs(+L, ?L2) : L2 est la liste des littéraux de L présents uniquement sous forme négative dans L.
enleve_non_negatifs([],[]).
enleve_non_negatifs([A|L], [A|L2]) :- integer(A), A =< 0, B is -A, not(element(B,L,_)), enleve_non_negatifs(L,L2),!.
enleve_non_negatifs([A|L], L2) :- integer(A), A > 0, B is -A, element(B,L,L_sans_B), enleve_non_negatifs(L_sans_B,L2),!.
enleve_non_negatifs([_|L], L2) :- enleve_non_negatifs(L,L2).

% get_polarisation_negative(+Fnc, ? Varibles) : Variables est la liste des variables présentes uniquement comme des littéraux négatifs dans la Fnc.
get_polarisation_negative(Fnc, Variables) :-
	get_litteraux(Fnc, Litt),
	enleve_non_negatifs(Litt, Variables),
	not(is_empty(Variables)).

% dpll(Fnc, Sol) : Sol est une affectation des variables qui rend satisfiable la formule FNC
dpll([],[]).
dpll(Fnc,Sol) :- get_unitaire(Fnc, [], Var), remove_litt(Fnc, Var, Fnc2), dpll(Fnc2,Sol2), union(Var, Sol2, Sol), !.
dpll(Fnc,Sol) :- get_polarisation_positive(Fnc, Var), remove_litt(Fnc, Var, Fnc2), dpll(Fnc2,Sol2), union(Var, Sol2, Sol), !.
dpll(Fnc,Sol) :- get_polarisation_negative(Fnc, Var), remove_litt(Fnc, Var, Fnc2), dpll(Fnc2,Sol2), union(Var, Sol2, Sol), !.
dpll(Fnc,Sol) :- get_litteraux(Fnc, Litt), get_variables(Litt, Var), head(P, _, Var), head(P,Sol2,Sol), remove_litt(Fnc,[P],Fnc2), dpll(Fnc2,Sol2).
dpll(Fnc,Sol) :- get_litteraux(Fnc, Litt), get_variables(Litt, Var), head(P, _, Var), L is -P, head(L,Sol2,Sol), remove_litt(Fnc,[L],Fnc2), dpll(Fnc2,Sol2).

% ecriture_solution(+L) : affiche à l'écran la solution avec une mis en forme minimale.
ecriture_solution([]).
ecriture_solution([A|L]) :- A =< 0, B is -A, write("La variable "), write(B), write(" est évaluée à False"), nl, ecriture_solution(L), !.
ecriture_solution([A|L]) :- A > 0, write("La variable "), write(A), write(" est évaluée à True"), nl,  ecriture_solution(L), !.

% solution(+Fnc) : Recherche une affectation de varibles de Fnc qui rende la formule satisfiable.
solution(Fnc):-
	unique_par_clause(Fnc, Fnc_unique),
	get_litteraux(Fnc_unique, Litt),
	get_variables(Litt, Var),
	dpll(Fnc_unique,Sol),
	union(Sol, Var, Solution),
	write("Une affectation des variables à été trouvée :"), nl,
	ecriture_solution(Solution).

% temp(+Fnc) : affiche le temps de résolution de la fnc
temp(Fnc):-
	get_time(A),
	unique_par_clause(Fnc, Fnc_unique),
	get_litteraux(Fnc_unique, Litt),
	get_variables(Litt, Var),
	dpll(Fnc_unique,Sol),
	union(Sol, Var, _),
	write("Une affectation des variables à été trouvée en "),
	get_time(B),
	C is B - A, 
	write(C), write(" secondes").
	
