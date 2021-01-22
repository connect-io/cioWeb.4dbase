If (modeleListe_at{modeleListe_at}#"")
	Form:C1466.sceneDetail.paramAction.modele:=modeleListe_at{modeleListe_at}
Else 
	OB REMOVE:C1226(Form:C1466.sceneDetail.paramAction;"modele")
End if 

ACCEPT:C269