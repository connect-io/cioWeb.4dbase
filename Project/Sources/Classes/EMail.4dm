/* 
Class : cs.EMail

Gestion des e-mail

Historique
10/11/20 - Grégory Fromain <gregory@connect-io.fr> - Reprise du code du composant plume et conversion en class
*/

Class constructor($name_t : Text; $paramOptionnel_o : Object)
/*------------------------------------------------------------------------------
Fonction : EMail.constructor
	
Initialisation de la page web.
ATTENTION : L'instance de la class "page" doit se faire obligatoirement par la fonction : webApp.pageCurrent()
	
Paramètres :
	$name_t           -> Nom du transporteur
	$paramOptionnel_o -> Param optionnel pour le transporteur
	
Historiques
02/01/20 - quentin@connect-io.fr - Création
10/11/20 - Grégory Fromain <gregory@connect-io.fr> - Reprise du code
01/12/21 - Jonathan Fernandez <jonathan@connect-io.fr> - Maj param dans la Class constructor
28/01/22 - Grégory Fromain <gregory@connect-io.fr> - Correction bug sur condition
01/03/22 - Jonathan Fernandez <jonathan@connect-io.fr> - Changement de la gestion du stockage des transporteurs.
18/03/22 - Grégory Fromain <gregory@connect-io.fr> - Fix bug selection serveur IMAP
------------------------------------------------------------------------------*/
	
	var $transporter_c : Collection  // Récupère la collection de plumeDemo
	var $server_o : Object  // Informations SMTP
	var $imapConfig_c : Collection  // config des serveur IMAP
	
	ASSERT:C1129($name_t#""; "EMail.constructor : le Param $name_t est obligatoire.")
	
	If (Storage:C1525.eMail=Null:C1517)
		cwEMailConfigLoad
		ASSERT:C1129(Storage:C1525.eMail.smtp.length=0; "EMail.constructor : merci de mettre à jour le transporteur dans le fichier email.json.")
	End if 
	
	$server_o:=New object:C1471()
	
	// Vérifie que le nom du transporteur soit bien dans la config
	
	This:C1470.transporterName:=$name_t
	
	$transporter_c:=Storage:C1525.eMail.transporter.query("name IS :1 and type IS 'smtp'"; $name_t)
	
	ASSERT:C1129($transporter_c.length#0; "Le nom du transporteur indiqué ne correspond à aucun transporteur")
	
	If ($transporter_c.length=1)
		$server_o:=$transporter_c[0]
	End if 
	
	// Il est possible de surcharger le transporteur.
	If (Count parameters:C259=2)
		$server_o:=cwToolObjectMerge($server_o; $paramOptionnel_o)
	End if 
	
	If ($server_o#Null:C1517)
		This:C1470.transporter:=SMTP New transporter:C1608($server_o)
		
		$imapConfig_c:=Storage:C1525.eMail.transporter.query("name IS :1 and type IS 'imap'"; $name_t)
		
		If ($imapConfig_c.length=1)
			This:C1470.transporterIMAP:=IMAP New transporter:C1723($imapConfig_c[0])
		End if 
		
	Else 
		ALERT:C41("cioWeb : Aucun transporteur SMTP trouvé au sein du fichier JSON.")
		This:C1470.transporter:=New object:C1471()
	End if 
	
	// Initialisation des pieces jointes
	This:C1470.attachmentsPath_c:=New collection:C1472()
	
	If (String:C10($server_o.from)#"")
		This:C1470.from:=$server_o.from
	End if 
	
	If (Storage:C1525.eMail.globalVar#Null:C1517)
		This:C1470.globalVar:=OB Copy:C1225(Storage:C1525.eMail.globalVar)
	End if 
	
	
	
Function attachmentAdd($vFolderDestination_t : Text; $nameInput_t : Text)->$retour_t : Text
	
/*------------------------------------------------------------------------------
Fonction : email_o.attachmentAdd
	
Gestion de la pièce jointe pour l'envoi par email
	
Paramètre :
$vFolderDestination_t  -> le chemin du dossier pour stocker la pièce jointe
$nameInput_t           -> le nom de l'input du formulaire
$retour_t              <- le chemin du fichier
	
Historique
23/02/22 - Jonathan Fernandez <jonathan@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	
	var $htmlName_t; $fileMimeType_t; $fileName_t : Text
	var $i_el : Integer
	var $fileContent_b : Blob
	var $email_o : Object
	
	For ($i_el; 1; WEB Get body part count:C1211)
		WEB GET BODY PART:C1212($i_el; $fileContent_b; $htmlName_t; $fileMimeType_t; $fileName_t)
		
		If ($htmlName_t=$nameInput_t)
			If ($fileName_t#"")
				
				BLOB TO DOCUMENT:C526($vFolderDestination_t+$fileName_t; $fileContent_b)
				$retour_t:=$vFolderDestination_t+$fileName_t
			End if 
			
			$i_el:=WEB Get body part count:C1211
		End if 
		
	End for 
	
	
	
Function modelGenerate($nomModel_t : Text; $variableDansMail_o : Object)->$retour_o : Object
/*------------------------------------------------------------------------------
Méthode : EMail.modelGenerate
	
Génération du HTML complet du model.
	
Paramètres :
var $nomModel_t         -> nom du modèle qu'on souhaite utiliser
var $variableDansMail_o -> (optionnel) on peut créer un objet contenant ces variables
var $retour_o           <- retour sur le résultat de la fonction.
	
Historiques :
24/01/22 - Grégory Fromain <gregory@connect-io.fr> - Décomposition de la fonction model send.
18/03/22 - Grégory Fromain <gregory@connect-io.fr> - Renommage de la fonction.
------------------------------------------------------------------------------*/
	
	// Déclarations
	var $error_t : Text  // Gestion des erreurs.
	var $model_c : Collection  // Informations tableau JSON du modèle
	var $model_o : Object  // Detail du modèle
	var $returnVar_t : Text  // Retourne le texte si 3ème paramètre
	var $mailStatus_o : Object  // Réponse de l'envoi du mail.
	var $modelPath_t : Text  // Le path des modeles
	
	ASSERT:C1129($nomModel_t#""; "EMail.sendModel : le Param $nomModel_t est obligatoire (Nom du modèle.")
	
	$mailStatus_o:=New object:C1471("success"; False:C215)
	
	If ($variableDansMail_o#Null:C1517)
		
		For each ($propriete_t; $variableDansMail_o)
			This:C1470[$propriete_t]:=$variableDansMail_o[$propriete_t]
		End for each 
		
	End if 
	
	// Vérification fichier modèle
	$model_c:=Storage:C1525.eMail.model.query("name IS :1"; $nomModel_t)
	This:C1470.model:=$model_c
	
	// Retrouver les informations du modèle
	If ($model_c.length=1)
		$model_o:=$model_c[0]
		$modelPath_t:=Convert path system to POSIX:C1106(Storage:C1525.param.folderPath.source_t)+Storage:C1525.eMail.modelPath
		corps_t:=File:C1566($modelPath_t+$model_o.source).getText()
		
		// Gestion du layout
		If (String:C10($model_o.layout)#"")
			This:C1470.htmlBody:=File:C1566($modelPath_t+$model_o.layout).getText()
			
		Else 
			This:C1470.htmlBody:=corps_t
		End if 
		
	Else 
		$error_t:="EMail.sendModel : Impossible de retrouver le modèle : "+$nomModel_t
	End if 
	
	If ($error_t="")
		
		// Si l'objet n'est pas défini avant on applique celui du modèle.
		If (String:C10(This:C1470.subject)="")
			This:C1470.subject:=String:C10($model_o.subject)
		End if 
		
		PROCESS 4D TAGS:C816(This:C1470.subject; $returnVar_t)
		This:C1470.subject:=$returnVar_t
		
		// On gère les destinataires du message.
		If (This:C1470.to=Null:C1517)
			
			If ($model_o.to#Null:C1517)
				This:C1470.to:=$model_o.to
			End if 
			
		End if 
		
		If (Count parameters:C259=2) | (String:C10($model_o.layout)#"")  // Les variables html sont utilisées dans l'email, il faut les traiter avec 4D.
			PROCESS 4D TAGS:C816(This:C1470.htmlBody; $returnVar_t)
			
			This:C1470.htmlBody:=$returnVar_t
			$mailStatus_o.success:=True:C214
		End if 
		
	End if 
	
	If ($error_t#"")
		$mailStatus_o.statusText:=$error_t
		$mailStatus_o.status:=-1
	End if 
	
	// Retourne les informations concernant l'envoie du mail
	$retour_o:=$mailStatus_o
	
	
	
Function send()->$resultat_o : Object
/*------------------------------------------------------------------------------
Méthode : EMail.send
	
Envoie simple d'un e-mail
	
Les informations sur l'email :
	
Informations obligatoire :
this.to -> text : Destinataire
this.htmlBody ou this.textBody -> text : Corps du message
	
Informataions optionelles :
this.attachmentsPath_c -> Collection : Chemin des pièces jointes.
	
Paramètre
$resultat_o <- Informations sur l'envoi de l'email
	
Historiques
11/11/20 - Grégory Fromain <gregory@connect-io.fr> - Reécriture du code du composant plume
01/12/21 - Jonathan Fernandez <jonathan@connect-io.fr> - Maj param dans la fonction
01/03/22 - Jonathan Fernandez <jonathan@connect-io.fr> - Changement de la gestion du stockage des transporteurs.
16/03/22 - Jonathan Fernandez <jonathan@connect-io.fr> - Modification du stockage des emails, archive dans le modèle au lieu du transporteur.
18/03/22 - Grégory Fromain <gregory@connect-io.fr> - Fix bug selection IMAP.
------------------------------------------------------------------------------*/
	
	// Déclarations
	var $error_t; $boxName_t : Text  // Info concernant les erreurs, Nom de la boite des éléments envoyés
	var $nbTentative_i : Integer
	var $mailStatus_o : Object  // Transporter, info sur mail et envoie de l'email
	var $cheminPj_v : Variant  // Chemin pièce jointe
	
	$mailStatus_o:=New object:C1471("success"; False:C215)
	
	//On vérifie que l'on a bien notre transporter
	If (This:C1470.transporter=Null:C1517)
		$error_t:="Il n'y a pas de transporter d'initialisé."
	End if 
	
	If (This:C1470.to=Null:C1517)
		$error_t:="Il manque le destinataire de votre e-mail. ($1.to)"
	End if 
	
	//On vérifie que l'on a bien notre émetteur
	If (String:C10(This:C1470.from)="")
		This:C1470.from:=This:C1470.transporter.user
	End if 
	
	//On vérifie que notre corps de message n'est pas vide (si This.bodyStructure est null ça veux dire qu'on ne passe pas par un mime mais par du code HTMLEUH classico-classique !)
	If (String:C10(This:C1470.htmlBody)="") & (String:C10(This:C1470.textBody)="") & (This:C1470.bodyStructure=Null:C1517)
		$error_t:="Il manque le contenu de votre message."
	End if 
	
	// Si aucune erreur, on envoie le mail
	If ($error_t="")
		
		// On vérifie que l'on à bien des pièces jointes
		If (This:C1470.attachmentsPath_c.length#0)
			
			// Dans ce cas on créé une collection
			This:C1470.attachments:=New collection:C1472()
			
			// on boucle sur les pièces jointes
			For each ($cheminPj_t; This:C1470.attachmentsPath_c)
				
				// On vérifie que le chemin de pièce jointe est bien de type texte
				If (Type:C295($cheminPj_t)=Is text:K8:3)
					
					// On vérifie que la pièce jointe est bien un document existant sur le disque
					If (Test path name:C476($cheminPj_t)=Is a document:K24:1)
						This:C1470.attachments.push(MAIL New attachment:C1644($cheminPj_t))
					Else 
						$error_t:="Le document suivant n'est pas présent sur le disque : "+$cheminPj_t
					End if 
					
				Else 
					$error_t:="Un élément de la collection des pièces jointes n'est pas une chaine de caractère."
				End if 
				
			End for each 
			
		End if 
		
	End if 
	
	//Envoi du mail
	If ($error_t="")
		$mailStatus_o:=This:C1470.transporter.send(This:C1470)
		
		//Si l'envoie du mail = True
		If ($mailStatus_o.success)
			
			// On regarde si la config du model souhaite stocker le mail dans les éléments énvoyés
			If (Bool:C1537(This:C1470.model[0].archive))
				
				// Upload email to the "Sent" mailbox
				If (This:C1470.transporterIMAP#Null:C1517)
					$boxName_t:=Storage:C1525.eMail.transporter.query("name IS :1 and type IS 'imap'"; This:C1470.transporterName)[0].boxName.sent
					$status_o:=This:C1470.transporterIMAP.append(This:C1470; $boxName_t)
					
					// Gestion des erreurs de l'IMAP.
					If (Not:C34($status_o.success))
						$error_t:=$status_o.statusText
					End if 
					
				End if 
				
			End if 
			
		Else 
			$error_t:="Une erreur est survenue lors de l'envoi de l'e-mail : "+$error_t+$mailStatus_o.statusText
		End if 
		
	End if 
	
	If ($error_t#"")
		$mailStatus_o.statusText:=$error_t
		$mailStatus_o.status:=-1
	End if 
	
	// Retourne les informations concernant l'envoie du mail
	$resultat_o:=$mailStatus_o
	
	
	
Function sendModel($nomModel_t : Text; $variableDansMail_o : Object)->$retour_o : Object
/*------------------------------------------------------------------------------
Méthode : EMail.sendModel
	
Envoi d'un e-mail depuis un modèle.
	
Paramètres :
	var $nomModel_t         -> nom du modèle qu'on souhaite utiliser
	var $variableDansMail_o -> (optionnel) on peut créer un objet contenant ces variables
	var $retour_o           <- retour sur le résultat de la fonction.
	
Historiques :
11/11/20 - Grégory Fromain <gregory@connect-io.fr> - Reécriture du code du composant plume.
25/05/21 - Alban Catoire <Alban@connect-io.fr> - On recreer le modelPath (il n'est plus stocker en dur dans le storage, voir cwEmailConfigLoad)
01/12/21 - Jonathan Fernandez <jonathan@connect-io.fr> - Maj param dans la fonction
24/01/22 - Grégory Fromain gregory@connect-io.fr> - Décomposition avec la fonction generateModel
------------------------------------------------------------------------------*/
	
	// Déclarations
	var $mailStatus_o : Object  // Réponse de l'envoi du mail.
	
	ASSERT:C1129($nomModel_t#""; "EMail.sendModel : le Param $nomModel_t est obligatoire (Nom du modèle.")
	
	$mailStatus_o:=This:C1470.modelGenerate($nomModel_t; $variableDansMail_o)
	
	If ($mailStatus_o.success)
		// Envoie du mail
		$mailStatus_o:=This:C1470.send()
	End if 
	
	// Retourne les informations concernant l'envoie du mail
	$retour_o:=$mailStatus_o
	
	
	
	
	