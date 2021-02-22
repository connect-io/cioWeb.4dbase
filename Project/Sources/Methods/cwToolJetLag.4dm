//%attributes = {"shared":true,"preemptive":"capable"}
// Méthode : cgDecallageHoraire
// Description
// Renvoi le decallage horaire depuis lheure local de la machine.
// origine du code : http://forums.4d.fr/Post/FR/14701949/1/14928049#14928049
//
// Paramètres
// $0=[entier] nombre de seconde
// ----------------------------------------------------

//TS_TimeZoneOffset-> long
//retourne le décalage du fuseau horaire courant
//par rapport à UTC en secondes
//valeur à ajouter à l'heure locales dans les conversions
var $0 : Integer

var $day_d : Date
var $out_l : Integer
var $ts_l : Integer
var $tsUTC_l : Integer
var $hour_h : Time
var $ts_t : Text
var $tsUTC_t : Text

$day_d:=Current date:C33
$hour_h:=Current time:C178

$tsUTC_t:=String:C10($day_d; ISO date GMT:K1:10; $hour_h)  //<<< encodage UTC
$tsUTC_t:=Substring:C12($tsUTC_t; 1; 19)  //remove trailing"Z"

$ts_t:=String:C10($day_d; ISO date:K1:8; $hour_h)  //<<< encodage heure locale

XML DECODE:C1091($tsUTC_t; $day_d)
XML DECODE:C1091($tsUTC_t; $hour_h)
$tsUTC_l:=(($day_d-!2000-01-01!)*86400)+$hour_h  //86400 sec= 24h

XML DECODE:C1091($ts_t; $day_d)
XML DECODE:C1091($ts_t; $hour_h)
$ts_l:=(($day_d-!2000-01-01!)*86400)+$hour_h

$out_l:=$ts_l-$tsUTC_l

$0:=$out_l