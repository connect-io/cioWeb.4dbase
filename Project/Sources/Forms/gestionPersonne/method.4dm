Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		C_OBJECT:C1216($maPersonneDisplay_cs;$maPersonneDisplay_o)
		
		$maPersonneDisplay_cs:=cwToolGetClass("MAPersonneDisplay")  // Initialisation de la class
		$maPersonneDisplay_o:=$maPersonneDisplay_cs.new()  // Instanciation de la class
		
		If (Form:C1466.entree=Null:C1517)  // Affichage directement du formulaire sans passer par le formulaire de gestion des scénarios
			Form:C1466.entree:=3
		End if 
		
		Form:C1466.MAPersonneDisplay:=$maPersonneDisplay_o
		Form:C1466.MAPersonneDisplay.viewPersonList(Form:C1466)
End case 