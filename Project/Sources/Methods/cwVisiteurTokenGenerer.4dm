//%attributes = {"shared":true}
/* ----------------------------------------------------
Méthode : cwVisiteurTokenGenerer

Permet de générer un token pour le visiteur.

Historique

----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_POINTER:C301($1)  // $1 : [pointeur] visiteur
	
	C_OBJECT:C1216($visiteur)
	C_TEXT:C284($t_uuid)
End if 

$visiteur:=$1->
$t_uuid:=Generate UUID:C1066
OB SET:C1220(visiteur;"token";$t_uuid)
OB SET:C1220(visiteur;"tokenControle";$t_uuid)

$1->:=$visiteur