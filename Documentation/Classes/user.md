<!-- Type your summary here -->
# Class : User

### Description
Gère l'utilisateur / client web
	
Utilisateur sur le serveur web peut-être un visiteur d'une page web, un robot google ou un autre serveur qui vient interroger le nôtre.

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


--------------------------------------------------------------------------------

## Fonction : constructor			
Initialisation d'un utilisateur
			
### Fonctionnement
Interne au composant cioWeb.

### Example
```4d
// Méthode sur connexion web.
C_OBJECT(visiteur_o)

// webConfig_o est chargé depuis la méthode sur ouverture.
visiteur_o:=cwToolGetClass("User").new()

```


--------------------------------------------------------------------------------

## Fonction : entityToForm		
Chargement des informations d'une entité dans un formulaire 

			
### Fonctionnement
```4d
User.entityToForm($entity, "nomDeMonFormulaire") -> Modifie this
```

| Paramètre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $entity       | entité     | Entrée         | L'entité dont on charge les infos dans le formulaire|
| "nomDuFormulaire"      | texte    | Entrée         | Le nom du formulaire à remplir|

### Example
```4d
visiteur_o.entityToForm($Article_entity, "formShopArticle")
```


--------------------------------------------------------------------------------

## Fonction : formInfo	
Renvoie une copie des informations d'un formulaire
			
### Fonctionnement
```4d
User.formInfo($nameForm_t) -> $form_o
```

| Paramètre   | Type      | entrée/sortie | Description |
| ----------- | --------- | ------------- | ----------- |
| $nameForm_t | Texte     | Entrée        | Le nom du formulaire à renvoyer |
| $form_o     | Objet     | Sortie        | Les informations du formulaire  |

### Example
```4d
$form_o := visiteur_o.formInfo("formShopArticle")
```

--------------------------------------------------------------------------------

## Fonction : formToEntity	
Charge les valeurs d'un formulaire vers une entité (ou objet).
			
### Fonctionnement
```4d
User.formToEntity($valueInput_o) -> $form_o
```

| Paramètre     | Type      | entrée/sortie | Description |
| ------------- | --------- | ------------- | ----------- |
| $valueInput_o | Pointer   | Entrée        | Objet qui sert à remplir les inputs du formulaire |

### Example
```4d
$form_o := visiteur_o.formToEntity($valueInput_o)
```

--------------------------------------------------------------------------------

## Fonction : getInfo			
Chargement des éléments sur l'utilisateur / visiteur
Remplace la méthode : cwVisiteurGetInfo
			
### Fonctionnement
```4d
User.getInfo() -> Modifie this
```

La fonction ne requiert pas de paramètre.

### Example
Voir la méthode de base [sur connexion web](/Documentation/commencer.md) sur la page Commencer.

--------------------------------------------------------------------------------

## Fonction : login			
À utiliser après la vérification des utilisateurs.  
Conserve l'information durant la session.
			
### Fonctionnement
```4d
User.login() -> Modifie this
```
La fonction ne requiert pas de paramètre.

### Example
```4d
visiteur_o.login()
```

--------------------------------------------------------------------------------

## Fonction : logout			
Déconnexion de l'utilisateur.
			
### Fonctionnement
```4d
User.logout() -> Modifie this
```

La fonction ne requiert pas de paramètre.


### Example
```html
???
```

--------------------------------------------------------------------------------

## Fonction : objectMerge			
Permet la fusion proprement d'un objet avec l'instance utilisateur
			
### Fonctionnement
```4d
User.objectMerge($fils_o) -> Modifie this
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

--------------------------------------------------------------------------------

## Fonction : sessionWebFolderPath			
Chemin du dossier des sessions web de l'utilisateur.	
			
### Fonctionnement
```4d
User.sessionWebFolderPath() -> $cheminSession_t
```

| Paramètre        | Type       | entrée/sortie | Description |
| ---------------- | ---------- | ------------- | ----------- |
| $cheminSession_t | Texte      | Sortie        | chemin du dossier de session du visiteur. |


### Example
```4d
C_TEXT($DossierDestination_t)
$DossierDestination_t:=visiteur_o.sessionWebFolderPath()
```

--------------------------------------------------------------------------------

## Fonction : sessionWebLoad			
Chargement des sessions web de l'utilisateur.
			
### Fonctionnement
```4d
User.sessionWebLoad() -> Modifie this
```

La fonction ne requiert pas de paramètre.


### Example
Voir la méthode de base [sur connexion web](/Documentation/commencer.md) sur la page Commencer.


--------------------------------------------------------------------------------

## Fonction : sessionWebSave			
Sauvegarder des sessions web de l'utilisateur. Cette fonction est à utiliser dans la méthode "Sur fermeture process web".
			
### Fonctionnement
```4d
User.sessionWebSave()
```

La fonction ne requiert pas de paramètre.


### Example
```4d
visiteur_o.sessionWebSave()
```

--------------------------------------------------------------------------------

## Fonction : tokenCheck			
Vérifie un jeton pour la validation d'une page web. Remplace la méthode : cwVisiteurTokenVerifier	
			
### Fonctionnement
```4d
User.tokenCheck() -> $tokenValide_o
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

--------------------------------------------------------------------------------

## Fonction : tokenGenerate			
Génère un jeton pour la validation des pages web.
			
### Fonctionnement
```4d
User.tokenGenerate() -> Modifie this
```

La fonction ne requiert pas de paramètre.

### Example
Voir la méthode de base [sur connexion web](/Documentation/commencer.md) sur la page Commencer.

--------------------------------------------------------------------------------

## Fonction : updateVarVisiteur			
Synchro avec du vieux code. Ne pas utiliser dans de nouveaux projets.
			
### Fonctionnement
```4d
User.updateVarVisiteur()
```

La fonction ne requiert pas de paramètre.

### Example
```4d
visiteur_o.tokenGenerate()
```