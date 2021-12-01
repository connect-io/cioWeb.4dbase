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
	
	
	
Function add($modele_o : Object)->$reponse_t : Text 
/*------------------------------------------------------------------------------
Fonction : ModeleMail.add
	
Ajout d'un nouveau modele de mail

Paramètres :
	$modele_o  -> l'objet contenant toutes les informations du nouveau modèle
	$reponse_t <- la réponse à l'enregistrement

Historiques
28/05/21 - Alban Catoire <alban@connect-io.fr> - Création
01/12/21 - Jonathan Fernandez <jonathan@connect-io.fr> - Maj param dans la fonction
------------------------------------------------------------------------------*/

	var $newModele_o : Object
	var $fichierSource : Object
	
	$reponse_t:="ok"
	
	ASSERT:C1129(($modele_o.name#"") & ($modele_o.name#Null:C1517); " ModeleMail.add : Le param $modele_o ne possède pas d'attribut 'name'.")
	ASSERT:C1129(($modele_o.source#"") & ($modele_o.source#Null:C1517); " ModeleMail.add : Le param $modele_o ne possède pas d'attribut  'source'.")
	
	$newModele_o:=New object:C1471()
	$newModele_o.name:=$modele_o.name
	$newModele_o.source:=$modele_o.source
	
	If ($modele_o.subject#"")
		$newModele_o.subject:=$modele_o.subject
	End if 
	
	If ($modele_o.personnalisation#"")
		$newModele_o:=cwToolObjectMerge($newModele_o; JSON Parse:C1218($modele_o.personnalisation))
	End if 
	
	//On va chercher le fichier associé à source HTML
	$fichierSource:=File:C1566(Convert path system to POSIX:C1106(Storage:C1525.param.folderPath.source_t)+This:C1470.email.modelPath+$1.source)
	
	//Si le fichier n'existe pas on le crée, puis on le reecrit
	If (Not:C34($fichierSource.exists) & ($modele_o.sourceHTML=""))
		$0:="Le fichier source n'existe pas et vous n'avez pas rempli le champs Source HTML"
	Else 
		If (Not:C34($fichierSource.exists) | ($modele_o.sourceHTML#""))
			$fichierSource.setText($modele_o.sourceHTML)
		End if 
	End if 
	
	If ($reponse_t="ok")
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
	
	
	
Function getAll()->$allModel_c : Collection
/*------------------------------------------------------------------------------
Fonction : ModeleMail.getAll
	
Renvoie la la liste de tous les modèles
	
Paramètre
$allModel_c <- Tout les modeles
	
Historique
28/05/21 - Alban Catoire <alban@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	
	$allModel_c:=This:C1470.email.model
	
	
	
Function modify($modelModify_o : Object)->$result_t : Text
/*------------------------------------------------------------------------------
Fonction : ModeleMail.modify
	
Modifie un modèle de mail
	
Paramètres
$modelModify_o  <- L'objet avec les informations du modèle à ajouter.
$result_t       -> Reponse à l'ajout du modèle
	
Historique
28/05/21 - Alban Catoire <alban@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	
	var $modele_c : Collection  //La collection de modele enregistré
	var $modele_o : Object  //Le modèle modifié
	var $index_i : Integer  // L'indice du modèle à modifier dans This.email.model
	var $key_t : Text
	
	$result_t:="ok"
	
	ASSERT:C1129(($modelModify_o.name#"") & ($modelModify_o.name#Null:C1517); " ModeleMail.modify : Le param $modelModify_o ($1) ne possède pas d'attribut 'name'.")
	ASSERT:C1129(($modelModify_o.source#"") & ($modelModify_o.source#Null:C1517); " ModeleMail.modify : Le param $modelModify_o ($1) ne possède pas d'attribut  'source'.")
	
	$modele_c:=This:C1470.email.model.query("name = :1"; $modelModify_o.oldName)
	If ($modele_c.length#0)
		$modele_o:=$modele_c[0]
		$index_i:=This:C1470.email.model.indexOf($modele_o)
		
		$modele_o.name:=$modelModify_o.name
		$modele_o.source:=$modelModify_o.source
		If (($modele_o.subject#Null:C1517) | ($modelModify_o.subject#""))
			$modele_o.subject:=$modelModify_o.subject
		End if 
		
		If ($modelModify_o.personnalisation#"")
			$modele_o:=cwToolObjectMerge($modele_o; JSON Parse:C1218($modelModify_o.personnalisation))
		Else 
			// On retire tous les éléments de personnalisation
			For each ($key_t; OB Keys:C1719($modele_o))
				If (($key_t#"name") & ($key_t#"subject") & ($key_t#"source"))
					OB REMOVE:C1226($modele_o; $key_t)
				End if 
			End for each 
		End if 
	Else 
		$result_t:="introuvable"
	End if 
	
	//On va chercher le fichier associé à source HTML
	$fichierSource:=File:C1566(Convert path system to POSIX:C1106(Storage:C1525.param.folderPath.source_t)+This:C1470.email.modelPath+$modelModify_o.source)
	
	//Si le fichier n'existe pas on le crée, puis on le reecrit
	If (Not:C34($fichierSource.exists) & ($modelModify_o.sourceHTML=""))
		$result_t:="Le fichier source n'existe pas et vous n'avez pas rempli le champs Source HTML"
	Else 
		$fichierSource.setText($modelModify_o.sourceHTML)
	End if 
	
	//Enregistrement des modifications
	If ($result_t="ok")
		This:C1470.email.model[$index_i]:=$modele_o
		This:C1470.enregistrement()
	End if 
	