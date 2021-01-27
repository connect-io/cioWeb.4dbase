If (Form event code:C388=Sur chargement:K2:1)
	Form:C1466.loadAll()  // Chargement de toutes les entités de la table [Personne] de la base hôte
	Form:C1466.toCollectionAndExtractField(New collection:C1472("nom"; "prenom"; "codePostal"; "ville"; "dateNaissance"; "UID"))
	
	Form:C1466.personneCollectionInit:=Form:C1466.personneCollection.copy()
	
	// Instanciation de la class pour la gestion des filtres
	Form:C1466.personneSelectionDisplayClass:=cwToolGetClass("MAPersonneSelectionDisplay").new()
End if 