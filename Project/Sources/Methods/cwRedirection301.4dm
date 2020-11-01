//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : ogWebRedirection301

Etabli une redirection 301 http (de type permanante)

Historique
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */

If (True:C214)  // Déclarations
	var $1 : Text  // $1 = [texte] nouvelle url
	
	ARRAY TEXT:C222($champs;2)
	ARRAY TEXT:C222($valeurs;2)
End if 

$champs{1}:="X-STATUS"
$valeurs{1}:="301 Moved Permanently, false, 301"
$champs{2}:="Location"
$valeurs{2}:=$1

WEB SET HTTP HEADER:C660($champs;$valeurs)
WEB SEND TEXT:C677("redirection")