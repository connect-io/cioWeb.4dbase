//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cwToolObjectFromFile

Charge un objet JSON depuis un objet de type file. (Compatible JSON et JSONC)

Historique
01/10/2020 - Grégory Fromain <gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
-----------------------------------------------------------------------------*/

var $1 : Object  // Objet du fichier à charger.
var $0 : Object  // Objet contenu dans le fichier.

var $file_o : Object
var $fileContent_t : Text

$file_o:=$1

Case of 
	: ($file_o.extension=".json")
		$fileContent_t:=$file_o.getText()
		
	: ($file_o.extension=".jsonc")
		$fileContent_t:=cwToolJsoncToJson($file_o.getText())
		
	Else 
		ALERT:C41("cwToolObjectFromPath : L'extension de ce fichier n'est pas prise en charge par cette méthode : "+$file_o.path)
		$fileContent_t:="{}"
End case 

$0:=JSON Parse:C1218($fileContent_t)
