If (Form event code:C388=Sur chargement:K2:1)
	
	If (Bool:C1537(Form:C1466.disabledCreateDeleteScenarioButton)=True:C214)
		OBJECT SET ENABLED:C1123(*; "scenarioListeBouton@"; False:C215)
	End if 
	
End if 