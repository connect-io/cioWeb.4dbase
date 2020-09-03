# Gestion des routes

## Description
Les routes permettents de construire les URL de notre application ainsi que le comportement attendu pour la page web.

# Coder notre fichier route

Les fichiers route sont des fichiers JSON nommer de facon suivante ```*.route.json```, le nom du fichier n'a pas d'importance est ils peuvents être placer n'importe où dans le repertoire source de votre sous domaine.

```json
"nomdelapage": {
	},
```

Chacun de ces éléments reprensentera la **route** pour une page en particulier.
Généralement, ce fichier se trouve dans le dossier **Webapp** de notre projet et plus exactement dans le fichier **Source**. Dans le fichier source se trouve chaque élément de notre site rangé chacun dans un dossier. Dans ces dossier on retrouvera donc les dossier form, view et js ainsi que le fichier qui nous intéresse ici le fichier **route**.json.

On doit ensuite complété avec différents éléments.

```json
"route": {
	"path": "/"
},
"titre": "Page 1 - Titre",
"keywords": "keyword1",
"viewPath": [
	"vitrine/view/index.html"
]
```

Le **titre** est ce qui s'affichera sur l'onglet du moteur de recherche.
**route** quand à lui permet de gérer se qui s'affiche dans la barre de recherche lorsque tu passes d'une page à une autre.
**keyword** permet d'associer des mots clefs à la page ce qui aidera son référencement.
Enfin **viewPath** 


# Ajout d'un élément parent 

On peut rajouter un parent à notre route. Cela permet d'ajouter des éléments communs à toutes les routes qui ont ce parent. Le nom de notre parent commencera toujours par parents suivi du nom du parent.

Pour cela, il faut d'abord rajouter la ligne suivante à toutes les routes ou l'on veut attrbuer ce parent.

```json

"parentsNom": [
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
Après avoir créé notre route il faut ensuite l'appeler sur notre page HTML.
Pour cela, on va utiliser la ligne de code suivante :

```html
<!--#4DSCRIPT/cwLibToUrl/nomdelapage-->
```

On peut utiliser par exemple un bouton dont le href sera la ligne de code ci dessus. On va alors appeler la page correspondant lorsqu'on clique sur ce bouton.