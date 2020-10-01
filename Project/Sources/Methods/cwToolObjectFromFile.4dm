//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cwToolObjectFromFile

Charge un objet JSON depuis un objet de type file. (Compatible JSON et JSONC)

Historique
01/10/2020 - Grégory Fromain <gregory@connect-io.fr> - Création
-----------------------------------------------------------------------------*/

C_OBJECT:C1216($1)  // Objet du fichier à charger.
C_OBJECT:C1216($0)  // Objet contenu dans le fichier.

C_OBJECT:C1216($file_o)
C_TEXT:C284($fileContent_t)

$file_o:=$1

Case of 
	: ($file_o.extension=".json")
		$fileContent_t:=$file_o.getText()
		
	: ($file_o.extension=".jsonc")
		$fileContent_t:=cwToolJsoncToJson ($file_o.getText())
		
	Else 
		ALERT:C41("cwToolObjectFromPath : L'extension de ce fichier n'est pas prise en charge par cette méthode : "+$file_o.path)
		$fileContent_t:="{}"
End case 

$0:=JSON Parse:C1218($fileContent_t)
