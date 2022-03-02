//%attributes = {"shared":true,"preemptive":"capable"}
/*------------------------------------------------------------------------------
Méthode : cwToolObjectBuildPropertyObject

Création au sein d'un ojet de propriété objet qui sont sous-forme de texte

Historique
02/03/21 - Rémy Scanu remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
var $1 : Object

var $key_c; $splitKey_c : Collection
var $key_t : Text

$key_c:=OB Keys:C1719($1)

For each ($key_t; $key_c)
	$splitKey_c:=New collection:C1472()
	$splitKey_c:=Split string:C1554($key_t; ".")
	
	If ($splitKey_c.length>1)
		
		If ($1[$splitKey_c[0]]=Null:C1517)
			$1[$splitKey_c[0]]:=New object:C1471
		End if 
		
		$1[$splitKey_c[0]][$splitKey_c[1]]:=$1[$key_t]
	End if 
	
End for each 