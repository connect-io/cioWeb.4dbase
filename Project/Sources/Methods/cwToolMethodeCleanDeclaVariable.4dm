//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Methode projet : cwToolMethodeCleanDeclaVariable

Convertit dans le code 4D la déclaration des variables dans le nouveau format "var"

Historique
07/01/2021 - Titouan Guillon <titouan@connect-io.fr> - Création
-----------------------------------------------------------------------------*/

//Déclarations
var $traduction_c : Collection
var $traduction_o : Object
ARRAY TEXT:C222($tabNoms;0)
ARRAY LONGINT:C221(tab_pos_trouvée;0)
ARRAY LONGINT:C221(tab_long_trouvée;0)
ARRAY TEXT:C222($listeChanges;0)


METHOD GET NAMES:C1166($tabNoms)

$traduction_c:=New collection:C1472
$traduction_c.push(New object:C1471("old";"_O_C_INTEGER\\((.*?)\\)";"new";"integer"))
$traduction_c.push(New object:C1471("old";"_O_C_STRING\\((.*?)\\)";"new";"text"))
$traduction_c.push(New object:C1471("old";"C_REAL\\((.*?)\\)";"new";"real"))
$traduction_c.push(New object:C1471("old";"C_TEXT\\((.*?)\\)";"new";"text"))
$traduction_c.push(New object:C1471("old";"C_TIME\\((.*?)\\)";"new";"time"))
$traduction_c.push(New object:C1471("old";"C_DATE\\((.*?)\\)";"new";"date"))
$traduction_c.push(New object:C1471("old";"C_BLOB\\((.*?)\\)";"new";"blob"))
$traduction_c.push(New object:C1471("old";"C_COLLECTION\\((.*?)\\)";"new";"collection"))
$traduction_c.push(New object:C1471("old";"C_BOOLEAN\\((.*?)\\)";"new";"boolean"))
$traduction_c.push(New object:C1471("old";"C_POINTER\\((.*?)\\)";"new";"pointer"))
$traduction_c.push(New object:C1471("old";"C_LONGINT\\((.*?)\\)";"new";"integer"))
$traduction_c.push(New object:C1471("old";"C_VARIANT\\((.*?)\\)";"new";"variant"))
$traduction_c.push(New object:C1471("old";"C_OBJECT\\((.*?)\\)";"new";"object"))

$compteur_i:=0
For each ($traduction_o;$traduction_c)
	
	$longueur_l:=Position:C15("\\";$traduction_o.old)  //Num($listeChanges{$numero_l}{2})  // Depend de l'expression recherchée
	
	For ($vlElem;1;Size of array:C274($tabNoms))  // On parcourt toutes les méthodes existantes dans le projet
		
		If ($tabNoms{$vlElem}#Current method name:C684)  // On évite de toucher à la méthode en cours d'execution...
			
			METHOD GET CODE:C1190($tabNoms{$vlElem};$source_t)
			$position_l:=1
			$source_t:=Replace string:C233($source_t;"\r";"##r")
			$source_t:=Replace string:C233($source_t;"\n";"##n")
			$obsolete_t:=""
			
			Repeat 
				
				$regexValid_b:=Match regex:C1019($traduction_o.old;$source_t;$position_l;$pos_trouvee_l;$long_trouvée_l)
				
				If ($regexValid_b)
					
					$obsolete_t:=Substring:C12($source_t;$pos_trouvee_l;$long_trouvée_l)
					$modeleRemplacer:="var "+Substring:C12($source_t;$pos_trouvee_l+$longueur_l;$long_trouvée_l-$longueur_l-1)+" : "+$traduction_o.new
					If (Substring:C12($source_t;$pos_trouvee_l+$longueur_l;$long_trouvée_l-$longueur_l-1)#"<>@")
						$source_t:=Replace string:C233($source_t;$obsolete_t;$modeleRemplacer)
						$compteur_i:=$compteur_i+1
					End if 
					$position_l:=$pos_trouvee_l+Length:C16($obsolete_t)
				End if 
				
			Until (Not:C34($regexValid_b))
			
			If ($obsolete_t#"")
				$source_t:=Replace string:C233($source_t;"##r";"\r")
				$source_t:=Replace string:C233($source_t;"##n";"\n")
				METHOD SET CODE:C1194($tabNoms{$vlElem};$source_t)
			End if 
			
		End if 
		
	End for 
	
End for each 

ALERT:C41("Modifications terminées. Nombre de variables modifiées : "+String:C10($compteur_i))



