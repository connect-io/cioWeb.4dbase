<!-- Type your summary here -->
# Class : ModeleMail

## Description

### Description
Gestion des modèles d'email que l'on souhaite envoyer. Un email doit avoir au minimum un nom et un fichier source HTML. Le chemin de ce fichier est l'attribut 'modelPath' du fichier email.jsonc à la racine de WebApp. Chaque modèle doit avoir un nom unique.

### Accès aux fonctions
* [Fonction : constructor](#fonction--constructor)
* [Fonction : add](#fonction--add)
* [Fonction : delete](#fonction--delete)
* [Fonction : enregistrement](#fonction--enregistrement)
* [Fonction : get](#fonction--get)
* [Fonction : getAll](#fonction--getAll)
* [Fonction : modify](#fonction--modify)
* [Fonction : layoutGetAll](#fonction--layoutGetAll)
* [Fonction : layoutAdd](#fonction--layoutAdd)
* [Fonction : layoutModify](#fonction--layoutModify)
* [Fonction : layoutDelete](#fonction--layoutDelete)
* [Fonction : transporterGetAll](#fonction--transporterGetAll)
* [Fonction : transporterAdd](#fonction--transporterAdd)
* [Fonction : transporterModify](#fonction--transporterModify)
* [Fonction : transporterDelete](#fonction--transporterDelete)


--------------------------------------------------------------------------------

## Fonction : constructor			
Initialisation de l'ensemble des modèles.
Le composant va chercher les informations des modèles dans un fichier email.jsonc à la racine de WebApp et les charger dans une collection.

### Fonctionnement
```4d
cs.ModeleMail.new()
```

### Exemple
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

### Exemple
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


### Exemple
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

### Exemple
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

| Paramètre  | Type       | entrée/sortie | Description |
| ---------- | ---------- | ------------- | ----------- |
| $name_t    | Texte      | Entrée        | Le nom du modèle (Ce nom doit être unique) |
| $reponse_o | Objet      | Sortie        | L'objet contenant toutes les informations du modèle demandé |

### Exemple
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


### Exemple
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


### Exemple
```4d
$NewModele_o.name:="Nouveau_nom"
$reponse_t:=modeleMail_o.modify($NewModele_o)
```


--------------------------------------------------------------------------------

## Fonction : layoutGetAll
Renvoie la collection de tous les layouts. Cette fonction est notamment utilisée pour charger une dataTable.

### Fonctionnement
```4d
ModeleMail.layoutGetAll() -> $allLayout_c
```

| Paramètre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $allLayout_c  | Collection | Sortie        | La collection de tous les layouts|

### Exemple
```4d
$layout_c:=modeleMail_o.layoutGetAll()
```


--------------------------------------------------------------------------------

## Fonction : layoutAdd
Permet d'ajouter un nouveau layout à partir d'un objet passé en argument comprenant toutes les informations nécessaires. Modifie ensuite le fichier email.jsonc et le storage du composant en conséquence. Renvoie la chaîne de texte "ok" si aucune erreur n'a été détectée et une autre chaine de texte selon l'erreur rencontrée. 

### Fonctionnement
```4d
ModeleMail.layoutAdd($layout_o) -> $reponse_t
```

| Paramètre  | Type       | entrée/sortie | Description |
| ---------- | ---------- | ------------- | ----------- |
| $layout_o  | Objet      | Entrée        | L'objet contenant toutes les informations du nouveau layout |
| $reponse_t | Texte      | Sortie        | La réponse à l'enregistrement |

### Exemple
```4d
$layout_o:=New Object("name";"marketing"; "source";"vente.html")
$reponse_t:=modeleMail_o.layoutAdd($layout_o)
```


--------------------------------------------------------------------------------

## Fonction : layoutModify
Modifie un layout déjà existant. Ce modèle est modifié à partir d'un objet passé en argument contenant toutes les informations du modèle mis à jour. Modifie ensuite le fichier email.jsonc et le storage du composant en conséquence. Renvoie la chaîne de texte "ok" si l'enregistrement s'est bien passé et une autre chaîne de texte selon l'erreur rencontrée. 

### Fonctionnement
```4d
ModeleMail.layoutModify($layoutModify_o) -> $reponse_t
```

| Paramètre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |
| $layoutModify_o | Objet      | Entrée        | L'objet contenant toutes les informations du nouveau layout |
| $reponse_t      | Texte      | Sortie        | La réponse à l'enregistrement |

### Exemple
```4d
$NewLayout_o.name:="Nouveau_layout"
$reponse_t:=modeleMail_o.layoutModify($NewLayout_o)
```


--------------------------------------------------------------------------------

## Fonction : layoutDelete
Supprime un layout. Ce layout est identifié par son attribut name passé en argument de la fonction.

### Fonctionnement
```4d
ModeleMail.layoutDelete($name_t) -> Modifie This
```

| Paramètre  | Type       | entrée/sortie | Description |
| ---------- | ---------- | ------------- | ----------- |
| $name_t    | Texte      | Entrée        | Le nom du modèle à supprimer|

### Exemple
```4d
$reponse_t:=modeleMail_o.layoutDelete("facture")
```


--------------------------------------------------------------------------------

## Fonction : transporterGetAll
Renvoie la collection de tous les transporteurs. Cette fonction est notamment utilisée pour charger une dataTable.
Le paramètre d'entrée est le protocol utilisé (exemples : smtp, imap...).

### Fonctionnement
```4d
ModeleMail.transporterGetAll($protocol_t) -> $allLayout_c
```

| Paramètre     | Type       | entrée/sortie | Description |
| ------------- | ---------- | ------------- | ----------- |
| $protocol_t   | Texte      | Entrée        | Le nom du protocole utilisé|
| $allLayout_c  | Collection | Sortie        | La collection de tous les layouts|

### Exemple
```4d
$layout_c:=modeleMail_o.transporterGetAll("smtp")
```


--------------------------------------------------------------------------------

## Fonction : transporterAdd
Permet d'ajouter un nouveau transporteur à partir d'un objet passé en argument comprenant toutes les informations nécessaires. Modifie ensuite le fichier email.jsonc et le storage du composant en conséquence. Renvoie la chaîne de texte "ok" si aucune erreur n'a été détectée et une autre chaine de texte selon l'erreur rencontrée.
Le deuxième paramètre d'entrée est le protocol utilisé (exemples : smtp, imap...). 

### Fonctionnement
```4d
ModeleMail.transporterAdd($transporter_o ; protocol_t) -> $reponse_t
```

| Paramètre      | Type       | entrée/sortie | Description |
| -------------- | ---------- | ------------- | ----------- |
| $transporter_o | Objet      | Entrée        | L'objet contenant toutes les informations du nouveau layout |
| $protocol_t    | Texte      | Entrée        | Le nom du protocole utilisé|
| $reponse_t     | Texte      | Sortie        | La réponse à l'enregistrement |

### Exemple
```4d
$transporter_o:=New Object("name";"marketing"; "host";"mail....")
$reponse_t:=modeleMail_o.transporterAdd($transporter_o; "smtp")
```


--------------------------------------------------------------------------------

## Fonction : transporterModify
Modifie un transporteur déjà existant. Ce transporteur est modifié à partir d'un objet passé en argument contenant toutes les informations du transporteur mis à jour. Modifie ensuite le fichier email.jsonc et le storage du composant en conséquence. Renvoie la chaîne de texte "ok" si l'enregistrement s'est bien passé et une autre chaîne de texte selon l'erreur rencontrée. 
Le deuxième paramètre d'entrée est le protocol utilisé (exemples : smtp, imap...). 

### Fonctionnement
```4d
ModeleMail.transporterModify($transporterModify_o ; protocol_t) -> $reponse_t
```

| Paramètre            | Type       | entrée/sortie | Description |
| -------------------- | ---------- | ------------- | ----------- |
| $transporterModify_o | Objet      | Entrée        | L'objet contenant toutes les informations du nouveau layout |
| $protocol_t          | Texte      | Entrée        | Le nom du protocole utilisé|
| $reponse_t           | Texte      | Sortie        | La réponse à l'enregistrement |

### Exemple
```4d
$NewLayout_o.name:="Nouveau_layout"
$reponse_t:=modeleMail_o.transporterModify($NewLayout_o; "smtp")
```


--------------------------------------------------------------------------------

## Fonction : transporterDelete
Supprime un transporteur. Ce transporteur est identifié par son attribut name passé en argument de la fonction.
Le deuxième paramètre d'entrée est le protocol utilisé (exemples : smtp, imap...). 

### Fonctionnement
```4d
ModeleMail.transporterDelete($name_t : Text ; $protocol_t) -> Modifie This
```

| Paramètre   | Type       | entrée/sortie | Description |
| ----------- | ---------- | ------------- | ----------- |
| $name_t     | Texte      | Entrée        | Le nom du transporteur à supprimer|
| $protocol_t | Texte      | Entrée        | Le nom du protocole utilisé|


### Exemple
```4d
$reponse_t:=modeleMail_o.transporterDelete("transactionnel" ; "smtp")
```

--------------------------------------------------------------------------------