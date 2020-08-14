# Gestion des routes

## Description
Les routes permettents de construire les url de notre application ainsi que le comportement attendu pour la page.

## Prérequis
*
*
*

# Coder notre fichier route

Le fichir route est composé d'une suite d'élément de  la forme suivante.
```json

	"nomdelapage": {
	},

```

Chacun de ces éléments reprensentera la **route** pour une page en particulier.

Ona ensuite complété avec différents éléments.default

```json

"route": {
			"path": "/"
		},
"titre": "Page 1 - Titre",
"keywords" : "keyword1",
"viewPath": [
	"vitrine/view/index.html"
		]

```

Le **titre** est ce qui s'affichera sur l'onglet du moteur de recherche.
**route** quand à lui permet de gérer se qui s'affiche dans la barre de recherche lorsque tu passes d'une page à une autre.
**keyword** permet d'associer des mots clefs à la page ce qui aidera son référencement.
Enfin **viewPath** 


# Ajout d'un élément parent 

On peut rajouter un parent à notre route. Cela permet d'ajouter des éléments communs à toutes les routes qui ont ce parent.

Pour cela, il faut d'abord rajouter la ligne suivante à toutes les routes ou l'on veut attrbuer ce parent.

```json

"parents": [
	"nomParent"
],

```

Il faut ensuite créer un autre fichier route.json qui sera celui du parent. Sa construction est identique aux routes classique.default

On peut y mettre par exemple les éléments de js et de css afin de pas avoir à les attribuer pour chaque route. On aura juste à attribuer le parents aux routes concernées. 


```json

"cssPath": [
			"/<!--4DTEXT visiteur_o.sousDomaine-->/css/1.css",
			"/<!--4DTEXT visiteur_o.sousDomaine-->/css/2.css",


		],
		"jsPath": [
			"/<!--4DTEXT visiteur_o.sousDomaine-->/js/1.js",
			"/<!--4DTEXT visiteur_o.sousDomaine-->/js/2.js",
			"/<!--4DTEXT visiteur_o.sousDomaine-->/js/3.js",
		]
```
