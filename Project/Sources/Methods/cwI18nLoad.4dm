//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cwI18nCharger

Charge tout les fichiers de langue du dossier ressource/I18n pour le serveur web.

Historique
15/08/20 - Grégory Fromain <gregory@connect-io.fr> - Mise en veille de l'internalisation
----------------------------------------------------------------------------- */
var $analyseTrad_b : Boolean
var $subDomain_t : Text  // Nom du sous domaine
var $SplitNomDoc : Collection
var $type : Text

$SplitNomDoc:=New collection:C1472

//Storage.i18n.sousDomaine.fr.page.titre
//Storage.i18n.sousDomaine.fr.form.titre
For each ($subDomain_t;This:C1470.config.subDomain_c)
	
	If (Storage:C1525.sites[$subDomain_t].I18n=Null:C1517)
		Use (Storage:C1525.sites[$subDomain_t])
			Storage:C1525.sites[$subDomain_t].I18n:=New shared object:C1526()
		End use 
	End if 
	
	
	ARRAY TEXT:C222($fichiersTrad;0)
	DOCUMENT LIST:C474(This:C1470.sourceSubdomainPath($subDomain_t);$fichiersTrad;Recursive parsing:K24:13+Absolute path:K24:14)
	
	For ($numTrad;1;Size of array:C274($fichiersTrad))
		$analyseTrad_b:=$fichiersTrad{$numTrad}="@i18n.json@"
		
		If ($analyseTrad_b)
			$SplitNomDoc:=Split string:C1554($fichiersTrad{$numTrad};".")
			$SplitNomDoc[0]:=Split string:C1554($SplitNomDoc[0];":")[Split string:C1554($SplitNomDoc[0];":").length-1]
			// On récupére la collection de fichier de traduction
			If (Storage:C1525.sites[$subDomain_t].I18n[$SplitNomDoc[0]]=Null:C1517)
				Use (Storage:C1525.sites[$subDomain_t].I18n)
					Storage:C1525.sites[$subDomain_t].I18n[$SplitNomDoc[0]]:=New shared object:C1526()
				End use 
			End if 
			
			If (Storage:C1525.sites[$subDomain_t].I18n[$SplitNomDoc[0]][$SplitNomDoc[1]]=Null:C1517)
				Use (Storage:C1525.sites[$subDomain_t].I18n[$SplitNomDoc[0]])
					Storage:C1525.sites[$subDomain_t].I18n[$SplitNomDoc[0]][$SplitNomDoc[1]]:=New shared object:C1526()
				End use 
			End if 
			
			
			$trad:=cwToolObjectFromPlatformPath($fichiersTrad{$numTrad})
			If (Not:C34(OB Is defined:C1231($trad)))
				ALERT:C41("Impossible de parse "+$fichiersTrad{$numTrad})
				$analyseTrad_b:=False:C215
			End if 
		End if 
		
		
		If ($analyseTrad_b)
			//chargement de la traduction
			
			// On commence par ajouter un timestamp de MAJ de la traduction
			$trad.maj_ts:=cwTimestamp
			
			// On indique également la source de la traduction
			$trad.source:=$fichiersTrad{$numTrad}
			
			If ($trad.readOnly=Null:C1517)
				$trad.readOnly:=False:C215
			End if 
			
			
			// Enregistrement de $trad dans storage
			
			//If (Storage.sites[$subDomain_t].I18n[$SplitNomDoc[0]][$SplitNomDoc[1]][$fichiersTrad{$numTrad}]=Null)
			
			// Si c'est le 1er chargement de la traduction, on l'ajoute à la collection.
			Use (Storage:C1525.sites[$subDomain_t].I18n[$SplitNomDoc[0]][$SplitNomDoc[1]])
				Storage:C1525.sites[$subDomain_t].I18n[$SplitNomDoc[0]][$SplitNomDoc[1]]:=OB Copy:C1225($trad;ck shared:K85:29;Storage:C1525.sites[$subDomain_t].I18n[$SplitNomDoc[0]][$SplitNomDoc[1]]))
			End use 
			//Else 
			//Use (Storage.sites[$subDomain_t].I18n[$SplitNomDoc[0]][$SplitNomDoc[1]][$indicesQuery_c[0]])
			//Storage.sites[$subDomain_t].I18n[$SplitNomDoc[0]][$SplitNomDoc[1]]:=OB Copy($trad;ck shared;Storage.sites[$subDomain_t].I18n[$SplitNomDoc[0]][$SplitNomDoc[1]])
			//End use 
			//End if 
			
			
		End if 
		
		
	End for 
End for each 

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