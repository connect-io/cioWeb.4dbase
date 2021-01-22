Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		
		// Chargement des images pour le choix du sexe ET pour la précense ou non d'une adresse email ET pour la sélection de personne(s) désabonnée(s)
		If (Form:C1466.marketingAutomation.loadImage("male.png";"male-clicked.png";"female.png";"female-clicked.png";"male-female.png";"male-female-clicked.png";"toggle.png";"toggle-on.png";"toggle-off.png")=True:C214)
			Form:C1466.loadImageScenarioCondition()
		End if 
		
End case 