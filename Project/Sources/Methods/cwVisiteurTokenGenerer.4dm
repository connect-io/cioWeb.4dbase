//%attributes = {"shared":true}
  // ----------------------------------------------------
  // Nom utilisateur (OS) : Grégory Fromain <gregory@connect-io.fr>
  // Date et heure : 28/06/18, 19:11:47
  // ----------------------------------------------------
  // Méthode : cwVisiteurTokenGenerer
  // Description
  // Permet de générer un token pour le visiteur.
  //
  // Paramètres
  // $1 : [pointeur] visiteur
  // ----------------------------------------------------

C_OBJECT:C1216($visiteur)
C_TEXT:C284($t_uuid)
C_POINTER:C301($1)

$visiteur:=$1->
$t_uuid:=Generate UUID:C1066
OB SET:C1220(visiteur;"token";$t_uuid)
OB SET:C1220(visiteur;"tokenControle";$t_uuid)

$1->:=$visiteur