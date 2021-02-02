Case of 
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
	: (Form event code:C388=Sur clic:K2:4)
		Form:C1466.imageMale:=Storage:C1525.automation.image["male"]
		Form:C1466.imageFemale:=Storage:C1525.automation.image["female"]
		Form:C1466.imageMaleFemale:=Storage:C1525.automation.image["male-female-clicked"]
		
		If (Form:C1466.scenarioDetail.condition.sexe#Null:C1517)
			OB REMOVE:C1226(Form:C1466.scenarioDetail.condition; "sexe")
		End if 
		
End case 