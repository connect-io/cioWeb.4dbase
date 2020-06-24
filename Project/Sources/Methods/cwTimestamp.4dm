//%attributes = {"shared":true}
  // ----------------------------------------------------
  // Méthode : cwTimestamp
  // Description
  // Retrouver le timestamp depuis le 01/01/1970 (en fonction de l'heure de votre machine)
  //
  // ----------------------------------------------------

If (False:C215)  // Historique
	  // 08/11/10 - Grégory Fromain <gregory@connect-io.fr> - Création
End if 

If (True:C214)  // Déclarations
	C_DATE:C307($1)  // Date (optionnel)
	C_TIME:C306($2)  // Heure (optionnel)
	C_LONGINT:C283($0)  // Timestamp
	
	C_DATE:C307($date_d)
	C_LONGINT:C283($heure_l)
	C_LONGINT:C283($nb_jour_sec_l)
End if 


If (Count parameters:C259=2)
	ASSERT:C1129($1#!00-00-00!;"Le type de $1 n'est pas une date")
	ASSERT:C1129($2#?00:00:00?;"Le type de $2 n'est pas une heure")
	
	$date_d:=$1
	$heure_l:=$2+0
Else 
	$date_d:=Current date:C33
	$heure_l:=Current time:C178+0
End if 

$nb_jour_sec_l:=Int:C8(($date_d-!1970-01-01!)*86400)
$0:=$nb_jour_sec_l+$heure_l-cwDecallageHoraire 