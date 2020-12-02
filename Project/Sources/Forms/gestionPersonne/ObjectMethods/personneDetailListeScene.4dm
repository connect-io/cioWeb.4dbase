If (Form event code:C388=Sur clic:K2:4) & (Form:C1466.SceneCurrentElement#Null:C1517)
	C_OBJECT:C1216($table_o)
	
	$table_o:=Form:C1466.SceneCurrentElement  // Gestion de la scène sélectionnée
	
	Form:C1466.personneDetail.sceneResume:="Test"
	
	OBJECT SET ENABLED:C1123(*;"personneDetailScene";True:C214)
Else 
	
	If (Form:C1466.personneDetail.sceneResume#Null:C1517)
		Form:C1466.personneDetail.sceneResume:=Null:C1517
	End if 
	
	OBJECT SET ENABLED:C1123(*;"personneDetailScene";False:C215)
End if 