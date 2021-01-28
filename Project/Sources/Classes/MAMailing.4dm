/* -----------------------------------------------------------------------------
Class : cs.MAMailing

Class de gestion du marketing automation pour un envoi de mailing

-----------------------------------------------------------------------------*/

Class constructor
/*-----------------------------------------------------------------------------
Fonction : MAMailing.constructor
	
Instenciation de la class MAMailing pour le marketing automotion
	
Historique
28/01/21 - RémyScanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	
Function sendGetType()->$type_t : Text
	// Choix du canal d'envoi
	cwToolWindowsForm("selectValue"; "center"; New object:C1471("collection"; New collection:C1472(New object:C1471("type"; "Email"); New object:C1471("type"; "Courrier"); New object:C1471("type"; "SMS")); \
		"property"; "type"; "selectSubTitle"; "Merci de sélectionner un type d'envoi"; "title"; "Choix du type de l'envoi :"))
	
	$type_t:=selectValue_t
	
Function sendGetConfig($type_t : Text)->$config_o : Object
	var $transporter_c : Collection
	
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
					$config_o.eMailConfig:=$eMail_o
					$config_o.success:=True:C214
				End if 
				
			End if 
			
		: ($type_t="Courrier")
			$config_o.success:=True:C214
		: ($type_t="SMS")
			
	End case 