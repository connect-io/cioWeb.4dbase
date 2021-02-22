//%attributes = {"preemptive":"capable"}
// ======================================================================
// Methode projet : cwToolProprieteExisteDansObjet
// 
// Méthode qui permet de vérifier l'existence d'une ou plusieurs propriétés dans un objet
// ----------------------------------------------------------------------

If (False:C215)  // Historique
	// 14/05/20 remy@connect-io.fr - Création
	// 20/05/20 remy@connect-io.fr - Passage du second paramètre en collection
	// 20/05/20 remy@connect-io.fr - Ajout de la possibilité d'extraire toutes les propriétés au lieu de la première occurence
	// 02/06/20 remy@connect-io.fr - Correction bug cas où on souhaite toutes les occurences
End if 

If (True:C214)  // Déclarations
	C_OBJECT:C1216($0)  // Objet qui contient les propriétés avec la mention Vrai ou Faux pour chacun si celui-ci est 
	C_OBJECT:C1216($1)  // Objet qui sert de contrôle
	C_COLLECTION:C1488($2)  // Collection qui contient les propriétés à vérifier
	C_LONGINT:C283($3)  // Entier long qui contient le nombre d'occurence qu'on souhaite extraire [optionnel]
	
	C_TEXT:C284($variable_t)
	C_BOOLEAN:C305($proprieteTrouver_b)
	C_LONGINT:C283($i_el; $compteur_el)
End if 

$0:=New object:C1471()

If (Count parameters:C259=2)
	$nbOccurence_el:=1
Else 
	$nbOccurence_el:=$3
End if 

For each ($variable_t; $2)
	
	For each ($propriete_t; $1) Until ($proprieteTrouver_b=True:C214)
		
		If ($propriete_t=$variable_t)
			$compteur_el:=$compteur_el+1
			
			// Modifié par : Scanu Rémy (20/05/2020) et Modifié par : Scanu Rémy (02/06/2020) 
			Case of 
				: (($nbOccurence_el>1) & ($nbOccurence_el>=$compteur_el)) | ($nbOccurence_el=-1)  // Si je souhaite n occurences où n est supérieur à 1 et n est supérieur au nombre de fois où je suis déjà passé dans la condition OU je souhaite toutes les occurences (-1)
					
					If ($0[$variable_t]=Null:C1517)  // Si c'est la première fois que je passe dans cette condition
						$0[$variable_t]:=New object:C1471("exist"; True:C214; "propriete"; New collection:C1472($propriete_t); "value"; New collection:C1472($1[$propriete_t]))
					Else   // Si ce n'est pas la première fois j'agrémente mes collections
						$0[$variable_t].propriete.push($propriete_t)
						$0[$variable_t].value.push($1[$propriete_t])
					End if 
					
				: ($nbOccurence_el=1)  // Si je ne souhaite qu'une seule occurence
					$0[$variable_t]:=New object:C1471("exist"; True:C214; "propriete"; $propriete_t; "value"; $1[$propriete_t])
			End case 
			
			// Modifié par : Scanu Rémy (20/05/2020)
			If (($nbOccurence_el#-1) & ($nbOccurence_el<$compteur_el)) | ($nbOccurence_el=1)  // Si je ne souhaite qu'une occurence OU le nombre de fois où je suis passé dans la condition est supérieur au nombre d'occurence que je souhaite j'arrête  de boucler
				$proprieteTrouver_b:=True:C214
			End if 
			
		End if 
		
	End for each 
	
	// Modifié par : Scanu Rémy (02/06/2020)
	If ($nbOccurence_el=-1)
		
		If ($0[$variable_t]=Null:C1517)
			$0[$variable_t]:=New object:C1471("exist"; False:C215)
		End if 
		
	Else 
		
		If ($proprieteTrouver_b=False:C215)
			$0[$variable_t]:=New object:C1471("exist"; False:C215)
		End if 
		
	End if 
	
	CLEAR VARIABLE:C89($proprieteTrouver_b)
	CLEAR VARIABLE:C89($compteur_el)
End for each 