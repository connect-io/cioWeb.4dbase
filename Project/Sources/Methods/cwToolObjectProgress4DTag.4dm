//%attributes = {"invisible":true,"shared":true}
  // ----------------------------------------------------
  // Nom utilisateur (OS) : Grégory Fromain <gregory@connect-io.fr>
  // Date et heure : 12/05/19, 01:45:48
  // ----------------------------------------------------
  // Méthode : cwToolObjectProgress4DTag
  // Description
  // Traiter les balises 4D qu'il peut y avoir dans un objet.
  //
  // Paramètres
  // $1 : [objet]
  // $0 : [objet]
  // ----------------------------------------------------

C_OBJECT:C1216($0;$1;$ressource_o)
C_TEXT:C284($cle_t;$tampon_t)

$ressource_o:=$1

For each ($cle_t;$ressource_o)
	If (OB Get type:C1230($ressource_o;$cle_t)=Is object:K8:27)
		$ressource_o[$cle_t]:=cwToolObjectProgress4DTag ($ressource_o[$cle_t])
	Else 
		$tampon_t:=$ressource_o[$cle_t]
		PROCESS 4D TAGS:C816($tampon_t;$tampon_t)
		$ressource_o[$cle_t]:=$tampon_t
	End if 
End for each 

$0:=$ressource_o