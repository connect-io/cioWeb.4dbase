//%attributes = {"shared":true}
/*------------------------------------------------------------------------------
Methode projet : cwToolMethodCleanVariableDecla(ration)

Convertis dans le code 4D la déclaration des variables dans le nouveau format "var"
C_text($0) -> var $0 : Text

Historique
07/01/2021 titouan@connect-io.fr - Création
22/11/2021 gregory@connect-io.fr - Clean code & fix bug sur les alpha
------------------------------------------------------------------------------*/

//Déclarations
var $traduction_c : Collection
var $compteur_i : Integer
var $traduction_o : Object
var $longueur_i : Integer
var $vlElem_i : Integer
var $source_t : Text
var $position_i : Integer
var $obsolete_t : Text
var $regexValid_b : Boolean
var $modeleRemplacer_t : Text
ARRAY TEXT:C222($tabNom_at; 0)
ARRAY LONGINT:C221(tab_pos_trouvée; 0)
ARRAY LONGINT:C221(tab_long_trouvée; 0)


METHOD GET NAMES:C1166($tabNom_at)

$traduction_c:=New collection:C1472
$traduction_c.push(New object:C1471("old"; "_O_C_INTEGER\\((.*?)\\)"; "new"; "integer"))
$traduction_c.push(New object:C1471("old"; "_O_C_STRING\\((.*?)\\)"; "new"; "text"))
$traduction_c.push(New object:C1471("old"; "C_REAL\\((.*?)\\)"; "new"; "real"))
$traduction_c.push(New object:C1471("old"; "C_TEXT\\((.*?)\\)"; "new"; "text"))
$traduction_c.push(New object:C1471("old"; "C_TIME\\((.*?)\\)"; "new"; "time"))
$traduction_c.push(New object:C1471("old"; "C_DATE\\((.*?)\\)"; "new"; "date"))
$traduction_c.push(New object:C1471("old"; "C_BLOB\\((.*?)\\)"; "new"; "blob"))
$traduction_c.push(New object:C1471("old"; "C_COLLECTION\\((.*?)\\)"; "new"; "collection"))
$traduction_c.push(New object:C1471("old"; "C_BOOLEAN\\((.*?)\\)"; "new"; "boolean"))
$traduction_c.push(New object:C1471("old"; "C_POINTER\\((.*?)\\)"; "new"; "pointer"))
$traduction_c.push(New object:C1471("old"; "C_LONGINT\\((.*?)\\)"; "new"; "integer"))
$traduction_c.push(New object:C1471("old"; "C_VARIANT\\((.*?)\\)"; "new"; "variant"))
$traduction_c.push(New object:C1471("old"; "C_OBJECT\\((.*?)\\)"; "new"; "object"))

$compteur_i:=0
For each ($traduction_o; $traduction_c)
	
	$longueur_i:=Position:C15("\\"; $traduction_o.old)  // Depend de l'expression recherchée
	
	For ($vlElem_i; 1; Size of array:C274($tabNom_at))  // On parcourt toutes les méthodes existantes dans le projet
		
		If ($tabNom_at{$vlElem_i}#Current method name:C684)  // On évite de toucher à la méthode en cours d'execution...
			
			METHOD GET CODE:C1190($tabNom_at{$vlElem_i}; $source_t)
			$position_i:=1
			$source_t:=Replace string:C233($source_t; "\r"; "##r")
			$source_t:=Replace string:C233($source_t; "\n"; "##n")
			$obsolete_t:=""
			
			Repeat 
				
				$regexValid_b:=Match regex:C1019($traduction_o.old; $source_t; $position_i; $pos_trouvee_l; $long_trouvée_l)
				
				If ($regexValid_b)
					
					$obsolete_t:=Substring:C12($source_t; $pos_trouvee_l; $long_trouvée_l)
					$modeleRemplacer_t:="var "+Substring:C12($source_t; $pos_trouvee_l+$longueur_i; $long_trouvée_l-$longueur_i-1)+" : "+$traduction_o.new
					
					If ($traduction_o.old="_O_C_STRING@")
						// Dans le cas des anciennes déclarations d'alpha, il fallait indiquer le nombre de caractère :
						// _O_C_STRING(10; test1; text2), ce n'est plus utilise aujourd'hui. Il faut donc supprimer cet élément.
						//var 10; test1; text2 : text
						$modeleRemplacer_t:="var "+Substring:C12($modeleRemplacer_t; Position:C15(";"; $modeleRemplacer_t)+1)
						// var test1; text2 : text
					End if 
					
					If (Substring:C12($source_t; $pos_trouvee_l+$longueur_i; $long_trouvée_l-$longueur_i-1)#"<>@")
						$source_t:=Replace string:C233($source_t; $obsolete_t; $modeleRemplacer_t)
						$compteur_i:=$compteur_i+1
					End if 
					$position_i:=$pos_trouvee_l+Length:C16($obsolete_t)
				End if 
				
			Until (Not:C34($regexValid_b))
			
			If ($obsolete_t#"")
				$source_t:=Replace string:C233($source_t; "##r"; "\r")
				$source_t:=Replace string:C233($source_t; "##n"; "\n")
				METHOD SET CODE:C1194($tabNom_at{$vlElem_i}; $source_t)
			End if 
			
		End if 
	End for 
End for each 

ALERT:C41("Modifications terminées. Nombre de variables modifiées : "+String:C10($compteur_i))