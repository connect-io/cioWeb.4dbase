//%attributes = {"shared":true}
  // ----------------------------------------------------
  // Nom utilisateur (OS) : Grégory Fromain <gregory@connect-io.fr>
  // Date et heure : 28/06/18, 19:28:39
  // ----------------------------------------------------
  // Méthode : cwVisiteurTokenVerifier
  // Description
  // Vérifie si le token du visiteur est valide
  //
  // Paramètres
  // $1 : [pointeur] visiteur
  // $0 : [booleen] vrai si valide
  // ----------------------------------------------------

C_OBJECT:C1216($visiteur;$O_logErreur)
C_POINTER:C301($1)
C_BOOLEAN:C305($0)

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