//%attributes = {"shared":true,"publishedWeb":true}
/* ----------------------------------------------------
Méthode : cwJsGetfile

Renvoie le contenu des fichiers déclaré dans le fichier pageWeb.json

Historique
27/07/2020 - Grégory Fromain <gregory@connect-io.fr> - Changement du nom de la propriete jsFile en jsPath
----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_TEXT:C284($1;$T_jsContenu;$T_jsHtmlModele;$T_domaineCDN)  // $1 : [texte] domaine du CDN
End if 

$T_domaineCDN:=""
If (Count parameters:C259=1)
	$T_domaineCDN:=$1
End if 

If (OB Is defined:C1231(pageWeb;"jsPath"))
	
	ARRAY TEXT:C222($AT_jsPath;0)
	OB GET ARRAY:C1229(pageWeb;"jsPath";$AT_jsPath)
	$T_jsHtmlModele:="<script type=\"text/javascript\" src=\"$jsPath\"></script>"
	
	For ($i;1;Size of array:C274($AT_jsPath))
		$AT_jsPath{$i}:=Replace string:C233($AT_jsPath{$i};"domaineCDN";$T_domaineCDN)
		$T_jsContenu:=$T_jsContenu+Replace string:C233($T_jsHtmlModele;"$jsPath";$AT_jsPath{$i})+Char:C90(Line feed:K15:40)
	End for 
End if 

$0:=Char:C90(Line feed:K15:40)+$T_jsContenu