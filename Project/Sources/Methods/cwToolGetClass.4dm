//%attributes = {"shared":true}
/* ----------------------------------------------------
Méthode : cwToolGetClass

Renvoie une class vers la base hôte.

Historique
03/07/2020 - gregory@connect-io.fr - Création
----------------------------------------------------*/

If (True:C214)
	C_TEXT:C284($1)  // Nom de la classe à renvoyer.
	C_OBJECT:C1216($0)  // Objet de la class
End if 

ASSERT:C1129($1#"";"La variable $1 est vide.")

$0:=cs:C1710[$1]