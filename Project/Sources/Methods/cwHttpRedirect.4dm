//%attributes = {"shared":true}
  // ----------------------------------------------------
  // Nom utilisateur (OS) : Grégory Fromain <gregory@connect-io.fr>
  // Date et heure : 03/10/17, 14:34:29
  // ----------------------------------------------------
  // Méthode : cwHttpRedirect
  // Description
  // Envoi une redirection d'après le libellé d'une page ou d'une page http://
  // Et stock l'information pour la prochaine page.
  //
  // Paramètres
  // $1 : [text] lib page
  // ----------------------------------------------------

C_TEXT:C284($1;$T_libPage)
$T_libPage:=$1

If ($T_libPage#"http@")
	$T_libPage:=cwLibToUrl ($T_libPage)
End if 

visiteur.envoiHttpRedirection:=True:C214

WEB SEND HTTP REDIRECT:C659($T_libPage)