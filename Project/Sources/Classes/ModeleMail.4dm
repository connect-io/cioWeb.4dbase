Class constructor
/*------------------------------------------------------------------------------
Fonction : ModeleMail.constructor
	
Creation de l'enregistrement de tous les modèles de mail
	
Historique
28/05/21 - Alban Catoire <alban@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	
	
	cwEMailConfigLoad
	ASSERT:C1129(Storage:C1525.eMail#Null:C1517; " Echec du chargement des modèles de mails, Storage.Email est vide.")
	This:C1470.email:=OB Copy:C1225(Storage:C1525.eMail)
	
	
	
Function add
/*------------------------------------------------------------------------------
Fonction : ModeleMail.add
	
Ajout d'un nouveau modele de mail
	
Historique
28/05/21 - Alban Catoire <alban@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	var $0 : Text  //Reponse à l'ajout du modèle
	var $1 : Object  // L'objet avec les informations du modèle à ajouter.
	
	var $newModele_o : Object
	var $fichierSource : Object
	
	$0:="ok"
	
	ASSERT:C1129(($1.name#"") & ($1.name#Null:C1517); " ModeleMail.add : Le param $1 ne possède pas d'attribut 'name'.")
	ASSERT:C1129(($1.source#"") & ($1.source#Null:C1517); " ModeleMail.add : Le param $1 ne possède pas d'attribut  'source'.")
	
	$newModele_o:=New object:C1471()
	$newModele_o.name:=$1.name
	$newModele_o.source:=$1.source
	
	If ($1.subject#"")
		$newModele_o.subject:=$1.subject
	End if 
	
	If ($1.personnalisation#"")
		$newModele_o:=cwToolObjectMerge($newModele_o; JSON Parse:C1218($1.personnalisation))
	End if 
	
	//On va chercher le fichier associé à source HTML
	$fichierSource:=File:C1566(Convert path system to POSIX:C1106(Storage:C1525.param.folderPath.source_t)+This:C1470.email.modelPath+$1.source)
	
	//Si le fichier n'existe pas on le crée, puis on le reecrit
	If (Not:C34($fichierSource.exists) & ($1.sourceHTML=""))
		$0:="Le fichier source n'existe pas et vous n'avez pas rempli le champs Source HTML"
	Else 
		If (Not:C34($fichierSource.exists) | ($1.sourceHTML#""))
			$fichierSource.setText($1.sourceHTML)
		End if 
	End if 
	
	If ($0="ok")
		This:C1470.email.model.push($newModele_o)
		This:C1470.enregistrement()
	End if 
	
	
	
Function delete
/*------------------------------------------------------------------------------
Fonction : ModeleMail.delete
	
Supprime un modèle de mail
	
Historique
28/05/21 - Alban Catoire <alban@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	
	var $1 : Text  // Le name du modèle à supprimer
	var $modele_c : Collection
	var $modele_o : Object  //Le modèle à supprimer
	
	ASSERT:C1129($1#""; " ModeleMail.delete : Le param $1 est vide.")
	
	$modele_c:=This:C1470.email.model.query("name = :1"; $1)
	ASSERT:C1129($modele_c.length#0; " ModeleMail.get : modèle introuvable.")
	$modele_o:=$modele_c[0]
	//On cherche le modèle à supprimer
	$index:=This:C1470.email.model.indexOf($modele_o)
	This:C1470.email.model.remove($index)
	This:C1470.enregistrement()
	
	
	
Function enregistrement
/*------------------------------------------------------------------------------
Fonction : ModeleMail.enregistrement
	
Enregistrement de This dans le fichier email.jsonc et dans le storage
	
Historique
28/05/21 - Alban Catoire <alban@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	
	//Réecriture dans le fichier email.jsonc
	Folder:C1567(Storage:C1525.param.folderPath.source_t; fk platform path:K87:2).file("email.jsonc").setText(JSON Stringify:C1217(This:C1470.email; *))
	// Rechargement dans le storage
	cwEMailConfigLoad
	
Function get
/*------------------------------------------------------------------------------
Fonction : ModeleMail.get
	
Renvoie les informations d'un modèle a l'aide de son nom
	
Historique
28/05/21 - Alban Catoire <alban@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	
	var $0 : Object  //Le modèle à renvoyer
	var $1 : Text  // Le nom du modèle à supprimer
	var $modele_c : Collection
	var $keys_c : Collection  // Liste des attributs contenu dans l'objet modele
	var $personnalisation_o  // Objet tampon utilisé pour récuperer la partie 'personnalisation'
	var $modele_o : Object  //Le modèle à renvoyer
	
	$modele_c:=This:C1470.email.model.query("name = :1"; $1).copy()
	ASSERT:C1129($modele_c.length#0; " ModeleMail.get : modèle introuvable.")
	$modele_o:=$modele_c[0]
	
	// On crée un attribut personnalisation
	$keys_c:=OB Keys:C1719($modele_o)
	$personnalisation_o:=New object:C1471
	For each ($key; $keys_c)
		If (($key#"name") & ($key#"subject") & ($key#"source") & ($key#"sourceHTML"))
			$personnalisation_o[$key]:=$modele_o[$key]
			OB REMOVE:C1226($modele_o; $key)
		End if 
	End for each 
	If (Not:C34(OB Is empty:C1297($personnalisation_o)))
		$modele_o.personnalisation:=JSON Stringify:C1217($personnalisation_o)
	End if 
	
	$fichierSource:=File:C1566(Convert path system to POSIX:C1106(Storage:C1525.param.folderPath.source_t)+This:C1470.email.modelPath+$modele_o.source)
	ASSERT:C1129($fichierSource.exists; " ModeleMail.get : Fichier source introuvable.")
	$modele_o.sourceHTML:=$fichierSource.getText()
	
	$0:=$modele_o
	
	
	
Function getAll
/*------------------------------------------------------------------------------
Fonction : ModeleMail.getAll
	
Renvoie la la liste de tous les modèles
	
Historique
28/05/21 - Alban Catoire <alban@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	
	var $0 : Collection  //Le modèle à renvoyer
	
	$0:=This:C1470.email.model
	
	
Function modify
/*------------------------------------------------------------------------------
Fonction : ModeleMail.modify
	
Modifie un modèle de mail
	
Historique
28/05/21 - Alban Catoire <alban@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	
	var $0 : Text  //Reponse à l'ajout du modèle
	var $1 : Object  // L'objet avec les informations du modèle à ajouter.
	
	var $modele_c : Collection  //La collection de modele enregistré
	var $keys_c : Collection  // Liste des attributs contenu dans l'objet modele
	var $modele_o : Object  //Le modèle modifié
	var $index : Integer  // L'indice du modèle à modifier dans This.email.model
	
	$0:="ok"
	
	ASSERT:C1129(($1.name#"") & ($1.name#Null:C1517); " ModeleMail.modify : Le param $1 ne possède pas d'attribut 'name'.")
	ASSERT:C1129(($1.source#"") & ($1.source#Null:C1517); " ModeleMail.modify : Le param $1 ne possède pas d'attribut  'source'.")
	
	$modele_c:=This:C1470.email.model.query("name = :1"; $1.oldName)
	If ($modele_c.length#0)
		$modele_o:=$modele_c[0]
		$index:=This:C1470.email.model.indexOf($modele_o)
		
		$modele_o.name:=$1.name
		$modele_o.source:=$1.source
		If (($modele_o.subject#Null:C1517) | ($1.subject#""))
			$modele_o.subject:=$1.subject
		End if 
		
		If ($1.personnalisation#"")
			$modele_o:=cwToolObjectMerge($modele_o; JSON Parse:C1218($1.personnalisation))
		Else 
			// On retire tous les éléments de personnalisation
			$keys_c:=OB Keys:C1719($modele_o)
			For each ($key; $keys_c)
				If (($key#"name") & ($key#"subject") & ($key#"source"))
					OB REMOVE:C1226($modele_o; $key)
				End if 
			End for each 
		End if 
	Else 
		$0:="introuvable"
	End if 
	
	//On va chercher le fichier associé à source HTML
	$fichierSource:=File:C1566(Convert path system to POSIX:C1106(Storage:C1525.param.folderPath.source_t)+This:C1470.email.modelPath+$1.source)
	
	//Si le fichier n'existe pas on le crée, puis on le reecrit
	If (Not:C34($fichierSource.exists) & ($1.sourceHTML=""))
		$0:="Le fichier source n'existe pas et vous n'avez pas rempli le champs Source HTML"
	Else 
		$fichierSource.setText($1.sourceHTML)
	End if 
	
	//Enregistrement des modifications
	If ($0="ok")
		This:C1470.email.model[$index]:=$modele_o
		This:C1470.enregistrement()
	End if 
	
	
	
	
	
	
	
	
	
	
	
	
	
	