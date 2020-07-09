//%attributes = {"shared":true}
/* ----------------------------------------------------
Méthode : ogWebMinifierJs

Minifie les fichiers .js, gain de 20 à 30% sur le poids d'origine.

Historique
16/04/12 - Grégory Fromain <gregory@connect-io.fr> - Création
21/12/19 - Grégory Fromain <gregory@connect-io.fr> - Ajout de la possibilité de créer une arborescence dans les fichiers JS.
----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_TEXT:C284($texteIn;$dirIn;$dirOut)
	C_BOOLEAN:C305($compression)
	C_TEXT:C284($subDomain_t)  // Nom du sous domaine
End if 


For each ($subDomain_t;<>webApp_o.config.subDomain_c)
	  //Le dossier avec le js non minifié.
	$dirIn:=<>webApp_o.config.source.folder_f($subDomain_t)
	
	  //Le dossier avec les javascripts minimifié.
	$dirOut:=<>webApp_o.config.webFolder.folder_f($subDomain_t)+"js"+Folder separator:K24:12
	
	  //On recupere la liste des documents dans le répertoire.
	DOCUMENT LIST:C474($dirIn;$fichierHtmlIn;Recursive parsing:K24:13)
	
	For ($i;1;Size of array:C274($fichierHtmlIn))
		If ($fichierHtmlIn{$i}="@.js")
			$compression:=True:C214
			
		Else 
			$compression:=False:C215
		End if 
		
		If ($compression)
			  // Dans le cas d'un fichier dans un sous dossier, il faut supprimer le séparateur.
			If ($fichierHtmlIn{$i}=(Folder separator:K24:12+"@"))
				$fichierHtmlIn{$i}:=Substring:C12($fichierHtmlIn{$i};2)
				  // Si besoin on crée le dossier dans le repertoire de destination.
				CREATE FOLDER:C475($dirOut+$fichierHtmlIn{$i};*)
			End if 
			
			  //Sauf si le dossier compressé existe deja et qu'il est plus jeune que le fichier d'origine.
			If (Test path name:C476($dirOut+$fichierHtmlIn{$i})=Is a document:K24:1)
				GET DOCUMENT PROPERTIES:C477($dirIn+$fichierHtmlIn{$i};$verrouilleIn;$invisibleIn;$creeLeIn;$creeAIn;$modifieLeIn;$modifieAIn)
				GET DOCUMENT PROPERTIES:C477($dirOut+$fichierHtmlIn{$i};$verrouilleOut;$invisibleOut;$creeLeOut;$creeAOut;$modifieLeOut;$modifieAOut)
				
				Case of 
					: ($modifieLeIn<$modifieLeOut)
						$compression:=False:C215
					: ($modifieLeIn=$modifieLeOut) & ($modifieAIn<$modifieAOut)
						$compression:=False:C215
				End case 
				
				If ($compression)
					  //Il faut donc faire la minification et l'ancien fichier existe.
					  //On le suppprime donc.
					DELETE DOCUMENT:C159($dirOut+$fichierHtmlIn{$i})
				End if 
			End if 
		End if 
		
		If ($compression)
			
			$texteIn:=Document to text:C1236($dirIn+$fichierHtmlIn{$i};"UTF-8")
			TEXT TO DOCUMENT:C1237($dirOut+$fichierHtmlIn{$i};cwMinifier ($texteIn);"UTF-8")  //Et on creer le nouvau fichier.
		End if 
	End for 
	
End for each 


