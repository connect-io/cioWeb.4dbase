// Je ré-initialise tout
Form:C1466.filtreDateNaissance:=Replace string:C233(Form:C1466.filtreDateNaissance; "/"; "")

// J'ajoute le formatage type Date
Form:C1466.filtreDateNaissance:=Substring:C12(Form:C1466.filtreDateNaissance; 0; 2)+"/"+Substring:C12(Form:C1466.filtreDateNaissance; 3; 2)+"/"+Substring:C12(Form:C1466.filtreDateNaissance; 5)

Form:C1466.personneCollection:=Form:C1466.personneSelectionDisplayClass.manageFilter(Form:C1466.personneCollectionInit; Form:C1466.filtreNom; Form:C1466.filtrePrenom; Form:C1466.filtreEmail; Form:C1466.filtreTelFixe; Form:C1466.filtreTelMobile; \
Form:C1466.filtreCodePostal; Form:C1466.filtreVille; Form:C1466.filtreDateNaissance)