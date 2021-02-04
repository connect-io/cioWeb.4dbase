Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		// Instanciation de la class pour la gestion des filtres
		Form:C1466.personneSelectionDisplayClass:=cwToolGetClass("MAPersonneSelectionDisplay").new()
		
		Form:C1466.imageSortNom:=Storage:C1525.automation.image["sort"]
		Form:C1466.imageSortPrenom:=Storage:C1525.automation.image["sort"]
		
		If (Form:C1466.entree=Null:C1517)  // Affichage directement du formulaire sans passer par le formulaire de gestion des scénarios
			Form:C1466.entree:=3
		End if 
		
		Form:C1466.MAPersonneDisplay:=cwToolGetClass("MAPersonneDisplay").new()
		Form:C1466.MAPersonneDisplay.viewPersonList(Form:C1466)
		
	: (Form event code:C388=Sur données modifiées:K2:15)
		Form:C1466.personneCollection:=Form:C1466.personneSelectionDisplayClass.manageFilter()
		Form:C1466.personneCollection:=Form:C1466.personneSelectionDisplayClass.manageSort("")
End case 