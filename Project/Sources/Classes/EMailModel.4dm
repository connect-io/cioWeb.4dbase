Class constructor
/*------------------------------------------------------------------------------
Fonction : EMailModel.constructor
	
Creation de l'enregistrement de tous les modèles de mail
	
Historique
28/05/21 - Alban Catoire <alban@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	
	cwEMailConfigLoad
	ASSERT:C1129(Storage:C1525.eMail#Null:C1517; " Echec du chargement des modèles de mails, Storage.Email est vide.")
	This:C1470.email:=OB Copy:C1225(Storage:C1525.eMail)
	
	
	
Function add($modele_o : Object)->$reponse_t : Text
/*------------------------------------------------------------------------------
Fonction : EMailModel.add
	
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
	
	ASSERT:C1129(($modele_o.name#"") & ($modele_o.name#Null:C1517); " EMailModel.add : Le param $modele_o ne possède pas d'attribut 'name'.")
	ASSERT:C1129(($modele_o.source#"") & ($modele_o.source#Null:C1517); " EMailModel.add : Le param $modele_o ne possède pas d'attribut  'source'.")
	
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
		This:C1470.configToJson()
	End if 
	
	
	
Function configToJson
/*------------------------------------------------------------------------------
Fonction : EMailModel.configToJson
	
Copie la config des modèles dans le fichier email.jsonc et dans le storage
	
Historique
28/05/21 - Alban Catoire <alban@connect-io.fr> - Création
13/12/21 - Jonathan Fernandez <jonathan@connect-io.fr> - Renommer la fonction.
------------------------------------------------------------------------------*/
	
	
	//Réecriture dans le fichier email.jsonc
	Folder:C1567(Storage:C1525.param.folderPath.source_t; fk platform path:K87:2).file("email.jsonc").setText(JSON Stringify:C1217(This:C1470.email; *))
	
	// Rechargement dans le storage
	cwEMailConfigLoad
	
	
