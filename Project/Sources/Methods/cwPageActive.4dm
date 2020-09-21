//%attributes = {"shared":true,"publishedWeb":true}
/* -----------------------------------------------------------------------------
Méthode : cwPageActive (Composant CioWeb)

Active le menu html en fonction de l'url.

Historique

----------------------------------------------------------------------------- */


If (True:C214)  // Déclarations
	C_TEXT:C284($0;$1;$retour_t;$texteRetour_t)  // $0 : [texte] "" ou "active", $1 : recup via la page web. (<!--#4DSCRIPT/cwPageActive/accueil-->)
	
	C_LONGINT:C283($debutPosition_l;$debutFin_l)
	C_BOOLEAN:C305($boucle_b)
End if 

$texteRetour_t:="active"

$debutFin_l:=1
$boucle_b:=True:C214


While ($boucle_b)
	$debutPosition_l:=Position:C15("/";$1;$debutFin_l)+1
	$debutFin_l:=Position:C15("/";$1;$debutPosition_l)
	
	If ($debutFin_l=0)
		$retour_t:=Choose:C955(pageWeb.lib=Substring:C12($1;$debutPosition_l);$texteRetour_t;"")
		$boucle_b:=False:C215
	Else 
		$retour_t:=Choose:C955(pageWeb.lib=Substring:C12($1;$debutPosition_l;$debutFin_l-$debutPosition_l);$texteRetour_t;"")
	End if 
	
	If ($debutFin_l=0) | ($retour_t#"")
		$boucle_b:=False:C215
	End if 
	
End while 

$0:=$retour_t