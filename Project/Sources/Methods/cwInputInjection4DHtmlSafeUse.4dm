//%attributes = {"publishedWeb":true,"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwInputInjection4DHtmlSafeUse

Historique
29/07/19 - Grégory Fromain <gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */

// Déclarations
var $1 : Text  // data à controler
var $0 : Text  // data valide


If (cwInputInjection4DHtmlIsValide($1))
	$0:=String:C10($1)
Else 
	
	$0:="Injection de balise 4D HTML détécté."
End if 