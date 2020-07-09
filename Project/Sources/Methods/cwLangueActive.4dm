//%attributes = {"shared":true}
/* ----------------------------------------------------
Méthode : cwLangueActive

Conserve dans le composant la langue actuelle

Historique

----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_TEXT:C284(langue)  // $1 = [text] nom de la langue au format ISO (ex : fr, en, ...)
End if 

langue:=$1
