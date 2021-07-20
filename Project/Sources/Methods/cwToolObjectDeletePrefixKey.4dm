//%attributes = {"shared":true,"preemptive":"capable"}
/*------------------------------------------------------------------------------
Méthode : cwToolObjectDeletePrefixKey

Supprime un suffixe à chaque clé d'un objet et passe le 1er caractère en minuscule.

La méthode accepte sur $1 soit un objet si l'on l'utilise dans le composant.
                          soit un pointeur si l'on utilise dans une base hote.

Historique
15/08/17 - Grégory Fromain <gregory@connect-io.fr> - Création
26/10/19 - Grégory Fromain <gregory@connect-io.fr> - Récupération de la méthode depuis le composant cioObjet
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
29/11/20 - Grégory Fromain <gregory@connect-io.fr> - Ré-ecriture de la méthode
20/07/21 - Grégory Fromain <gregory@connect-io.fr> - Disponible base hôte et gestion $1 par pointeur si besoin
------------------------------------------------------------------------------*/

// Déclarations
var $1 : Variant
var $2 : Text  // le suffixe à supprimer

var $source_o : Object
var $nomLib_t : Text
var $nouvelleCle_t : Text


If (Value type:C1509($1)=Is pointer:K8:14)
	$source_o:=$1->
Else 
	$source_o:=$1
End if 

For each ($nomLib_t; $source_o)
	If ($nomLib_t=($2+"@"))
		$nouvelleCle_t:=Substring:C12($nomLib_t; Length:C16($2)+1)
		$nouvelleCle_t:=Change string:C234($nouvelleCle_t; Lowercase:C14(Substring:C12($nouvelleCle_t; 1; 1)); 1)
		
		$source_o[$nouvelleCle_t]:=$source_o[$nomLib_t]
		OB REMOVE:C1226($source_o; $nomLib_t)
	End if 
End for each 

//$1:=$source_o


