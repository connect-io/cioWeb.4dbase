<!-- Type your summary here -->
# Class : Page

### Description
Cette class permet de génerer le contenue d'une page.

### Accès aux fonctions
* [Fonction : constructor](#fonction--constructor)
* [Fonction : cssGetHtmlPath](#fonction--cssGetHtmlPath)
* [Fonction : jsGetHtmlPath](#fonction--jsGetHtmlPath)
* [Fonction : scanBlock](#fonction--scanBlock)


------------------------------------------------------

## Fonction : constructor
Initialisation de la page web.

### Fonctionnement
Interne au composant cioWeb.

### Example
```4d
  // ===== Chargement des informations sur la page =====
pageWeb_o:=cwToolGetClass("Page").new(visiteur_o)
```


------------------------------------------------------

## Fonction : cssGetHtmlPath
Renvoi le HTML pour le chargement des fichiers CSS.

### Fonctionnement
```4d
Page.cssGetHtmlPath($domaineCDN_t) -> $cssHtmlLink_t
```

| Paramêtre      | Type       | entrée/sortie | Description |
| -------------- | ---------- | ------------- | ----------- |
| $domaineCDN_t  | Texte      | Entrée        | Permet d'ajouter un CDN en production. |
| $cssHtmlLink_t | Texte      | Sortie        | Contenu HTML des appels CSS |


### Example
```html
<!--#4DHTML pageWeb_o.cssGetHtmlPath()-->
```


------------------------------------------------------

## Fonction : jsGetHtmlPath
Renvoi le HTML pour le chargement des fichiers JS déclaré dans le fichier pageWeb.json

### Fonctionnement
```4d
Page.jsGetHtmlPath($domaineCDN_t) -> $jsHtmlLink_t
```

| Paramêtre      | Type       | entrée/sortie | Description |
| -------------- | ---------- | ------------- | ----------- |
| $domaineCDN_t  | Texte      | Entrée        | Permet d'ajouter un CDN en production. |
| $jsHtmlLink_t  | Texte      | Sortie        | Contenu HTML des appels JS |


### Example
```html
<!--#4DHTML pageWeb_o.jsGetHtmlPath()-->
```


------------------------------------------------------

## Fonction : jsInHtml
Place le contenue du fichier javascript dans le HTML.

### Fonctionnement
```4d
Page.jsInHtml() -> $jsInHtml_t
```

| Paramêtre      | Type       | entrée/sortie | Description |
| -------------- | ---------- | ------------- | ----------- |
| $jsInHtml_t    | Texte      | Sortie        | Contenu JS  |


### Example

Déclaration dans le fichier *.route.json:
```json
"jsPathInHtml":[
  "_cioWeb/js/notification.js",
  "_layout/js/layout.js"
]
```

Utilisation dans le fichier *.html:
```html
<!--#4DHTML pageWeb_o.jsInHtml()-->
```


------------------------------------------------------

## Fonction : scanBlock
Niveau suppreme du template 4D :o) :-p Permet la gestion des blocs dans le HTML.

### Fonctionnement
```4d
Page.scanBlock($corpsHtml_t) -> Modifie this
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $corpsHtml_t  | Texte      | Entée         | Contenu HTML dans lequel on souhaite retrouver les blocks. |


### Example
```html
pageWeb_o.scanBlock($contenuFichierCorpsHtml_t)
```

