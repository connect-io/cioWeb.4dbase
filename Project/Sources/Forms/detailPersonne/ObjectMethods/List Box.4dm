If (Form event code:C388=Sur clic:K2:4) & (Form:C1466.ScenarioEnCoursCurrentElement#Null:C1517)
	var $class_o : Object
	
	Form:C1466.scenarioSelected:=Form:C1466.ScenarioEnCoursSelectedElement[0]  // Gestion du scènario sélectionné
	
	$class_o:=cwToolGetClass("MAScenario").new()
	$class_o.loadByPrimaryKey(Form:C1466.scenarioSelected.ID)
	
	$class_o.updateStringScenarioForm(1)
	
	Form:C1466.scenarioPersonneEnCours:=$class_o.scenarioPersonneEnCours
	
	OBJECT SET ENABLED:C1123(*; "detailPersonneScenario@"; True:C214)
Else 
	
	If (Form:C1466.scenarioSelected#Null:C1517)
		Form:C1466.scenarioSelected:=Null:C1517  // Scénario sélectionné
		
		Form:C1466.scenarioPersonneEnCours:=Null:C1517  // Chaine qui indique le nombre de personne auquel le scénario est appliqué
	End if 
	
	OBJECT SET ENABLED:C1123(*; "detailPersonneScenario@"; False:C215)
End if 