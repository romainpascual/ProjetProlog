# ProjetProlog
Projet ProLog pour le cours de Logique ECP

Le projet est constitué d'un fichier par implémentation :
- le fichier "riviere.pl" contient la solution au problème de traversée de la rivière. Après avoir chargé le fichier, on peut lire la solution avec les commandes sans paramètre :
	--> "solution" : on obtient la liste des situations depuis celle où tout le monde est sur la première berge jusqu’à celle ou tout le monde est sur la seconde berge ;
montre la sortie ci-dessous
	--> "solution_ecrite" : on obtient la liste écrite des déplacements de Lulu .

- le fichier "compteEstBon.pl" contient la solution au problème du compte est bon. Après avoir chargé le fichier, on peut lire la solution avec les commandes :
	--> "solution(+Liste, +Nombre)" : on obtient les solutions pour obtenir la valeur Nombre à partir des valeurs de Liste.
	--> "meilleure_solution(+Liste, +Nombre)" : on obtient la meilleure solution en nombre d'opérations.
	--> meilleure_solution_approchee(+Nombres, +But, +Erreur_toleree) : on obtient la meilleure solution avec au plus un écart de Erreur_toloree avec le But recherché.

- le fichier "dpll.pl" contient la solution au problème de la satisfiabilité d'une formule mise sous forme normale conjonctice à l'aide de l'algorithme DPLL. Après avoir chargé le fichier, on peut lire la solution avec la commande :
	--> "solution(+Fnc)" : on obtient une valuation des variables de la formule qui permette sa satisfiabilité, si celle-ci est possible.
