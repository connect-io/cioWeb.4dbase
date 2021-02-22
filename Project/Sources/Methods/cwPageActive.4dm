//%attributes = {"publishedWeb":true,"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwPageActive (Composant CioWeb)

Active le menu html en fonction de l'url.

Historique
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */

// Déclarations
var $1 : Text  // recup via la page web. (<!--#4DSCRIPT/cwPageActive/accueil-->)
var $0;$retour_t : Text  // "" ou "active"

var $texteRetour_t : Text
var $debutPosition_l : Integer
var $debutFin_l : Integer
var $boucle_b : Boolean


$texteRetour_t:="active"
$debutFin_l:=1
$boucle_b:=True:C214


While ($boucle_b)
	$debutPosition_l:=Position:C15("/";$1;$debutFin_l)+1
	$debutFin_l:=Position:C15("/";$1;$debutPosition_l)
	
	If ($debutFin_l=0)
		$retour_t:=Choose:C955(pageWeb_o.lib=Substring:C12($1;$debutPosition_l);$texteRetour_t;"")
		$boucle_b:=False:C215
	Else 
		$retour_t:=Choose:C955(pageWeb_o.lib=Substring:C12($1;$debutPosition_l;$debutFin_l-$debutPosition_l);$texteRetour_t;"")
	End if 
	
	If ($debutFin_l=0) | ($retour_t#"")
		$boucle_b:=False:C215
	End if 
	
End while 

$0:=$retour_t