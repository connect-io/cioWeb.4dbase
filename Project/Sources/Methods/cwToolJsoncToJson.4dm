//%attributes = {"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwToolJsoncToJson

Converti du JSONC en JSON

Historique
01/10/20 - Grégory Fromain <gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */

var $1 : Text  // texte en format JSONC
var $0;$texteOut : Text  // texte en format JSON


$texteOut:=$1
$texteOut:=cwToolTextReplaceByRegex($texteOut;"\\/\\*(.*?)\\*\\/";"")
$texteOut:=cwToolTextReplaceByRegex($texteOut;"[^:\"]\\/\\/(.*?)##r";"##r")

$0:=$texteOut
