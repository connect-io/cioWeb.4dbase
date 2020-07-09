//%attributes = {"shared":true}
/* ----------------------------------------------------
Méthode : ogWebRedirection301

Etabli une redirection 301 http (de type permanante)

Historique

----------------------------------------------------*/

If (True:C214)  // Déclarations
	C_TEXT:C284($1)  // $1 = [texte] nouvelle url
End if 

ARRAY TEXT:C222($champs;2)
ARRAY TEXT:C222($valeurs;2)

$champs{1}:="X-STATUS"
$valeurs{1}:="301 Moved Permanently, false, 301"
$champs{2}:="Location"
$valeurs{2}:=$1

WEB SET HTTP HEADER:C660($champs;$valeurs)
WEB SEND TEXT:C677("redirection")