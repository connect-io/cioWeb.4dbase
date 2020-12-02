If (Form:C1466.scenarioDetail#Null:C1517) & (Form:C1466.SceneCurrentElement#Null:C1517)
	C_OBJECT:C1216($retour_o)
	
	$retour_o:=Form:C1466.SceneSelectedElement[0].drop()
	
	If ($retour_o.success=False:C215)
		  // Avertir l'utilisateur
	Else 
		Form:C1466.SceneSelectedElement:=Null:C1517
	End if 
	
	$retour_o:=Form:C1466.scenarioDetail.reload()
	
	Form:C1466.scene:=Form:C1466.scenarioDetail.AllCaScene
	Form:C1466.sceneDetail:=Null:C1517
End if 