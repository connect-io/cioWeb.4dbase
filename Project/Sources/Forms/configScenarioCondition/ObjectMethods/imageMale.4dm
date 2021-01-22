Case of 
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
	: (Form event code:C388=Sur clic:K2:4)
		C_TEXT:C284($lib_t)
		
		Form:C1466.imageMale:=Form:C1466.marketingAutomation.image["male-clicked"]
		Form:C1466.imageFemale:=Form:C1466.marketingAutomation.image["female"]
		Form:C1466.imageMaleFemale:=Form:C1466.marketingAutomation.image["male-female"]
		
		$lib_t:=Form:C1466.marketingAutomation.formule.getFieldName(Form:C1466.marketingAutomation.passerelle.libelleSexe;"homme")
		
		Form:C1466.scenarioDetail.condition.sexe:=$lib_t
End case 