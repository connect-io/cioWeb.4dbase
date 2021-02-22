//%attributes = {"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwLogErreurAjout

Ajoute une erreur dans le fichier de log.

Historique
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */

// Déclarations
var $1 : Text  // type erreur
var $2 : Object  // Message erreur

var $chErreur : Text
var $nouveauLog : Object
ARRAY OBJECT:C1221($logJson;0)


ASSERT:C1129(Length:C16($1)#0;"Le contenue du param $1 est vide.")

$chErreur:=Get 4D folder:C485(Logs folder:K5:19;*)+"cioWebErreur"+cwDateFormatTexte("AAMMJJ")+".json"

//On verifie l'existance d'un fichier de log...
If (Test path name:C476($chErreur)#Is a document:K24:1)
	TEXT TO DOCUMENT:C1237($chErreur;JSON Stringify array:C1228($logJson))
End if 

JSON PARSE ARRAY:C1219(Document to text:C1236($chErreur;"UTF-8");$logJson)
OB SET:C1220($nouveauLog;"timestamps";String:C10(cwTimestamp);"type";$1;"message";$2)
APPEND TO ARRAY:C911($logJson;$nouveauLog)
TEXT TO DOCUMENT:C1237($chErreur;JSON Stringify array:C1228($logJson;*))