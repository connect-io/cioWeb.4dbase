<!-- Type your summary here -->
# Class : Chart

## Description

### Description
Gestion des graphiques en HTML et JS.
La librairie JavaScript utilisée est chart.js disponible ici : https://www.chartjs.org

### Accès aux fonctions
* [Fonction : constructor](#fonction--constructor)
* [Fonction : dataColor](#fonction--dataColor)
* [Fonction : dataOption](#fonction--dataOption)
* [Fonction : dataSet](#fonction--dataSet)
* [Fonction : getHtml](#fonction--getHTML)
* [Fonction : labelSet](#fonction--label)
* [Fonction : optionsMerge](#fonction--optionsMerge)
* [Fonction : titleSet](#fonction--titleSet)
* [Fonction : typeSet](#fonction--typeSet)



--------------------------------------------------------------------------------

## Fonction : constructor			
Initialisation d'un graphique.
Si vous ne passez qu'un argument, la génération du graphique se basera sur un fichier chart.json dont le libellé sera le premier argument ($libChart_t).
Si vous passez 2 arguments, la génération du graphique se basera sur un fichier chart.json dont le lib sera le deuxième argument ($modele_t) et le lib de votre graphique sera définit comme votre premier argument ($libChart_t).

### Fonctionnement
```4d
cs.Chart.new($libChart_t {;$modele_t}) -> $instance_o
```

| Paramètre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |
| $libChart_t     | Texte      | Entrée        | Le lib du graph |
| $modele_t       | Texte      | Entrée        | Le lib du modèle (optionel) |
| $instance_o     | Objet      | Sortie        | Nouvelle instance |

### Example
```4d
charts_o.graph1 := cwToolGetClass("Chart").new("EvolutionAnnee", "monModeleChart")
```


--------------------------------------------------------------------------------

## Fonction : getHtml
Renvoie le code HTML du graphique.

### Fonctionnement
```html
<!--#4DHTML Chart.getHtml()--> -> $codeHtml_t
```

| Paramètre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $codeHtml_t   | Text       | Sortie        | Le code HTML |

### Example
```html
<!--#4DHTML charts_o.graph1.getHtml()-->
```


--------------------------------------------------------------------------------

## Fonction : dataColor
Définis la couleur d'un set de donnée (d'une courbe). 
Si aucune couleur n'est précisée, ou une couleur inconnue, la courbe hérite de la couleur noire.
Vous pouvez utiliser la couleur "random" pour utiliser une couleur générée au hasard.

### Fonctionnement
```4d
Chart.dataColor($labelName_t; $colorName_t) -> Modifie this
```

| Paramètre    | Type       | entrée/sortie | Description |
| ------------ | ---------- | ------------- | ----------- |
| $labelName_t | Texte      | Entrée        | Le label de la courbe à colorer |
| $colorName_t | Texte      | Entrée        | La couleur à utiliser |

### Example
```4d
charts_o.graph1.dataColor("2021","blue")
```

##

--------------------------------------------------------------------------------

## Fonction : dataOption
Modifie ou ajoute une nouvelle option à un set de données (une courbe par exemple).

### Fonctionnement
```4d
Chart.dataOption($labelName_t; $option_o) -> Modifie this
```

| Paramètres   | Types      | entrée/sortie | Descriptions |
| ------------ | ---------- | ------------- | ------------ |
| $labelName_t | Texte      | Entrée        | Le nom du label de la courbe |
| $option_o    | Objet      | Entrée        | Les options à ajouter à la courbe |

### Example
```4d
charts_o.graph1.dataOption("2021"; new object("fill";"false"))
```


--------------------------------------------------------------------------------

## Fonction : dataSet
Permet de créer ou de modifier les données d'une courbe. Si la courbe n'existe pas, une nouvelle courbe est créée avec le label et les données passées en argument.

### Fonctionnement
```4d
Chart.dataSet($labelName_t; $data_c) -> Modifie this
```

| Paramètre    | Type                | entrée/sortie | Description |
| ------------ | ------------------- | ------------- | ----------- |
| $labelName_t | Text                | Entrée        | Le label de la courbe à modifier|
| $data_c      | Collection d'entier | Entrée        | Les données pour chaque point d'abscisse|

### Example
```4d
charts_o.graph1.dataSet("2021"; New collection(10,25,32,22))
```


--------------------------------------------------------------------------------

## Fonction : labelSet
Charge les labels (les points d'abscisse) du graphique.

### Fonctionnement
```4d
Chart.label($label_c) -> Modifie this
```

| Paramètre | Type               | entrée/sortie | Description |
| --------- | ------------------ | ------------- | ----------- |
| $label_c  | Collection de text | Entrée        | La liste des labels à charger sur le graph|

### Example
```4d
charts_o.graph1.label(New collection("2018","2019","2020","2021"))
```


--------------------------------------------------------------------------------

## Fonction : optionsMerge
Modifie les options générales du graphique.

### Fonctionnement
```4d
Chart.optionsMerge($options_o) -> Modifie this
```

| Paramètre  | Type   | entrée/sortie | Description |
| ---------- | ------ | ------------- | ----------- |
| $options_o | Objet  | Entrée        | Toutes les options à ajouter au graphique|

### Example
```4d
charts_o.graph1.optionsMerge(New object("responsive","true"))
```


--------------------------------------------------------------------------------

## Fonction : titleSet
Ajoute ou de modifie le titre du graphique.

### Fonctionnement
```4d
Chart.titleSet($title_t) -> Modifie this
```

| Paramètre | Type       | entrée/sortie | Description |
| --------- | ---------- | ------------- | ----------- |
| $title_t  | Text       | Entrée        | Le titre à ajouter / modifier|

### Example
```4d
charts_o.graph1.titleSet("Chiffre d'affaire par année")
```


--------------------------------------------------------------------------------

## Fonction : typeSet
Modifie le type du graphique (barre, ligne, camembert...).
Si le type de graphique passé en argument est inconnu, le graphique utilise par défaut le type "line".

### Fonctionnement
```4d
Chart.typeSet($type_t) -> Modifie this
```

| Paramètre | Type       | entrée/sortie | Description |
| --------- | ---------- | ------------- | ----------- |
| $type_t   | Text       | Entrée        | Le type du graphique|

### Example
```4d
charts_o.graph1.typeSet("bar")
```