/* Auteur : Valentin Noel et Romain Pascual

Problème de prouvabilité par méthode des tableaux : on chercher à savoir si une formule phi représentée comme un arbre est prouvable par la méthode des tableaux, c'est-à-dire s'il existe un tableau clos à partir de la négation de phi).

On définit donc dans un premier temps des prédicats sur les formules manipulées comme des arbres puis on des prédicats sur les tableaux.

Les variables propositionnelles sont manipuléees avec des entiers naturels. On obtient alors simplement les littéraux correspondant en considérant des entiers relatifs (négatifs pour la négation d'une variable).

Cela peut induire des ambiguité pour décrire un littéral, ainsi la négation de 1 peut s'écrire :
	-1, il s'agit alors d'un littéral ;
	non(1), il s'agit alors d'une formule.

Cette ambiguité est levée à la construction du tableau ou l'on n'obtient uniquement des littéraux sur les feuilles.

Exemple de formules pour tester (issues de l'exercice 1 du TD 3) :
p -> 1
q -> 2
r -> 3
   --- Prouvables par tableaux ---
imp(imp(et(1,2),3), ou(imp(1,3), imp(2,3))) := (((p ∧ q) ⇒ r) ⇒ ((p ⇒ r) ∨ (q ⇒ r)))
ou(imp(1,2),imp(2,1)) := ((p ⇒ q) ∨ (q ⇒ p))
imp(ou(1,et(2,3)),et(ou(1,2),ou(1,3))) := ((p ∨ (q ∧ r)) ⇒ ((p ∨ q) ∧ (p ∨ r)))

   --- Non prouvables par tableaux ---
imp(ou(1,2),imp(3,imp(-2,-1))) := ((p ∨ q) ⇒ (r ⇒ (¬q ⇒ ¬p)))

*/
% concatener(?L1, ?L2, ?L3) L3 est obtenu par concaténation de L1 et L2.S
concatener([],L,L) :- !.
concatener([H1|T1],L2,[H1|L]) :- concatener(T1,L2,L).

% head (?A, ?L, ?L2) : L2 est la liste ayant pour tête A et pour queue L 
% Utilisé pour ajouter un élémént en tête de liste.
head(A,L,[A|L]).imp(ou(1,et(2,3)),et(ou(1,2),ou(1,3)))

% element(?A, ?L, ?L2) : L est la liste L2 à laquelle on a enlevé A
% Utilisé pour selectionner un élément dans une liste et vérifier l'appartenance d'un élément à la liste.
element(X,[X|T],T).
element(X,[A|T],[A|L]):- element(X,T,L).

% litt(+N) : N est un littéral, donc un entier relatif.
litt(N) :- integer(N).

% formule(+F) : prédicat déterminant si F est une formule propositionnelle représentée sous la forme d'un arbre.
formule(N) :- litt(N) ,!. % La formule est une variable
formule(non(A)) :- formule(A),!. % Le connecteur principal est la négation
formule(et(A,B)) :- formule(A),formule(B),!. % Le connecteur principal est la conjonction
formule(ou(A,B)) :- formule(A), formule(B),!. % Le connecteur principal est la disjonction
formule(imp(A,B)) :- formule(A),formule(B),!. % Le connecteur principal est l'implication

/* Implémentation des tableaux : les prédicats "noeud_tableau" et "tableau" ne sont pas nécessaires au bon fonctionnement du code mais ils permettent de mieux cerner la manière dont sont construits les tableaux, c'est pourquoi nous avons jugé bon de les laisser dans le code */
% noeud_tableau(+L) : L est un noeud d'un tableau, ie tous les éléments de la liste L sont des formules.
noeud_tableau([]).
noeud_tableau([A|L]) :- formule(A), noeud_tableau(L).

% tableau(+A, ?B) : A est un tableau, B sont les éventuels fils de A.
tableau(A) :- noeud_tableau(A). % Le tableau est une feuille
tableau(alpha(B)) :- tableau(B). % Le tableau est une branche alpha, on vérifie que la branche est un tableau.
tableau(beta(B1,B2)) :- tableau(B1), tableau(B2). % Le tableau est une branche beta, on vérifie que les deux branches sont des tableaux.

% noeud_developpe(+L) : L est un noeud développé du tableau, ie tous les éléments de la liste L sont des littéraux.
noeud_developpe([]).
noeud_developpe([A|L]) :- litt(A), noeud_developpe(L).

% noeud_clos(+L) : L est un noeud clos, ie il contient au moins une variable et sa négation.
noeud_clos([]) :- !, fail. % On a pas trouvé de variable accompagnée de sa négation.
noeud_clos([A|L]) :- B is -A, element(B,L,_),!. % On vient de trouvé une variable et sa négation, le noeud est clos.
noeud_clos([_|L]) :- noeud_clos(L). % On poursuit l'exploration du noeud.

% tableau_clos(+Tab) : Tab est un tableau clos, c'est-à-dire que toutes ses branches sont closes.
tableau_clos(A) :- noeud_clos(A),!.
tableau_clos(alpha(B)) :- tableau_clos(B),!. % le tableau est une branche alpha, on vérifie que la branche est close.
tableau_clos(beta(B1,B2)) :- tableau_clos(B1), tableau_clos(B2),!. % le tableau est deux branches beta, on vérifie que les branches sont closes.

