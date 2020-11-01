//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cwJsSetFile

Ajoute le contenu d'un fichier javascript dans le code html 
via la commande cwJsGetContent à placer dans le code html.

Historique
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */


If (True:C214)  // Déclarations
	var ${1} : Text  // $1 : [texte] nom d'un fichier js dans le dossier /ressource/site/XXX/js/
	
	var $i : Integer
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

