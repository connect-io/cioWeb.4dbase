Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		var $maPersonneDisplay_o : Object
		
		$maPersonneDisplay_o:=cwToolGetClass("MAPersonneDisplay").new()  // Instanciation de la class
		
		If (Form:C1466.entree=Null:C1517)  // Affichage directement du formulaire sans passer par le formulaire de gestion des scénarios
			Form:C1466.entree:=3
		End if 
		
		Form:C1466.MAPersonneDisplay:=$maPersonneDisplay_o
		Form:C1466.MAPersonneDisplay.viewPersonList(Form:C1466)
End case 