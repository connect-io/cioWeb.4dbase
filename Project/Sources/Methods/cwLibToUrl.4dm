//%attributes = {"publishedWeb":true,"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwLibToUrl

Permet de renvoyer l'url d'une page.

Historique
21/03/15 - Grégory Fromain <gregory@connect-io.fr> - Création
26/10/19 - Grégory Fromain <gregory@connect-io.fr> - notation objet
30/10/19 - Grégory Fromain <gregory@connect-io.fr> - ajout possibilité de forcer une variable de l'url depuis le routing.
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */

// Déclarations
var $1 : Text  // lib de page
var $2 : Object  // objet de personnalisation de l'URL
var $0 : Text  // url de la page

var $url_t : Text
var $libPage_t : Text
var $nomVar_t : Text
var $formatInput_t : Text
var routeVar : Object
var $configPage_o : Object


$libPage_t:=Choose:C955($1="/@";Substring:C12($1;2);$1)

ASSERT:C1129(siteRoute_c#Null:C1517;"La variable siteRoute_c n'est pas initialisé, impossible de charger l'url de la page "+$libPage_t)


If (siteRoute_c.query("lib IS :1";$libPage_t).length#0)
	$configPage_o:=siteRoute_c.query("lib IS :1";$libPage_t)[0]
	//On essai de travailler avec les routes.
	Case of 
		: ($configPage_o.route#Null:C1517)
			$url_t:=$configPage_o.route.variable
			
			
			
			// On regarde si la route contient des variables.
			If ($configPage_o.route.format#Null:C1517)
				// On initialise les variables de la route.
				routeVar:=New object:C1471()
				
				// On récupére les variables du visiteur qui peuvent servir à construire la route.
				For each ($formatInput_t;$configPage_o.route.format)
					If (visiteur[$formatInput_t]#Null:C1517)
						OB SET:C1220(routeVar;$formatInput_t;visiteur[$formatInput_t])
					End if 
				End for each 
				
				
				If (Count parameters:C259=2)
					routeVar:=cwToolObjectMerge(routeVar;$2)
				End if 
				
				// On force une variable de l'url depuis le routing.
				If ($configPage_o.route.force#Null:C1517)
					routeVar:=cwToolObjectMerge(routeVar;$configPage_o.route.force)
				End if 
				
				// Petit controle des data avant utilisation dans l'url.
				//If (routeVar.noclean=Null)
				//03/03/20 : Changement d'approche, par défaut on ne nettoye pas les url.
				// Mais on pourra le forcer en passant la variable urlClean = "1"
				If (String:C10(routeVar.urlClean)="1")
					For each ($nomVar_t;routeVar)
						If (routeVar[$nomVar_t]#Null:C1517)
							routeVar[$nomVar_t]:=cwToolUrlCleanText(String:C10(routeVar[$nomVar_t]))
						End if 
					End for each 
				End if 
			End if 
			
			PROCESS 4D TAGS:C816($url_t;$url_t)
			
		: ($configPage_o.url#Null:C1517)  // Si ce n'est pas possible on passe par un modele d'url.
			$url_t:=$configPage_o.url
		Else 
			$url_t:="La-page-"+$libPage_t+"-ne-contient-pas-d-url"
	End case 
	
Else 
	$url_t:="Il-y-a-aucune-information-sur-la-page-"+$libPage_t
End if 

$0:=String:C10($url_t)
