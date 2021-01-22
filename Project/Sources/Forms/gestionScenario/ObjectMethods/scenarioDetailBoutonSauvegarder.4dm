If (Form:C1466.ScenarioCurrentElement#Null:C1517)
	C_OBJECT:C1216($retour_o)
	
	$retour_o:=Form:C1466.scenarioDetail.save()
	
	If ($retour_o.success=False:C215)
		  // Avertir l'utilisateur
	End if 
	
	Form:C1466.loadAllScenario()
	
	LISTBOX SELECT ROW:C912(*;"scenarioListe";Form:C1466.ScenarioCurrentPosition)
Else 
	ALERT:C41("Impossible de sauvegarder, aucun scénario de sélectionner !")
End if 