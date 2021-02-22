//%attributes = {"invisible":true,"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwToolObjectProgress4DTag

Traiter les balises 4D qu'il peut y avoir dans un objet.

Historique
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */

// Déclarations
var $1;$ressource_o : Object
var $0 : Object

var $cle_t : Text
var $tampon_t : Text

$ressource_o:=$1

For each ($cle_t;$ressource_o)
	If (OB Get type:C1230($ressource_o;$cle_t)=Is object:K8:27)
		$ressource_o[$cle_t]:=cwToolObjectProgress4DTag($ressource_o[$cle_t])
	Else 
		$tampon_t:=$ressource_o[$cle_t]
		PROCESS 4D TAGS:C816($tampon_t;$tampon_t)
		$ressource_o[$cle_t]:=$tampon_t
	End if 
End for each 

$0:=$ressource_o