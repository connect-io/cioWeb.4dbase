//%attributes = {"shared":true}
  // ----------------------------------------------------
  // Méthode : ogWebMinifierHtml
  // Description
  // Minifie les fichiers HTML. Gain de 20 à 30% sur le poids des pages HTML.
  //
  // Paramètres
  // $1 = [texte] action (Utile seulement pour la methode.)
  // ----------------------------------------------------

If (False:C215)  // Historique
	  // 16/04/12 - Grégory Fromain <gregory@connect-io.fr> - Création
	  // 21/12/19 - Grégory Fromain <gregory@connect-io.fr> - Ajout de la possibilité de créer une arborescence dans les fichiers des pages html.
End if 

C_TEXT:C284($texteIn;$texteOut;$dirIn;$dirOut)
C_BOOLEAN:C305($compression)

ARRAY TEXT:C222($sites;0)
FOLDER LIST:C473(<>webApp_o.config.webAppOld.folder_f();$sites)

For ($j;1;Size of array:C274($sites))
	  //Le dossier avec le html non minifié.
	$dirIn:=<>webApp_o.config.viewDev.folder_f($sites{$j})
	
	  //Le dossier avec le html minifié.
	$dirOut:=<>webApp_o.config.viewCache.folder_f($sites{$j})
	
	
	  //On recupere la liste des documents dans le répertoire.
	DOCUMENT LIST:C474($dirIn;$fichierHtmlIn;Recursive parsing:K24:13)
	
	For ($i;1;Size of array:C274($fichierHtmlIn))
		  // Par defaut on compresse le fichier
		$compression:=True:C214
		
		  // Dans le cas d'un fichier dans un sous dossier, il faut supprimer le séparateur.
		If ($fichierHtmlIn{$i}=(Folder separator:K24:12+"@"))
			$fichierHtmlIn{$i}:=Substring:C12($fichierHtmlIn{$i};2)
			  //Si besoin on creer le dossier dans le repertoire de destination...
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
		
		If ($compression)
			
			$texteIn:=Document to text:C1236($dirIn+$fichierHtmlIn{$i};"UTF-8")
			ASSERT:C1129(Length:C16($texteIn)#0;"Impossible de charger le fichier : "+$dirIn+$fichierHtmlIn{$i})
			$texteOut:=Replace string:C233(cwMinifier ($texteIn);"\n";"")
			
			  // On retire les commentaires HTML mais pas les balises 4D.
			  //$texteOut:=cwToolTextReplaceByRegex ($texteOut;"<!-- (.*?)-->";"")
			
			  // On vérifie les espace insécable.
			$texteOut:=Replace string:C233($texteOut;" ;";Char:C90(160)+";")
			$texteOut:=Replace string:C233($texteOut;" ?";Char:C90(160)+"?")
			$texteOut:=Replace string:C233($texteOut;" !";Char:C90(160)+"!")
			$texteOut:=Replace string:C233($texteOut;" :";Char:C90(160)+":")
			$texteOut:=Replace string:C233($texteOut;" %";Char:C90(160)+"%")
			$texteOut:=Replace string:C233($texteOut;" €";Char:C90(160)+"€")
			
			TEXT TO DOCUMENT:C1237($dirOut+$fichierHtmlIn{$i};$texteOut;"UTF-8")  //Et on creer le nouvau fichier.
		End if 
	End for 
End for 