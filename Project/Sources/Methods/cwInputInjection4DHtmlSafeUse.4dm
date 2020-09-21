//%attributes = {"shared":true,"publishedWeb":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwInputInjection4DHtmlSafeUse

Historique
29/07/19 - Grégory Fromain <gregory@connect-io.fr> - Création
----------------------------------------------------------------------------- */


If (True:C214)  // Déclarations
	C_TEXT:C284($0;$1)  // $1 : [text] : data à controler, $0 : [text] : data valide
End if 

If (cwInputInjection4DHtmlIsValide ($1))
	$0:=String:C10($1)
Else 
	
	$0:="Injection de balise 4D HTML détécté."
End if 