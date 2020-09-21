//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cwI18nCharger

Charge tout les fichiers de langue du dossier ressource/I18n pour le serveur web.

Historique
15/08/20 - Grégory Fromain <gregory@connect-io.fr> - Mise en veille de l'internalisation
----------------------------------------------------------------------------- */

/*
If (True)  // Déclarations
C_OBJECT($oFullI18n;$oFichierI18n)
C_TEXT($T_langue)
End if 

ARRAY TEXT($sites;0)
FOLDER LIST(<>webApp_o.config.webAppOld.folder_f();$sites)

◊webApp_o.i18n:=New object()

For ($i;1;Size of array($sites))


ARRAY TEXT($fichiersI18n;0)
$dossierI18n:=<>webApp_o.config.webAppOld.folder_f()+$sites{$i}+Folder separator+"i18n"+Folder separator

If (Test path name($dossierI18n)#Is a folder)
CREATE FOLDER($dossierI18n;*)
End if 

DOCUMENT LIST($dossierI18n;$fichiersI18n)

For ($j;1;Size of array($fichiersI18n))
$fichierI18n:=Document to text($dossierI18n+$fichiersI18n{$j};"UTF-8")
$oFichierI18n:=JSON Parse($fichierI18n)

  // On extrait la langue du fichier
$T_langue:=Replace string($fichiersI18n{$j};".json";"")

$T_langue:=Substring($T_langue;Length($T_langue)-1)

If (Not(OB Is defined($oFullI18n;$T_langue)))
OB SET($oFullI18n;$T_langue;New object)
End if 

OB SET($oFullI18n;$T_langue;cwToolObjectMerge (OB Get($oFullI18n;$T_langue);$oFichierI18n))

End for 
OB SET(<>webApp_o.i18n;$sites{$i};$oFullI18n)
End for 
*/