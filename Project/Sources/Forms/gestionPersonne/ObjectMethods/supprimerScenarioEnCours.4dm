If (Form:C1466.PersonneCurrentElement#Null:C1517)
	C_BOOLEAN:C305($suppr_b)
	
	CONFIRM:C162("Cette action est irréversible, souhaitez-vous continuer ?";"Oui";"Non")
	
	If (OK=1)
		
		Case of 
			: (Form:C1466.entree=2)
				$suppr_b:=Form:C1466.donnee.deleteScenarioToPerson(Form:C1466.PersonneSelectedElement[0].UID;Form:C1466.donnee.scenarioDetail.getKey())
		End case 
		
		If ($suppr_b=True:C214)
			
			If (Form:C1466.entree=2)
				Form:C1466.donnee.scenarioPersonneEnCoursEntity:=Form:C1466.donnee.scenarioDetail.AllCaPersonneScenario.OnePersonne
			End if 
			
			Form:C1466.MAPersonneDisplay.viewPersonList(Form:C1466)
			
			Form:C1466.scenarioPersonne:=Null:C1517  // Je réinitialise mon tableau des scénarios de personne
		End if 
		
	End if 
	
End if 