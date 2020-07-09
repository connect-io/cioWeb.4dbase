//%attributes = {"shared":true}
/* ----------------------------------------------------
Méthode : cwVisiteurTokenVerifier

Vérifie si le token du visiteur est valide

Historique

----------------------------------------------------*/

If (True:C214)  // Déclarations
	C_POINTER:C301($1)  // $1 : [pointeur] visiteur
	C_BOOLEAN:C305($0)  // $0 : [booleen] vrai si valide
	
	C_OBJECT:C1216($visiteur;$O_logErreur)
End if 

$0:=False:C215
$visiteur:=$1->

If (OB Is defined:C1231(visiteur;"token"))
	If (OB Is defined:C1231(visiteur;"tokenControle"))
		If (OB Get:C1224(visiteur;"token")=OB Get:C1224(visiteur;"tokenControle"))
			$0:=True:C214
		Else 
			OB SET:C1220($O_logErreur;"detailErreur";"Erreur de Token du visiteur")
			OB SET:C1220($O_logErreur;"methode";Current method name:C684)
			OB SET:C1220($O_logErreur;"visiteur";visiteur)
			cwLogErreurAjout ("Configuration serveur";$O_logErreur)
		End if 
	End if 
End if 