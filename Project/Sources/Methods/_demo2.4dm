//%attributes = {"shared":true,"lang":"en"}
C_VARIANT:C1683($1)

// Dans cette demo on va tacher de mettre à jour les informations d'une personne concernant les envoie de mail passé.
var $update_b : Boolean
var $marketingAutomation_o; $personne_o; $caPersonneMarketing_o; $retour_o : Object

// Instanciation de la class
$marketingAutomation_o:=cwToolGetClass("MarketingAutomation").new()

// Instanciation de la class
$personne_o:=cwToolGetClass("MAPersonne").new()
$personne_o.loadByPrimaryKey($1)  // Recherche et chargement de l'entité de la personne

// On pensera à mettre à jour les informations marketing.
$personne_o.updateCaMarketingStatistic(1)