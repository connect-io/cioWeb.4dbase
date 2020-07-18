/* 
Class : page

Cette class permet de génerer le contenue d'une page.

*/


Class constructor
/* ----------------------------------------------------
Fonction : page.constructor
	
Initialisation de la page web.
ATTENTION : L'instance de la class "page" doit se faire obligatoirement par la fonction : webApp.pageCurrent()
	
Historique
13/03/18 - Grégory Fromain <gregory@connect-io.fr> - Création
08/12/19 - Grégory Fromain <gregory@connect-io.fr> - Les fichiers de routing sont triés par ordre croissant
16/07/20 - Grégory Fromain <gregory@connect-io.fr> - Conversion en fonction
-----------------------------------------------------*/
	
	C_COLLECTION:C1488($1)  // Information sur les routes du site provenants directement de la class webApp.
	C_OBJECT:C1216($2)  // Les informations sur le visiteur.
	
	C_OBJECT:C1216($page_o)
	C_TEXT:C284($propriete_t)
	C_OBJECT:C1216(pageWeb_o;$routeData;$logErreur_o)
	C_TEXT:C284($libPageConnexion_t)
	C_BOOLEAN:C305($B_estMethodeValide)
	ARRAY LONGINT:C221($AT_positionTrouvee;0)
	ARRAY LONGINT:C221($AT_longueurTrouvee;0)
	ARRAY TEXT:C222($AT_routeFormatCle;0)
	
	This:C1470.siteRoute_c:=$1
	
	This:C1470.user:=$2
	
	$libPageConnexion_t:="userIdentification"
	
	$logErreur_o:=New object:C1471
	
	$B_estMethodeValide:=True:C214
	
	pageWeb_o:=Null:C1517
	
	  // Cas particulier pour la home du site.
	If ($B_estMethodeValide)
		If ("/"=visiteur.url)
			pageWeb_o:=This:C1470.siteRoute_c.query("lib IS index")[0]
			
		End if 
	End if 
	
	If ($B_estMethodeValide) & (pageWeb_o=Null:C1517)
		
		For each ($page_o;This:C1470.siteRoute_c.query("lib IS NOT index")) Until (pageWeb_o#Null:C1517)
			
			If (Match regex:C1019($page_o.route.regex;visiteur.url;1;$AT_positionTrouvee;$AT_longueurTrouvee))
				pageWeb_o:=$page_o
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
					If (visiteur.loginExpire_ts<=cwTimestamp )
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
				OB SET:C1220($routeData;$AT_routeFormatCle{$t};Substring:C12(visiteur.url;$AT_positionTrouvee{$t};$AT_longueurTrouvee{$t}))
			End for 
		End if 
		
		If (String:C10($routeData.langue)="")
			$routeData.langue:="fr"
		End if 
		
		pageWeb_o.route.data:=$routeData
		
	Else 
		  //Renvoie page 404
		If (visiteur.url#"@.php")
			$logErreur_o.detailErreur:="Impossible de charger la configuration de la page : "+visiteur.url
		End if 
		
		If (This:C1470.siteRoute_c.query("lib IS 404").length#0)
			pageWeb_o:=This:C1470.siteRoute_c.query("lib IS 404")[0]
			
			  // Gestion de la langue de la page 404
			pageWeb_o.lib:="404"
			ARRAY TEXT:C222($champs;1)
			ARRAY TEXT:C222($valeurs;1)
			$champs{1}:="X-STATUS"
			$valeurs{1}:="404 Not Found"
			WEB SET HTTP HEADER:C660($champs;$valeurs)
		Else 
			$logErreur_o.detailErreur:="Impossible de charger la configuration de la page 404."
			cwRedirection301 ("/")
		End if 
	End if 
	
	  //gestion des keywords
	If (String:C10(pageWeb_o.keywords)="")
		pageWeb_o.keywords:=""
	End if 
	
	  //gestion des descriptions
	If (String:C10(pageWeb_o.description)="")
		pageWeb_o.description:=""
	End if 
	
	
	  //pageWeb_o.i18n:=cwi18nDataPage 
	
	If (OB Is defined:C1231($logErreur_o;"detailErreur"))
		$logErreur_o.methode:=Current method name:C684
		$logErreur_o.visiteur:=visiteur
		cwLogErreurAjout ("Configuration serveur";$logErreur_o)
	End if 
	
	
	For each ($propriete_t;pageWeb_o)
		This:C1470[$propriete_t]:=pageWeb_o[$propriete_t]
	End for each 
	
	
	  // A défaut de faire mieux pour le moment... (Comptatibilité avec du vieux code)
	C_OBJECT:C1216(pageWeb)
	pageWeb:=pageWeb_o