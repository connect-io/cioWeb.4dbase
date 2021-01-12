If (Form event code:C388=Sur clic:K2:4) & (Form:C1466.SceneCurrentElement#Null:C1517)
	Form:C1466.sceneDetail:=Form:C1466.SceneSelectedElement[0]
	
	Form:C1466.updateStringSceneForm(1)
	
	OBJECT SET ENABLED:C1123(*;"sceneDetail@";True:C214)
Else 
	
	If (Form:C1466.sceneDetail#Null:C1517)
		Form:C1466.sceneDetail:=Null:C1517
		
		Form:C1466.scenePersonneEnCours:=Null:C1517  // Chaine qui indique le nombre de personne auquel la scène du scénario sélectionné est appliqué
		Form:C1466.sceneSuivanteDelai:=Null:C1517  // Chaine qui indique le délai avec la scène suivante du scénario sélectionné
	End if 
	
	OBJECT SET ENABLED:C1123(*;"sceneDetail@";False:C215)
End if 