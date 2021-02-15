/* -----------------------------------------------------------------------------
Class : cs.MAMailing

Class de gestion du marketing automation pour un envoi de mailing

-----------------------------------------------------------------------------*/

Class constructor
/*-----------------------------------------------------------------------------
Fonction : MAMailing.constructor
	
Instanciation de la class MAMailing pour le marketing automotion
	
Historique
28/01/21 - RémyScanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	
Function sendGetType()->$type_t : Text
	// Choix du canal d'envoi
	cwToolWindowsForm("selectValue"; "center"; New object:C1471("collection"; New collection:C1472(New object:C1471("type"; "Email"); New object:C1471("type"; "Courrier"); New object:C1471("type"; "SMS")); \
		"property"; "type"; "selectSubTitle"; "Merci de sélectionner un type d'envoi"; "title"; "Choix du type de l'envoi :"))
	
	$type_t:=selectValue_t
	
Function sendGetConfig($type_t : Text)->$config_o : Object
	var $document_t : Text
	var $transporter_c : Collection
	
	ARRAY TEXT:C222($attachmentsFiles_at; 0)
	
	$config_o:=New object:C1471("success"; False:C215)
	
	Case of 
		: ($type_t="Email")
			// Choix du transporteur
			$transporter_c:=cwStorage.eMail.smtp
			
			cwToolWindowsForm("selectValue"; "center"; New object:C1471("collection"; $transporter_c; "property"; "name"; "selectSubTitle"; "Merci de sélectionner un expéditeur"; "title"; "Choix de l'expéditeur :"))
			
			If (selectValue_t#"")
				$eMail_o:=cwToolGetClass("EMail").new(selectValue_t)
				
				$eMail_o.subject:=Request:C163("Objet du mail ?"; ""; "Valider"; "Annuler l'envoi")
				
				If ($eMail_o.subject#"")
					CONFIRM:C162("Voulez-vous insérer une ou plusieurs pièces-jointes ?")
					
					If (OK=1)
						$eMail_o.attachmentsPath_c:=New collection:C1472
						
						$document_t:=Select document:C905(""; "*"; "Fichiers à insérer en pièce-jointe"; Fichiers multiples:K24:7+Utiliser fenêtre feuille:K24:11; $attachmentsFiles_at)
						
						// IMPORTANT NE FONCTIONNE QUE SUR LA MACHINE DU SERVEUR POUR DU CLIENT/SERVEUR IL FAUT CREER UNE TABLE PIECE-JOINTE (VOIR BASE CERFPA)
						If (Size of array:C274($attachmentsFiles_at)>0)
							ARRAY TO COLLECTION:C1563($eMail_o.attachmentsPath_c; $attachmentsFiles_at)
						End if 
						
					End if 
					
					$config_o.eMailConfig:=$eMail_o
					$config_o.success:=True:C214
				End if 
				
			End if 
			
		: ($type_t="Courrier")
			$config_o.success:=True:C214
		: ($type_t="SMS")
	End case 