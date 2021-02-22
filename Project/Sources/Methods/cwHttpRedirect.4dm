//%attributes = {"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwHttpRedirect

Envoi une redirection d'après le libellé d'une page ou d'une page http://
Et stock l'information pour la prochaine page.

Historique
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */

// Déclarations
var $1;$T_libPage : Text  // lib page
var $2 : Object  // Param de l'url

$T_libPage:=$1

If ($T_libPage#"http@")
	If (Count parameters:C259=1)
		$T_libPage:=cwLibToUrl($T_libPage)
		
	Else 
		$T_libPage:=cwLibToUrl($T_libPage;$2)
	End if 
End if 

visiteur.envoiHttpRedirection:=True:C214

WEB SEND HTTP REDIRECT:C659($T_libPage)