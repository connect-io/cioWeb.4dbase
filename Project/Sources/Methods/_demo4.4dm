//%attributes = {"shared":true,"lang":"en"}
// Dans cette démo on va montrer comment on gère les scénarios et scènes

// Comment faire une selection de personne ?
var $marketingAutomation_cs; $marketingAutomation_o; $scenario_cs; $scenario_o : Object

$marketingAutomation_cs:=cwToolGetClass("MarketingAutomation")  // Initialisation de la class

$marketingAutomation_o:=$marketingAutomation_cs.new()  // Instanciation de la class
$marketingAutomation_o.loadPasserelle("Personne")  // Création de la passerelle entre la class $marketingAutomation_o et la base hôte

$scenario_cs:=cwToolGetClass("MAScenario")  // Initialisation de la class

$scenario_o:=$scenario_cs.new($marketingAutomation_o)  // Instanciation de la class

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