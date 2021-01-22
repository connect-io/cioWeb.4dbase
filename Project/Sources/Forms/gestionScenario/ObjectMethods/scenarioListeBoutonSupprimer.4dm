If (Form:C1466.ScenarioCurrentElement#Null:C1517)
	C_OBJECT:C1216($retour_o)
	
	$retour_o:=Form:C1466.ScenarioSelectedElement[0].drop()
	
	If ($retour_o.success=False:C215)
		  // Avertir l'utilisateur
	Else 
		Form:C1466.ScenarioSelectedElement:=Null:C1517
	End if 
	
	Form:C1466.loadAllScenario()
	
	Form:C1466.scenarioDetail:=Null:C1517
	Form:C1466.scene:=Null:C1517
End if 