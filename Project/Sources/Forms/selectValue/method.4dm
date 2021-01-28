If (Form event code:C388=Sur chargement:K2:1)
	C_TEXT:C284(selectValue_t)
	
	ARRAY TEXT:C222(selectList_at; 0)
	
	CLEAR VARIABLE:C89(selectValue_t)
	
	COLLECTION TO ARRAY:C1562(Form:C1466.collection; selectList_at; Form:C1466.property)
	selectList_at{0}:=Form:C1466.selectSubTitle
End if 