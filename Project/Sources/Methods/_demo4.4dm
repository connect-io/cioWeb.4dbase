//%attributes = {"shared":true,"lang":"en"}
// Dans cette démo on va montrer comment on gère les scénarios et scènes
var $marketingAutomation_o; $scenario_o : Object

// Instanciation de la class
$marketingAutomation_o:=cwToolGetClass("MarketingAutomation").new()
$marketingAutomation_o.loadPasserelle("Personne")  // Création de la passerelle entre la class $marketingAutomation_o et la base hôte

// Instanciation de la class
$scenario_o:=cwToolGetClass("MAScenario").new()
$scenario_o.loadScenarioDisplay()
/*
$scenario_o:=$marketingAutomation_o.scenario()

$scenario_o.create($config)

// Il faut définir ce qu'il faut mettre dans la config au depart et comment la structurer...
$scenario_o.sceneAdd($config)

$scenario_o.select($name)

// Leur envoyer un mailing de masse ?
$scenario_o.segnementation().applyPeople()

$scenario_o.play($name)
// On peut imaginer que s'il y a un param name, il va jouer un scénario, sinon il va jouer tout les scénarios.

// Stocker l'information ?
*/