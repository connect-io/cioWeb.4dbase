//%attributes = {"shared":true,"publishedWeb":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwInputInjection4DHtmlIsValide

Historique
29/07/19 - Grégory Fromain <gregory@connect-io.fr> - Création
----------------------------------------------------------------------------- */


If (True:C214)  // Déclarations
	C_BOOLEAN:C305($0)  //true si valide
	C_TEXT:C284($1)  //data à vérifier
End if 

$0:=Not:C34(String:C10($1)="@<!--#4D@")