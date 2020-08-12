<!-- Type your summary here -->
# Class : user

### Description
Gére l'utilisateur / client web
	
Utilisateur sur le serveur web peut-être un visiteur d'une page web, un robot google ou un autre serveur qui vient interroger le notre.

### Accès aux fonctions
* [Fonction : constructor](#fonction--constructor)
* [Fonction : scanBlock](#fonction--scanBlock)


## Fonction : constructor			
Initialisation d'un utilisateur
ATTENTION : L'instance de la class "user" doit se faire obligatoirement par la fonction : webApp.userNew()
			
### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| ???    | Objet      | Entée         | Quelques infos de Web app (La config des sessions)|


### Example
```html
???
```


## Fonction : getInfo			
Chargement des éléments sur l'utilisateur / visiteur
Remplace la méthode : cwVisiteurGetInfo
			
### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |



### Example
```html
???
```

## Fonction : login			
À utiliser après la vérification des utilisateurs. Permet de garder l'information durant la  session.
			
### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |



### Example
```html
???
```

## Fonction : login			
À utiliser après la vérification des utilisateurs. Permet de garder l'information durant la  session.
			
### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |



### Example
```html
???
```

## Fonction : logout			
Déconnexion de l'utilisateur. Remplace la méthode : cwVisiteurLogout
			
### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |



### Example
```html
???
```

## Fonction : objectMerge			
Permet la fusion proprement d'un objet avec l'instance utilisateur
			
			
### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| ???    | Objet      | Entée         |???|


### Example
```html
???
```

## Fonction : sessionWebFolderPath			
Chemin du dossier des sessions web de l'utilisateur. Remplace la méthode : cwSessionUserFolder		
			
### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| ???    | Texte      | Sortie         |chemin du dossier de session du visiteur|


### Example
```html
???
```

## Fonction : sessionWebLoad			
Chargement des sessions web de l'utilisateur. Remplace la méthode : cwSessionUserLoad	
			
### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |



### Example
```html
???
```

## Fonction : sessionWebSave			
Sauvegarder des sessions web de l'utilisateur. Remplace la méthode : cwSessionUserSave
			
### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |



### Example
```html
???
```

## Fonction : tokenCheck			
Vérifie un jeton pour la validation d'une pages web. Remplace la méthode : cwVisiteurTokenVerifier	
			
### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| ???    | Booléen      | Sortie         |Vrai si valide|


### Example
```html
???
```

## Fonction : tokenGenerate			
Génere un jeton pour la validation des pages web. Remplace la méthode : cwVisiteurTokenGenerer
			
### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |


### Example
```html
???
```

## Fonction : updateVarVisiteur			
Sychro avec du vieux code
			
### Fonctionnement
```4d
???
```

| Paramêtre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |


### Example
```html
???
```