# Gestion des tableaux de données

## Description
Les tableaux de données (vous retrouverez sont nom anglais "datatables")

## Prérequis
* La conpréhention des routes est requis.
* La compréhension des views est requises.
* Chargement des fichiers js et css

## Coder notre tableau


### **Création du fichier document.datatable.json**

Il faut tout d'abord définir le tableau et ses différenes caractéristiques. On va donc lui donner un **lib** qui sera le nom de notre tableau ainsi qu'une classe **class** si cela est nécessaire.
On obtient alors:

```json
	"lib": "dtNomPageDetailElementTableau",
	"class": "",
```

Ici, on nommera conventionnellement le lib par le préfixe dt pour datatable puis du nom de la page ou se situera le tableau suivi de détail et enfin l'éléments qui sera répresenté dans un tableau.

On peut y rajouter ensuite des caractéristique à notre tableau tel que :

* la gestion automatique du nombre de page de notre tableau si nécessaire avec ``` "dom": "auto", ```

* la possibilité de double cliquer sur un ligne du tableau pour accéder à l'élément 
```json    
    "doubleClick" :{
        "link": "elementtableauDetail",
        "linkVariable": {
            "urlDataClass" : "ElementTableau",
            "urlEntityPK": "maskID_t",
			"urlEntityAction": "edit"
        } 
```



### **Création des colonnes de notre tableau et utilisation des data**

Après avoir créer notre tableau, il faut créer les colonnes de notre tableau et les lier au data de 4D.

Dans notre première partie **column** chaque colonne sera défini par un **title** qui sera son nom et par **data** qui permettra de faire le lien avec la partie data.
On peut aussi y rajouter l'élément **className** qui nous permet de choisir ou se trouvera la donnée dans la case.

```json    
    "column": [
        {
            "title": "Element1", //on aura alors affiché pour le titre de notre colonne "Element1"
            "data": "element1"
        },
        {
            "title": "Element2",
            "data": "element2",
            "className": "text-right" // nos données pour cette colonne ne seront donc plus au milieu de la case mais à droite
        }
	],
```

La deuxième partie est appelé **data**. Pour chaque colonne, on va donc créer la data avec **name** et la lier à la variable 4D avec **value**.
On peut aussi créer des datas qui seront stocké dans le tableau mais pas affiché. Pour cela on crée la data sans avoir avant créer la column.

```json    
	"data": [
        {
            "name": "maskID_t", //Data créer conventionnellment et qui n'est pas affiché
            "value": "this.PK"
        },
        {
            "name": "element1", //permet de relier la colonne avec la data
            "value": "This.Element1" //nom de la variable que l'on trouve sur 4D
        },
        {
            "name": "element2",
            "value": "This.Element2"
        },
	]
```

On peut rajouter des éléments afin de personaliser nos data. On peut par exemple rajouter le symbole € à la suite de notre valeur en mettant **"This.Prix+\" €\""** ou bien mettre sous forme de date avec **"string(This.Date)"** 


Cela donne donc au final le code suivant :

```json  
{
	"lib": "dtNomPageDetailElementTableau",
	"class": "",
    "dom": "auto",
    "doubleClick" :{
        "link": "elementtableauDetail",
        "linkVariable": {
            "urlDataClass" : "ElementTableau",
            "urlEntityPK": "maskID_t",
			"urlEntityAction": "edit"
        } 
    },  
   "column": [
        {
            "title": "Element1", 
            "data": "element1"
        },
        {
            "title": "Element2",
            "data": "element2",
            "className": "text-right" 
        }
	],
	"data": [
        {
            "name": "maskID_t", 
            "value": "this.PK"
        },
        {
            "name": "element1", 
            "value": "This.Element1" 
        },
        {
            "name": "element2",
            "value": "This.Element2"
        },
	]
}
```

Ce code va donc nous donner le tableau suivant :

Element1 | Element2 
------------ | ------------- 
"This.Element1" | "This.Element2"




### **Incorporation dans notre fichier HTML**

Après avoir créer le tableau, il faut ensuite le rajouter à notre code HTML pour pouvoir l'afficher.

```html
<table <!--#4DHTML cwDataTableJsInformation (->pageWeb_o;"dtNomPageDetailElementTableau";entity_o.Element)-->></table>
```

Les éléments à modifier sont donc le nom du tableau qui est le "lib" de notre code json ainsi que entity.Element ou il faut changer Element par l'élément que l'on trouve dans le tableau.

## Rajout de bouton pour agir avec le tableau

On va tout d'abord créer le div dans le code HTML qui contiendra les boutons.default

```html
    <div class="dtNomPageDetailElementTableauButtons">
        <!-- Code des boutons -->                
    </div>
```

### Code HTML pour la création du bouton "supprimer ligne"

```html
<button type="button" id="NomBtnRetirerLigne" class="btn rounded-0 btn-sm u-btn-outline-bluegray g-mr-10" tooltip data-title="Effacer la ligne ?" data-toggle="confirmation">
    <i class="far fa-trash-alt"></i> Retirer ligne 
</button> 
```

Ici on definit son type avec **type="button"** puis on choisit le nom du bouton avec l'id **id="NomBtnRetirerLigne"** puis le style du bouton (couleur, taille, etc) avec **class="btn rounded-0 btn-sm u-btn-outline-bluegray g-mr-10"** et enfin le logo et le texte dans le bouton avec **class="far fa-trash-alt"** et **Retirer ligne**

### Code Javascript pour la création du bouton "supprimer ligne"


```js

// ----- Bouton retirer ligne -----
$('#NomBtnRetirerLigne').click( function () {
    table.dtNomPageDetailElementTableau.row('.selected').remove().draw( false );
    } );
    
// ----- FIN - Bouton retirer ligne -----

```

Ici on verifie si l'on clique sur le bouton d'id NomBtnRetirerLigne et on supprime la ligne selectionnée dans le tableau dtNomPageDetailElementTableau.