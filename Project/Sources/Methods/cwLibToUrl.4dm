//%attributes = {"publishedWeb":true,"shared":true,"preemptive":"capable"}
/*------------------------------------------------------------------------------
Méthode : cwLibToUrl

Permet de renvoyer l'url d'une page.

Historique
21/03/15 - Grégory Fromain <gregory@connect-io.fr> - Création
26/10/19 - Grégory Fromain <gregory@connect-io.fr> - Notation objet
30/10/19 - Grégory Fromain <gregory@connect-io.fr> - Ajout possibilité de forcer une variable de l'url depuis le routing.
03/03/20 - Grégory Fromain <gregory@connect-io.fr> - Changement d'approche, par défaut on ne nettoye pas les url.
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
------------------------------------------------------------------------------*/

// Déclarations
var $0 : Text  // url de la page
var $1 : Text  // lib de page
var $2 : Object  // objet de personnalisation de l'URL

var $url_t; $libPage_t; $nomVar_t; $formatInput_t : Text
var routeVar_o; $configPage_o : Object

ASSERT:C1129(siteRoute_c#Null:C1517; "La variable siteRoute_c n'est pas initialisé, impossible de charger l'url de la page "+$libPage_t)
$libPage_t:=Choose:C955($1="/@"; Substring:C12($1; 2); $1)

If (siteRoute_c.query("lib IS :1"; $libPage_t).length#0)
	$configPage_o:=siteRoute_c.query("lib IS :1"; $libPage_t)[0]
	
	// On essai de travailler avec les routes.
	Case of 
		: ($configPage_o.route#Null:C1517)
			$url_t:=$configPage_o.route.variable
			
			// On regarde si la route contient des variables.
			If ($configPage_o.route.format#Null:C1517)
				
				// On initialise les variables de la route.
				routeVar_o:=New object:C1471()
				
				// On récupére les variables du visiteur qui peuvent servir à construire la route.
				For each ($formatInput_t; $configPage_o.route.format)
					
					If (visiteur[$formatInput_t]#Null:C1517)
						OB SET:C1220(routeVar_o; $formatInput_t; visiteur[$formatInput_t])
					End if 
					
				End for each 
				
				If (Count parameters:C259=2)
					routeVar_o:=cwToolObjectMerge(routeVar_o; $2)
				End if 
				
				// On force une variable de l'url depuis le routing.
				If ($configPage_o.route.force#Null:C1517)
					routeVar_o:=cwToolObjectMerge(routeVar_o; $configPage_o.route.force)
				End if 
				
				// Petit controle des data avant utilisation dans l'url. Mais on pourra le forcer en passant la variable urlClean = "1"
				If (String:C10(routeVar_o.urlClean)="1")
					
					For each ($nomVar_t; routeVar_o)
						
						If (routeVar_o[$nomVar_t]#Null:C1517)
							routeVar_o[$nomVar_t]:=cwToolUrlCleanText(String:C10(routeVar_o[$nomVar_t]))
						End if 
						
					End for each 
					
				End if 
				
			End if 
			
			PROCESS 4D TAGS:C816($url_t; $url_t)
		: ($configPage_o.url#Null:C1517)  // Si ce n'est pas possible on passe par un modele d'url.
			$url_t:=$configPage_o.url
		Else 
			$url_t:="La-page-"+$libPage_t+"-ne-contient-pas-d-url"
	End case 
	
Else 
	$url_t:="Il-y-a-aucune-information-sur-la-page-"+$libPage_t
End if 

$0:=String:C10($url_t)