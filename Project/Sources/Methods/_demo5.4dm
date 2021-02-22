//%attributes = {"shared":true,"preemptive":"capable"}
// Dans cette demo on va générer si besoin les enregistrements dans la table [CaMarketing]
var $1 : Collection

var $marketingAutomation_o; $class_o : Object

// Instanciation de la class
$marketingAutomation_o:=cwToolGetClass("MarketingAutomation").new()

$class_o:=cwToolGetClass("MAPersonneSelection").new()
$class_o.fromListPersonCollection($1)

$class_o.updateCaMarketingStatistic()