Function delete($name_t : Text)
/*------------------------------------------------------------------------------
Fonction : EMailModel.delete
	
Supprime un modèle de mail
	
Paramètre :
	$name_t -> le nom du modèle à supprimer
	
Historique
28/05/21 - Alban Catoire <alban@connect-io.fr> - Création
01/12/21 - Jonathan Fernandez <jonathan@connect-io.fr> - Maj param dans la fonction
------------------------------------------------------------------------------*/
	
	var $modele_c : Collection
	var $modele_o : Object  //Le modèle à supprimer
	var $tempo_f : 4D:C1709.File
	
	ASSERT:C1129($name_t#""; " EMailModel.delete : Le param $name_t est vide.")
	
	$modele_c:=This:C1470.email.model.query("name = :1"; $name_t)
	ASSERT:C1129($modele_c.length#0; " EMailModel.get : modèle introuvable.")
	$modele_o:=$modele_c[0]
	//On cherche le modèle à supprimer
	$index:=This:C1470.email.model.indexOf($modele_o)
	
	$tempo_f:=File:C1566(Convert path system to POSIX:C1106(Storage:C1525.param.folderPath.source_t)+This:C1470.email.modelPath+$modele_o.source)
	If ($tempo_f.exists)
		$tempo_f.delete()
	End if 
	
	This:C1470.email.model.remove($index)
	This:C1470.configToJson()
	
	
	
Function get($name_t : Text)->$reponse_o : Object
/*------------------------------------------------------------------------------
Fonction : EMailModel.get
	
Renvoie les informations d'un modèle a l'aide de son nom
	
Paramètres :
	var $name_t    -> Le nom du modèle à supprimer
	var $reponse_o <- informations du modèle demandé
	
Historiques
28/05/21 - Alban Catoire <alban@connect-io.fr> - Création
01/12/21 - Jonathan Fernandez <jonathan@connect-io.fr> - Maj param dans la fonction
------------------------------------------------------------------------------*/
	
	var $modele_c : Collection
	var $personnalisation_o  // Objet tampon utilisé pour récuperer la partie 'personnalisation'
	var $modele_o : Object  //Le modèle à renvoyer
	var $file_f : 4D:C1709.File
	
	$modele_c:=This:C1470.email.model.query("name = :1"; $name_t).copy()
	ASSERT:C1129($modele_c.length#0; " EMailModel.get : modèle introuvable.")
	$modele_o:=$modele_c[0]
	
	// On crée un attribut personnalisation
	$personnalisation_o:=New object:C1471
	For each ($key; OB Keys:C1719($modele_o))
		If (($key#"name") & ($key#"subject") & ($key#"source") & ($key#"sourceHTML"))
			$personnalisation_o[$key]:=$modele_o[$key]
			OB REMOVE:C1226($modele_o; $key)
		End if 
	End for each 
	If (Not:C34(OB Is empty:C1297($personnalisation_o)))
		$modele_o.personnalisation:=$personnalisation_o
	End if 
	
	$file_f:=File:C1566(Convert path system to POSIX:C1106(Storage:C1525.param.folderPath.source_t)+This:C1470.email.modelPath+$modele_o.source)
	ASSERT:C1129($file_f.exists; " EMailModel.get : Fichier source introuvable.")
	$modele_o.sourceHTML:=$file_f.getText()
	
	// Chargement du html du layout si il existe...
	If (String:C10($modele_o.personnalisation.layout)#"")
		$file_f:=File:C1566(Convert path system to POSIX:C1106(Storage:C1525.param.folderPath.source_t)+This:C1470.email.modelPath+$modele_o.personnalisation.layout)
		ASSERT:C1129($file_f.exists; " EMailModel.get : Fichier source introuvable.")
		$modele_o.layoutHTML:=$file_f.getText()
	End if 
	
	
	$reponse_o:=$modele_o
	
	
	
Function getAll()->$allModel_c : Collection
/*------------------------------------------------------------------------------
Fonction : EMailModel.getAll
	
Renvoie la la liste de tous les modèles
	
Paramètre
$allModel_c <- Tout les modeles
	
Historique
28/05/21 - Alban Catoire <alban@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	
	$allModel_c:=This:C1470.email.model
	
	
	
Function layoutAdd($layout_o : Object)->$reponse_t : Text
/*------------------------------------------------------------------------------
Fonction : EMailModel.layoutAdd
	
Ajout d'un nouveau layout
	
Paramètres :
$layout_o  -> l'objet contenant toutes les informations du nouveau layout
$reponse_t <- la réponse à l'enregistrement
	
Historique
01/02/22 - Jonathan Fernandez <jonathan@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	
	var $newLayout_o : Object
	var $fichierSource : Object
	
	$reponse_t:="ok"
	
	ASSERT:C1129(($layout_o.name#"") & ($layout_o.name#Null:C1517); " EMailModel.layoutAdd : Le param $layout_o ne possède pas d'attribut 'name'.")
	ASSERT:C1129(($layout_o.source#"") & ($layout_o.source#Null:C1517); " EMailModel.layoutAdd : Le param $layout_o ne possède pas d'attribut  'source'.")
	
	$newLayout_o:=New object:C1471()
	$newLayout_o.name:=$layout_o.name
	$newLayout_o.source:=$layout_o.source
	
	//On va chercher le fichier associé à source HTML
	$fichierSource:=File:C1566(Convert path system to POSIX:C1106(Storage:C1525.param.folderPath.source_t)+This:C1470.email.modelPath+$1.source)
	
	//Si le fichier n'existe pas on le crée, puis on le reecrit
	If (Not:C34($fichierSource.exists) & ($layout_o.layoutHtml=""))
		$0:="Le fichier source n'existe pas et vous n'avez pas rempli le champs Source HTML"
	Else 
		If (Not:C34($fichierSource.exists) | ($layout_o.layoutHtml#""))
			$fichierSource.setText($layout_o.layoutHtml)
		End if 
	End if 
	
	If ($reponse_t="ok")
		This:C1470.email.layout.push($newLayout_o)
		This:C1470.configToJson()
	End if 
	
	
	
Function layoutDelete($name_t : Text)
/*------------------------------------------------------------------------------
Fonction : EMailModel.layoutDelete
	
Supprime un layout
	
Paramètre :
$name_t -> le nom du layout à supprimer
	
Historique
01/02/22 - Jonathan Fernandez <jonathan@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	
	var $modele_c : Collection
	var $modele_o : Object  //Le layout à supprimer
	var $tempo_f : 4D:C1709.File
	
	ASSERT:C1129($name_t#""; " EMailModel.layoutDelete : Le param $name_t est vide.")
	
	$modele_c:=This:C1470.email.layout.query("name = :1"; $name_t)
	ASSERT:C1129($modele_c.length#0; " EMailModel.get : modèle introuvable.")
	$modele_o:=$modele_c[0]
	//On cherche le layout à supprimer
	$index:=This:C1470.email.layout.indexOf($modele_o)
	
	$tempo_f:=File:C1566(Convert path system to POSIX:C1106(Storage:C1525.param.folderPath.source_t)+This:C1470.email.modelPath+$modele_o.source)
	If ($tempo_f.exists)
		$tempo_f.delete()
	End if 
	
	This:C1470.email.layout.remove($index)
	This:C1470.configToJson()
	
	
	
Function layoutGetAll()->$allLayout_c : Collection
/*------------------------------------------------------------------------------
Fonction : EMailModel.layoutGetAll
	
Renvoie la liste de tous les layouts d'emails
	
Paramètre
$allLayout_c <- Tous les layouts
	
Historique
01/02/22 - Jonathan Fernandez <jonathan@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	
	$allLayout_c:=This:C1470.email.layout
	
	
	
Function layoutModify($layoutModify_o : Object)->$result_t : Text
/*------------------------------------------------------------------------------
Fonction : EMailModel.layoutModify
	
Modifie un modèle de Layout
	
Paramètres
$layoutModify_o  <- L'objet avec les informations du layout à ajouter.
$result_t        -> Reponse à l'ajout du layout
	
Historique
01/02/22 - Jonathan Fernandez <jonathan@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	
	var $layout_c : Collection  // La collection de layout enregistré
	var $layout_o : Object  // Le layout modifié
	var $index_i : Integer  // L'indice du layout à modifier dans This.email.layout
	var $key_t : Text
	
	$result_t:="ok"
	
	ASSERT:C1129(($layoutModify_o.name#"") & ($layoutModify_o.name#Null:C1517); " EMailModel.layoutModify : Le param $layoutModify_o ($1) ne possède pas d'attribut 'name'.")
	ASSERT:C1129(($layoutModify_o.source#"") & ($layoutModify_o.source#Null:C1517); " EMailModel.layoutModify : Le param $layoutModify_o ($1) ne possède pas d'attribut  'source'.")
	
	$layout_c:=This:C1470.email.layout.query("name = :1"; $layoutModify_o.oldName)
	If ($layout_c.length#0)
		$layout_o:=$layout_c[0]
		$index_i:=This:C1470.email.layout.indexOf($layout_o)
		
		$layout_o.name:=$layoutModify_o.name
		$layout_o.source:=$layoutModify_o.source
		
	Else 
		$result_t:="introuvable"
	End if 
	
	//On va chercher le fichier associé à source HTML
	$fichierSource:=File:C1566(Convert path system to POSIX:C1106(Storage:C1525.param.folderPath.source_t)+This:C1470.email.modelPath+$layoutModify_o.source)
	
	//On va chercher le fichier avec l'ancien nom pour le supprimer
	$fichierSourceOld:=File:C1566(Convert path system to POSIX:C1106(Storage:C1525.param.folderPath.source_t)+This:C1470.email.modelPath+$layoutModify_o.sourceOldName)
	
	//Si le fichier n'existe pas on le crée, puis on le reecrit
	If (Not:C34($fichierSource.exists) & ($layoutModify_o.layoutHtml=""))
		$result_t:="Le fichier source n'existe pas et vous n'avez pas rempli le champs Source HTML"
	Else 
		$fichierSource.setText($layoutModify_o.layoutHtml)
		If ($layoutModify_o.source#$layoutModify_o.sourceOldName)
			$fichierSourceOld.delete()
		End if 
	End if 
	
	//Enregistrement des modifications
	If ($result_t="ok")
		This:C1470.email.layout[$index_i]:=$layout_o
		This:C1470.configToJson()
		
	End if 
	
	
	
Function modify($modelModify_o : Object)->$result_t : Text
/*------------------------------------------------------------------------------
Fonction : EMailModel.modify
	
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
	
	ASSERT:C1129(($modelModify_o.name#"") & ($modelModify_o.name#Null:C1517); " EMailModel.modify : Le param $modelModify_o ($1) ne possède pas d'attribut 'name'.")
	ASSERT:C1129(($modelModify_o.source#"") & ($modelModify_o.source#Null:C1517); " EMailModel.modify : Le param $modelModify_o ($1) ne possède pas d'attribut  'source'.")
	
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
		This:C1470.configToJson()
	End if 
	
	
	
Function transporterAdd($transporter_o : Object; $protocol_t : Text)->$reponse_t : Text
/*------------------------------------------------------------------------------
Fonction : EMailModel.transporterAdd
	
Ajout d'un nouveau transporteur
	
Paramètres
$transporter_o  -> l'objet contenant toutes les informations du nouveau transporteur
$protocol_t.    -> Le nom du protocole utilisé (exemple : smtp, imap...)
$reponse_t      <- la réponse à l'enregistrement
	
Historique
02/02/22 - Jonathan Fernandez <jonathan@connect-io.fr> - Création
01/03/22 - Jonathan Fernandez <jonathan@connect-io.fr> - Changement de la gestion du stockage des transporteurs.
------------------------------------------------------------------------------*/
	
	var $newTransporter_o : Object
	var $fichierSource : Object
	
	$reponse_t:="ok"
	
	ASSERT:C1129(($transporter_o.name#"") & ($transporter_o.name#Null:C1517); " EMailModel.transporterAdd : Le param $transporter_o ne possède pas d'attribut 'name'.")
	ASSERT:C1129(($protocol_t#"") & ($protocol_t#Null:C1517); " EMailModel.transporterGetAll : Le param $protocol_t est obligatoire.")
	
	$newTransporter_o:=New object:C1471()
	$newTransporter_o.name:=$transporter_o.name
	$newTransporter_o.type:=$transporter_o.type
	$newTransporter_o.host:=$transporter_o.host
	$newTransporter_o.port:=Num:C11($transporter_o.port)
	$newTransporter_o.user:=$transporter_o.user
	$newTransporter_o.password:=$transporter_o.password
	$newTransporter_o.from:=$transporter_o.from
	$newTransporter_o.archive:=$transporter_o.archive
	$newTransporter_o.type:=$protocol_t
	
	If ($reponse_t="ok")
		This:C1470.email.transporter.push($newTransporter_o)
		This:C1470.configToJson()
	End if 
	
	
	
Function transporterDelete($name_t : Text; $protocol_t : Text)
/*------------------------------------------------------------------------------
Fonction : EMailModel.transporterDelete
	
Supprime un transporteur
	
Paramètres
$name_t.     -> le nom du transporteur à supprimer
$protocol_t. -> Le nom du protocole utilisé (exemple : smtp, imap...)
	
Historique
01/02/22 - Jonathan Fernandez <jonathan@connect-io.fr> - Création
01/03/22 - Jonathan Fernandez <jonathan@connect-io.fr> - Changement de la gestion du stockage des transporteurs.
------------------------------------------------------------------------------*/
	
	var $transporter_c : Collection
	var $transporter_o : Object  //Le layout à supprimer
	
	ASSERT:C1129($name_t#""; " EMailModel.transporterDelete : Le param $name_t est vide.")
	ASSERT:C1129(($protocol_t#"") & ($protocol_t#Null:C1517); " EMailModel.transporterGetAll : Le param $protocol_t est obligatoire.")
	
	$transporter_c:=This:C1470.email.transporter.query("name = :1 and type = :2"; $name_t; $protocol_t)
	ASSERT:C1129($transporter_c.length#0; " EMailModel.get : modèle introuvable.")
	$transporter_o:=$transporter_c[0]
	//On cherche le layout à supprimer
	$index:=This:C1470.email.transporter.indexOf($transporter_o)
	This:C1470.email.transporter.remove($index)
	This:C1470.configToJson()
	
	
	
Function transporterGetAll($protocol_t : Text)->$allTransporter_c : Collection
/*------------------------------------------------------------------------------
Fonction : EMailModel.transporterGetAll
	
Renvoie la liste de tous les transporteurs pour la gestion des emails
	
Paramètres
$protocol_t       -> Le nom du protocole utilisé (exemple : smtp, imap...)
$allTransporter_c <- Tous les transporteurs
	
Historique
02/02/22 - Jonathan Fernandez <jonathan@connect-io.fr> - Création
01/03/22 - Grégory Fromain <gregory@connect-io.fr> - Changement de la gestion du stockage des transporteurs.
------------------------------------------------------------------------------*/
	
	ASSERT:C1129(($protocol_t#"") & ($protocol_t#Null:C1517); " EMailModel.transporterGetAll : Le param $protocol_t est obligatoire.")
	
	$allTransporter_c:=This:C1470.email.transporter.query("type IS :1"; $protocol_t)
	
	
Function transporterModify($transporterModify_o : Object; $protocol_t : Text)->$result_t : Text
/*------------------------------------------------------------------------------
Fonction : EMailModel.transporterModify
	
Modifie un modèle de transporteur
	
Paramètres
$transporterModify_o  <- L'objet avec les informations du tranposteur à modifier.
$protocol_t.          -> Le nom du protocole utilisé (exemple : smtp, imap...)
$result_t             -> Reponse à l'ajout du transporteur
	
Historique
02/02/22 - Jonathan Fernandez <jonathan@connect-io.fr> - Création
01/03/22 - Jonathan Fernandez <jonathan@connect-io.fr> - Changement de la gestion du stockage des transporteurs.
------------------------------------------------------------------------------*/
	
	var $transporter_c : Collection  // La collection de layout enregistré
	var $transporter_o : Object  // Le layout modifié
	var $index_i : Integer  // L'indice du layout à modifier dans This.email.layout
	var $key_t : Text
	
	$result_t:="ok"
	
	ASSERT:C1129(($transporterModify_o.name#"") & ($transporterModify_o.name#Null:C1517); " EMailModel.transporterModify : Le param $transporterModify_o ($1) ne possède pas d'attribut 'name'.")
	ASSERT:C1129(($protocol_t#"") & ($protocol_t#Null:C1517); " EMailModel.transporterGetAll : Le param $protocol_t est obligatoire.")
	
	$transporter_c:=This:C1470.email.transporter.query("name = :1"; $transporterModify_o.oldName)
	If ($transporter_c.length#0)
		$transporter_o:=$transporter_c[0]
		$index_i:=This:C1470.email.transporter.indexOf($transporter_o)
		
		$transporter_o.name:=$transporterModify_o.name
		// $transporter_o.type:=$transporterModify_o.type
		$transporter_o.host:=$transporterModify_o.host
		$transporter_o.port:=Num:C11($transporterModify_o.port)
		$transporter_o.user:=$transporterModify_o.user
		$transporter_o.password:=$transporterModify_o.password
		$transporter_o.from:=$transporterModify_o.from
		$transporter_o.archive:=$transporterModify_o.archive
		
	Else 
		$result_t:="introuvable"
	End if 
	
	//Enregistrement des modifications
	If ($result_t="ok")
		This:C1470.email.transporter[$index_i]:=$transporter_o
		This:C1470.configToJson()
	End if 