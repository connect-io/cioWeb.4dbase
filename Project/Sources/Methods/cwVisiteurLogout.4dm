//%attributes = {"shared":true}
/* ----------------------------------------------------
Méthode : cwVisiteurLogout

Déconnexion de l'utilisateur, et renvoit vers la page d'identification.

Historique

----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_POINTER:C301($1)  // $1 = [pointeur] objet "visiteur"
	
	C_OBJECT:C1216($visiteur)
End if 

$visiteur:=$1->

OB SET:C1220($visiteur;"loginDomaine";"")
OB SET:C1220($visiteur;"loginEMail";"")
OB SET:C1220(visiteur;"loginLevel";"")

$1->:=$visiteur