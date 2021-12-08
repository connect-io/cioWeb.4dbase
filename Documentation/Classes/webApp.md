<!-- Type your summary here -->
# Class : WebApp

### Description
C'est la class principale du composant cioWeb.

### Accès aux fonctions
* [Fonction : cachePath](#fonction--cachePath)
* [Fonction : cacheSessionWebPath](#fonction--cacheSessionWebPath)
* [Fonction : cacheViewPath](#fonction--cacheViewPath)
* [Fonction : cacheViewSubdomainPath](#fonction--cacheViewSubdomainPath)
* [Fonction : htmlMinify](#fonction--htmlMinify)
* [Fonction : jsMinify](#fonction--jsMinify)
* [Fonction : serverStart](#fonction--serverStart)
* [Fonction : sessionWebStart](#fonction--sessionWebStart)
* [Fonction : sourcePath](#fonction--sourcePath)
* [Fonction : sourceSubdomainPath](#fonction--sourceSubdomainPath)
* [Fonction : webAppPath](#fonction--webAppPath)
* [Fonction : webfolderSubdomainPath](#fonction--webfolderSubdomainPath)
* [Fonction : eMailConfigLoad](#fonction--eMailConfigLoad)



--------------------------------------------------------------------------------

## Fonction : cacheSessionWebPath
Chemin complet (format plateforme) des sessions web.<br />
Dans le cas où l'on souhaiterait forcer un nouveau chemin, il suffit de passer un chemin valide dans ```newPath_t```, dans ce cas la fonction retournera toujours ce chemin au prochain appel.

### Fonctionnement
```4d
WebApp.cacheSessionWebPath ({newPath_t}) -> path_t
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
$webApp:=caToolGetClass ("WebApp")

// On génère une instance de la class webApp.
myWebApp_o:=$webApp.new("Tonton")

// On récupère le chemin du cache web.
$chemin_t:=myWebApp_o.cacheSessionWebPath()
```


--------------------------------------------------------------------------------

## Fonction : cacheViewPath
Chemin complet plateforme du dossier cache des vues

### Fonctionnement
```4d
WebApp.cacheViewPath()
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| ????     | Texte      | Sortie        | Chemin du dossier cache des vues|

### Example
???


--------------------------------------------------------------------------------

## Fonction : cacheViewSubdomainPath
Chemin complet plateforme du dossier cache des vues / sousDomaine
		

### Fonctionnement
```4d
WebApp.cacheViewSubdomainPath()
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| ???     | Texte      | Entée         | Nom du sous-domaine|
| ???        | Texte      | Sortie        | Chemin des vues du sous-domaine|

### Example
```html
???
```



--------------------------------------------------------------------------------

## Fonction : eMailConfigLoad
Permet de configurer la boite mail et les modèles présents. On doit obligatoirement avoir inclus un fichier email.json sur dans le dossier. Ces variables viendront se greffer au champ globalVar d'un mail nouvellement créé grâce à la classe mail.


### Fonctionnement
```4d
WebApp.eMailConfigLoad({$globalVar})
```

| Paramêtre             | Type       | entrée/sortie             | Description |
| --------------------- | ---------- | ------------------------- | ----------- |
| $globalVar            | Objet      | Entrée  (optionnel)       |Permet de mettre des variables globales que l'on pourra inclure dans tous les mails ( par exemple le nom de la boutique, du domaine, le lien vers la page facebook, un numero de telephone, ...)|

### Example
```4d
// Configuration du chargement des emails

$globalVar:=New object()

$globalVar.boutiqueDomaine:="connect-io.fr"
$globalVar.boutiqueNom:="connect-io.fr"
$globalVar.boutiqueUrlFaceBook:="https://www.connect-io.fr"
$globalVar.boutiqueTelephone:="0123456789"

<>webApp_o.eMailConfigLoad($globalVar)
```
### Inclure ces variables dans un modèle de mail
Une fois que ces variables sont chargées dans les mails, il est simple de les appeler depuis le modèle html d'un mail : 
```html
<!--#4DTEXT this.globalVar.*nomAttribut*-->
```
Pour plus d'informations sur les mails, merci de vous référer à la classe [webApp](EMail.md).

--------------------------------------------------------------------------------

## Fonction : htmlMinify
Minification du HTML
		

### Fonctionnement
```4d
WebApp.htmlMinify()
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
???

### Example
```html
???
```

--------------------------------------------------------------------------------

## Fonction : serverStart
Démarrage du serveur web
		

### Fonctionnement
```4d
WebApp.serverStart() -> Modifie this
```

La fonction ne requiert pas de paramètre.

### Example
```4d
<>webApp_o.serverStart()
```

--------------------------------------------------------------------------------

## Fonction : sessionWebStart
Démarrage des sessions Web
		

### Fonctionnement
```4d
WebApp.sessionWebStart({$option_c}) -> Modifie this
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $option_c     | Collection      | Entée         |option du serveur web|

### Example
```4d
  // Démarrage des sessions.
<>webApp_o.sessionWebStart()
```

--------------------------------------------------------------------------------

## Fonction : sourceSubdomainPath
Chemin complet plateforme du dossier Source/sousDomaine
		

### Fonctionnement
```4d
WebApp.sourceSubdomainPath({$domaine_t}) -> $chemin_t
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $domaine_t    | Texte      | Entée         | Nom du sous-domaine |
| $chemin_t     | Texte      | Sortie        | Chemin du dossier source du sous-domaine |

### Example
```4d
$cheminSourceSousDomaine_t:=<>webApp_o.sourceSubdomainPath("www")

// $cheminSourceSousDomaine_t = [...]/monApp4D/WebApp/Sources/www/
```

--------------------------------------------------------------------------------

## Fonction : webfolderSubdomainPath
Chemin complet plateforme du dossier Webfolder/sousDomaine  
Il est possible de forcer l'accès à un sous-domaine en l'inscrivant dans $domaine_t. Dans le cas contraire, vous utiliserez le domaine de la requête HTTPS.


### Fonctionnement
```4d
WebApp.webfolderSubdomainPath({$domaine_t}) -> $path_t
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $domaine_t    | Texte      | Entée         |Nom du sous domaine|
| $chemin_t     | Texte      | Sortie        |Chemin du dossier webfolder du sous domaine|

### Example
```4d
$cheminDossierWebAppSousDomaine_t:=<>webApp_o.webfolderSubdomainPath("www")

// $cheminDossierWebAppSousDomaine_t = [...]/monApp4D/WebApp/WebFolder/www/
```