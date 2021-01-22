If (Form:C1466.PersonneCurrentElement#Null:C1517)
	C_BOOLEAN:C305($suppr_b)
	
	Case of 
		: (Form:C1466.entree=2)
			$suppr_b:=Form:C1466.donnee.deleteScenarioToPerson(Form:C1466.PersonneSelectedElement[0].UID;Form:C1466.donnee.scenarioDetail.getKey())
	End case 
	
	If ($suppr_b=True:C214)
		Form:C1466.personne.remove(Form:C1466.PersonneCurrentPosition-1)
	End if 
	
End if 