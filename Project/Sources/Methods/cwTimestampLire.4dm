//%attributes = {"publishedWeb":true,"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwTimestampLire

Renvoie la date ou l'heure du timestamp en $1

Historique
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */

// Déclarations
var $1 : Text  // $1 = [texte] info de sortie ("date" ou "heure")
var $2 : Integer  // $2 = [entier long] le timestamp
var $0 : Text  // $0 = [texte]

var $tsAvecDecallage : Integer


ASSERT:C1129(Count parameters:C259=2;"Il manque un paramêtre à cette méthode.")
ASSERT:C1129(Type:C295($2)=Est un entier long:K8:6;"Le param $1 doit être de type 'entier'.")
ASSERT:C1129(($1="date") | ($1="heure");"La valeur de $1 est incorrect.")

$tsAvecDecallage:=$2+cwToolJetLag
If ($1="date")
	$0:=String:C10(Int:C8($tsAvecDecallage/86400)+!1970-01-01!;Interne date court:K1:7)
Else 
	$0:=String:C10(Time:C179(Mod:C98($tsAvecDecallage;86400));h mn s:K7:1)
End if 
