Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		
		// Chargement des images pour le choix du sexe ET pour la précense ou non d'une adresse email ET pour la sélection de personne(s) désabonnée(s)
		If (Form:C1466.marketingAutomation.loadImage("toggle.png";"toggle-on.png";"toggle-off.png")=True:C214)
			//Form.loadImageSceneActionCondition()
		End if 
		
End case 