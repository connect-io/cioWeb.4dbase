//%attributes = {"invisible":true}
/* -----------------------------------------------------------------------------
Méthode : cwToolDeletePrefixKey

Supprime un suffixe à chaque clé d'un objet.

Historique
15/08/17 gregory@connect-io.fr - Création
26/10/19 gregory@connect-io.fr - Récupération de la méthode depuis le composant cioObjet
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */


If (True:C214)  // Déclarations
	var $1;$source_o : Object
	var $2 : Text  // le suffixe à supprimer
	
	var $i_l : Integer
	var $nbCar_l : Integer
	ARRAY TEXT:C222($nomLib_at;0)
End if 


$source_o:=$1
$nbCar_l:=Length:C16($2)
OB GET PROPERTY NAMES:C1232($source_o;$nomLib_at)

For ($i_l;1;Size of array:C274($nomLib_at))
	If ($nomLib_at{$i_l}=($2+"@"))
		$nouvelleCle:=Substring:C12($nomLib_at{$i_l};$nbCar_l+1)
		$nouvelleCle:=Change string:C234($nouvelleCle;Lowercase:C14(Substring:C12($nouvelleCle;1;1));1)
		OB SET:C1220($source_o;$nouvelleCle;OB Get:C1224($source_o;$nomLib_at{$i_l}))
		OB REMOVE:C1226($source_o;$nomLib_at{$i_l})
	End if 
End for 

//$1:=$source_o


