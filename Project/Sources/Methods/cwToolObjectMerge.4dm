//%attributes = {"shared":true,"preemptive":"capable"}
/*------------------------------------------------------------------------------
Méthode : cwToolObjectMerge (composant CioWeb)

Fusionne 2 objets

Historique
27/10/15 - Grégory Fromain <gregory@connect-io.fr> - Création
27/10/19 - Grégory Fromain <gregory@connect-io.fr> - Récupération de la méthode depuis le composant cioObjet
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
------------------------------------------------------------------------------*/

// Déclarations
var $1; $oParent : Object  // Parent
var $2; $oFils : Object  // Fils
var $0; $oFusion : Object  // Fusionné

ARRAY TEXT:C222($cles; 0)


$oParent:=$1
$oFils:=$2
$oFusion:=New object:C1471()

//On fusionne toutes les cles de 1er niveau.
OB GET PROPERTY NAMES:C1232($oParent; $cles)
OB GET PROPERTY NAMES:C1232($oFils; $cleFils)
For ($i; 1; Size of array:C274($cleFils))
	If (Find in array:C230($cles; $cleFils{$i})=-1)
		APPEND TO ARRAY:C911($cles; $cleFils{$i})
	End if 
End for 


//On compare les valeurs.
For ($i; 1; Size of array:C274($cles))
	ARRAY OBJECT:C1221($tFils; 0)
	ARRAY OBJECT:C1221($tParents; 0)
	Case of 
		: (Not:C34(OB Is defined:C1231($oFils; $cles{$i})))
			//Ob fil n'existe pas, donc on rajoute celui du parent.
			If (OB Get type:C1230($oParent; $cles{$i})=Object array:K8:28)
				OB GET ARRAY:C1229($oParent; $cles{$i}; $tParents)
				OB SET ARRAY:C1227($oFusion; $cles{$i}; $tParents)
			Else 
				$oFusion[$cles{$i}]:=$oParent[$cles{$i}]
			End if 
			
		: (Not:C34(OB Is defined:C1231($oParent; $cles{$i})))
			//Ob parent n'existe pas, donc on rajoute celui du fils.
			//OB SET($oFusion;$cles{$i};OB Get($oFils;$cles{$i}))
			$oFusion[$cles{$i}]:=$oFils[$cles{$i}]
			
		: (OB Get type:C1230($oFils; $cles{$i})=Is object:K8:27) & (OB Get type:C1230($oParent; $cles{$i})=Is object:K8:27)
			If ($oFils[$cles{$i}]=Null:C1517) & ($oParent[$cles{$i}]=Null:C1517)
				// Si les 2 objets sont vide, on crée un objet vide.
				//OB SET($oFusion;$cles{$i};New object)
				$oFusion[$cles{$i}]:=New object:C1471()
			Else 
				//Du moment qu'ils ont le même type, on prend la valeur du fils
				//OB SET($oFusion;$cles{$i};cwToolObjectMerge(OB Get($oParent;$cles{$i});OB Get($oFils;$cles{$i})))
				$oFusion[$cles{$i}]:=cwToolObjectMerge($oParent[$cles{$i}]; $oFils[$cles{$i}])
			End if 
			
		: (OB Get type:C1230($oFils; $cles{$i})=Object array:K8:28) & (OB Get type:C1230($oParent; $cles{$i})=Object array:K8:28)
			OB GET ARRAY:C1229($oFils; $cles{$i}; $tFils)
			OB GET ARRAY:C1229($oParent; $cles{$i}; $tParents)
			
			For ($t; 1; Size of array:C274($tParents))
				// Pour le moment on rassemble les 2 tableaux
				APPEND TO ARRAY:C911($tFils; $tParents{$t})
			End for 
			
			OB SET ARRAY:C1227($oFusion; $cles{$i}; $tFils)
			
		: (OB Get type:C1230($oFils; $cles{$i})=Is collection:K8:32) & (OB Get type:C1230($oParent; $cles{$i})=Is collection:K8:32)
			
			If ($oFusion=Null:C1517)
				$oFusion:=New object:C1471()
			End if 
			
			
			If ($oParent[$cles{$i}].equal($oFils[$cles{$i}]))
				$oFusion[$cles{$i}]:=$oParent[$cles{$i}]
			Else 
				// Dans le cas ou 2 collections ne sont pas identique, on les concatenes et fait un distints...
				$oFusion[$cles{$i}]:=$oParent[$cles{$i}].concat($oFils[$cles{$i}])
				ARRAY TEXT:C222($element_at; 0)
				// Puis on va comparer les chaines de caractères de chaque objet pour vérifier si l'on doit les conservers ou pas.
