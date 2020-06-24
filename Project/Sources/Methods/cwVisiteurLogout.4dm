//%attributes = {"shared":true}
  // ----------------------------------------------------
  // Nom utilisateur (OS) : Grégory Fromain <gregory@connect-io.fr>
  // Date et heure : 29/09/15, 17:34:05
  // ----------------------------------------------------
  // Méthode : cwVisiteurLogout
  // Description
  // Déconnexion de l'utilisateur, et renvoit vers la page d'identification.
  //
  // Paramètres
  // $1 = [pointeur] objet "visiteur"
  // ----------------------------------------------------
C_OBJECT:C1216($visiteur)
C_POINTER:C301($1)

$visiteur:=$1->

OB SET:C1220($visiteur;"loginDomaine";"")
OB SET:C1220($visiteur;"loginEMail";"")
OB SET:C1220(visiteur;"loginLevel";"")

$1->:=$visiteur