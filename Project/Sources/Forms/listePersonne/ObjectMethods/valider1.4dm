Case of 
	: (Form event code:C388=Sur clic:K2:4)
		
		If (Form:C1466.PersonneSelectedElement.length#0)
			_demo1(Form:C1466.PersonneSelectedElement)
		Else 
			ALERT:C41("Merci de sélectionner au moins une personne")
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 