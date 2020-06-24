//%attributes = {"shared":true,"publishedWeb":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Méthode : cwInputInjection4DHtmlIsValide
  // Description
  // 
  //
  // Paramètres
  // $1 : [text] : data à vérifier
  // $0 : [bool] : true si valide
  // ----------------------------------------------------

If (False:C215)  // Historique
	  // 29/07/19 - Grégory Fromain <gregory@connect-io.fr> - Création
End if 

If (True:C214)  // Déclarations
	C_BOOLEAN:C305($0)
	C_TEXT:C284($1)
End if 

$0:=Not:C34(String:C10($1)="@<!--#4D@")