If (Form:C1466.SceneCurrentElement#Null:C1517) & (Form:C1466.ScenarioCurrentElement#Null:C1517)
	C_OBJECT:C1216($retour_o)
	
	$retour_o:=Form:C1466.sceneDetail.save()
	
	If ($retour_o.success=False:C215)
		  // Avertir l'utilisateur
	End if 
	
	$retour_o:=Form:C1466.scenarioDetail.reload()
	
	Form:C1466.scene:=Form:C1466.scenarioDetail.AllCaScene
	
	LISTBOX SELECT ROW:C912(*;"sceneListe";Form:C1466.SceneCurrentPosition)
Else 
	ALERT:C41("Impossible de sauvegarder, aucune scène de sélectionner !")
End if 