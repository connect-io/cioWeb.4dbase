//%attributes = {"shared":true}
/* ----------------------------------------------------
Méthode : cwSessionClean

Supprime les sessions périmées.

Historique
20/02/15 - Grégory Fromain <gregory@connect-io.fr> - Création
31/07/19 - Grégory Fromain <gregory@connect-io.fr> - Ré-écriture de la méthode
----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_DATE:C307($creerLe_d;$modifierLe_d;$dernierJourValide_d)
	C_TIME:C306($creerA_t;$modifierA_t)
	C_BOOLEAN:C305($verrou_b;$invisible_b)
	ARRAY TEXT:C222($listeSessionWeb_t;0)
	C_OBJECT:C1216($infoFichier_o)
	C_OBJECT:C1216($logErreur_o)
End if 

MESSAGE:C88("nettoyage des sessions web")

If (String:C10(<>sessionWeb.name)#"")
	
	  //Nettoyage des sessions périmée...
	$dernierJourValide_d:=Current date:C33-Num:C11(<>sessionWeb.valideDay)
	
	DOCUMENT LIST:C474(<>sessionWeb.folder;$listeSessionWeb_t;Recursive parsing:K24:13+Absolute path:K24:14)
	
	For ($i;1;Size of array:C274($listeSessionWeb_t))
		  // On verifie une derniere fois que le fichier existe,
		  // Possibilité d'être supprimé par un autre process parallele...
		If (Test path name:C476($listeSessionWeb_t{$i})=Is a document:K24:1)
			GET DOCUMENT PROPERTIES:C477($listeSessionWeb_t{$i};$verrou_b;$invisible_b;$creerLe_d;$creerA_t;$modifierLe_d;$modifierA_t)
			
			If ($creerLe_d<$dernierJourValide_d)
				  //Il faut le supprimer, mais avant l'on regarde si il n'a pas un dossier temporaire associé.
				$infoFichier_o:=Path to object:C1547($listeSessionWeb_t{$i})
				
				  // c'est un dossier qui porte le même nom que le fichier mais sans extension.
				$infoFichier_o.folderTemp:=$infoFichier_o.parentFolder+$infoFichier_o.name+Folder separator:K24:12
				
				If (Test path name:C476($infoFichier_o.folderTemp)=Is a folder:K24:2)
					DELETE FOLDER:C693($infoFichier_o.folderTemp;Delete with contents:K24:24)
				End if 
				
				  // Maintenant on supprime le fichier de session
				DELETE DOCUMENT:C159($listeSessionWeb_t{$i})
			End if 
		End if 
		
	End for 
	
Else 
	$logErreur_o:=New object:C1471
	$logErreur_o.methode:=Current method name:C684
	$logErreur_o.detailErreur:="La gestion des sessions n'est pas actif."
	$logErreur_o.visiteur:=visiteur
	cwLogErreurAjout ("erreur session";$logErreur_o)
	
End if 