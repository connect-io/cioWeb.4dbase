//%attributes = {"shared":true,"lang":"en"}
// Dans cette demo on va créer un cron qui va interroger mailjet de façon automatique et mettre à jour les fiches des personnes
var $marketingAutomation_o : Object

// Instanciation de la class
$marketingAutomation_o:=cwToolGetClass("MarketingAutomation").new()
$marketingAutomation_o.loadPasserelle("Personne")  // Création de la passerelle entre la class $marketingAutomation_o et la base hôte

$marketingAutomation_o.loadCronos()