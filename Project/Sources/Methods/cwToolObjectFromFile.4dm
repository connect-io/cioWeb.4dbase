//%attributes = {"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwToolObjectFromFile

Charge un objet JSON depuis un objet de type file. (Compatible JSON et JSONC)

Historique
01/10/20 - Grégory Fromain <gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
10/11/20 - Grégory Fromain <gregory@connect-io.fr> - Ajout de la possibilité de retourner un objet partagé.
-----------------------------------------------------------------------------*/

var $1 : 4D:C1709.File  // Objet du fichier à charger.
var $2 : Integer  // renvoi un objet partagé, on utilisera la constante "ck shared" (entier 16)
var $0 : Object  // Objet contenu dans le fichier.

var $file_o : 4D:C1709.File
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


If (Count parameters:C259=2)
	If (Num:C11($2)=ck shared:K85:29)
		$0:=OB Copy:C1225($0; ck shared:K85:29)
	End if 
End if 
