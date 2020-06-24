//%attributes = {"shared":true}
  // ----------------------------------------------------
  // Nom utilisateur (OS) : Grégory Fromain <gregoryfromain@gmail.com>
  // Date et heure : 18/02/15, 13:28:12
  // ----------------------------------------------------
  // Méthode : ogWebRedirection301
  // Description
  // Etabli une redirection 301 http (de type permanante)
  //
  // Paramètres
  // $1 = [texte] nouvelle url
  // ----------------------------------------------------

C_TEXT:C284($1)
ARRAY TEXT:C222($champs;2)
ARRAY TEXT:C222($valeurs;2)

$champs{1}:="X-STATUS"
$valeurs{1}:="301 Moved Permanently, false, 301"
$champs{2}:="Location"
$valeurs{2}:=$1

WEB SET HTTP HEADER:C660($champs;$valeurs)
WEB SEND TEXT:C677("redirection")