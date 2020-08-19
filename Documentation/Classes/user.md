﻿<!-- Type your summary here -->
# Class : user

### Description
Gère l'utilisateur / client web
	
Utilisateur sur le serveur web peut-être un visiteur d'une page web, un robot google ou un autre serveur qui vient interroger le notre.

### Accès aux fonctions
* [Fonction : constructor](#fonction--constructor)
* [Fonction : getInfo](#fonction--getInfo)
* [Fonction : login](#fonction--login)
* [Fonction : logout](#fonction--logout)
* [Fonction : objectMerge](#fonction--objectMerge)
* [Fonction : sessionWebFolderPath](#fonction--sessionWebFolderPath)
* [Fonction : sessionWebLoad](#fonction--sessionWebLoad)
* [Fonction : sessionWebSave](#fonction--sessionWebSave)
* [Fonction : tokenCheck](#fonction--tokenCheck)
* [Fonction : tokenGenerate](#fonction--tokenGenerate)
* [Fonction : updateVarVisiteur](#fonction--updateVarVisiteur)


------------------------------------------------------

## Fonction : constructor			
Initialisation d'un utilisateur
ATTENTION : L'instance de la class "user" doit se faire obligatoirement par la fonction : webApp.userNew()
			
### Fonctionnement
Interne au composant cioWeb.

### Example
```4d
// Méthode sur connexion web.
C_OBJECT(visiteur_o)

// webConfig_o est chargé depuis la méthode sur ouverture.
visiteur_o:=<>webConfig_o.userNew()

```


------------------------------------------------------

## Fonction : getInfo			
Chargement des éléments sur l'utilisateur / visiteur
Remplace la méthode : cwVisiteurGetInfo
			
### Fonctionnement
```4d
user.getInfo() -> Modifie this
```

La fonction ne requiert pas de paramètre.

### Example
Voir la méthode de base [sur connexion web](/Documentation/commencer.md) sur la page Commencer.


------------------------------------------------------

## Fonction : login			
À utiliser après la vérification des utilisateurs.  
Conserve l'information durant la session.
			
### Fonctionnement
```4d
user.login() -> Modifie this
```
La fonction ne requiert pas de paramètre.

### Example
```4d
visiteur_o.login()
```


------------------------------------------------------

## Fonction : logout			
Déconnexion de l'utilisateur.
			
### Fonctionnement
```4d
user.logout() -> Modifie this
```

La fonction ne requiert pas de paramètre.


### Example
```html
???
```


------------------------------------------------------

## Fonction : objectMerge			
Permet la fusion proprement d'un objet avec l'instance utilisateur
			
### Fonctionnement
```4d
user.objectMerge($fils_o) -> Modifie this
```

| Paramètre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| fils_o        | Objet      | Entée         | Objet qui sera fusionner avec le visiteur.|


### Example
```4d
C_OBJECT(O_avatar)
O_avatar:=New object()

OB SET(O_avatar;"X-URL";$1)
O_avatar.Host:="clients."+<>webConfig_o.domaine.nom

visiteur.objectMerge(O_avatar)
```


------------------------------------------------------

## Fonction : sessionWebFolderPath			
Chemin du dossier des sessions web de l'utilisateur.	
			
### Fonctionnement
```4d
user.objectMerge() -> $cheminSession_t
```

| Paramètre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| cheminSession_t | Texte    | Sortie        | chemin du dossier de session du visiteur. |


### Example
```4d
C_TEXT($DossierDestination_t)
$DossierDestination_t:=visiteur_o.sessionWebFolderPath()
```


------------------------------------------------------

## Fonction : sessionWebLoad			
Chargement des sessions web de l'utilisateur.
			
### Fonctionnement
```4d
user.sessionWebLoad() -> Modifie this
```

La fonction ne requiert pas de paramètre.


### Example
Voir la méthode de base [sur connexion web](/Documentation/commencer.md) sur la page Commencer.



------------------------------------------------------
## Fonction : sessionWebSave			
Sauvegarder des sessions web de l'utilisateur. Cette fonction est à utiliser dans la méthode "Sur fermeture process web".
			
### Fonctionnement
```4d
user.sessionWebSave()
```

La fonction ne requiert pas de paramètre.


### Example
```4d
visiteur_o.sessionWebSave()
```


------------------------------------------------------

## Fonction : tokenCheck			
Vérifie un jeton pour la validation d'une pages web. Remplace la méthode : cwVisiteurTokenVerifier	
			
### Fonctionnement
```4d
user.sessionWebSave() -> $tokenValide_o
```

| Paramètre      | Type       | entrée/sortie | Description |
| -------------- | ---------- | ------------- | ----------- |
| $tokenValide_o | Booléen    | Sortie        | Vrai si valide |


### Example
```4d
// Vérification du token
If (visiteur_o.tokenCheck())
	
// Faire quelque chose...
	
End if 
```


------------------------------------------------------

## Fonction : tokenGenerate			
Génere un jeton pour la validation des pages web.
			
### Fonctionnement
```4d
user.tokenGenerate() -> Modifie this
```

La fonction ne requiert pas de paramètre.

### Example
Voir la méthode de base [sur connexion web](/Documentation/commencer.md) sur la page Commencer.


------------------------------------------------------

## Fonction : updateVarVisiteur			
Synchro avec du vieux code. Ne pas utiliser dans de nouveau projet.
			
### Fonctionnement
```4d
user.updateVarVisiteur()
```

La fonction ne requiert pas de paramètre.

### Example
```4d
visiteur_o.tokenGenerate()
```