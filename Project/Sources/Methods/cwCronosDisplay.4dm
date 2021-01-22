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
C_OBJECT:C1216($1)  // Class MarketingAutomation
C_LONGINT:C283($refFen_el)

$refFen_el:=Open form window:C675("cronos";Form fenêtre standard:K39:10;À gauche:K39:2;En haut:K39:5)
DIALOG:C40("cronos";$1)
CLOSE WINDOW:C154($refFen_el)