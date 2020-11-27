//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cwRedirection301

Etabli une redirection 301 http (de type permanante)

Historique
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */

/*
If (True)  // Déclarations
var $1 : Text  // $1 = [texte] nouvelle url

ARRAY TEXT($champs;2)
ARRAY TEXT($valeurs;2)
End if 

$champs{1}:="X-STATUS"
$valeurs{1}:="301 Moved Permanently, false, 301"
$champs{2}:="Location"
$valeurs{2}:=$1

WEB SET HTTP HEADER($champs;$valeurs)
WEB SEND TEXT("redirection")

*/

ALERT:C41("La méthode cwRedirection301 est obsolette, merci d'utiliser pageWeb_o.redirection301()")