// Je ré-initialise tout
Form:C1466.filtreDateNaissance:=Replace string:C233(Form:C1466.filtreDateNaissance; "/"; "")

// J'ajoute le formatage type Date
Form:C1466.filtreDateNaissance:=Substring:C12(Form:C1466.filtreDateNaissance; 0; 2)+"/"+Substring:C12(Form:C1466.filtreDateNaissance; 3; 2)+"/"+Substring:C12(Form:C1466.filtreDateNaissance; 5)

If (Form:C1466.filtreDateNaissance="__/__/____")
	OB REMOVE:C1226(Form:C1466; "filtreDateNaissance")
End if 
