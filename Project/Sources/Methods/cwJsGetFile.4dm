//%attributes = {"shared":true,"publishedWeb":true}
/* ----------------------------------------------------
Méthode : cwJsGetfile

Renvoie le contenu des fichiers déclaré dans le fichier pageWeb.json

  //C_TEXT($jsContenu;jsHtmlModele)
  //If (OB Is defined(pageWeb;"jsFile"))

  //ARRAY TEXT($jsFile;0)
  //OB GET ARRAY(pageWeb;"jsFile";$jsFile)
  //jsHtmlModele:="<script type=\"text/javascript\" src=\"$jsFile\"></script>"

  //For ($i;1;Size of array($jsFile))
  //$jsContenu:=$jsContenu+Replace string(jsHtmlModele;"$jsFile";$jsFile{$i})+Char(Line feed)
  //End for 
  //End if 

  //$0:=Char(Line feed)+$jsContenu

----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_TEXT:C284($1;$T_jsContenu;$T_jsHtmlModele;$T_domaineCDN)  // $1 : [texte] domaine du CDN
End if 

$T_domaineCDN:=""
If (Count parameters:C259=1)
	$T_domaineCDN:=$1
End if 

If (OB Is defined:C1231(pageWeb;"jsFile"))
	
	ARRAY TEXT:C222($AT_jsFile;0)
	OB GET ARRAY:C1229(pageWeb;"jsFile";$AT_jsFile)
	$T_jsHtmlModele:="<script type=\"text/javascript\" src=\"$jsFile\"></script>"
	
	For ($i;1;Size of array:C274($AT_jsFile))
		$AT_jsFile{$i}:=Replace string:C233($AT_jsFile{$i};"domaineCDN";$T_domaineCDN)
		$T_jsContenu:=$T_jsContenu+Replace string:C233($T_jsHtmlModele;"$jsFile";$AT_jsFile{$i})+Char:C90(Line feed:K15:40)
	End for 
End if 

$0:=Char:C90(Line feed:K15:40)+$T_jsContenu