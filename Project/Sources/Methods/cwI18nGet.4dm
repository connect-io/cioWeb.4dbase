//%attributes = {"shared":true,"publishedWeb":true}
/* ----------------------------------------------------
Méthode : cwI18nGet

Historique

----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_TEXT:C284($0;$1)  // $0 :[text] le text en retour, $1 : [text] nom de la ressource que l'on souhaite utiliser.
	C_OBJECT:C1216($2;$O_ressource)  // $2 : [objet] (optionnel) objet de référence que l'on souhaite utiliser.
End if 

  // Si il y a un 2eme param, on utilise celui la.
If (Count parameters:C259=2)
	$O_ressource:=$2
Else 
	$O_ressource:=OB Get:C1224(pageWeb;"i18n")
End if 

  // Si la ressource existe on l'utilise sinon on renvoie la cle.
If (OB Is defined:C1231($O_ressource;$1))
	$0:=OB Get:C1224($O_ressource;$1)
Else 
	$0:=$1
End if 