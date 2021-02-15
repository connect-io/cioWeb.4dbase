If (Form event code:C388=Sur chargement:K2:1)
	ARRAY TEXT:C222(selectList_at; 0)
	
	APPEND TO ARRAY:C911(selectList_at; "Email")
	APPEND TO ARRAY:C911(selectList_at; "SMS")
	APPEND TO ARRAY:C911(selectList_at; "Courrier")
	
	selectList_at{0}:="Selection du canal d'envoi"
	selectList_at:=0
	
	Form:C1466.sceneClass:=cwToolGetClass("MAScene").new()
	Form:C1466.sceneClass.loadByPrimaryKey(Form:C1466.sceneDetail.ID)
	
	Form:C1466.modeleActif:=""
End if 