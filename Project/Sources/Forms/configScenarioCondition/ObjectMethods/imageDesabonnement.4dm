Case of 
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
	: (Form event code:C388=Sur clic:K2:4)
		
		Case of 
			: (Picture size:C356(Form:C1466.imageDesabonnement)=Picture size:C356(Form:C1466.marketingAutomation.image["toggle"]))
				Form:C1466.imageDesabonnement:=Form:C1466.marketingAutomation.image["toggle-on"]
				
				Form:C1466.scenarioDetail.condition.desabonnement:=True:C214
			: (Picture size:C356(Form:C1466.imageDesabonnement)=Picture size:C356(Form:C1466.marketingAutomation.image["toggle-on"]))
				Form:C1466.imageDesabonnement:=Form:C1466.marketingAutomation.image["toggle-off"]
				
				Form:C1466.scenarioDetail.condition.desabonnement:=False:C215
			Else 
				Form:C1466.imageDesabonnement:=Form:C1466.marketingAutomation.image["toggle"]
				
				If (Form:C1466.scenarioDetail.condition.desabonnement#Null:C1517)
					OB REMOVE:C1226(Form:C1466.scenarioDetail.condition;"desabonnement")
				End if 
				
		End case 
		
End case 