//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cwSupprBaliseHtml (composant CioWeb)

Supprimer les balises html d'un chaine de caractére.
(ex : on reutilise du code html pour placer dans une meta description)

Historique

----------------------------------------------------------------------------- */


If (True:C214)  // Déclarations
	var $1;$in : Text  // chaine avec balise
	var $0;$out : Text  // chaine sans balise
	
	var $B : Boolean
End if 

$in:=$1
$B:=PHP Execute:C1058("";"strip_tags";$out;$in)
$0:=$out
