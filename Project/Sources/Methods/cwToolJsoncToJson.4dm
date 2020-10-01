//%attributes = {}
/* -----------------------------------------------------------------------------
Méthode : cwToolJsoncToJson

Converti du JSONC en JSON

Historique
01/10/2020 - Grégory Fromain <gregory@connect-io.fr> - Création
----------------------------------------------------------------------------- */

C_TEXT:C284($1)  // texte en format JSONC
C_TEXT:C284($0)  // texte en format JSON

C_TEXT:C284($texteOut)

$texteOut:=$1

$texteOut:=cwToolTextReplaceByRegex ($texteOut;"\\/\\*(.*?)\\*\\/";"")
$texteOut:=cwToolTextReplaceByRegex ($texteOut;"[^:\"]\\/\\/(.*?)##r";"##r")


$0:=$texteOut
