//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Methode projet : cwToolMethodeAjouterEntete



Historique
07/01/2021 - Titouan Guillon <titouan@connect-io.fr> - Création
08/01/2021 - Titouan Guillon <titouan@connect-io.fr> - Finitions
-----------------------------------------------------------------------------*/

//Déclaration
var $code_t;$find_t;$entete_t;$newCode_t : Text
ARRAY TEXT:C222($tabNoms;0)
METHOD GET NAMES:C1166($tabNoms)
$find_t:="/* -----------------------------------------------"


$compteur_i:=0
For ($vlElem;1;Size of array:C274($tabNoms))
	
	If ($tabNoms{$vlElem}#Current method name:C684)
		METHOD GET CODE:C1190($tabNoms{$vlElem};$code_t)
		$col:=Split string:C1554($code_t;"comment added and reserved by 4D.\r")
		$code_t:=$col[1]
		
		
		If ((Position:C15($find_t;$code_t)=0) | (Position:C15($find_t;$code_t)>10))  // Dans ce cas il n'y a pas d'entete et il faut en rajouter une
			$entete_t:="/* -----------------------------------------------------------------------------\rMethode projet : "\
				+String:C10($tabNoms{$vlElem})+"\r\rDescription\r\rHistorique\r"\
				+\
				String:C10(Current date:C33)+" titouan@connect-io.fr - Création entête\r----------------------------------------------------------------------------- */\r\r//Déclarations\r\r"
			
			$newCode_t:=$col[0]+"comment added and reserved by 4D.\r"+$entete_t+$col[1]
			METHOD SET CODE:C1194($tabNoms{$vlElem};$newCode_t)
			$compteur_i:=$compteur_i+1
		End if 
		
	End if 
	
End for 
ALERT:C41("Modifications terminées. Nombre de variables modifiées : "+String:C10($compteur_i))

