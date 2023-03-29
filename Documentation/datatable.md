# Gestion des tableaux de données

Les tableaux de données (vous retrouverez son nom anglais "datatables") permettent d'afficher sous forme de liste triable une collection 4D.
Les dataTables du composant utilisent la solution HTML/jQuery du site https://datatables.net

# Prérequis
* La compréhension des routes est requise.
* La compréhension des views est requise.
* Chargement des fichiers js et css

Dans le fichier route de la page (ou la page parent) ajouter les appels CSS et JS suivant :
```json

"nomPageRoute": {
    "cssPath": [
        "https://cdn.datatables.net/1.10.21/css/jquery.dataTables.min.css"
    ],
    "jsPath": [
        "https://code.jquery.com/jquery-3.5.1.min.js",
        "https://cdn.datatables.net/1.10.21/js/jquery.dataTables.min.js"
    ]
},

```

# Coder notre tableau


## Création du fichier  de configuration document.datatable.json

Il faut tout d'abord définir le fichier de configuration du tableau.<br/>
Son emplacement est libre du moment qu'il se trouve dans le répertoire sous-domaine du dossier sources.<br/>
Le nom du fichier est également libre, mais il doit terminer par datatable.json (ex : Sources/www/professeur/eleve.datatable.json )

On va donc lui donner un **lib** qui sera le nom de notre tableau, on nommera conventionnellement le lib par le préfixe dt pour datatable puis du nom de la page où se situeront le tableau et l'élément qui sera représenté dans un tableau.
On ajoute ensuite une **source** qui est là dont provient les éléments du tableau.

```json
{
    "lib": "dtNomPageNomTableau",
    "source": "entity_o.param_o.elementtableau",
    "column": [ "..." ],
    "data": [ "..." ]
}

```

On ajoute ensuite des propriétés à notre tableau tel que :

| Nom de la propriété | Type  | Valeur par défaut | Commentaire |
| ------------------- | ----- | ----------------- | ----------- |
| class               | texte | ""                | Permet de personnaliser le CSS du tableau |
| multiSelect         | bool  | ""                | Permet la sélection multiple dans un tableau. |
| dom                 | texte | "auto"            | Génère les éléments autour du tableau. <br>La valeur ```auto``` permet une structure standard simple, elle permet également l'affichage de la pagination lorsque le tableau à plus de 10 éléments à son chargement. <br> La valeur ```forcePagination``` permet une structure standard simple avec la pagination dans tous les cas.<br />Plus d'information sur le site de dataTable : https://datatables.net/reference/option/dom |
| doubleClick         | objet | null              | Permet l'utilisation du double-clic sur une ligne tableau et redirige l'utilisateur vers une nouvelle page en fonction de l'ID de la ligne. Exemple complet sous le tableau. |
| noOrdering          | bool  | false             | Si cette propriété est passé à true, au chargement le tableau n'est pas trié, on utilise alors le tri de 4D. |


La possibilité de doublecliquer sur une ligne du tableauL pour accéder à l'élément 
```json    
    "doubleClick" :{
        "link": "elementtableauDetail",
        "linkVariable": {
            "urlDataClass" : "ElementTableau",
            "urlEntityPK": "maskID_t",
            "urlEntityAction": "edit"
        } 
```



## Création des colonnes de notre tableau

Après avoir créé notre tableau, il faut créer les colonnes de notre tableau et les lier aux data de 4D.

Dans notre première partie **column** chaque colonne sera définie par un **title** qui sera son nom et par **data** qui permettra de faire le lien avec la partie data.
On peut aussi y ajouter l'élément **className** qui nous permet de choisir où se trouvera la donnée dans la case.

```json    
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
```
Liste des propriétés propre aux colonnes (column) :

| Nom de la propriété | Obligatoire | Type  | Valeur par defaut | Commentaire |
| ------------------- | ----------- | ----- | ----------------- | ----------- |
| title               | Oui         | Texte | ""                | Nom de la colonne |
| data                | Oui         | Texte | #""               | Correspond à la valeur de data.name |
| className           | Non         | Texte | ""                | Personnalise le CSS de la colonne (ex : ``` text-right ```) |


