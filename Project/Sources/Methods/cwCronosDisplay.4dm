//%attributes = {}
// ----------------------------------------------------
// Nom utilisateur (OS) : Scanu Rémy
// Date et heure : 08/07/20, 18:08:16
// ----------------------------------------------------
// Méthode : cwCronosDisplay
// Description
// Permet d'afficher l'interface de Cronos
//
// Paramètres
// ----------------------------------------------------
var $1 : Object  // Class MarketingAutomation
var $refFen_el : Integer

$refFen_el:=Open form window:C675("cronos"; Plain form window:K39:10; On the left:K39:2; At the top:K39:5)
DIALOG:C40("cronos"; $1)
CLOSE WINDOW:C154($refFen_el)