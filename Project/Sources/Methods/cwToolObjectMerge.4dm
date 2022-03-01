//%attributes = {"shared":true,"preemptive":"capable"}
//%attributes = {"shared":true,"preemptive":"capable"}
/*------------------------------------------------------------------------------
Méthode : cwToolObjectMerge (composant CioWeb)
Fusionne 2 objets
Historique
27/10/15 - Grégory Fromain <gregory@connect-io.fr> - Création
27/10/19 - Grégory Fromain <gregory@connect-io.fr> - Récupération de la méthode depuis le composant cioObjet
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
20/08/21 - Grégory Fromain <gregory@connect-io.fr> - Ajout de la gestion du merge des collections par ID et modernisation du code.
------------------------------------------------------------------------------*/

// Déclarations
var $1; $oParent : Object  // Parent
var $2; $oFils : Object  // Fils
var $0; $oFusion : Object  // Fusionné
var $key_c : Collection

$oParent:=$1
$oFils:=$2
$oFusion:=New object:C1471()


// On fusionne toutes les cles de 1er niveau.
// On n'utilise pas combine et distint car cela renvoit une collection trié.
// $key_c:=$key_c.combine(OB Keys($oFils)).distinct(ck diacritical)

$key_c:=OB Keys:C1719($oParent)
For each ($key_t; OB Keys:C1719($oFils))
	If ($key_c.countValues($key_t)=0)
		$key_c.push($key_t)
	End if 
End for each 


//On compare les valeurs.
For each ($key_t; $key_c)
	
	ARRAY OBJECT:C1221($tFils; 0)
	ARRAY OBJECT:C1221($tParents; 0)
	Case of 
		: (Not:C34(OB Is defined:C1231($oFils; $key_t)))
			//Ob fil n'existe pas, donc on rajoute celui du parent.
			If (OB Get type:C1230($oParent; $key_t)=Object array:K8:28)
				OB GET ARRAY:C1229($oParent; $key_t; $tParents)
				OB SET ARRAY:C1227($oFusion; $key_t; $tParents)
			Else 
				$oFusion[$key_t]:=$oParent[$key_t]
			End if 
			
		: (Not:C34(OB Is defined:C1231($oParent; $key_t)))
			//Ob parent n'existe pas, donc on rajoute celui du fils.
			$oFusion[$key_t]:=$oFils[$key_t]
			
		: (OB Get type:C1230($oFils; $key_t)=Is object:K8:27) & (OB Get type:C1230($oParent; $key_t)=Is object:K8:27)
			If ($oFils[$key_t]=Null:C1517) & ($oParent[$key_t]=Null:C1517)
				// Si les 2 objets sont vide, on crée un objet vide.
				$oFusion[$key_t]:=New object:C1471()
			Else 
				//Du moment qu'ils ont le même type, on prend la valeur du fils
				$oFusion[$key_t]:=cwToolObjectMerge($oParent[$key_t]; $oFils[$key_t])
			End if 
			
		: (OB Get type:C1230($oFils; $key_t)=Object array:K8:28) & (OB Get type:C1230($oParent; $key_t)=Object array:K8:28)
			OB GET ARRAY:C1229($oFils; $key_t; $tFils)
			OB GET ARRAY:C1229($oParent; $key_t; $tParents)
			
			For ($t; 1; Size of array:C274($tParents))
				// Pour le moment on rassemble les 2 tableaux
				APPEND TO ARRAY:C911($tFils; $tParents{$t})
			End for 
			
			OB SET ARRAY:C1227($oFusion; $key_t; $tFils)
			
		: (OB Get type:C1230($oFils; $key_t)=Is collection:K8:32) & (OB Get type:C1230($oParent; $key_t)=Is collection:K8:32)
			
			If ($oFusion=Null:C1517)
				$oFusion:=New object:C1471()
			End if 
			
			If ($oParent[$key_t].equal($oFils[$key_t]))
				$oFusion[$key_t]:=$oParent[$key_t]
			End if 
			
			
			If ($oFusion[$key_t]=Null:C1517)
				// On recherche si c'est une collection avec des identifiants
				
				Case of 
					: ($oFils[$key_t].length=0)
						$KeyIdName_t:=""
					: (Value type:C1509($oFils[$key_t][0])#Is object:K8:27)
						$KeyIdName_t:=""
					: (String:C10($oFils[$key_t][0].ID)#"")
						$KeyIdName_t:="ID"
					: (String:C10($oFils[$key_t][0].PK)#"")
						$KeyIdName_t:="PK"
					: (String:C10($oFils[$key_t][0].UUID)#"")
						$KeyIdName_t:="UUID"
					: (String:C10($oFils[$key_t][0].PKU)#"")
						$KeyIdName_t:="PKU"
					Else 
						$KeyIdName_t:=""
				End case 
				
				If ($KeyIdName_t#"")
					// On commence par dupliquer le parent dans la fusion.
					$oFusion[$key_t]:=$oParent[$key_t]
					
					For each ($objectCollectionSon_o; $oFils[$key_t])
						// On récupére la valeur de ID du fils.
						$IdValue:=$objectCollectionSon_o[$KeyIdName_t]
						
						// On va boucle dans tout les objects du père pour essayer de le retrouver avec le même ID.
						
						$indicesParent_c:=$oParent[$key_t].indices(":1 = :2"; $KeyIdName_t; $IdValue)
						
						If ($indicesParent_c.length=1)
							$oFusion[$key_t][$indicesParent_c[0]]:=cwToolObjectMerge($oParent[$key_t][$indicesParent_c[0]]; $objectCollectionSon_o)
						Else 
							$oFusion[$key_t].push($objectCollectionSon_o)
						End if 
						
					End for each 
				End if 
			End if 
			
			
			If ($oFusion[$key_t]=Null:C1517)
				// Dans le cas ou 2 collections ne sont pas identique, on les concatenes...
				$oFusion[$key_t]:=$oParent[$key_t].concat($oFils[$key_t])
				ARRAY TEXT:C222($element_at; 0)
				// Puis on va comparer les chaines de caractères de chaque objet pour vérifier si l'on doit les conservers ou pas.
				
				$j:=0
				While ($j<$oFusion[$key_t].length)
					
					Case of 
						: (Value type:C1509($oFusion[$key_t][$j])=Is object:K8:27)
							$element_t:=JSON Stringify:C1217($oFusion[$key_t][$j])
							
						: (Value type:C1509($oFusion[$key_t][$j])=Is collection:K8:32)
							$element_t:=JSON Stringify array:C1228($oFusion[$key_t][$j])
							
						Else 
							$element_t:=String:C10($oFusion[$key_t][$j])
							
					End case 
					
					$elementPos_i:=Find in array:C230($element_at; $element_t)
					If ($elementPos_i#-1)
						$oFusion[$key_t].remove($j)
					Else 
						APPEND TO ARRAY:C911($element_at; $element_t)
						$j:=$j+1
					End if 
					
				End while 
				
			End if 
			
		Else 
			// Si objet existe dans les 2 parties, peut importe le type (different de type objet)
			// On prend l'objet fils.
			$oFusion[$key_t]:=$oFils[$key_t]
	End case 
End for each 

$0:=$oFusion