/*
For ($j; ($oFusion[$cles{$i}].length)-1; 0; -1)
				
Case of 
: (Value type($oFusion[$cles{$i}][$j])=Is object)
$element_t:=JSON Stringify($oFusion[$cles{$i}][$j])
				
: (Value type($oFusion[$cles{$i}][$j])=Is collection)
$element_t:=JSON Stringify array($oFusion[$cles{$i}][$j])
				
Else 
$element_t:=String($oFusion[$cles{$i}][$j])
				
End case 
				
$elementPos_i:=Find in array($element_at; $element_t)
If ($elementPos_i#-1)
$oFusion[$cles{$i}].remove($j)
Else 
APPEND TO ARRAY($element_at; $element_t)
End if 
				
End for 
*/
				
				$j:=0
				While ($j<$oFusion[$cles{$i}].length)
					
					Case of 
						: (Value type:C1509($oFusion[$cles{$i}][$j])=Is object:K8:27)
							$element_t:=JSON Stringify:C1217($oFusion[$cles{$i}][$j])
							
						: (Value type:C1509($oFusion[$cles{$i}][$j])=Is collection:K8:32)
							$element_t:=JSON Stringify array:C1228($oFusion[$cles{$i}][$j])
							
						Else 
							$element_t:=String:C10($oFusion[$cles{$i}][$j])
							
					End case 
					
					$elementPos_i:=Find in array:C230($element_at; $element_t)
					If ($elementPos_i#-1)
						$oFusion[$cles{$i}].remove($j)
					Else 
						APPEND TO ARRAY:C911($element_at; $element_t)
						$j:=$j+1
					End if 
					
				End while 
				
			End if 
			
		Else 
			// Si objet existe dans les 2 parties, peut importe le type (different de type objet)
			// On prend l'objet fils.
			//OB SET($oFusion;$cles{$i};OB Get($oFils;$cles{$i}))
			$oFusion[$cles{$i}]:=$oFils[$cles{$i}]
	End case 
End for 

$0:=$oFusion


//*** Test de la méthode ***//
/*
var oParent; oFils; oFusion : Object
var $a; $b : Object

oParent:=New object()
oFils:=New object()

$a:=New object("toto"; "tutu"; "momo"; "mumuPere")
$b:=New object("toto1"; "tutu"; "momo"; "mumuFils")

col_c:=New collection()
col_c.push(New object("obCol110"; "coucou110"; "obCol120"; "hell120"))
col_c.push(New object("obCol111"; "coucou110"; "obCol121"; "hello110"))
col_c.push("A")
col_c.push("B")

colFils_c:=New collection()
colFils_c.push(New object("obCol110"; "coucou110"; "obCol120"; "hell120"))
colFils_c.push(New object("obCol112"; "coucou110"; "obCol121"; "hello110"))
colFils_c.push("A")
colFils_c.push("C")

oParent.cle1:="val1"
oParent.cle10:=col_c
oParent.cle2:="val2"
oParent.cle3:="val3"
oParent.cle4:="val4"
oParent.cle5:=$a
oParent.cle6:=1

oFils.cle1:="val1bis"
oFils.cle10:=colFils_c
oFils.cle2:="val2"
oFils.cle3:="val3bis"
oFils.cle5:=$b
oFils.cle6:=1

oFusion:=cwToolObjectMerge(oParent; oFils)

*/

/*
 Résultat attendu sur oFusion
{
  cle1:val1bis,
  cle10:[
    {obCol110:coucou110,obCol120:hell120},
    {obCol111:coucou110,obCol121:hello110},
    A,
    B,
    {obCol112:coucou110,obCol121:hello110},
    C],
  cle2:val2,
  cle3:val3bis,
  cle4:val4,
  cle5:{
    toto:tutu,
    momo:mumuFils,
    toto1:tutu},
  cle6:1
}
*/