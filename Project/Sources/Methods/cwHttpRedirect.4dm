//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cwHttpRedirect

Envoi une redirection d'après le libellé d'une page ou d'une page http://
Et stock l'information pour la prochaine page.

Historique
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */


If (True:C214)  // Déclarations
	var $1;$T_libPage : Text  //$1 : [text] lib page
End if 

$T_libPage:=$1

If ($T_libPage#"http@")
	$T_libPage:=cwLibToUrl($T_libPage)
End if 

visiteur.envoiHttpRedirection:=True:C214

WEB SEND HTTP REDIRECT:C659($T_libPage)