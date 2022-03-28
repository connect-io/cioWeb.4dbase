<!-- Type your summary here -->
# Class : EMail

### Description
Gestion de l'envoi des mails. La configuration se fait par le biais d'un fichier de config "email.json" qui se trouve à la racine du dossier Sources. La lecture de ce document se fait nécessairement en appelant la fonction EMailConfigLoad de la classe [EMail](webApp.md).

### Accès aux fonctions
* [Fichier : email.json](#fichier--email.json)
* [Fonction : constructor](#fonction--constructor)
* [Fonction : send](#fonction--send)
* [Fonction : sendModel](#fonction--sendModel)



--------------------------------------------------------------------------------

## Fichier : email.json		
Ce fichier recense diverses informations sur la configuration des emails.
Il contient 4 objets.

| Objet     | Utilité                                                                            | 
| --------- | ---------------------------------------------------------------------------------- | 
| modelPath |  Chemin depuis le dossier source pour atteindre les models                         |
| smtp      |  Dans cet objet, on recense les différents transporteurs que l'on souhaite utiliser|
| model     |  Définit les modèles des mails enregistrés par défaut                              |
| mjml      |  Optionnel, il permet d'utiliser l'API de MJML, qui transforme un fichier mjml en fichier html                                                                                     |

### Example
```
{
	"modelPath": "www/email/",

	"smtp":[
		{
			"name": "transactionnel",
			"host": "pro1.mail.ovh.net",
			"user": "adresse1@mail.com",
			"password":	"motDePasse1"
		},
		{
			"name": "prospection",
			"host": "xxx",
			"port":	465,
			"user": "adresse2@mail.com",
			"password":	"motDePasse2",
			"from":	"xxxx"
		}
	],
	"imap": [
		{
			"name": "transactionnel",
			"host": "pro1.mail.ovh.net",
			"user": "adresse1@mail.com",
			"password": "motDePasse1",
			"boxName":{
				"inbox": "INBOX",
				"sent": "Éléments envoyés",
				"draft": "Brouillons",
				"trash": "Éléments supprimés"
			}
		}
	],

	"model": [
		{
			"name": "demo",
			"object": "E-mail de démonstration",

			// Attention la source des models doit être au format POSIX.
			"source": "facture/demo1.mjml",
			"to": [
				"adresse3@mail.com"
			],
            "layout": "facture/test.mjml",
			"archive":true               // Optionnel, si true, les mails envoyés sont archivés dans le dossier archive
		}
	],

	"mjml": {
		"applicationID" : "xxxxxxx",
		"secretKey": "xxxxxxx",
		"urlAPI" : "https://api.mjml.io/v1/render"
	}

}
```
Note : les fichiers de source et layout peuvent être des fichiers HTML ou MJML, comme on le désire. Il sera préférable d'utiliser MJML pour avoir des mails en format responsive. 
Plus d'informations sur le langage <a href = "https://mjml.io/documentation/">ici</a>.


--------------------------------------------------------------------------------

## Fonction : constructor			
Initialisation du transporteur de mail

### Fonctionnement
```4d
cs.EMail.new(options) -> Configure le transporteur
```

| Paramêtre         | Type       | entrée/sortie | Description                   |
| ----------------- | ---------- | ------------- | ----------------------------- |
| $name_t           | Texte      | Entrée        | Le nom de l'instance du SMTP souhaité, et défini dans le fichier de config email.jsonc   |
| $paramOptionnel_o | Objet      | Entrée        | Un objet correspondant aux options que l'on souhaite rajouer / ecraser par rapport au transporteur choisi     |

### Example
```4d
var $mail : cs.EMail
$name_t := "transactionnel"
$paramOptionnel_o:= New Object("user";"adresse@mail.com")

$mail:=cs.EMail.new($name_t;$paramOptionnel_o)
```


--------------------------------------------------------------------------------

## Fonction : send
Permet d'envoyer un mail sans modèle particulier, en fonction des instances de l'objet que l'on est en train d'utiliser. Plus particulièrement, il faudra obligatoirement remplir les champs : <b>this.to, this.htmlBody </b>, et de manière optionnelle : <b>this.attachmentsPath_c</b>

### Fonctionnement
```4d
$EMail.send() -> $resultat_o
```

| Paramêtre              | Type       | Description                                               |
| ---------------------- | ---------- | --------------------------------------------------------- |
| this.to                | Texte      | Adresse du destinataire                                   |
| this.htmlBody          | Texte      | Corps du texte                                            |
| this.attachmentsPath_c | Collection | Collection contenant les pièces jointes à inclure au mail |
| this.subject           | Texte      | L'objet du mail en question                               |

La méthode send renverra des informations sur l'envoi de l'email. Voir <a href="https://doc.4d.com/4Dv18/4D/18/SMTP-transportersend.305-4505974.en.html">ici</a> pour obtenir des informations précises sur ce qui est renvoyées, et pour en savoir plus sur les paramètres optionnels qu'on peut rajouter au mail.

### Example
```4d
$mail:=cwToolGetClass("EMail").new("transactionnel")

$mail.to:="adresse@mail.com"
$mail.subject:="mail de démonstration"
$mail.htmlBody:="Bonjour, ceci est un exemple de mail"

$retour_o:=$mail.send()
```


--------------------------------------------------------------------------------

## Fonction : sendModel
Permet d'envoyer un mail à partir d'un modèle particulier enregistré dans le fichier de configuration email.json.

### Fonctionnement
```4d
$EMail.sendModel($nomModel_t;$variableDansMail_o) -> $retour_o
```

Voilà un exemple d'un objet de mail de démonstration contenu dans la collection "model" du fichier de configuration :
```
{
    "name": "demo1",
    "object": "E-mail de démonstration Plume 4D",

    // Attention la source des models doit être au format POSIX.
    "source": "facture/factureTemplate.mjml",
    "to": [
        "adresse1@mail.com",
        "adresse2@mail.com"
    ],
    "layout": "mailLayout.mjml"
}
```

Voilà la description des différents paramètres utilisés dans la fonction : 

| Paramètre                       | Type       | entrée/sortie | Description                     |
| ------------------------------- | ---------- | ------------- | ------------------------------- |
| $nomModel_t                     | Texte      | Entrée        | Chaine de caractères contenant le nom du modèle qu'on souhaite utiliser, comme indiqué dans le fichier de config                          |
| $variableDansMail_o (Optionnel) | Objet      | Entrée        | Dans le cas où l'on souhaite inclure des variables dans le mail de démo (dans le fichier html), on peut créer un objet contenant ces variables |
| $retour_o                       | Objet      | Sortie        | Renvoie des informations sur le resultat de la méthode send. Voir plus haut pour plus d'informations sur les différents attributs de cet objet. |


### Example
```4d
$mail:=cs.EMail.new("transactionnel")

$variableDansMail_o:=New object()
$variableDansMail_o.name:="Aurélie" 

$variableDansMail_o.produits:=New collection() 
$variableDansMail_o.produits.push(New object("nom";"Carotte";"quantite";"1"))
$variableDansMail_o.produits.push(New object("nom";"Patate";"quantite";"2"))
$variableDansMail_o.produits.push(New object("nom";"Tomate";"quantite";"3"))
$mail.to:="titouan@connect-io.fr"

$retour:=$mail.sendModel("demo3";$variableDansMail_o)
```
Note : 
<ul>
<li>
Les variables <b>$variableDansMail_o.name</b> et <b>$variableDansMail_o.produits</b> sont instancées dans le html de la manière suivante : 


```html
<!--#4DTEXT this.name--> ou <!--#4DTEXT this.produits[i].nomAttribut-->
```
</li>

<li>
Lorsque l'on envoie des mails à plusieurs personnes depuis la collection "to" du fichier de config, les destinataires verront à qui ont été envoyés les autres mails. Il sera donc en général préférable de boucler sur une collection de contacts afin de ne pas permettre aux contacts de voir la liste entière de destinataires.
</li>

</ul>


--------------------------------------------------------------------------------

## Fonction : generateModel
Permet de générer un modèle avec traitement des balises 4D.

### Fonctionnement
```4d
$EMail.generateModel($nomModel_t;$variableDansMail_o) -> $retour_o
```

Voilà la description des différents paramètres utilisés dans la fonction : 

| Paramètre                       | Type       | entrée/sortie | Description                     |
| ------------------------------- | ---------- | ------------- | ------------------------------- |
| $nomModel_t                     | Texte      | Entrée        | Chaine de caractères contenant le nom du modèle qu'on souhaite utiliser|
| $variableDansMail_o (Optionnel) | Objet      | Entrée        | Dans le cas où l'on souhaite inclure des variables dans le mail de démo (dans le fichier html), on peut créer un objet contenant ces variables |
| $retour_o                       | Objet      | Sortie        | Renvoie un modèle après traitement des balises 4d. |


--------------------------------------------------------------------------------

## Fonction : attachmentAdd
Permet de stocker la pièce jointe à envoyer dans l'email et retourner le chemin vers celle-ci pour l'expédition.
Le premier paramètre d'entrée est le chemin du dossier pour stocker la pièce jointe. 
Le deuxième paramètre d'entrée est le nom de l'input type file du formulaire. 

### Fonctionnement
```4d
$email_o.attachmentAdd($$vFolderDestination_t : Text; nameInput_t : Text) -> $retour_t : Text
```

| Paramètres            | Type       | entrée/sortie | Description |
| --------------------- | ---------- | ------------- | ----------- |
| $vFolderDestination_t | Texte      | Entrée        | Le chemin du dossier pour stocker la pièce jointe |
| $nameInput_t          | Texte      | Entrée        | Le nom de l'input du formulaire|
| $retour_t             | Texte      | Sortie        | Le chemin du fichier |

### Exemple
```4d
$vFolderDestination_t:=Get 4D folder(HTML Root folder)+"uploads"+Folder separator+"attachment"+Folder separator

$pathToAttachement_t:=$email_o.attachmentAdd($vFolderDestination_t; "slemImportFile")

If ($pathToAttachement_t#"")
	$email_o.attachmentsPath_c.push($pathToAttachement_t)
End if
```