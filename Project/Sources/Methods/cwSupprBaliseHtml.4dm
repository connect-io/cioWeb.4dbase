//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cwSupprBaliseHtml (composant CioWeb)

Supprimer les balises html d'un chaine de caractére.
(ex : on reutilise du code html pour placer dans une meta description)

Historique

----------------------------------------------------------------------------- */


If (True:C214)  // Déclarations
	C_TEXT:C284($0;$1;$in;$out)  // $1 = [texte] chaine avec balise, $0 = [texte] chaine sans balise
	
	C_BOOLEAN:C305($B)
End if 

$in:=$1
$B:=PHP Execute:C1058("";"strip_tags";$out;$in)
$0:=$out
