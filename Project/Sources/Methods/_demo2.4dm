//%attributes = {"shared":true}
// Dans cette demo on va tacher de mettre à jour les informations d'une personne concernant les envoie de mail passé.
C_OBJECT:C1216($marketingAutomation_cs;$marketingAutomation_o;$entity_o;$caPersonneMarketing_o;$retour_o)

$marketingAutomation_cs:=cwToolGetClass("MarketingAutomation")  // Initialisation de la class

$marketingAutomation_o:=$marketingAutomation_cs.new()  // Instanciation de la class
$marketingAutomation_o.loadPasserelle("Personne")  // Création de la passerelle entre la class $marketingAutomation_o et la base hôte

$entity_o:=$marketingAutomation_o.loadPeopleByUID("2237F6C0D8AC4A78AC7AB423C57AF5F8")  // Recherche et chargement de l'entité de la personne

// On va récupérer les informations utiles sur mailjet pour mettre à jour la stratégie de relance.
$entity_o.getInfo()

// On pensera à mettre à jour les informations marketing.
$entity_o.updateCaMarketingStatisticManual()