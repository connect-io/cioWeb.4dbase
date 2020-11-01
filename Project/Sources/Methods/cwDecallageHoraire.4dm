//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : ogDecallageHoraire

Renvoie le decallage horaire depuis lheure local de la machine.

Historique
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */


If (True:C214)  // Déclarations
	var $0 : Integer
	
	var $day_d : Date
	var $out_l : Integer
	var $ts_l : Integer
	var $tsUTC_l : Integer
	var $hour_h : Time
	var $ts_t : Text
	var $tsUTC_t : Text
End if 

$day_d:=Current date:C33
$hour_h:=Current time:C178

$tsUTC_t:=String:C10($day_d;ISO date GMT:K1:10;$hour_h)  //<<< encodage UTC
$tsUTC_t:=Substring:C12($tsUTC_t;1;19)  //remove trailing"Z"

$ts_t:=String:C10($day_d;ISO date:K1:8;$hour_h)  //<<< encodage heure locale

XML DECODE:C1091($tsUTC_t;$day_d)
XML DECODE:C1091($tsUTC_t;$hour_h)
$tsUTC_l:=(($day_d-!2000-01-01!)*86400)+$hour_h  //86400 sec= 24h

XML DECODE:C1091($ts_t;$day_d)
XML DECODE:C1091($ts_t;$hour_h)
$ts_l:=(($day_d-!2000-01-01!)*86400)+$hour_h

$out_l:=$ts_l-$tsUTC_l

$0:=$out_l