# Gestion de form

## Description
Le fichier form permet la création des variables utilisées dans le fichier view.

## Prérequis
* La conpréhension des routes est requise.
* La compréhension des views est requise.

# Initialiser notre fichier form

Notre fichier form est en language json.
La création de ce fichier est presque identique dans chaque cas. Il faut seulement changer le **lib** et **action**

```json

{
	"lib": "formPageDetail",
	"class": "m-t g-pa-10",
	"action": "pageDetail",
	"method": "POST",
	"input": [
	]
}

```

# Remplissage de "input"

Après avoir créé le docmuent il faut remplir la partie **input** qui contient nos variables.

Dans sa forme la plus basique, une variable aura la forme suivante :

```json

{
	"lib": "pdVariable1",
	"type": "text",
	"label": "C'est la variable 1",
	"colLabel": 4
},

```

Le **lib** sera le nom de notre variable. Généralement, on choisit les premières lettres du lib de notrefichier (ici PageDetail donc pd). 

Il y a aussi le **label** qui sera un texte qui s'affichera notre élément (zone de complétion, menu déroulant, etc) il permet de donner des infos à l'utilisateur sur ce qu'il doit faire.

Il y a ensuite le **collabel** qui permet de gérer l'espace entre le label et notre élément. C'est un entier comprit entre 0 et 12.

Enfin, il y a le **type** qui permet de choisir le type de varaible. Cela peut être une zone de texte ou bien un menu déroulant, une case à cocher ou encore un élément cacher.

On peut donc utiliser:
* **text** pour une zone de texte
* **textarea** pour une zone de texte de taille plus importante
* **select** pour un menu déroulant
dans ce cas il faut rajouter:
```json
"selection": [
	{
		"lib": "choix1",
		"value": "0"
	},
	{
		"lib": "choix2",
		"value": "1"
	}
]
```
Pour les values, elles se retrouvent dans 4D.
* **checkbox** pour une case à cocher
Il en existe d'autres qui se retrouve facilement sur internet.


Pour résumer les différents éléments que l'on peut trouver dans l'input, nous avons  :

| Nom de la propriété | Type    | Valeur par defaut | Commentaire |
| ------------------- | ------- | ----------------- | ----------- |
| lib                 | texte   | ""                | C'est le nom de la variable |
| type                | texte   | ""                | Permet de choisir le type de notre variable (text, textarea, select, etc) Voir tableau suivant |
| label               | texte   | ""                | C'est le texte qui s'affichera avec notre variable sur la page web |
| collabel            | entier  | ""                | Permet de gérer l'espace entre le label et la variable |
| class               | texte   | ""                | Permet de rajouter des propriétés à notre variable |
| clientDisabled      | boolean | false             | Permet de choisir si les champs sont saisissble ou pas (false = saisissable) |
| append              | texte   | ""                | Permet de rajouter un petit texte au bout du champ de saisi (€, m2, etc) |
| selection           | texte   | ""                | Nécessaire lorsqu'on crée un menu déroulant ou des boutons radios (voir au dessus) |
| format              | texte   | ""                | Permet de définir des format spécifique tel que des dates( °°/°°/°°°°) |
| colRadio            | entier  | ""                | Lorsqu'on a un type: radio cela permet d'aligner les boutons radios |
| required            | texte   | ""                | |
| placeholder         | texte   | ""                | |
| collapse            | texte   | ""                | |
| contentType         | entier  | ""                | |
| divClassSubmit      | boolean | false             | |
| dateMin             | texte   | ""                | Permet de choisir la date minimum lorsqu'on a un type date |
| dateMax             | texte   | ""                | Permet de choisir la date maximum lorsqu'on a un type date  |
| blobSize            | texte   | ""                | |


Voici un tableau regroupant les différentes valeur que peut prendre type:

| Nom de la propriété | Element nécessaire dans input | Element facultatif dans input                          | Commentaire |
| ------------------- | ------------------------------| ------------------------------------------------------ | ----------- |
| text                |                               | append, label, collabel, class, clientDisabled, append | Permet de créer un champ de texte|
| textarea            |                               | label, collabel, clientDisabled                        | Permet de créer un champ de texteprenant plusieurs lignes |
| select              | selection                     | label, collabel, clientDisabled                        | Permet de créer un menu déroulant |
| checkbox            |                               | label, collabel, clientDisabled                        | Permet de creer une case à cocher |
| radio               | selection                     | label, collabel, clientDisabled, colRadio              | Permet de créer des boutons radio|



## Element constant

Pour chacune des page il faut toujours mettre le **token** qui est très utile pour la sécurité de la page.

```json
{
	"lib": "token"
},
```

Il y a aussi **Submit** que l'on peut mettre en format cacher. Pour cela, il faut la class **hidden**. Mais on peut aussi afficher le bouton qui permet de valider la saisie. 

```json
{
	"lib": "pdSubmit",
	"type": "submit",
	"class": "hidden",
	"value": "Enregistrer"
}
```
ou

```json
{
	"lib": "pdSubmit",
	"type": "submit",
	"class": "btn btn-large u-btn-outline-teal rounded-0 ",
	"value": "Valider"
}
```

