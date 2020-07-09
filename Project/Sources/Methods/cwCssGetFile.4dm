//%attributes = {"shared":true,"publishedWeb":true}
/* ----------------------------------------------------
Méthode : cwCssGetfile

Renvoi le contenu des fichiers déclaré dans le fichier pageWeb.json

Historique
19/06/2019 - Grégory Fromain <gregory@connect-io.fr> - Création
10/02/2020 - Grégory Fromain <gregory@connect-io.fr> - Mise en place de la boucle for each.
----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_TEXT:C284($1)  // Domaine du CDN
	C_TEXT:C284($0)  // Contenu des fichiers html
	
	C_TEXT:C284($cssContenu_t;$cssHtmlModele_t;$domaineCDN_t;$cssFile_t)
End if 

  // Attention de ne pas utiliser "choose" ici, cela génére une erreur en compilé.
$domaineCDN_t:=""
If (Count parameters:C259=1)
	$domaineCDN_t:=$1
End if 

$cssHtmlModele_t:="<link rel=\"stylesheet\" href=\"$cssFile\">"
$cssContenu_t:=""


If (pageWeb.cssFile#Null:C1517)
	
	For each ($cssFile_t;pageWeb.cssFile)
		
		$cssContenu_t:=$cssContenu_t+Replace string:C233($cssHtmlModele_t;"$cssFile";$cssFile_t)+Char:C90(Line feed:K15:40)
	End for each 
	
End if 

$cssContenu_t:=Replace string:C233($cssContenu_t;"domaineCDN";$domaineCDN_t)

$0:=$cssContenu_t