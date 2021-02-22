//%attributes = {"shared":true,"preemptive":"capable"}
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
var $1 : Integer
var $2 : Text
var $3 : Text
var $0 : Date

Case of 
	: ($2="year")
		
		If ($3="add")
			$0:=Add to date:C393(Current date:C33; $1; 0; 0)
		Else 
			$0:=Add to date:C393(Current date:C33; -$1; 0; 0)
		End if 
		
End case 