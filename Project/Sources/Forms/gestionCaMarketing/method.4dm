Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		
		// Chargement des images la gestion  du désabonnement
		If (Form:C1466.caMarketing.desabonementMail=True:C214)
			Form:C1466.imageDesabonnement:=Storage:C1525.automation.image["toggle-on"]
		Else 
			Form:C1466.imageDesabonnement:=Storage:C1525.automation.image["toggle-off"]
		End if 
		
End case 