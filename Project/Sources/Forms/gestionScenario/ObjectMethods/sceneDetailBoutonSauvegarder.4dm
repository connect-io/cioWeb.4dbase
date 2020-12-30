If (Form:C1466.SceneCurrentElement#Null:C1517) & (Form:C1466.ScenarioCurrentElement#Null:C1517)
	C_OBJECT:C1216($retour_o)
	
	Case of 
		: (String:C10(Form:C1466.sceneDetail.paramAction.echelleDelai)="jour(s)")
			Form:C1466.sceneDetail.tsAttente:=Num:C11(Form:C1466.sceneSuivanteDelai)*5184000*1
		: (String:C10(Form:C1466.sceneDetail.paramAction.echelleDelai)="semaine(s)")
			Form:C1466.sceneDetail.tsAttente:=Num:C11(Form:C1466.sceneSuivanteDelai)*5184000*7
		: (String:C10(Form:C1466.sceneDetail.paramAction.echelleDelai)="mois(s)")
			Form:C1466.sceneDetail.tsAttente:=Num:C11(Form:C1466.sceneSuivanteDelai)*5184000*30
		: (String:C10(Form:C1466.sceneDetail.paramAction.echelleDelai)="année(s)")
			Form:C1466.sceneDetail.tsAttente:=Num:C11(Form:C1466.sceneSuivanteDelai)*5184000*365
	End case 
	
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