## Intégration des données

La deuxième partie est appelée **data**. Pour chaque colonne, on va donc créer la data avec **name** et la lier à la variable 4D avec **value**.
On peut aussi créer des datas qui seront stockées dans le tableau, mais pas affichées. Pour cela, on crée la data sans avoir avant créé la column.

```json    
	"data": [
        {
            "name": "maskID_t", //Data créer conventionnellement et qui n'est pas affiché.
            "value": "this.PK"
        },
        {
            "name": "element1", // Permet de relier la colonne avec la data.
            "value": "This.Element1" //Nom de la variable que l'on trouve sur 4D.
        },
        {
            "name": "element2",
            "value": "This.Element2"
        },
	]
```

Liste des propriétés propre aux données (data):

| Nom de la propriété | Obligatoire | Type  | Valeur par defaut | Commentaire |
| ------------------- | ----------- | ----- | ----------------- | ----------- |
| name                | Oui         | Texte | #""               | Nom de la donnée (Permet la correspondance avec les colonnes.)|
| value               | Oui         | Texte | #""               | Nom de la propriété de notre collection 4D. <br>Il est possible de concaténer 2 données : ``` "This.cp+\" - \"+This.ville" ``` ou  bien ``` "This.Prix+\" €\"" ```<br> Pour les dates, il est préférable de les passer sous forme de texte : ``` "string(This.Date)" ``` |



Cela donne donc au final le fichier de configuration suivant :

```json  
{
    "lib": "dtNomPageNomTableau",
    "source": "entity_o.param_o.elementtableau",
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

| Element1        | Element2 |
| --------------- | -------- |
| "This.Element1" | "This.Element2" |




# Incorporation dans notre fichier HTML

Après avoir créé le tableau, il faut ensuite le rajouter à notre code HTML pour pouvoir l'afficher.

```html
<!--#4DHTML Session.storage.dataTables.libDeMonDataTable.getHtml()-->
```

```dataTables_o``` : variable process contenant toutes les informations sur les dataTables<br />
```libDeMonDataTable``` : Libellé de la dataTable.<br />
```getHtml()``` : Fonction de la class dataTable.getHtml()<br />


Les éléments à modifier sont donc le nom du tableau qui est le "lib" de notre code JSON ainsi que entity. Element où il faut changer Element par l'élément que l'on trouve dans le tableau.

# Rajout de bouton pour agir avec le tableau

On va tout d'abord créer le div dans le code HTML qui contiendra les boutons.défault

```html
    <div class="dtNomPageNomTableauButtons">
        <!-- Code des boutons -->                
    </div>
```

## Code HTML pour la création du bouton "supprimer ligne"

```html
<button type="button" id="btnRetirerLigne">
    Retirer la ligne 
</button> 
```

Ici, on définit son type avec **type="button"** puis on choisit le nom du bouton avec l'id **id="NomBtnRetirerLigne"**.

## Code Javascript pour la création du bouton "supprimer ligne"


```js

// ----- Bouton retirer ligne -----
$('#btnRetirerLigne').click( function () {
    table.dtNomPageNomTableau.row('.selected').remove().draw( false );

    // Si aucune ligne n'est séléctionné, on prévient l'utilisateur.
    if( rowData === undefined){
        alert("Merci de séléctionner une ligne.");
        return;
    }

    // On envoi une requête au serveur pour informer que l'on souhaite retirer une ligne.
    $.ajax({
        method: "POST",
        // Url de destination
        url: data4D.urlCustom ,
        data: {
            // On envoi le PK de la ligne.
            lignePk: rowData.maskID_t,
            action: "retirerLigne"
        },
        success: function(response) {
            // Tout ce passe bien, on recharge le tableau.
            dtNomPageNomTableauReload();

            // Et pour finir on fait une demande de mise à jour diu cache.
            cacheUpdate();
        }
    });
});
    
// ----- FIN - Bouton retirer ligne -----
```

Ici on verifie si l'on clique sur le bouton d'id NomBtnRetirerLigne et on supprime la ligne selectionnée dans le tableau dtNomPageDetailElementTableau.