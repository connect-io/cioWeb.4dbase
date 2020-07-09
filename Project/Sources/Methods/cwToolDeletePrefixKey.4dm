//%attributes = {"invisible":true}
/* ----------------------------------------------------
Méthode : cwToolDeletePrefixKey

Supprime un suffixe à chaque clé d'un objet.

Historique
15/08/17 gregory@connect-io.fr - Création
26/10/19 gregory@connect-io.fr - Récupération de la méthode depuis le composant cioObjet
----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_OBJECT:C1216($1;$source_o)  // $1 [pointeur] objet
	C_TEXT:C284($2)  // $2 [text] le suffixe à supprimer
	
	C_LONGINT:C283($i_l;$nbCar_l)
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


