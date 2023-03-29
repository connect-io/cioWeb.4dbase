<!-- Type your summary here -->
# Class : Datatable

### Description
Gestion des tableaux de données en HTML.

### Accès aux fonctions
* [Fonction : constructor](#fonction--constructor)
* [Fonction : addData](#fonction--addData)
* [Fonction : getHtml](#fonction--getHtml)
* [Fonction : sendDataAjax](#fonction--sendDataAjax)
* [Fonction : setData](#fonction--setData)


--------------------------------------------------------------------------------

## Fonction : constructor			
Initialisation d'une dataTable

### Fonctionnement
```4d
Datatable.new($libDataTable_t) -> $instance_o
```

| Paramêtre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |
| $libDataTable_t | Texte      | Entrée        | Le lib de la dataTable |
| $instance_o     | Texte      | Sortie        | Nouvelle instance |

### Example
```4d
/* Consultez la documentation concernant la fonction dataTableNew de la class webApp. */
dataTables_o.userListe:=cwToolGetClass("DataTable").new("userListe")
```


--------------------------------------------------------------------------------

## Fonction : addData
Ajoute une ligne à votre tableau.

### Fonctionnement
```4d
Datatable.addData($data_o) -> Modifie this
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $data_o       | Variante   | Entrée        | Nouvelle valeur en derniere position de votre tableau. |

### Example
```4d
C_OBJECT($data_es)
$data_es:=ds.personne.query("actif IS true")
dataTables_o.dtPersonneListe.setData(data_es)
```


--------------------------------------------------------------------------------

## Fonction : getHtml
Génére le code HTML pour le tableau.

### Fonctionnement
```4d
Datatable.getHtml() -> $html_t
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $html_t       | Texte      | Sortie        | Contenu HTML pour générer la dataTable |

### Example
```html
<!--#4DHTML Session.storage.dataTables.dtPersonneListe.getHtml()-->
```


--------------------------------------------------------------------------------

## Fonction : sendDataAjax
Génére le JSON des données à renvoyer au navigateur.

### Fonctionnement
```4d
Datatable.sendDataAjax() -> $json_t
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $json_t       | Texte      | Sortie        | Contenu JSON des données du tableau |


### Example
```4d
$0:=dataTables_o.dtPersonneListe.sendDataAjax()
```


--------------------------------------------------------------------------------

## Fonction : setData
Charger les data dans le tableau de donnée.

### Fonctionnement
```4d
Datatable.setData($data_v) -> Modifie this
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $data_v       | Variante   | Entrée         | Les données à intégrer dans la dataTable (Collection ou Entité selection) |


### Example
```4d
C_OBJECT($data_es)
$data_es:=ds.personne.query("actif IS true")
dataTables_o.dtPersonneListe.setData(data_es)
```