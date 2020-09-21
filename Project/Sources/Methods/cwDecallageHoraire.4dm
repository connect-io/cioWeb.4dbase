//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : ogDecallageHoraire

Renvoie le decallage horaire depuis lheure local de la machine.

Historique

----------------------------------------------------------------------------- */


If (True:C214)  // Déclarations
	C_LONGINT:C283($0)
	
	C_DATE:C307($day_d)
	C_LONGINT:C283($out_l)
	C_LONGINT:C283($ts_l)
	C_LONGINT:C283($tsUTC_l)
	C_TIME:C306($hour_h)
	C_TEXT:C284($ts_t)
	C_TEXT:C284($tsUTC_t)
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