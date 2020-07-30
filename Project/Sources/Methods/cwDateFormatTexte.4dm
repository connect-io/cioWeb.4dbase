//%attributes = {"shared":true}
/* ----------------------------------------------------
Méthode : cwDateFormatTexte

Formate une date en fonction d'un modele.

Historique
12/02/15 - Grégory Fromain <gregory@connect-io.fr> - Création
----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_TEXT:C284($1)  // Modele du format (ex : JJMMAA, AA-MM-JJ, AA.JJ.MM,...)
	C_DATE:C307($2)  // Date à formater, si inexistant la date sera la date du jour.
	C_TEXT:C284($0)  // Date formaté
	
	C_TEXT:C284($jj_t;$mm_t;$aa_t;$miseEnForme_t)
	C_DATE:C307($dateAFormater_d)
End if 



ASSERT:C1129(Length:C16($1)#0;"Le contenue du param $1 est vide.")

If (Count parameters:C259=1)
	$dateAFormater_d:=Current date:C33
Else 
	ASSERT:C1129(Type:C295($2)=Is date:K8:7;"Le param $2 n'est pas une date.")
	$dateAFormater_d:=$2
End if 

$miseEnForme_t:=$1
$aa_t:=String:C10(Year of:C25($dateAFormater_d);"0000")
If ($miseEnForme_t="@AAAA@")
	$miseEnForme_t:=Replace string:C233($miseEnForme_t;"AAAA";$aa_t)
Else 
	$aa_t:=Substring:C12($aa_t;3;2)
	$miseEnForme_t:=Replace string:C233($miseEnForme_t;"AA";$aa_t)
End if 

$mm_t:=String:C10(Month of:C24($dateAFormater_d);"00")
$miseEnForme_t:=Replace string:C233($miseEnForme_t;"MM";$mm_t)

$jj_t:=String:C10(Day of:C23($dateAFormater_d);"00")
$miseEnForme_t:=Replace string:C233($miseEnForme_t;"JJ";$jj_t)

$0:=$miseEnForme_t
