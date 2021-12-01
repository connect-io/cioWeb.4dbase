<!-- Type your summary here -->
# Class : Page

### Description
Cette class permet de générer le contenu d'une page.

### Accès aux fonctions
* [Fonction : constructor](#fonction--constructor)
* [Fonction : cssGetHtmlPath](#fonction--cssGetHtmlPath)
* [Fonction : jsGetHtmlPath](#fonction--jsGetHtmlPath)
* [Fonction : scanBlock](#fonction--scanBlock)

--------------------------------------------------------------------------------

## Fonction : constructor
Initialisation de la page web.

### Fonctionnement
Interne au composant cioWeb.

### Example
```4d
  // ===== Chargement des informations sur la page =====
pageWeb_o:=cwToolGetClass("Page").new(visiteur_o)
```

--------------------------------------------------------------------------------

## Fonction : cssGetHtmlPath
Renvoie le HTML pour le chargement des fichiers CSS.

### Fonctionnement
```4d
Page.cssGetHtmlPath($domaineCDN_t) -> $cssHtmlLink_t
```

| Paramètre      | Type       | entrée/sortie | Description |
| -------------- | ---------- | ------------- | ----------- |
| $domaineCDN_t  | Texte      | Entrée        | Permet d'ajouter un CDN en production. |
| $cssHtmlLink_t | Texte      | Sortie        | Contenu HTML des appels CSS |


### Example
```html
<!--#4DHTML pageWeb_o.cssGetHtmlPath()-->
```

--------------------------------------------------------------------------------

## Fonction : i18nGet
Mise en veille de l'internalisation avec utilisation de storage.

### Fonctionnement
```4d
Page.i18nGet($nameAttribut_t) -> $reponse_t
```

| Paramètre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |
| $nameAttribut_t | Texte      | Entrée        | Nom de l'attribut de l'objet que l'on souhaite utiliser. |
| $reponse_t      | Texte      | Sortie        | Le text en retour |

--------------------------------------------------------------------------------

## Fonction : jsGetHtmlPath
Renvoi le HTML pour le chargement des fichiers JS déclarés dans le fichier pageWeb.json

### Fonctionnement
```4d
Page.jsGetHtmlPath($domaineCDN_t) -> $jsHtmlLink_t
```

| Paramètre      | Type       | entrée/sortie | Description |
| -------------- | ---------- | ------------- | ----------- |
| $domaineCDN_t  | Texte      | Entrée        | Permet d'ajouter un CDN en production |
| $jsHtmlLink_t  | Texte      | Sortie        | Contenu HTML des appels JS |


### Example
```html
<!--#4DHTML pageWeb_o.jsGetHtmlPath()-->
```

--------------------------------------------------------------------------------

## Fonction : jsInHtml
Place le contenu du fichier javascript dans le HTML.

### Fonctionnement
```4d
Page.jsInHtml() -> $jsInHtml_t
```

| Paramètre   | Type       | entrée/sortie | Description |
| ----------- | ---------- | ------------- | ----------- |
| $jsInHtml_t | Texte      | Sortie        | Contenu JS  |


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

--------------------------------------------------------------------------------

## Fonction : scanBlock
Niveau suprême du template 4D :o) :-p Permet la gestion des blocs dans le HTML.

### Fonctionnement
```4d
Page.scanBlock($corpsHtml_t) -> Modifie this
```

| Paramètre    | Type       | entrée/sortie | Description |
| ------------ | ---------- | ------------- | ----------- |
| $corpsHtml_t | Texte      | Entée         | Contenu HTML dans lequel on souhaite retrouver les blocks. |
| $reponse_t   | Texte      | Sortie        | Retourne les éléments du fichier qui ne sont pas dans un block. |

### Example
```html
pageWeb_o.scanBlock($contenuFichierCorpsHtml_t)
```

--------------------------------------------------------------------------------

## Fonction : redirection301
Etabli une redirection 301 http(de type permanante).

### Fonctionnement
```4d
Page.redirection301($newUrl_t) -> Modifie this
```

| Paramètre  | Type       | entrée/sortie | Description |
| ---------- | ---------- | ------------- | ----------- |
| $newUrl_t  | Texte      | Entée         | Nouvelle url. |

### Example
```html
pageWeb_o.redirection301($newUrl_t)
```

