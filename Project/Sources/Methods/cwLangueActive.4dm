//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cwLangueActive

Conserve dans le composant la langue actuelle

Historique
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */


If (True:C214)  // Déclarations
	var langue : Text  // $1 = [text] nom de la langue au format ISO (ex : fr, en, ...)
End if 

langue:=$1
