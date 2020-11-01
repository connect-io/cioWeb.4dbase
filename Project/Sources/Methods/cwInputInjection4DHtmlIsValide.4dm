//%attributes = {"shared":true,"publishedWeb":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwInputInjection4DHtmlIsValide

Historique
29/07/19 - Grégory Fromain <gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */


If (True:C214)  // Déclarations
	var $0 : Boolean  //true si valide
	var $1 : Text  //data à vérifier
End if 

$0:=Not:C34(String:C10($1)="@<!--#4D@")