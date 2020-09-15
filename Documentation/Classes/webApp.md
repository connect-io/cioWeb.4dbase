<!-- Type your summary here -->
# Class : webApp

### Description
C'est la class principale du composant cioWeb.

### Accès aux fonctions
* [Fonction : cachePath](#fonction--cachePath)
* [Fonction : cacheSessionWebPath](#fonction--cacheSessionWebPath)
* [Fonction : cacheViewPath](#fonction--cacheViewPath)
* [Fonction : cacheViewSubdomainPath](#fonction--cacheViewSubdomainPath)
* [Fonction : dataTableInit](#fonction--dataTableInit)
* [Fonction : dataTableNew](#fonction--dataTableNew)
* [Fonction : htmlMinify](#fonction--htmlMinify)
* [Fonction : jsMinify](#fonction--jsMinify)
* [Fonction : pageCurrent](#fonction--pageCurrent)
* [Fonction : serverStart](#fonction--serverStart)
* [Fonction : sessionWebStart](#fonction--sessionWebStart)
* [Fonction : sourcePath](#fonction--sourcePath)
* [Fonction : sourceSubdomainPath](#fonction--sourceSubdomainPath)
* [Fonction : userNew](#fonction--userNew)
* [Fonction : webAppPath](#fonction--webAppPath)
* [Fonction : webfolderSubdomainPath](#fonction--webfolderSubdomainPath)


------------------------------------------------------

## Fonction : cachePath
Chemin complet (format plateforme) du dossier cache dans l'application webApp.

### Fonctionnement
```4d
webApp.cachePath () -> chemin_t
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| chemin_t      | Texte      | Sortie        | Chemin dossier cache |

### Example
```html
C_OBJECT($webApp_o) 
C_OBJECT(myWebApp_o)
C_TEXT($chemin_t)

// On récupére la class depuis notre composant.
$webApp:=caToolGetClass ("webApp")

// On génére une instance de la class webApp.
myWebApp_o:=$webApp.new("Tonton")

// On récupére le chemin du cache web.
$chemin_t:=myWebApp_o.cachePath()
```


------------------------------------------------------

## Fonction : cacheSessionWebPath
Chemin complet (format plateforme) des sessions web.<br />
Dans le cas ou l'on souhaite forcer un nouveau chemin, il suffit de passer un chemin valide dans ```newPath_t```, dans ce cas la fonction retournera toujours ce chemin au prochain appel.

### Fonctionnement
```4d
webApp.cacheSessionWebPath ({newPath_t}) -> path_t
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| newPath_t     | Texte      | Entée         | (Optionel) Forcer le chemin par défaut. |
| path_t        | Texte      | Sortie        | Chemin des sessions web |

### Example
```html
C_OBJECT($webApp_o) 
C_OBJECT(myWebApp_o)
C_TEXT($chemin_t)

// On récupére la class depuis notre composant.
$webApp:=caToolGetClass ("webApp")

// On génére une instance de la class webApp.
myWebApp_o:=$webApp.new("Tonton")

// On récupére le chemin du cache web.
$chemin_t:=myWebApp_o.cacheSessionWebPath()
```


------------------------------------------------------

## Fonction : cacheViewPath
Chemin complet plateforme du dossier cache des vues

### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| ????     | Texte      | Sortie        | Chemin du dossier cache des vues|

### Example
???


------------------------------------------------------

## Fonction : cacheViewSubdomainPath
Chemin complet plateforme du dossier cache des vues / sousDomaine
		

### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| ???     | Texte      | Entée         | Nom du sous domaine|
| ???        | Texte      | Sortie        | Chemin des vues du sous domaine|

### Example
```html
???
```


------------------------------------------------------

## Fonction : dataTableInit
Initialisation des dataTables.
		

### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| ???     | Objet      | Entée         | instance de user|
| ???        | Objet      | Sortie        |Instance de la dataTable en cours|

### Example
```html
???
```


------------------------------------------------------

## Fonction : dataTableNew
Chargement d'une nouvelle dataTable
		

### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| ???     | Texte      | Entée         | Lib du dataTable|
| ???     | Pointeur      | Entée         | ???|
| ???        | Objet      | Sortie        |Instance de la dataTable en cours|

### Example
```html
???
```


------------------------------------------------------

## Fonction : htmlMinify
Minification du HTML
		

### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
???

### Example
```html
???
```


------------------------------------------------------

## Fonction : pageCurrent
Chargement des éléments de la page courante
		

### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| ???     | Objet      | Entée         |instance de user|
| ???        | Objet      | Sortie        | Instance de la page courante|

### Example
```html
???
```


------------------------------------------------------

## Fonction : serverStart
Démarrage du serveur web
		

### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
???

### Example
```html
???
```


------------------------------------------------------

## Fonction : sessionWebStart
Démarrage des sessions Web
		

### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| ???     | Collection      | Entée         |option du serveur web|
| ???        | Objet      | Sortie        | Retourne tout les paramêtres de la session|

### Example
```html
???
```


------------------------------------------------------

## Fonction : sourcePath
Chemin complet plateforme du dossier Source
		

### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| ???        | Texte      | Sortie        | Chemin du dossier source|

### Example
```html
???
```


------------------------------------------------------

## Fonction : sourceSubdomainPath
Chemin complet plateforme du dossier Source/sousDomaine
		

### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| ???     | Texte      | Entée         |Nom du sous domaine|
| ???        | Texte      | Sortie        | Chemin du dossier source du sous domaine|

### Example
```html
???
```


------------------------------------------------------

## Fonction : userNew
Chargement des éléments sur l'utilisateur / visiteur
		

### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| ???        | Objet      | Sortie        | Instance de l'utilisateur en cours|

### Example
```html
???
```


------------------------------------------------------

## Fonction : webAppPath
Chemin complet plateforme du dossier WebApp.
		

### Fonctionnement
```4d
webApp.webAppPath() -> $path_t
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $path_t       | Texte      | Sortie        | Chemin du dossier WebApp |

### Example
```4d
$chemin_t:=<>webApp_o.webAppPath()
```


------------------------------------------------------

## Fonction : webfolderSubdomainPath
Chemin complet plateforme du dossier Webfolder/sousDomaine
		

### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| ???     | Texte      | Entée         |Nom du sous domaine|
| ???        | Texte      | Sortie        |Chemin du dossier webfolder du sous domaine|

### Example
```4d

```
