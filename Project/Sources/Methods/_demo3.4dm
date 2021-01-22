//%attributes = {"shared":true}
// Dans cette demo on va créer un cron qui va interroger mailjet de façon automatique et mettre à jour les fiches des personnes
C_OBJECT:C1216($marketingAutomation_cs;$marketingAutomation_o;$entity_o;$caPersonneMarketing_o;$retour_o)

$marketingAutomation_cs:=cwToolGetClass("MarketingAutomation")  // Initialisation de la class

$marketingAutomation_o:=$marketingAutomation_cs.new()  // Instanciation de la class
$marketingAutomation_o.loadPasserelle("Personne")  // Création de la passerelle entre la class $marketingAutomation_o et la base hôte

$marketingAutomation_o.loadCronos()