% formule2noeud(+Formule, ?Tab) : Tab est le tableau associé à Formule en éliminant le connecteur principal.
formule2noeud(litt(N), litt(N)) :- !. % Formule est un littéral (variable ou négation de la variable)
formule2noeud(non(N), litt(B)) :- litt(N), B is -N, !. % Formule est la négation d'un littéral.
formule2noeud(et(A,B), alpha([A,B])) :- !. % Le connecteur principal est la conjonction -> alpha
formule2noeud(non(ou(A,B)), alpha([non(A),non(B)])) :- !. % Le connecteur principal est la négation, suivi d'une disjonction -> alpha
formule2noeud(non(imp(A,B)), alpha([A,non(B)])) :- !. % Le connecteur principal est la négation, suivi d'une implication -> alpha
formule2noeud(non(non(A)), alpha([A])) :- !. % Le connecteur principal est la négation, suivi d'une autre négation -> alpha
formule2noeud(ou(A,B), beta([A],[B])) :- !. % Le connecteur principal est la disjonciton -> beta
formule2noeud(non(et(A,B)), beta([non(A)], [non(B)])) :- !. % Le connecteur principal est la négation, suivi d'une conjonction -> beta
formule2noeud(imp(A,B), beta([non(A)], [B])) :- !. % Le connecteur principal est l'implication -> beta

% trouve_non_developpe(+Liste, ? Formule) : Formule est une formule non développée présente dans la fiste de formules Liste.
trouve_non_developpe([],_) :- !, fail. % Toutes les formules de la liste vide sont développées.
trouve_non_developpe([A|_], A) :- not(litt(A)),!. % A n'est pas un littéral, la formule est donc non développpée.
trouve_non_developpe([_|L], B) :- trouve_non_developpe(L,B). % La formule est tête de liste est un littéral (coupure), c'est donc une formule développée

% liste_formule2tableau(+Liste, ?Tab) : Tableau est un tableau développé construit à partir des formules de Liste.
% Cas où la liste représente un noeud développé.
liste_formule2tableau(L,L) :- noeud_developpe(L),!.
%  Cas où la formule non développée obtenue dans Liste est la négation d'un littéral (lié à l'ambiguité de la représentation de la négation, cf en-tête)
liste_formule2tableau(L, Tab) :- 
	trouve_non_developpe(L,Formule_non_developpee), % On cherche une formule non développée.
	element(Formule_non_developpee,L,L_sans_non_developpee), % On récupère la liste privée de la formule à développer
	formule2noeud(Formule_non_developpee, litt(Litt)), % On récupère la négation du littéral.
	head(Litt,L_sans_non_developpee,L_bis), % On replace le littéral dans la liste.
	liste_formule2tableau(L_bis,Tab),!. % On recommence la construction du tableau.
% Cas où la formule non développée obtenue dans Liste est de type alpha.
liste_formule2tableau(L, Tab) :- 
	trouve_non_developpe(L,Formule_non_developpee), % On cherche une formule non développée.
	element(Formule_non_developpee,L,L_sans_non_developpee), % On récupère la liste privée de la formule à développer.
	formule2noeud(Formule_non_developpee, alpha(Liste_alpha)), % On récupère la formule développée (cas alpha : on récupère une liste).
	concatener(Liste_alpha,L_sans_non_developpee,L_bis), % On ajoute les littéraux de la formule développée à la liste.
	liste_formule2tableau(L_bis,Tab_bis), % On recommence la construction du tableau.
	Tab = alpha(Tab_bis),!. % On construit la branche alpha.
% Cas où la formule non développée obtenue dans Liste est de type beta.
liste_formule2tableau(L, Tab) :- 
	trouve_non_developpe(L,Formule_non_developpee), % On cherche une formule non développée.
	element(Formule_non_developpee,L,L_sans_non_developpee), % On récupère la liste privée de la formule à développer.
	formule2noeud(Formule_non_developpee, beta(Liste_beta_1, Liste_beta_2)), % On récupère les deux formules développées (cas beta : on récupère deux listes).
	concatener(Liste_beta_1,L_sans_non_developpee,L_bis_1), % On ajoute les littéraux de la première formule développée à la liste.
	liste_formule2tableau(L_bis_1,Tab_bis_1), % On recommence la construction du tableau (branche 1).
	concatener(Liste_beta_2,L_sans_non_developpee,L_bis_2), % On ajoute séparemment les littéraux de la deuxième formule développée à la liste.
	liste_formule2tableau(L_bis_2,Tab_bis_2), % On recommence la construction du tableau (branche 2).
	Tab = beta(Tab_bis_1,Tab_bis_2),!. % On reconstruit le tableau à l'aide des deux branches

% formule2tableau(+Formule, ?Tab) : Tab est un tableau développé construit à partir de Formule.
formule2tableau(F,Tab):-
	liste_formule2tableau([F],Tab).

% prouve_par_tableau(+F, ?Tab) : La formule F est prouvée par Tab.
prouve_par_tableau(F, Tab):-
	formule(F), % On vérifie qu'il s'agit d'une formule.
	formule2tableau(non(F),Tab), % On construit le tableau développé associé à la négation de la formule.
	tableau_clos(Tab). % On vérifie que le tableau est clos.

% solution(+F) : Affiche à l'écran si la formule F est prouvable par tableaux.
solution(F):-
	prouve_par_tableau(F,_), write("La formule est prouvable par tableaux."),!.
solution(_):-
	write("La formule n'est pas prouvable par tableaux."),!.

% solution_avec_tableau(+F) : Affiche à l'écran si la formule F est prouvable par tableaux, si c'est le cas, le tableau est aussi affiché.
solution_avec_tableau(F):-
	prouve_par_tableau(F, Tab), write("La formule est prouvable par tableaux."), nl, write(Tab),!.
solution_avec_tableau(_):-
	write("La formule n'est pas prouvable par tableaux."),!.



