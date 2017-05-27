/* Autheur : Romain Pascual

On cherche à modéliser le problème de la traversée de rivière.

Lulu doit faire passer le chou, la chèvre et le loup de l’autre côté de la rivière et il n’a qu’une place sur son bateau. Si la chèvre et le chou sont ensemble sur une rive quand Lulu s’éloigne, la chèvre mange le chou. Et si le loup et la chèvre sont ensemble quand Lulu s’éloigne, le loup mange la chèvre.

Modélisation : on utilise un tuple de (Lulu, Chou, Chevre, Loup). Une variable vaut 0 si le personnage est du premier côté de la rivière et 1 s'il est du second côté. On cherche donc une transition de (0,0,0,0) vers (1,1,1,1).
*/

% Etat ou un personnage mange l'autre :
interdit(situation(A, B, B, A)) :- A \= B.
interdit(situation(A, A, B, B)) :- A \= B.

% Déplacer le chou
deplacement(situation(Lulu, Chou, Chevre, Loup),
		situation(Lulu_deplace, Chou_deplace, Chevre, Loup)) :-
	Lulu is Chou,	
	Lulu_deplace is (Lulu + 1) mod 2,
	Chou_deplace is (Chou + 1) mod 2,
	not(interdit(situation(Lulu_deplace, Chou_deplace, Chevre, Loup))).

% Déplacer la chèvre
deplacement(situation(Lulu, Chou, Chevre, Loup),
		situation(Lulu_deplace, Chou, Chevre_deplace, Loup)) :-
	Lulu is Chevre,
	Lulu_deplace is (Lulu + 1) mod 2,
	Chevre_deplace is (Chevre + 1) mod 2,
	not(interdit(situation(Lulu_deplace, Chou, Chevre_deplace, Loup))).

% Déplacer le loup
deplacement(situation(Lulu, Chou, Chevre, Loup),
		situation(Lulu_deplace, Chou, Chevre, Loup_deplace)) :-
	Lulu is Loup,
	Lulu_deplace is (Lulu + 1) mod 2,
	Loup_deplace is (Loup + 1) mod 2,
	not(interdit(situation(Lulu_deplace, Chou, Chevre, Loup_deplace))).

% Déplacer uniquement Lulu
deplacement(situation(Lulu, Chou, Chevre, Loup),
		situation(Lulu_deplace, Chou, Chevre, Loup)) :- 
	Lulu_deplace is (Lulu + 1) mod 2,
	not(interdit(situation(Lulu_deplace, Chou, Chevre, Loup))).

bfs(A,B,Chemin) :- parcours(B,[[A]],Chemin). % parcours en largeur

parcours(Arrivee,[[Arrivee|Chemins]|_],[Arrivee|Chemins]) :- !. % on a trouvé une solution, on stop la recherche.
parcours(Arrivee,[[Situation_actuelle|Chemins]|Autres_chemins],Solution) :-
	findall([Situation_suivante,Situation_actuelle|Chemins],
		deplacement(Situation_actuelle,Situation_suivante),
		Nouveau_chemins),
	append(Autres_chemins,Nouveau_chemins,Chemins_rallonges),
	parcours(Arrivee,Chemins_rallonges,Solution).


solution :- bfs(situation(0,0,0,0),situation(1,1,1,1), Lrev),
	reverse(Lrev,Liste),
	write(Liste).
