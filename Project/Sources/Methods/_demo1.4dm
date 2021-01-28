//%attributes = {"shared":true,"lang":"en"}
C_VARIANT:C1683($1)

// Dans cette demo on veut envoyer un email simple à une personne.
var $marketingAutomation_o : Object
var $statut_o; $eMail_o; $personne_o : Object

// Instanciation de la class
$marketingAutomation_o:=cwToolGetClass("MarketingAutomation").new()

$personne_o:=cwToolGetClass("MAPersonne").new()
$personne_o.loadByPrimaryKey($1)  // Recherche et chargement de l'entité de la personne

$personne_o.sendMailing()