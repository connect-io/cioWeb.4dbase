//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cwJsSetFile

Ajoute le contenu d'un fichier javascript dans le code html 
via la commande cwJsGetContent à placer dans le code html.

Historique

----------------------------------------------------------------------------- */


If (True:C214)  // Déclarations
	C_TEXT:C284(${1})  // $1 : [texte] nom d'un fichier js dans le dossier /ressource/site/XXX/js/
	
	C_LONGINT:C283($i)
End if 

If (Not:C34(OB Is defined:C1231(pageWeb)))
	ALERT:C41("L'objet 'pageWeb' n'est pas défini.")
Else 
	If (Count parameters:C259>=1)
		ARRAY TEXT:C222($jsFileContent;0)
		For ($i;1;Count parameters:C259)
			APPEND TO ARRAY:C911($jsFileContent;${$i})
		End for 
		
		OB SET ARRAY:C1227(pageWeb;"jsFile";$jsFileContent)
	End if 
End if 

