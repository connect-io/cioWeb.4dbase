# Gestion des routes

## Description
Les routes permettentent de construire les URL de notre application ainsi que le comportement attendu pour la page web.

# Coder notre fichier route

Les fichiers des routes sont des fichiers JSON nommé de la façon suivante ```*.route.json```, le préfixe du nom du fichier n'a pas d'importance et ils peuvent être placés n'importe où dans le répertoire source de votre sous-domaine.

Un fichier de route peut contenir une, plusieurs voir toutes les routes de l'application. Mais pour plus de clarté, nous vous recommandons de créer un fichier par module (user, blog, article, paiement, ...).

Exemple d'organisation :
```
 📦VotreApplication
 ┗ 📂WebApp                         
   ┗📂Sources
     ┗📂www                     // Nom de mon sous-domaine
       ┣ 📂route
       ┃ ┣ 📜user.route.json
       ┃ ┣ 📜blog.route.json
       ┃ ┣ 📜article.route.json
       ┃ ┗ 📜...
       ┗ 📂view
         ┗ 📜userDetail.html
         ┣ 📜blogListe.html
         ┗ 📜...
 ```

Mais une meilleure pratique consiste à créer un dossier par module avec les routes, HTML, JS, datable, formulaire à l'intérieur.
 ```
 📦VotreApplication
 ┗ 📂WebApp
   ┗📂Sources
     ┗📂www
       ┣ 📂user
       ┃   ┣ 📜route.json
       ┃   ┣ 📂view
       ┃   ┃ ┣📜liste.html
       ┃   ┃ ┗ 📜detail.html
       ┃   ┣ 📂js
       ┃   ┃ ┗📜detail.js
       ┃   ┗  📂...
       ┣ 📂blog
       ┃   ┣ 📜route.json
       ┃   ┗ 📂...
       ┣ 📂article
       ┃   ┣ 📜route.json
       ┃   ┗ 📂...
       ┗ 📂...
 ```

Chacun de ces éléments représentera la **route** pour une page/URL en particulier.

On doit ensuite compléter avec différents éléments.

```json
{
	"helloWord": {
		"parents": [
			"parentsLayoutDemo"
		],
		"route": {
			"path": "/hello-word.html"
		},
		"titre": "Hello word",
		"viewPath": [
			"demo/view/helloWord.html"
		]
	}
}
```
Dans cet exemple la propriété ```parents``` permet à la route d'hériter intégralement de la route parent.  
Le **titre** est utilisé dans le calque (layout) parent de la page web pour définir la valeur du title : ```<title><!--#4DTEXT pageWeb_o.titre--> | Composant cioWeb</title>```  
La propriété ```route``` quant à lui permet de gérer l'URL de la page.  
La propriété ```viewPath``` est le chemin relatif du fichier HTML qui sera chargé depuis le sous-domaine du dossier Sources.


## Liste des propriétés d'une route

Attention, il faut savoir la liste n'est pas exhaustif, vous avez également la possibilité de créer vous-même des propriétés qui pourront directement être utilisable depuis la variable pageWeb_o.

| Nom de la propriété | Type          | Valeur par defaut | Commentaire |
| ------------------- | ------------- | ----------------- | ----------- |
| parents             | tableau texte | ""                | Permet de fixer un certain nombre de parents qui seront fusionnés avec la route. |
| route               | objet         | Obligatoire       | la propriété ```path``` est obligatoire. |
| titre               | texte         | ""                | Définit la variable title d'une page web : ```<title><!--#4DTEXT pageWeb_o.titre--> | Composant cioWeb</title>``` |
| description         | text          | ""                | Définit le meta description d'une page web : ```<meta name="description" content="<!--#4DHTML pageWeb_o.description-->" />``` |
| keywords            | texte         | ""                | Définit le meta keywords d'une page web : ```<meta NAME="keywords" content="<!--#4DHTML pageWeb_o.keywords-->" />``` |
| methode             | tableau texte |                   | Définit la méthode qui sera executé au chargement de la page. |
| cssPath             | tableau texte |                   | Définit les fichiers CSS qui seront chargés avec la page. Pour être activé le layout HTML doit éxécuté le code suivant après les appeles CSS en dur : ```<!--#4DHTML cwCssGetfile-->``` |
| jsPath              | tableau texte |                   | Définit les fichiers JS qui seront chargés avec la page. Pour être activé le layout HTML doit éxécuté le code suivant après les appeles JS en dur : ```<!--#4DHTML cwJsGetfile-->``` |
| login               | boolean       | false             | Définit si la page à besoin d'être authentifié pour être délivré. |


### Ajout d'un élément parent 

On peut ajouter un parent à notre route. Cela permet d'ajouter des éléments communs à toutes les routes qui ont ce parent. Le nom de notre parent commencera toujours par parents suivis du nom du parent.

Pour cela, il faut d'abord rajouter la ligne suivante à toutes les routes où l'on veut attribuer ce parent.

```json

"parentsNom": [
	"nomParent"
],

```

Il faut ensuite créer un autre fichier route.json qui sera celui du parent. Sa construction est identique aux routes classiques.

On peut y mettre par exemple les éléments de js et de css afin de ne pas avoir à les attribuer pour chaque route. On aura juste à attribuer le parent aux routes concernées. 


```json
{
	"nomParent": {
    "cssPath": [
      "/<!--4DTEXT visiteur_o.sousDomaine-->/css/1.css",
      "/<!--4DTEXT visiteur_o.sousDomaine-->/css/2.css",
    ],
    "jsPath": [
      "/<!--4DTEXT visiteur_o.sousDomaine-->/js/1.js",
      "/<!--4DTEXT visiteur_o.sousDomaine-->/js/2.js",
      "/<!--4DTEXT visiteur_o.sousDomaine-->/js/3.js",
    ]
	}
}
```

## Bien utilisé la propriété route
La propriété route dans les routes permet de générer mais également de comprendre comment est construite une URL.


| Nom de la propriété | Type          | Valeur par defaut | Commentaire |
| ------------------- | ------------- | ----------------- | ----------- |
| path                | texte         | Obligatoire       |  |
| format              | tableau texte | Obligatoire       |  |
| force               | tableau texte | Obligatoire       |  |


## Appel d'une route depuis le HTML

Après avoir créé notre route, il vous est possible de générer l'URL dans une page HTML via la commande suivante :

```html
<!--#4DSCRIPT/cwLibToUrl/nomDeLaRoute-->
```

On peut utiliser par exemple un bouton dont le href sera la ligne de code ci-dessus. On va alors appeler la page correspondante lorsqu'on clique sur ce bouton.