/* 
Class : cs.EMail

Gestion des e-mail

Historique
10/11/20 - Grégory Fromain <gregory@connect-io.fr> - Reprise du code du composant plumeet conversion en class
*/


Class constructor
/* -----------------------------------------------------------------------------
Fonction : EMail.constructor
	
Initialisation de la page web.
ATTENTION : L'instance de la class "page" doit se faire obligatoirement par la fonction : webApp.pageCurrent()
	
Historique
02/01/20 - quentin@connect-io.fr - Création
10/11/20 - Grégory Fromain <gregory@connect-io.fr> - Reprise du code
----------------------------------------------------------------------------- */
	
	// Déclaration
	var $1 : Text  // Nom du transporteur
	var $2 : Object  // Param optionnel pour le transporteur
	
	var $transporter_c : Collection  // Récupère la collection de plumeDemo
	var $server_o : Object  // Informations SMTP
	
	ASSERT:C1129($1#"";"EMail.constructor : le Param $1 est obligatoire.")
	
	$server_o:=New object:C1471()
	
	// Vérifie que le nom du transporteur soit bien dans la config
	$transporter_c:=Storage:C1525.eMail.smtp.query("name IS :1";$1)
	
	If ($transporter_c.length=1)
		$server_o:=$transporter_c[0]
	End if 
	
	// Il est possible de surcharger le transporteur.
	If (Count parameters:C259=2)
		$server_o:=cwToolObjectMerge($server_o;$2)
	End if 
	
	If ($server_o#Null:C1517)
		This:C1470.transporter:=SMTP New transporter:C1608($server_o)
	Else 
		ALERT:C41("Aucune occurence trouvé au sein du fichier JSON")
		This:C1470.transporter:=New object:C1471()
	End if 
	
	// Initialisation des pieces jointes
	This:C1470.attachmentsPath_c:=New collection:C1472()
	
	
	
Function send
/* -----------------------------------------------------------------------------
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
----------------------------------------------------------------------------- */
	
	// Déclaration
	var $0 : Object  // Remonte les informations sur l'envoi d'e-mail 
	
	var $mailStatus_o : Object  // transporter, info sur mail et envoie de l'email
	var $error_t : Text  // Info concernant les erreurs
	var $cheminPj_v : Variant  // Chemin pièce jointe
	
	$mailStatus_o:=New object:C1471("success";False:C215)
	
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
	
	//On vérifie que notre corps de message n'est pas vide
	If (String:C10(This:C1470.htmlBody)="") & (String:C10(This:C1470.textBody)="")
		$error_t:="Il manque le contenu de votre message."
	End if 
	
	// Si aucune erreur, on envoie le mail
	If ($error_t="")
		
		// On vérifie que l'on à bien des pièces jointes
		If (This:C1470.attachmentsPath_c.length#0)
			
			// Dans ce cas on créé une collection
			This:C1470.attachments:=New collection:C1472()
			
			// on boucle sur les pièces jointes
			For each ($cheminPj_t;This:C1470.attachmentsPath_c)
				
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
			This:C1470.to:=Null:C1517
			This:C1470.from:=Null:C1517
			This:C1470.htmlBody:=Null:C1517
			This:C1470.textBody:=Null:C1517
			This:C1470.attachmentsPath_c:=New collection:C1472()
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
	// ----------------------------------------------------
	// Méthode : plSendModel
	// Description
	// 
	// Envoie d'un email avec son modèle
	// ----------------------------------------------------
	
	If (False:C215)
		// 06/01/2020 - quentin@connect-io.fr - Création
		// 09/01/2020 - quentin@connect-io.fr - Ajout paramètre 3
	End if 
	
	// Déclaration de variables
	If (True:C214)
		C_COLLECTION:C1488($model_c)  // Informations tableau JSON du modèle
		C_OBJECT:C1216($mail_o)  // Informations sur l'email
		C_OBJECT:C1216($model_o;$0)  // Le modèle
		C_TEXT:C284($1)  // Var nom du modèle
		C_OBJECT:C1216($2)  // Var email
		C_OBJECT:C1216($3)  // Var content
		C_TEXT:C284($returnVar_t)  // Retourne le texte si 3ème paramètre
		C_TEXT:C284($modeleNom_t)  // Nom du modèle
		C_TEXT:C284($nameFolderInResources_t)  // Nom du dossier
		C_OBJECT:C1216(content)  // 3ème paramètre
	End if 
	
	content:=New object:C1471()
	
	$nameFolderInResources_t:="plumeMail"
	
	// Attribuer des variables aux parametres
	$modeleNom_t:=$1
	$mail_o:=$2
	
	If (Count parameters:C259=3)
		content:=$3
	End if 
	
	// Vérification fichier modèle
	$model_c:=<>plumeConfig.model.query("name IS :1";$modeleNom_t)
	
	// Retrouver les informations du modèle
	If ($model_c.length=1)
		$model_o:=$model_c[0]
		
		corps_t:=Document to text:C1236(<>plumeConfig.info.hostPath+$model_o.source;"UTF-8")
		
		// Gestion du layout
		If (String:C10($model_o.layout)#"")
			$mail_o.htmlBody:=Document to text:C1236(<>plumeConfig.info.hostPath+$model_o.layout;"UTF-8")
			
		Else 
			$mail_o.htmlBody:=corps_t
		End if 
		
		
		// Si parametre 3 
		If (Count parameters:C259=3) | (String:C10($model_o.layout)#"")
			// Les variables html sont utilisées dans l'email, il faut les traités avec 4D.
			PROCESS 4D TAGS:C816($mail_o.htmlBody;$returnVar_t)
			$mail_o.htmlBody:=$returnVar_t
		End if 
		
		// Si l'objet n'est pas défini avant on applique celui du modèle.
		If (String:C10($mail_o.subject)="")
			$mail_o.subject:=String:C10($model_o.object)
		End if 
		
		// On gère les destinataires du message.
		If ($mail_o.to=Null:C1517)
			If ($model_o.to#Null:C1517)
				$mail_o.to:=$model_o.to
			End if 
		End if 
		
		// Envoie du mail
		$mailInfo_o:=plSend($mail_o)
		
		// Si l'envoie = True
		If ($mailInfo_o.success=True:C214)
			ALERT:C41("L'email est envoyé.")
			// Sinon..
		Else 
			ALERT:C41($mailInfo_o.statusText)
		End if 
		
		
		
		$0:=$model_o
	Else 
		// to do: faire remonter l'erreur dans le cas ou on ne retrouve pas le modele dans la config
	End if 
	
	
	
	
	
	