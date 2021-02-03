Case of 
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
	: (Form event code:C388=Sur clic:K2:4)
		
		Case of 
			: (Picture size:C356(Form:C1466.imageSansScenario)=Picture size:C356(Storage:C1525.automation.image["toggle"]))
				Form:C1466.imageSansScenario:=Storage:C1525.automation.image["toggle-on"]
				
				Form:C1466.scenarioDetail.condition.sansScenario:=True:C214
			: (Picture size:C356(Form:C1466.imageSansScenario)=Picture size:C356(Storage:C1525.automation.image["toggle-on"]))
				Form:C1466.imageSansScenario:=Storage:C1525.automation.image["toggle-off"]
				
				Form:C1466.scenarioDetail.condition.sansScenario:=False:C215
			Else 
				Form:C1466.imageSansScenario:=Storage:C1525.automation.image["toggle"]
				
				If (Form:C1466.scenarioDetail.condition.sansScenario#Null:C1517)
					OB REMOVE:C1226(Form:C1466.scenarioDetail.condition; "sansScenario")
				End if 
				
		End case 
		
End case 