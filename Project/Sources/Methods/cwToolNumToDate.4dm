//%attributes = {"shared":true}
  // ----------------------------------------------------
  // Nom utilisateur (OS) : Scanu Rémy
  // Date et heure : 16/07/20, 18:19:53
  // ----------------------------------------------------
  // Méthode : caNumToDate
  // Description
  // 
  //
  // Paramètres
  // ----------------------------------------------------
C_LONGINT:C283($1)
C_TEXT:C284($2)
C_TEXT:C284($3)
C_DATE:C307($0)

Case of 
	: ($2="year")
		
		If ($3="add")
			$0:=Add to date:C393(Current date:C33;$1;0;0)
		Else 
			$0:=Add to date:C393(Current date:C33;-$1;0;0)
		End if 
		
End case 