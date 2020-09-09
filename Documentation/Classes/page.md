<!-- Type your summary here -->
# Class : page

### Description
Cette class permet de génerer le contenue d'une page.

### Accès aux fonctions
* [Fonction : constructor](#fonction--constructor)
* [Fonction : scanBlock](#fonction--scanBlock)


------------------------------------------------------

## Fonction : constructor
Initialisation de la page web.
ATTENTION : L'instance de la class "page" doit se faire obligatoirement par la fonction : webApp.pageCurrent()


### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| ???           | Collection | Entrée        | Information sur les routes du site provenants directement de la class webApp. |
| ???           | Objet      | Entrée        |Les informations sur le visiteur. |

### Example
```html
???
```


------------------------------------------------------

## Fonction : cssGetHtmlPath
Renvoi le HTML pour le chargement des fichiers CSS.

### Fonctionnement
```4d
user.cssGetHtmlPath($domaineCDN_t) -> $cssHtmlLink_t
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

## Fonction : cachePath
Niveau suppreme du template 4D :o) :-p Permet la gestion des blocs dans le HTML.

### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| ???           | Texte      | Entée         | ??? |


### Example
```html
???
```

