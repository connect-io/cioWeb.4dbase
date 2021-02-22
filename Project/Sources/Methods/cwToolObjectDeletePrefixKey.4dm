//%attributes = {"invisible":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwToolObjectDeletePrefixKey

Supprime un suffixe à chaque clé d'un objet.

Historique
15/08/17 - Grégory Fromain <gregory@connect-io.fr> - Création
26/10/19 - Grégory Fromain <gregory@connect-io.fr> - Récupération de la méthode depuis le composant cioObjet
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
29/11/20 - Grégory Fromain <gregory@connect-io.fr> - Ré-ecriture de la méthode
----------------------------------------------------------------------------- */

// Déclarations
var $1;$source_o : Object
var $2 : Text  // le suffixe à supprimer

var $nomLib_t : Text
var $nouvelleCle_t : Text

$source_o:=$1

For each ($nomLib_t;$source_o)
	If ($nomLib_t=($2+"@"))
		$nouvelleCle_t:=Substring:C12($nomLib_t;Length:C16($2)+1)
		$nouvelleCle_t:=Change string:C234($nouvelleCle_t;Lowercase:C14(Substring:C12($nouvelleCle_t;1;1));1)
		
		$source_o[$nouvelleCle_t]:=$source_o[$nomLib_t]
		OB REMOVE:C1226($source_o;$nomLib_t)
	End if 
End for each 

//$1:=$source_o


