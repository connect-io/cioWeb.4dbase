//%attributes = {"shared":true}
  // ----------------------------------------------------
  // Méthode : cwPageGetInfo
  // 
  // Charge les éléments d'une page
  // ----------------------------------------------------

If (False:C215)  // Historique
	  // 13/03/18 - Grégory Fromain <gregory@connect-io.fr> - Création
	  // 08/12/19 - Grégory Fromain <gregory@connect-io.fr> - Les fichiers de routing sont triés par ordre croissant
End if 

If (True:C214)  // Déclarations
	C_OBJECT:C1216($1)
	C_OBJECT:C1216($0)
	
	C_LONGINT:C283($i)
	C_OBJECT:C1216(urlSite;configSite;pageWeb;$routeData;$O_logErreur)
	C_TEXT:C284($page;$libPageConnexion_t)
	C_BOOLEAN:C305($B_estMethodeValide)
	ARRAY TEXT:C222($regexPage;0)
	ARRAY LONGINT:C221($AT_positionTrouvee;0)
	ARRAY LONGINT:C221($AT_longueurTrouvee;0)
	ARRAY TEXT:C222($AT_routeFormatCle;0)
End if 


$libPageConnexion_t:="userIdentification"

$O_logErreur:=New object:C1471

$B_estMethodeValide:=True:C214
$page:=""

urlSite:=OB Copy:C1225(OB Get:C1224(<>cwUrlToLibSites;visiteur.sousDomaine))
If (urlSite=Null:C1517)
	$O_logErreur.detailErreur:="Impossible de charger les urls du sous domaine."
	$B_estMethodeValide:=False:C215
End if 

If ($B_estMethodeValide)
	configSite:=OB Get:C1224(<>webApp_o.sites;visiteur.sousDomaine)
	If (configSite=Null:C1517)
		$O_logErreur.detailErreur:="Impossible de charger la configuration du sous domaine."
		$B_estMethodeValide:=False:C215
	End if 
End if 

  // Cas particulier pour la home du site.
If ($B_estMethodeValide)
	If ("/"=visiteur.url)
		$page:=OB Get:C1224(urlSite;visiteur.url)
		If ($page="")
			$O_logErreur.detailErreur:="Impossible de charger le nom de la page /."
			$B_estMethodeValide:=False:C215
		End if 
		
	Else 
		  // On supprime la route home.
		OB REMOVE:C1226(urlSite;"/")
	End if 
End if 

If ($B_estMethodeValide)
	If ($page="")
		OB GET PROPERTY NAMES:C1232(urlSite;$regexPage)
		For ($i;1;Size of array:C274($regexPage))
			If (Match regex:C1019($regexPage{$i};visiteur.url;1;$AT_positionTrouvee;$AT_longueurTrouvee))
				$page:=OB Get:C1224(urlSite;$regexPage{$i})
				If ($page="")
					$O_logErreur.detailErreur:="Impossible de charger le nom de la page : "+visiteur.url
					$B_estMethodeValide:=False:C215
				End if 
				$i:=Size of array:C274($regexPage)
			End if 
		End for 
	End if 
End if 

If ($page#"")
	
	pageWeb:=OB Copy:C1225(OB Get:C1224(configSite;$page))
	If (Not:C34(OB Is defined:C1231(pageWeb)))
		$O_logErreur.detailErreur:="Impossible de charger la configuration de la page : "+$page
		$B_estMethodeValide:=False:C215
	End if 
	
	
	  // On verifie si la page à besoin d'être identifier.
	If (OB Is defined:C1231(pageWeb;"login"))
		  // On regarde si l'utilisateur est loggué.
		If (OB Is defined:C1231(visiteur;"loginDomaine"))
			If (visiteur.domaine#visiteur.loginDomaine)
				$page:=$libPageConnexion_t
				pageWeb:=OB Copy:C1225(OB Get:C1224(configSite;$page))
			End if 
		Else 
			$page:=$libPageConnexion_t
			pageWeb:=OB Copy:C1225(OB Get:C1224(configSite;$page))
		End if 
		
		  // On vérifie que la durée de la session ne soit pas expiré.
		  // Pour le moment on fixe une durée de session au jour même, après minuit on reset la connexion.
		If ($page#$libPageConnexion_t)
			  // Donc l'utilisateur est bien connecté.
			If (visiteur.loginExpire_ts#Null:C1517)
				If (visiteur.loginExpire_ts<=cwTimestamp )
					  // Delais session dépassé.
					visiteur.loginDomaine:=""
					$page:=$libPageConnexion_t
					pageWeb:=OB Copy:C1225(OB Get:C1224(configSite;$page))
					
				End if 
				
			Else 
				$page:=$libPageConnexion_t
				pageWeb:=OB Copy:C1225(OB Get:C1224(configSite;$page))
			End if 
		End if 
	End if 
	
	pageWeb.lib:=$page
	
	$routeData:=New object:C1471
	  // Récupération des variables de l'URL
	$L_nbDeVariableDansUrl:=Size of array:C274($AT_positionTrouvee)
	
	  // Si il y a des param dans l'url & que la page est differente de la page de connexion.
	If ($L_nbDeVariableDansUrl#0) & (pageWeb.lib#$libPageConnexion_t)
		OB GET PROPERTY NAMES:C1232(pageWeb.route.format;$AT_routeFormatCle)
		
		For ($t;1;Size of array:C274($AT_positionTrouvee))
			OB SET:C1220($routeData;$AT_routeFormatCle{$t};Substring:C12(visiteur.url;$AT_positionTrouvee{$t};$AT_longueurTrouvee{$t}))
		End for 
	End if 
	
	If (String:C10($routeData.langue)="")
		$routeData.langue:="fr"
	End if 
	
	  //coFixerObjet ($routeData;->pageWeb;"route";"data")
	pageWeb.route.data:=$routeData
	
Else 
	  //Renvoit page 404
	If (visiteur.url#"@.php")
		$O_logErreur.detailErreur:="Impossible de charger la configuration de la page : "+visiteur.url
	End if 
	
	If (OB Is defined:C1231(configSite;"404"))
		pageWeb:=OB Copy:C1225(OB Get:C1224(configSite;"404"))
		
		  // Gestion de la langue de la page 404
		pageWeb.lib:="404"
		  //$routeData:=New object
		  //If (OB Is defined(visiteur;"langue"))
		  //$routeData.langue:=visiteur.langue
		  //Else 
		  //$routeData.langue:="fr"
		  //End if 
		  //coFixerObjet ($routeData;->pageWeb;"route";"data")
		
		ARRAY TEXT:C222($champs;1)
		ARRAY TEXT:C222($valeurs;1)
		$champs{1}:="X-STATUS"
		$valeurs{1}:="404 Not Found"
		WEB SET HTTP HEADER:C660($champs;$valeurs)
	Else 
		$O_logErreur.detailErreur:="Impossible de charger la configuration de la page 404."
		cwRedirection301 ("/")
	End if 
End if 

  //gestion des keywords
If (String:C10(pageWeb.keywords)="")
	pageWeb.keywords:=""
End if 


  //gestion des descriptions
If (String:C10(pageWeb.description)="")
	pageWeb.description:=""
End if 


  //pageWeb.i18n:=cwi18nDataPage 

If (OB Is defined:C1231($O_logErreur;"detailErreur"))
	$O_logErreur.methode:=Current method name:C684
	$O_logErreur.visiteur:=visiteur
	cwLogErreurAjout ("Configuration serveur";$O_logErreur)
End if 


$0:=pageWeb