If (Form event code:C388=Sur clic:K2:4) & (Form:C1466.ScenarioCurrentElement#Null:C1517)
	Form:C1466.scenarioDetail:=Form:C1466.ScenarioSelectedElement[0]  // Gestion du scènario sélectionné
	
	If (Form:C1466.scenarioSelectionPossiblePersonne#Null:C1517)
		OB REMOVE:C1226(Form:C1466; "scenarioSelectionPossiblePersonne")
	End if 
	
	Form:C1466.updateStringScenarioForm(1)
	
	Form:C1466.scene:=Form:C1466.scenarioDetail.AllCaScene  // Gestion des scènes du scénario sélectionné
	
	OBJECT SET ENABLED:C1123(*; "scenarioListeBoutonSupprimer"; True:C214)
	OBJECT SET ENABLED:C1123(*; "scenarioDetail@"; True:C214)
	OBJECT SET ENABLED:C1123(*; "sceneListe@"; True:C214)
	
	OBJECT SET HELP TIP:C1181(*; "scenarioDetailObjectif"; "• Rang 1 : Suspect\r• Rang 2 : Prospect\r• Rang 3 : Client\r• Rang 4 : Client fidèle\r• Rang 5 : Ambassadeur")
Else 
	
	If (Form:C1466.scenarioDetail#Null:C1517)
		Form:C1466.scenarioDetail:=Null:C1517  // Détail du scénario
		Form:C1466.scene:=Null:C1517  // Liste des scènes
		Form:C1466.sceneDetail:=Null:C1517  // Détail de la scène
		
		Form:C1466.scenarioPersonnePossible:=Null:C1517  // Chaine qui indique le nombre de personne auquel le scénario est applicable
		Form:C1466.scenarioPersonneEnCours:=Null:C1517  // Chaine qui indique le nombre de personne auquel le scénario est appliqué
	End if 
	
	OBJECT SET ENABLED:C1123(*; "scenarioListeBoutonSupprimer"; False:C215)
	OBJECT SET ENABLED:C1123(*; "scenarioDetail@"; False:C215)
	OBJECT SET ENABLED:C1123(*; "sceneListe@"; False:C215)
End if 

OBJECT SET ENABLED:C1123(*; "sceneDetail@"; False:C215)

Form:C1466.scenePersonneEnCours:=Null:C1517  // Chaine qui indique le nombre de personne auquel la scène du scénario sélectionné est appliqué
Form:C1466.sceneSuivanteDelai:=Null:C1517  // Chaine qui indique le délai avec la scène suivante du scénario sélectionné

// Si on a ordonné de ne pas pouvoir ajouter ou supprimer un scénario
If (Bool:C1537(Form:C1466.disabledCreateDeleteScenarioButton)=True:C214)
	OBJECT SET ENABLED:C1123(*; "scenarioListeBouton@"; False:C215)
End if 