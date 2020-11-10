//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cwToolGetClass

Renvoie une class vers la base hôte.

Historique
03/07/2020 - gregory@connect-io.fr - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */

If (True:C214)
	var $1 : Text  // Nom de la classe à renvoyer.
	var $0 : Object  // Objet de la class
End if 

ASSERT:C1129($1#"";"La variable $1 est vide.")

$1:=Uppercase:C13(Substring:C12($1;1;1))+Substring:C12($1;2)

$0:=cs:C1710[$1]