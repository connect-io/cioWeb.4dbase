Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		// Chargement des images pour le choix du sexe ET pour la précense ou non d'une adresse email ET pour la sélection de personne(s) désabonnée(s)
		Form:C1466.loadImageScenarioCondition()
		
		OBJECT SET HELP TIP:C1181(*; "rang"; "• Rang 1 : Suspect\r• Rang 2 : Prospect\r• Rang 3 : Client\r• Rang 4 : Client fidèle\r• Rang 5 : Ambassadeur")
End case 