Case of 
	: (Form event code:C388=Sur clic:K2:4)
		
		Case of 
			: (Picture size:C356(Form:C1466.imageDesabonnement)=Picture size:C356(Storage:C1525.automation.image["toggle-off"]))
				Form:C1466.imageDesabonnement:=Storage:C1525.automation.image["toggle-on"]
			: (Picture size:C356(Form:C1466.imageDesabonnement)=Picture size:C356(Storage:C1525.automation.image["toggle-on"]))
				Form:C1466.imageDesabonnement:=Storage:C1525.automation.image["toggle-off"]
		End case 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 