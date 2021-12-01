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
------------------------------------------------------------------------------*/
	
	var $transporter_c : Collection  // Récupère la collection de plumeDemo
	var $server_o : Object  // Informations SMTP
	var $imapConfig_c : Collection  // config des serveur IMAP
	
	ASSERT:C1129($name_t#""; "EMail.constructor : le Param $name_t est obligatoire.")
	
	If (Storage:C1525.eMail=Null:C1517)
		cwEMailConfigLoad
	End if 
	
	$server_o:=New object:C1471()
	
	// Vérifie que le nom du transporteur soit bien dans la config
	
	Use (Storage:C1525.eMail)
		Storage:C1525.eMail.transporterName:=$name_t
	End use 
	
	$transporter_c:=Storage:C1525.eMail.smtp.query("name IS :1"; $name_t)
	
	If ($transporter_c.length=1)
		$server_o:=$transporter_c[0]
	End if 
	
	// Il est possible de surcharger le transporteur.
	If (Count parameters:C259=2)
		$server_o:=cwToolObjectMerge($server_o; $paramOptionnel_o)
	End if 
	
	If ($server_o#Null:C1517)
		This:C1470.transporter:=SMTP New transporter:C1608($server_o)
		
		$imapConfig_c:=Storage:C1525.eMail.imap.query("name IS :1"; $name_t)
		If ($imapConfig_c.length=1)
			This:C1470.transporterIMAP:=IMAP New transporter:C1723($imapConfig_c[0])
		End if 
		
	Else 
		ALERT:C41("Aucune occurence trouvé au sein du fichier JSON")
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
	
	
	
Function send
/*------------------------------------------------------------------------------
Méthode : EMail.send
	
Envoie simple d'un e-mail
	
Les informations sur l'email :
	
Informations obligatoire :
this.to -> text : Destinataire
this.htmlBody ou this.textBody -> text : Corps du message
	
Informataions optionelles :
this.attachmentsPath_c -> Collection : Chemin des pièces jointes.
	
Historique
11/11/20 - Grégory Fromain <gregory@connect-io.fr> - Reécriture du code du composant plume.
------------------------------------------------------------------------------*/
	
	// Déclaration
	var $0 : Object  // Remonte les informations sur l'envoi d'e-mail 
	
	var $mailStatus_o : Object  // transporter, info sur mail et envoie de l'email
	var $error_t : Text  // Info concernant les erreurs
	var $cheminPj_v : Variant  // Chemin pièce jointe
	var $boxName_t : Text  //Nom de la boite des éléments envoyés.
	
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
			// On regarde si la config smtp souhaite stocker le mail dans les éléments énvoyés?
			If (Bool:C1537(Storage:C1525.eMail.smtp.query("name IS :1"; $1)[0].archive))
				
				// Upload email to the "Sent" mailbox
				If (This:C1470.transporterIMAP#Null:C1517)
					$boxName_t:=Storage:C1525.eMail.imap.query("name IS :1"; Storage:C1525.eMail.transporterName)[0].boxName.sent
					$status_o:=This:C1470.transporterIMAP.append(This:C1470; $boxName_t)
					
					// Gestion des erreurs de l'IMAP.
					If (Not:C34($status_o.sucess))
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
	$0:=$mailStatus_o
	
	
	
Function sendModel
/*------------------------------------------------------------------------------
Méthode : EMail.sendModel
	
Envoi d'un e-mail depuis un modèle.
	
Historique
11/11/20 - Grégory Fromain <gregory@connect-io.fr> - Reécriture du code du composant plume.
25/05/21 - Alban Catoire <Alban@connect-io.fr> - On recreer le modelPath (il n'est plus stocker en dur dans le storage, voir cwEmailConfigLoad)
------------------------------------------------------------------------------*/
	
	// Déclaration
	var $1 : Text  // Var nom du modèle
	var $2 : Object  // Var content
	var $0 : Object  // retour sur le résultat de la fonction.
	
	var $error_t : Text  // Gestion des erreurs.
	var $model_c : Collection  // Informations tableau JSON du modèle
	var $model_o : Object  // Detail du modèle
	var $returnVar_t : Text  // Retourne le texte si 3ème paramètre
	var $mailStatus_o : Object  // Réponse de l'envoi du mail.
	var $modelPath_t : Text  // Le path des modeles
	
	ASSERT:C1129($1#""; "EMail.sendModel : le Param $1 est obligatoire (Nom du modèle.")
	
	$mailStatus_o:=New object:C1471("success"; False:C215)
	
	If (Count parameters:C259=2)
		
		For each ($propriete_t; $2)
			This:C1470[$propriete_t]:=$2[$propriete_t]
		End for each 
		
	End if 
	
	// Vérification fichier modèle
	$model_c:=Storage:C1525.eMail.model.query("name IS :1"; $1)
	
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
		$error_t:="EMail.sendModel : Impossible de retrouver le modèle : "+$1
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
		End if 
		
		// Envoie du mail
		$mailStatus_o:=This:C1470.send()
	End if 
	
	If ($error_t#"")
		$mailStatus_o.statusText:=$error_t
		$mailStatus_o.status:=-1
	End if 
	
	// Retourne les informations concernant l'envoie du mail
	$0:=$mailStatus_o