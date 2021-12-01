<!-- Type your summary here -->
# Class : ModeleMail

## Description

### Description
Gestion des modèles de mail que l'on souhaite envoyer. Un email doit avoir au minimum un nom et un fichier source HTML. Le chemin de ce fichier est l'attribut 'modelPath' du fichier email.jsonc à la racine de WebApp. Chaque modèle doit avoir un nom unique.

### Accès aux fonctions
* [Fonction : constructor](#fonction--constructor)
* [Fonction : add](#fonction--add)
* [Fonction : delete](#fonction--delete)
* [Fonction : enregistrement](#fonction--enregistrement)
* [Fonction : get](#fonction--get)
* [Fonction : getAll](#fonction--getAll)
* [Fonction : modify](#fonction--modify)




--------------------------------------------------------------------------------

## Fonction : constructor			
Initialisation de l'ensemble des modèles.
Le composant va chercher les informations des modèles dans un fichier email.jsonc à la racine de WebApp et les charger dans une collection.

### Fonctionnement
```4d
cs.ModeleMail.new()
```

| Paramètre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |
|                 |            |               |             |



### Example
```4d
modeleMail_o:=cwToolGetClass("ModeleMail").new()
```

--------------------------------------------------------------------------------

## Fonction : add
Permet d'ajouter un nouveau modèle à partir d'un objet passé en argument comprenant toutes les informations nécessaires. Modifie ensuite le fichier email.jsonc et le storage du composant en conséquence. Renvoie la chaîne de texte "ok" si aucune erreur n'a été détectée et une autre chaine de texte selon l'erreur rencontrée. 
Pour les attributs differents de 'name', 'source', 'subject', 'sourceHTML', l'objet passé en argument doit contenir un attribut 'personnalisation' contenant toutes les autres informations du modèle sous forme de chaîne de texte JSON. Chacune des informations sera enregistrée normalement dans le fichier email.jsonc par la suite.


### Fonctionnement
```4d
ModeleMail.add($modele_o) -> $reponse_t
```

| Paramètre  | Type       | entrée/sortie | Description |
| ---------- | ---------- | ------------- | ----------- |
| $modele_o  | Objet      | Entrée        | L'objet contenant toutes les informations du nouveau modèle |
| $reponse_t | Texte      | Sortie        | La réponse à l'enregistrement |


### Example
```4d
$modele_o:=New Object("name";"facture"; "source";"facture.html")
$reponse_t:=modeleMail_o.add($modele_o)
```

--------------------------------------------------------------------------------

## Fonction : delete
Supprime un modèle. Ce modèle est identifié par son attribut name passé en argument de la fonction.

### Fonctionnement
```4d
ModeleMail.delete($name_t) -> Modifie This
```

| Paramètre  | Type       | entrée/sortie | Description |
| ---------- | ---------- | ------------- | ----------- |
| $name_t    | Texte      | Entrée        | Le nom du modèle à supprimer|



### Example
```4d
$reponse_t:=modeleMail_o.delete("facture")
```

--------------------------------------------------------------------------------

## Fonction : enregistrement
Réécrit le fichier email.jsonc à partir des informations contenues dans l'instance de la classe et appelle la méthode 'cwEMailConfigLoad' qui recharge ces informations dans le storage du composant. Cette méthode n'est pas censée être utilisée hors du composant.

### Fonctionnement
```4d
ModeleMail.enregistrement() -> Modifie Storage et email.jsonc
```


| Paramètre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |
|                 |            |               |             |



### Example
```4d
This.enregistrement()
```

--------------------------------------------------------------------------------

## Fonction : get
Renvoie les informations d'un modèle. Ce modèle est identifié par son attribut name passé en argument de la fonction.


### Fonctionnement
```4d
ModeleMail.get($name_t) -> $modele_o
```

| Paramètre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $name_t       | Texte      | Entrée        | Le nom du modèle (Ce nom doit être unique) |
| $reponse_t    | Objet      | Sortie        | L'objet contenant toutes les informations du modèle demandé |


### Example
```4d
$modele_o:=modeleMail_o.get("facture")
```

--------------------------------------------------------------------------------

## Fonction : getAll
Renvoie la collection de tous les modèles. Cette fonction est notamment utilisée pour charger une dataTable.


### Fonctionnement
```4d
ModeleMail.getAll() -> $modeles_c
```

| Paramètre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $modeles_c    | Collection | Sortie        | La collection de tous les modèles|


### Example
```4d
$modeles_c:=modeleMail_o.getAll()
```

--------------------------------------------------------------------------------


## Fonction : modify
Modifie un modèle déjà existant. Ce modèle est modifié à partir d'un objet passé en argument contenant toutes les informations du modèle mis à jour. Modifie ensuite le fichier email.jsonc et le storage du composant en conséquence. Renvoie la chaîne de texte "ok" si l'enregistrement s'est bien passé et une autre chaîne de texte selon l'erreur rencontrée. 
Pour les attributs différents de 'name', 'source' et 'subject' et 'sourceHTML', l'objet passé en argument doit contenir un attribut 'personnalisation' contenant toutes les autres informations du modèle sous forme de chaîne de texte JSON. Chacune des informations sera enregistrée normalement dans le fichier email.jsonc par la suite.


### Fonctionnement
```4d
ModeleMail.modify($modele_o) -> $reponse_t
```

| Paramètre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $modele_o     | Objet      | Entrée        | L'objet contenant toutes les informations du nouveau modèle |
| $reponse_t    | Texte      | Sortie        | La réponse à l'enregistrement |


### Example
```4d
$NewModele_o.name:="Nouveau_nom"
$reponse_t:=modeleMail_o.modify($NewModele_o)
```
```

--------------------------------------------------------------------------------