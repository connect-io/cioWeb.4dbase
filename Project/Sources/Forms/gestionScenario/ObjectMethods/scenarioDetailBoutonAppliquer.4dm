C_OBJECT:C1216($retour_o)

Form:C1466.applyScenarioToPerson()

$retour_o:=Form:C1466.scenarioDetail.save()

If ($retour_o.success=False:C215)
	  // Avertir l'utilisateur
End if 