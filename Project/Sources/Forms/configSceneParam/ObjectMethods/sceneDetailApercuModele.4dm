Case of 
	: (Form event code:C388=Sur clic:K2:4)
		
		If (selectList_at>0)
			
			If (Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version.length>0)
				cwToolWindowsForm("apercuDocument"; New object:C1471("ecartHautEcran"; 30; "ecartBasEcran"; 70); New object:C1471("entree"; 1; "donnee"; Form:C1466))
			Else 
				ALERT:C41("Aucune version dans le canal d'envoi "+Form:C1466.sceneTypeSelected+" n'a été créé")
			End if 
			
		Else 
			ALERT:C41("Merci de sélectionner un canal d'envoi")
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 