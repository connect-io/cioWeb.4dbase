Case of 
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
	: (Form event code:C388=Sur clic:K2:4)
		Form:C1466.imageMale:=Form:C1466.marketingAutomation.image["male"]
		Form:C1466.imageFemale:=Form:C1466.marketingAutomation.image["female"]
		Form:C1466.imageMaleFemale:=Form:C1466.marketingAutomation.image["male-female-clicked"]
		
		If (Form:C1466.scenarioDetail.condition.sexe#Null:C1517)
			OB REMOVE:C1226(Form:C1466.scenarioDetail.condition;"sexe")
		End if 
		
End case 