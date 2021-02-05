If (modeleListe_at{modeleListe_at}#"")
	Form:C1466.sceneDetail.paramAction.modele:=modeleListe_at{modeleListe_at}
	
	If (modeleListe_at{modeleListe_at}#"@.4WP") & (modeleListe_at{modeleListe_at}#"@.4W7")  // Modèle du composant cioWeb
		
		If (Form:C1466.sceneDetail.paramAction.modelePerso#Null:C1517)
			OB REMOVE:C1226(Form:C1466.sceneDetail.paramAction; "modelePerso")
		End if 
		
		If (Form:C1466.sceneDetail.paramAction.modele4WP#Null:C1517)
			OB REMOVE:C1226(Form:C1466.sceneDetail.paramAction; "modele4WP")
		End if 
		
	Else   // Modèle perso
		Form:C1466.sceneDetail.paramAction.modelePerso:=True:C214
		Form:C1466.sceneDetail.paramAction.modele4WP:=WP Import document:C1318(Form:C1466.modele[0].path)
	End if 
	
Else 
	
	If (Form:C1466.sceneDetail.paramAction.modele#Null:C1517)
		OB REMOVE:C1226(Form:C1466.sceneDetail.paramAction; "modele")
	End if 
	
	If (Form:C1466.sceneDetail.paramAction.modelePerso#Null:C1517)
		OB REMOVE:C1226(Form:C1466.sceneDetail.paramAction; "modelePerso")
	End if 
	
	If (Form:C1466.sceneDetail.paramAction.modele4WP#Null:C1517)
		OB REMOVE:C1226(Form:C1466.sceneDetail.paramAction; "modele4WP")
	End if 
	
End if 

ACCEPT:C269