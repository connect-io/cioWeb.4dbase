//%attributes = {"shared":true}
/* ----------------------------------------------------
Méthode : cwI18nCharger

Charge tout les fichiers de langue du dossier ressource/I18n pour le serveur web.

Historique

----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_OBJECT:C1216($oFullI18n;$oFichierI18n)
	C_TEXT:C284($T_langue)
End if 

ARRAY TEXT:C222($sites;0)
FOLDER LIST:C473(<>webApp_o.config.webAppOld.folder_f();$sites)

<>webApp_o.i18n:=New object:C1471()

For ($i;1;Size of array:C274($sites))
	
	
	ARRAY TEXT:C222($fichiersI18n;0)
	$dossierI18n:=<>webApp_o.config.webAppOld.folder_f()+$sites{$i}+Folder separator:K24:12+"i18n"+Folder separator:K24:12
	
	If (Test path name:C476($dossierI18n)#Is a folder:K24:2)
		CREATE FOLDER:C475($dossierI18n;*)
	End if 
	
	DOCUMENT LIST:C474($dossierI18n;$fichiersI18n)
	
	For ($j;1;Size of array:C274($fichiersI18n))
		$fichierI18n:=Document to text:C1236($dossierI18n+$fichiersI18n{$j};"UTF-8")
		$oFichierI18n:=JSON Parse:C1218($fichierI18n)
		
		  // On extrait la langue du fichier
		$T_langue:=Replace string:C233($fichiersI18n{$j};".json";"")
		
		$T_langue:=Substring:C12($T_langue;Length:C16($T_langue)-1)
		
		If (Not:C34(OB Is defined:C1231($oFullI18n;$T_langue)))
			OB SET:C1220($oFullI18n;$T_langue;New object:C1471)
		End if 
		
		OB SET:C1220($oFullI18n;$T_langue;cwToolObjectMerge (OB Get:C1224($oFullI18n;$T_langue);$oFichierI18n))
		
	End for 
	OB SET:C1220(<>webApp_o.i18n;$sites{$i};$oFullI18n)
End for 
