/* Autheurs : Valentin Noel et Romain Pascual

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

tete([A|_],A).


/* Fonction d'affichage */
ecriture_solution([_]) :- write('Tout le monde a traversé'),!.

% Deplacement du Chou
ecriture_solution([situation(_, Chou, _, _)|L]) :-
	tete(L,situation(_, Chou2, _, _)),
	Chou \= Chou2,
	Debut is Chou + 1,
	Fin is Chou2 + 1,
	write('Lulu se déplace avec le chou de la berge '),
	write(Debut), write(' à la berge '),
	write(Fin), write('.'), nl,
	ecriture_solution(L).

% Deplacement de la Chevre
ecriture_solution([situation(_, _, Chevre, _)|L]) :-
	tete(L,situation(_, _, Chevre2, _)),
	Chevre \= Chevre2,
	Debut is Chevre + 1,
	Fin is Chevre2 + 1,
	write('Lulu se déplace avec la chevre de la berge '),
	write(Debut), write(' à la berge '),
	write(Fin), write('.'), nl,
	ecriture_solution(L).
	
% Deplacement du Loup
ecriture_solution([situation(_, _, _, Loup)|L]) :-
	tete(L,situation(_, _, _, Loup2)),
	Loup \= Loup2,
	Debut is Loup + 1,
	Fin is Loup2 + 1,
	write('Lulu se déplace avec le loup de la berge '),
	write(Debut), write(' à la berge '),
	write(Fin), write('.'), nl,
	ecriture_solution(L).
	
%Deplacement de Lulu
ecriture_solution([situation(Lulu, Chou, Chevre, Loup)|L]) :-
	tete(L,situation(Lulu2, Chou2, Chevre2, Loup2)),
	Chou == Chou2,
	Chevre == Chevre2,
	Loup == Loup2,
	Lulu \= Lulu2,
	Debut is Lulu + 1,
	Fin is Lulu2 + 1,
	write('Lulu se déplace seul de la berge '),
	write(Debut), write(' à la berge '),
	write(Fin), write('.'), nl,
	ecriture_solution(L).

solution :- bfs(situation(0,0,0,0),situation(1,1,1,1), Lrev),
	reverse(Lrev,Liste),
	write(Liste).

solution_ecrite :- bfs(situation(0,0,0,0),situation(1,1,1,1), Lrev),
	reverse(Lrev,Liste),
	ecriture_solution(Liste).
