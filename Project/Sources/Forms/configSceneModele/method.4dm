If (Form event code:C388=Sur chargement:K2:1)
	ARRAY TEXT:C222(modeleListe_at;0)
	
	COLLECTION TO ARRAY:C1562(Form:C1466.modele;modeleListe_at;"name")
	
	modeleListe_at{0}:="Merci de sélectionner un modèle"
End if 