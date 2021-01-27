C_OBJECT:C1216($config_o)

$config_o:=New object:C1471("entree"; 1; "donnee"; Form:C1466)

cwToolWindowsForm("gestionPersonne"; "center"; $config_o)

If (OK=1)
	Form:C1466.scenarioSelectionPossiblePersonne:=entitySelection_o
	
	Form:C1466.updateStringScenarioForm(1)
End if 