Case of 
	: (Form event code:C388=Sur clic:K2:4)
		var $docFichier_t : Text
		var $continue_b : Boolean
		var $config_o : Object
		
		If (selectList_at>0)
			cwToolWindowsForm("configSceneModele"; "center"; Form:C1466)
			
			Form:C1466.modeleActif:=Form:C1466.sceneClass.updateStringActiveModel(Lowercase:C14(Form:C1466.sceneTypeSelected))
		Else 
			ALERT:C41("Merci de sélectionner un canal d'envoi")
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 