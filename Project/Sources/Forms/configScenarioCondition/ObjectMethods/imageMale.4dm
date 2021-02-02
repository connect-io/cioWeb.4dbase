Case of 
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
	: (Form event code:C388=Sur clic:K2:4)
		Form:C1466.imageMale:=Storage:C1525.automation.image["male-clicked"]
		Form:C1466.imageFemale:=Storage:C1525.automation.image["female"]
		Form:C1466.imageMaleFemale:=Storage:C1525.automation.image["male-female"]
		
		Form:C1466.scenarioDetail.condition.sexe:=Storage:C1525.automation.passerelle.libelleSexe.query("lib = :1"; "homme")[0].value
End case 