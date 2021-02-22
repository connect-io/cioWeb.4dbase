//%attributes = {"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwTimestamp

Retrouver le timestamp depuis le 01/01/1970 (en fonction de l'heure de votre machine)

Historique
08/11/10 - Grégory Fromain <gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */

// Déclarations
var $1;$date_d : Date  // Date (optionnel)
var $2 : Time  // Heure (optionnel)
var $0 : Integer  // Timestamp

var $heure_l : Integer
var $nbJourSec_l : Integer


If (Count parameters:C259=2)
	ASSERT:C1129($1#!00-00-00!;"Le type de $1 n'est pas une date")
	ASSERT:C1129($2#?00:00:00?;"Le type de $2 n'est pas une heure")
	
	$date_d:=$1
	$heure_l:=$2+0
Else 
	$date_d:=Current date:C33
	$heure_l:=Current time:C178+0
End if 

$nbJourSec_l:=Int:C8(($date_d-!1970-01-01!)*86400)
$0:=$nbJourSec_l+$heure_l-cwToolJetLag