If (Form:C1466.newScenario()=False:C215)
	  // Avertir l'utilisateur
End if 

Form:C1466.loadAllScenario()

Form:C1466.scenarioDetail:=Form:C1466.scenario.first()

Form:C1466.scene:=Null:C1517

OBJECT SET ENABLED:C1123(*;"scenarioDetail@";True:C214)

LISTBOX SELECT ROW:C912(*;"scenarioListe";1)