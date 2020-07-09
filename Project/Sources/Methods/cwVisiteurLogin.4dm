//%attributes = {"shared":true}
/* ----------------------------------------------------
Méthode : cwVisiteurLogin

à utiliser après la vérification des utilisateurs.
permet de garder l'information durant la  session.

Historique
29/09/15 Grégory Fromain <gregory@connect-io.fr> - Création
14/08/19  Grégory Fromain <gregory@connect-io.fr> - Mise au propre et ajout visiteur.action
----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_OBJECT:C1216($visiteur_o)
	C_POINTER:C301($1)  // $1 = [pointeur] objet "visiteur"
End if 

$visiteur_o:=$1->

$visiteur_o.loginDomaine:=String:C10($visiteur_o.domaine)
$visiteur_o.loginEMail:=String:C10($visiteur_o.eMail)

visiteur.loginExpire_ts:=cwTimestamp (Current date:C33;?23:59:59?)

  // Peut être utilisé dans certaine requête pour la suite.
$visiteur_o.action:=Null:C1517

  // On redirige vers la page d'index.
cwRedirection301 (cwLibToUrl ("index"))

$1->:=$visiteur_o