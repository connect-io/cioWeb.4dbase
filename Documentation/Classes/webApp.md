<!-- Type your summary here -->
# Class : webApp

### Description
C'est la class principale du composant cioWeb.

### Accès aux fonctions
* [Fonction : cachePath](#fonction--cachePath)
* [Fonction : cacheSessionWebPath](#fonction--cacheSessionWebPath)



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