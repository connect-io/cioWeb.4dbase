If (Form event code:C388=Sur chargement:K2:1)
	Form:C1466.loadAll()  // Chargement de toutes les entités de la table [Personne] de la base hôte
	Form:C1466.toCollectionAndExtractField(New collection:C1472("nom"; "prenom"; "eMail"; "telFixe"; "telMobile"; "codePostal"; "ville"; "dateNaissance"; "UID"))
	
	Form:C1466.personneCollectionInit:=Form:C1466.personneCollection.copy()
	
	// Instanciation de la class pour la gestion des filtres
	Form:C1466.personneSelectionDisplayClass:=cwToolGetClass("MAPersonneSelectionDisplay").new()
	
	Form:C1466.imageSortNom:=Storage:C1525.automation.image["sort"]
	Form:C1466.imageSortPrenom:=Storage:C1525.automation.image["sort"]
	
	Form:C1466.imageSortEMail:=Storage:C1525.automation.image["sort"]
	Form:C1466.imageSortTelFixe:=Storage:C1525.automation.image["sort"]
	Form:C1466.imageSortTelMobile:=Storage:C1525.automation.image["sort"]
	
	Form:C1466.imageSortCodePostal:=Storage:C1525.automation.image["sort"]
	Form:C1466.imageSortVille:=Storage:C1525.automation.image["sort"]
	Form:C1466.imageSortDateNaissance:=Storage:C1525.automation.image["sort"]
End if 

If (Form event code:C388=Sur données modifiées:K2:15)
	Form:C1466.personneCollection:=Form:C1466.personneSelectionDisplayClass.manageFilter()
	Form:C1466.personneCollection:=Form:C1466.personneSelectionDisplayClass.manageSort("")
End if 
