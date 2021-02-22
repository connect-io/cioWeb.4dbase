//%attributes = {"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwMarketingAutomationStart

Permet de faire l'éxécution de la partie marketingAutomation du composant cioWeb

Historique
16/02/21 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/

// Déclarations
var $0 : Object

var $initComponent_b : Boolean

If (Application type:C494=4D Server:K5:6) | (Application type:C494=4D mode local:K5:1)
	$initComponent_b:=True:C214
End if 

// Instanciation de la class
$0:=cwToolGetClass("MarketingAutomation").new($initComponent_b)

If (Application type:C494=4D Server:K5:6) | (Application type:C494=4D mode local:K5:1)
	$0.loadPasserelle("Personne")  // Création de la passerelle entre la class $marketingAutomation_o et la base hôte
	$0.loadCronos()
End if 