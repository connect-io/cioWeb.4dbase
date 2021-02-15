If (Form event code:C388=Sur données modifiées:K2:15)
	var $collection_c : Collection
	
	Form:C1466.sceneTypeSelected:=selectList_at{selectList_at}
	Form:C1466.modeleActif:=Form:C1466.sceneClass.updateStringActiveModel(Lowercase:C14(Form:C1466.sceneTypeSelected))
End if 