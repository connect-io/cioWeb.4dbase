<!-- Type your summary here -->
# Class : Chart

## Description

### Description
Gestion des graphiques en HTML et js

### Accès aux fonctions
* [Fonction : constructor](#fonction--constructor)
* [Fonction : dataColor](#fonction--dataColor)
* [Fonction : dataOption](#fonction--dataOption)
* [Fonction : dataSet](#fonction--dataSet)
* [Fonction : getHTML](#fonction--getHTML)
* [Fonction : label](#fonction--label)
* [Fonction : optionsMerge](#fonction--optionsMerge)
* [Fonction : titleSet](#fonction--titleSet)
* [Fonction : typeSet](#fonction--typeSet)



------------------------------------------------------

## Fonction : constructor			
Initialisation d'un graph

### Fonctionnement
```4d
cs.Chart.new($libChart_t {;$modele_t}) -> $instance_o
```

| Paramêtre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |
| $libChart_t     | Texte      | Entrée        | Le lib du graph |
| $modele_t       | Texte      | Entrée        | le lib du modèle (optionel) |
| $instance_o     | Texte      | Sortie        | Nouvelle instance |


### Example
```4d
charts_o.graph1 := cwToolGetClass("Chart").new("EvolutionAnnee", "monModeleChart")
```

------------------------------------------------------

## Fonction : dataColor
Définit la couleur d'un set (une courbe) de donnée.

### Fonctionnement
```4d
Chart.dataColor($label; $couleur_t) -> Modifie this
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $label        | Texte      | Entrée        | le label de la courbe à colorer |
| $couleur_t    | Texte      | Entrée        | la couleur à utiliser |


### Example
```4d
charts_o.graph1.dataColor("2021","blue")
```

------------------------------------------------------

## Fonction : dataOption
Definit une nouvelle option à ajouter ou à modifier pour un dataset en particulier.

### Fonctionnement
```4d
Chart.dataOption($option_o) -> Modifie this
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $option_o     | Objet      | Entrée        | Les options à ajouter à la courbe|



### Example
```4d
charts_o.graph1.dataOptions("2021"; new object(fill";"false"))
```

------------------------------------------------------

## Fonction : dataSet
Definit un nouveau set de données (une nouvelle courbe par exemple)

### Fonctionnement
```4d
Chart.dataSet($label_t; $data_c) -> Modifie this
```

| Paramètre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $label_t      | Text       | Entrée        | le label de la courbe à modifier|
| $data_c       | Collection d'entier| Entrée | Les données pour chaque point d'abscisse|



### Example
```4d
charts_o.graph1.dataSet("2021"; New collection(10,25,32,22))
```

------------------------------------------------------

## Fonction : getHTML
Renvoie le code HTML du chart.

### Fonctionnement
```4d
Chart.getHTML() -> $codeHTML_t
```

| Paramètre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $codeHTML_t      | Text       | Sortie        | Le code HTML |




### Example
```4d
charts_o.graph1.getHTML()
```

------------------------------------------------------

## Fonction : label
Permet de charget les labels (les points d'abscisse) du graphique

### Fonctionnement
```html
Chart.label($label_c) -> Modifie this
```

| Paramètre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $label_c      | Collection de text | Entrée        | La liste des labels à charger sur le graph|




### Example
```4d
charts_o.graph1.label(New collection("2018","2019","2020","2021"))
```


------------------------------------------------------

## Fonction : optionsMerge
Permet de modifier les options générales du graphique 

### Fonctionnement
```4d
Chart.optionsMerge($options_o) -> Modifie this
```

| Paramètre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $options_o    | Objet      | Entrée        | Toutes les options à ajouter au graphique|




### Example
```4d
charts_o.graph1.optionsMerge(New object("responsive","true"))
```

------------------------------------------------------

## Fonction : titleSet
Permet de modifier le titre du graphique 

### Fonctionnement
```4d
Chart.titleSet($title_t) -> Modifie this
```

| Paramètre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $title_t      | Text       | Entrée        | Le titre à ajouter / Modifier|




### Example
```4d
charts_o.graph1.titleSet("Chiffre d'affaire par année")
```


------------------------------------------------------

## Fonction : typeSet
Permet de modifier le type du graphique (barre, ligne, camembert...)

### Fonctionnement
```4d
Chart.typeSet($type_t) -> Modifie this
```

| Paramètre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $type_t       | Text       | Entrée        | Le type du graphique|




### Example
```4d
charts_o.graph1.typeSet("bar")
```