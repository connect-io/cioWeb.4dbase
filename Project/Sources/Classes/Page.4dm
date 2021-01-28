/* 
Class : cs.Page

Cette class permet de génerer le contenue d'une page.

*/


Class constructor
/* -----------------------------------------------------------------------------
Fonction : Page.constructor
	
Historique
13/03/18 - Grégory Fromain <gregory@connect-io.fr> - Création
08/12/19 - Grégory Fromain <gregory@connect-io.fr> - Les fichiers de routing sont triés par ordre croissant
16/07/20 - Grégory Fromain <gregory@connect-io.fr> - Conversion en fonction
20/09/20 - Grégory Fromain <gregory@connect-io.fr> - Renomer pageweb_o.langue en pageweb_o.lang
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */
	
	var $1 : Object  // Les informations sur le visiteur.
	
	var $page_o : Object
	var $propriete_t : Text
	var pageWeb_o : Object
	var $routeData : Object
	var $logErreur_o : Object
	var $libPageConnexion_t : Text
	ARRAY LONGINT:C221($AT_positionTrouvee;0)
	ARRAY LONGINT:C221($AT_longueurTrouvee;0)
	ARRAY TEXT:C222($AT_routeFormatCle;0)
	
	This:C1470.user:=$1
	
	// Information sur les routes du site provenants directement de storage.
	This:C1470.siteRoute_c:=Storage:C1525.sites[This:C1470.user.sousDomaine].route.copy()
	
	// En attendant de faire mieux, je passe la variable en process
	siteRoute_c:=Storage:C1525.sites[This:C1470.user.sousDomaine].route.copy()
	
	// Petit hack pour les datatables en attendant des jours meilleurs.
	siteDataTable_c:=Storage:C1525.sites[This:C1470.user.sousDomaine].dataTable
	
	This:C1470.info:=New object:C1471("webfolderSubdomainPath_t";Get 4D folder:C485(HTML Root folder:K5:20;*)+This:C1470.user.sousDomaine+Folder separator:K24:12)
	
	
	$libPageConnexion_t:="userIdentification"
	
	$logErreur_o:=New object:C1471
	
	pageWeb_o:=Null:C1517
	
	
	// Cas particulier pour la home du site.
	If ("/"=visiteur.url)
		pageWeb_o:=This:C1470.siteRoute_c.query("lib IS index")[0]
	End if 
	
	If (pageWeb_o=Null:C1517)
		
		For each ($page_o;This:C1470.siteRoute_c.query("lib IS NOT index")) Until (pageWeb_o#Null:C1517)
			
			If (Match regex:C1019($page_o.route.regex;visiteur.url;1;$AT_positionTrouvee;$AT_longueurTrouvee))
				pageWeb_o:=$page_o
				pageWeb_o.info:=New object:C1471("webfolderSubdomainPath_t";Get 4D folder:C485(HTML Root folder:K5:20;*)+This:C1470.user.sousDomaine+Folder separator:K24:12)
			End if 
			
		End for each 
	End if 
	
	
	If (pageWeb_o#Null:C1517)
		
		// On verifie si la page à besoin d'être identifier.
		If (OB Is defined:C1231(pageWeb_o;"login"))
			// On regarde si l'utilisateur est loggué.
			If (OB Is defined:C1231(visiteur;"loginDomaine"))
				If (visiteur.domaine#visiteur.loginDomaine)
					pageWeb_o:=This:C1470.siteRoute_c.query("lib IS :1";$libPageConnexion_t)[0]
				End if 
			Else 
				pageWeb_o:=This:C1470.siteRoute_c.query("lib IS :1";$libPageConnexion_t)[0]
			End if 
			
			// On vérifie que la durée de la session ne soit pas expiré.
			// Pour le moment on fixe une durée de session au jour même, après minuit on reset la connexion.
			If (String:C10(pageWeb_o.lib)#$libPageConnexion_t)
				// Donc l'utilisateur est bien connecté.
				If (visiteur.loginExpire_ts#Null:C1517)
					If (visiteur.loginExpire_ts<=cwTimestamp)
						// Delais session dépassé.
						visiteur.loginDomaine:=""
						pageWeb_o:=This:C1470.siteRoute_c.query("lib IS :1";$libPageConnexion_t)[0]
						
					End if 
					
				Else 
					pageWeb_o:=This:C1470.siteRoute_c.query("lib IS :1";$libPageConnexion_t)[0]
				End if 
			End if 
		End if 
		
		$routeData:=New object:C1471
		// Récupération des variables de l'URL
		$L_nbDeVariableDansUrl:=Size of array:C274($AT_positionTrouvee)
		
		// Si il y a des param dans l'url & que la page est differente de la page de connexion.
		If ($L_nbDeVariableDansUrl#0) & (pageWeb_o.lib#$libPageConnexion_t)
			OB GET PROPERTY NAMES:C1232(pageWeb_o.route.format;$AT_routeFormatCle)
			
			For ($t;1;Size of array:C274($AT_positionTrouvee))
				//OB SET($routeData;$AT_routeFormatCle{$t};Substring(visiteur.url;$AT_positionTrouvee{$t};$AT_longueurTrouvee{$t}))
				$routeData[$AT_routeFormatCle{$t}]:=Substring:C12(visiteur.url;$AT_positionTrouvee{$t};$AT_longueurTrouvee{$t})
			End for 
		End if 
		
		If (String:C10($routeData.lang)="")
			$routeData.lang:="fr"
		End if 
		
		pageWeb_o.route.data:=$routeData
		
	Else 
		// Renvoie page 404
		
		If (This:C1470.siteRoute_c.query("lib IS '404'").length#0)
			pageWeb_o:=This:C1470.siteRoute_c.query("lib IS '404'")[0]
			pageWeb_o.route:=New object:C1471()
			pageWeb_o.route.data:=New object:C1471()
			
			// Gestion de la langue de la page 404
			pageWeb_o.lib:="404"
			If (This:C1470.user.lang#Null:C1517)
				If (This:C1470.user.lang#"")
					pageWeb_o.route.data.lang:=This:C1470.user.lang
				End if 
			End if 
			ARRAY TEXT:C222($champs;1)
			ARRAY TEXT:C222($valeurs;1)
			$champs{1}:="X-STATUS"
			$valeurs{1}:="404 Not Found"
			WEB SET HTTP HEADER:C660($champs;$valeurs)
		Else 
			$logErreur_o.detailErreur:="Impossible de charger la configuration de la page 404."
			pageWeb_o.redirection301("/")
		End if 
	End if 
	
	// Gestion des keywords
	If (String:C10(pageWeb_o.keywords)="")
		pageWeb_o.keywords:=""
	End if 
	
	// Gestion des descriptions
	If (String:C10(pageWeb_o.description)="")
		pageWeb_o.description:=""
	End if 
	
	// Gestion des fichiers JS à inclure dans le HTML.
	If (pageWeb_o.jsPathInHtml=Null:C1517)
		pageWeb_o.jsPathInHtml:=New collection:C1472
	End if 
	
	// Chargement des informations i18n.
	pageWeb_o.i18n:=This:C1470.siteRoute_c.query("lib IS :1";pageWeb_o.lib)[0].i18n
	
	
	If (OB Is defined:C1231($logErreur_o;"detailErreur"))
		$logErreur_o.methode:=Current method name:C684
		$logErreur_o.visiteur:=visiteur
		cwLogErreurAjout("Configuration serveur";$logErreur_o)
		
		If (Bool:C1537(visiteur.devMode))
			ALERT:C41($logErreur_o.methode+" : "+$logErreur_o.detailErreur)
		End if 
	End if 
	
	
	For each ($propriete_t;pageWeb_o)
		This:C1470[$propriete_t]:=pageWeb_o[$propriete_t]
	End for each 
	
	
	
Function cssGetHtmlPath
/*-----------------------------------------------------------------------------
Fonction : Page.cssGetHtmlPath
	
Renvoi le HTML pour le chargement des fichiers CSS.
	
Historique
19/06/19 - Grégory Fromain <gregory@connect-io.fr> - Création
10/02/20 - Grégory Fromain <gregory@connect-io.fr> - Mise en place de la boucle for each.
09/09/20 - Grégory Fromain <gregory@connect-io.fr> - Conversion en fonction
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
-----------------------------------------------------------------------------*/
	
	var $1 : Text  // Domaine du CDN
	var $0 : Text  // Contenu des fichiers html
	
	var $cssContenu_t;$cssHtmlModele_t;$cssPath_t : Text
	
	
	$cssHtmlModele_t:="<link rel=\"stylesheet\" href=\"$cssPath\">"
	$cssContenu_t:=""
	
	// On ajoute en dernier le custom.css
	This:C1470.cssPath.push("/<!--4DTEXT visiteur_o.sousDomaine-->/css/custom.css")
	
	
	If (This:C1470.cssPath#Null:C1517)
		
		For each ($cssPath_t;This:C1470.cssPath)
			
			$cssContenu_t:=$cssContenu_t+Replace string:C233($cssHtmlModele_t;"$cssPath";$cssPath_t)+Char:C90(Line feed:K15:40)
		End for each 
		
	End if 
	
	If (Count parameters:C259=1)
		$cssContenu_t:=Replace string:C233($cssContenu_t;"domaineCDN";$1)
	End if 
	
	$0:=$cssContenu_t
	
	
	
Function i18nGet
/* -----------------------------------------------------------------------------
Fonction : Page.I18nGet
	
Historique
15/08/20 - Grégory Fromain<gregory@connect-io.fr> - Mise en veille de l'internalisation
26/11/20 - Alban Catoire <alban@connect-io.fr> - Actualisation avec utilisation de storage
-----------------------------------------------------------------------------*/
	
	var $1 : Text  // nom de l'attribut de l'objet que l'on souhaite utiliser.
	var $0 : Text  // le text en retour
	
	ASSERT:C1129($1#"";"Le param $1 doit être une chaine de caractère non vide.")
	If (This:C1470.route.data.lang=Null:C1517)
		This:C1470.route.data.lang:="fr"
	End if 
	$0:=String:C10(This:C1470.i18n[This:C1470.route.data.lang][$1])
	// Exemple : Storage.sites.www.I18n.page.fr.index.title
	If ($0="")
		$0:="Traduction inconnu : "+$1
	End if 
	
	
	
Function jsGetHtmlPath
/*-----------------------------------------------------------------------------
Fonction : Page.jsGetHtmlPath
	
Renvoi le HTML pour le chargement des fichiers JS déclaré dans le fichier page.json
	
Historique
27/07/20 - Grégory Fromain<gregory@connect-io.fr> - Changement du nom de la propriete jsFile en jsPath
11/20/20 - Grégory Fromain<gregory@connect-io.fr> - Conversion en fonction
31/10/20 - Grégory Fromain<gregory@connect-io.fr> - Déclaration des variables via var
-----------------------------------------------------------------------------*/
	
	var $1 : Text  // $1 : [texte] domaine du CDN
	var $0 : Text  // Contenu des chemin JS à insérer dans le HTML.
	
	var $T_jsContenu : Text
	var $jsHtmlModele_t : Text
	var $jsPath_t : Text
	
	$jsHtmlModele_t:="<script type=\"text/javascript\" src=\"$jsPath\"></script>"
	
	If (This:C1470.jsPath#Null:C1517)
		
		For each ($jsPath_t;This:C1470.jsPath)
			$T_jsContenu:=$T_jsContenu+Replace string:C233($jsHtmlModele_t;"$jsPath";$jsPath_t)+Char:C90(Line feed:K15:40)
		End for each 
	End if 
	
	If (Count parameters:C259=1)
		$T_jsContenu:=Replace string:C233($T_jsContenu;"domaineCDN";$1)
	End if 
	
	$0:=Char:C90(Line feed:K15:40)+$T_jsContenu
	
	
	
Function jsInHtml
/*-----------------------------------------------------------------------------
Fonction : Page.jsInHtml
	
Place le contenue du fichier javascript dans le HTML
	
Historique
20/09/20 - Grégory Fromain<gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain<gregory@connect-io.fr> - Déclaration des variables via var
-----------------------------------------------------------------------------*/
	
	var $0 : Text  // Contenu des fichiers JS à insérer dans le HTML
	
	var $jsInHtml_t : Text
	
	If (pageWeb_o.jsPathInHtml=Null:C1517)
		pageWeb_o.jsPathInHtml:=New collection:C1472()
	End if 
	
	// Intégration du JS dans la page HTML.
	For each ($jsPath_t;pageWeb_o.jsPathInHtml)
		
		// On gére la possibilité de créer une arborescence dans les dossiers des pages HTML
		$jsPath_t:=Replace string:C233($jsPath_t;":";Folder separator:K24:12)  // Séparateur mac
		$jsPath_t:=Replace string:C233($jsPath_t;"/";Folder separator:K24:12)  // Séparateur unix
		$jsPath_t:=Replace string:C233($jsPath_t;"\\";Folder separator:K24:12)  // Séparateur windows
		
		
		If (Test path name:C476(This:C1470.info.webfolderSubdomainPath_t+"js"+Folder separator:K24:12+$jsPath_t)=Is a document:K24:1)
			$jsInHtml_t:=$jsInHtml_t+Document to text:C1236(This:C1470.info.webfolderSubdomainPath_t+"js"+Folder separator:K24:12+$jsPath_t)+Char:C90(Line feed:K15:40)
		Else 
			ALERT:C41("page.jsInHtml() : Le fichier suivant n'existe pas : "+This:C1470.info.webfolderSubdomainPath_t+"js"+Folder separator:K24:12+$jsPath_t)
		End if 
		
	End for each 
	
	$0:=$jsInHtml_t
	
	
	
Function scanBlock
/*-----------------------------------------------------------------------------
Fonction : Page.scanBlock
	
Niveau suppreme du template 4D :o) : -p Permet la gestion des blocs dans le HTML.
	
Historique
27/07/20 - Grégory Fromain<gregory@connect-io.fr> - Conversion en fonction
31/10/20 - Grégory Fromain<gregory@connect-io.fr> - Déclaration des variables via var
-----------------------------------------------------------------------------*/
	
	var $1 : Text
	var $0 : Text  // Retourne les élements du fichiers qui ne sont pas dans un block
	
	var $contenuFichierCorpsHtml_t : Text
	var $nomVar_t : Text
	var $valVar_t : Text
	ARRAY LONGINT:C221($posTrouvee_al;0)
	ARRAY LONGINT:C221($longTrouvee_al;0)
	
	$contenuFichierCorpsHtml_t:=$1
	
	// On regarde si il y a des blocks de template.
	
	If ($contenuFichierCorpsHtml_t="@<!--#cwBlock@")
		// On remplace les sauts de lignes par un espace. (Créer des erreurs sur le regex)
		$contenuFichierCorpsHtml_t:=Replace string:C233($contenuFichierCorpsHtml_t;"\r";"##r")
		$contenuFichierCorpsHtml_t:=Replace string:C233($contenuFichierCorpsHtml_t;"\n";"##n")
		
		// On purge les premiers caractéres.
		$Pos:=Position:C15("<!--#cwBlock";$contenuFichierCorpsHtml_t)
		If ($Pos#1)
			$contenuFichierCorpsHtml_t:=Substring:C12($contenuFichierCorpsHtml_t;$Pos)
		End if 
		
		// On récupére le 1er block
		$blockLength_l:=Position:C15("<!--#cwBlockFin-->";$contenuFichierCorpsHtml_t)+Length:C16("<!--#cwBlockFin-->")-1
		$block_t:=Substring:C12($contenuFichierCorpsHtml_t;1;$blockLength_l)
		
		While ((Match regex:C1019("<!--#cwBlock ([a-zA-Z0-9_-]*)-->(.*)<!--#cwBlockFin-->(.*)?";$block_t;1;$posTrouvee_al;$longTrouvee_al)))
			
			$nomVar_t:=Substring:C12($contenuFichierCorpsHtml_t;$posTrouvee_al{1};$longTrouvee_al{1})
			$valVar_t:=Substring:C12($contenuFichierCorpsHtml_t;$posTrouvee_al{2};$longTrouvee_al{2})
			
			This:C1470[$nomVar_t]:=$valVar_t
			This:C1470[$nomVar_t]:=Replace string:C233(This:C1470[$nomVar_t];"##r";"\r")
			This:C1470[$nomVar_t]:=Replace string:C233(This:C1470[$nomVar_t];"##n";"\n")
			
			$group3:=Substring:C12($contenuFichierCorpsHtml_t;$posTrouvee_al{3};$longTrouvee_al{3})
			
			$contenuFichierCorpsHtml_t:=Replace string:C233($contenuFichierCorpsHtml_t;$block_t;"";1)
			$blockLength_l:=Position:C15("<!--#cwBlockFin-->";$contenuFichierCorpsHtml_t)+Length:C16("<!--#cwBlockFin-->")-1
			$block_t:=Substring:C12($contenuFichierCorpsHtml_t;1;$blockLength_l)
			
		End while 
	End if 
	
	$0:=$contenuFichierCorpsHtml_t
	
	
	
Function redirection301
/*-----------------------------------------------------------------------------
Méthode : ogWebRedirection301
	
Etabli une redirection 301 http(de type permanante)
	
Historique
31/10/20 - Grégory Fromain<gregory@connect-io.fr> - Déclaration des variables via var
-----------------------------------------------------------------------------*/
	
	// Déclarations
	var $1 : Text  // $1 = [texte] nouvelle url
	
	ARRAY TEXT:C222($champs;2)
	ARRAY TEXT:C222($valeurs;2)
	
	$champs{1}:="X-STATUS"
	$valeurs{1}:="301 Moved Permanently, false, 301"
	$champs{2}:="Location"
	$valeurs{2}:=$1
	
	WEB SET HTTP HEADER:C660($champs;$valeurs)
	WEB SEND TEXT:C677("redirection")
	
	This:C1470.route:=New object:C1471()
	This:C1470.route.data:=New object:C1471()
	
	This:C1470.methode:=New collection:C1472()
	This:C1470.viewPath:=New collection:C1472()
	