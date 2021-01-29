//%attributes = {"shared":true,"lang":"en"}
// Dans cette demo on veut envoyer un emailing
var $1 : Collection

var $marketingAutomation_o; $class_o : Object

// Instanciation de la class
$marketingAutomation_o:=cwToolGetClass("MarketingAutomation").new()

$class_o:=cwToolGetClass("MAPersonneSelection").new()
$class_o.fromListPersonCollection($1)

$class_o.sendMailing()