If (Form event code:C388=Sur chargement:K2:1)
	ARRAY TEXT:C222(versionList_at; 0)
	
	If (Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version#Null:C1517)
		COLLECTION TO ARRAY:C1562(Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version.orderBy("titre asc"); versionList_at; "titre")
	End if 
	
	APPEND TO ARRAY:C911(versionList_at; "Créer une nouvelle version...")
	
	versionList_at{0}:="Merci de sélectionner une version"
	versionList_at:=0
	
	Form:C1466.modeleDetail:=""
	
	Form:C1466.imageModeleActif:=Storage:C1525.automation.image["toggle-off"]
End if 