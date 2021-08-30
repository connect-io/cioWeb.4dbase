//%attributes = {}
/*------------------------------------------------------------------------------
Méthode : cwToolObjectMergeTest (composant CioWeb)

Teste de la méthode cwToolObjectMerge.
L'objet $control_o est la réponse attendu du merge du fils dans le parent.
Si aucun trace ne remonte c'est qu'il n'y a pas de souci.

Historique
20/08/21 - Grégory Fromain <gregory@connect-io.fr> - Création
------------------------------------------------------------------------------*/

// Déclaration
var $0 : Text

var $parent_o : Object
var $son_o : Object
var $fusion_o : Object
var $control_o : Object


$parent_o:=New object:C1471()
$son_o:=New object:C1471()
$control_o:=New object:C1471()

// Test 1
$parent_o.cle01:="val1"
$son_o.cle01:="val1bis"
$control_o.cle01:="val1bis"

// Test 2
$parent_o.cle02:="val2"
$son_o.cle02:="val2"
$control_o.cle02:="val2"

// Test 3
// $parent_o.cle03 : Inexistant
$son_o.cle03:="val3bis"
$control_o.cle03:="val3bis"

// Test 4
$parent_o.cle04:="val4"
// $son_o.cle04 : Inexistant
$control_o.cle04:="val4"

// Test 5
$parent_o.cle05:=New object:C1471("toto"; "tutu"; "momo"; "mumuPere")
$son_o.cle05:=New object:C1471("toto1"; "tutu"; "momo"; "mumuFils")
$control_o.cle05:=New object:C1471("toto"; "tutu"; "momo"; "mumuFils"; "toto1"; "tutu")

// Test 6
$parent_o.cle06:=1
$son_o.cle06:=2
$control_o.cle06:=2

// Test 7
$parent_o.cle07:=Null:C1517
$son_o.cle07:="val7"
$control_o.cle07:="val7"

// Test 8
$parent_o.cle08:="val8"
$son_o.cle08:=Null:C1517
$control_o.cle08:=Null:C1517

// Test 9
$parent_o.cle09:="coucou"
$son_o.cle09:=!1985-03-23!
$control_o.cle09:=!1985-03-23!

// Test 10 : merge collection mixte
$parent_o.cle10:=New collection:C1472()
$parent_o.cle10.push(New object:C1471("obCol110"; "coucou110"; "obCol120"; "hell120"))
$parent_o.cle10.push(New object:C1471("obCol111"; "coucou110"; "obCol121"; "hello110"))
$parent_o.cle10.push("A")
$parent_o.cle10.push("B")
$parent_o.cle10.push(!1985-03-23!)

$son_o.cle10:=New collection:C1472()
$son_o.cle10.push(New object:C1471("obCol110"; "coucou110"; "obCol120"; "hell120"))
$son_o.cle10.push(New object:C1471("obCol112"; "coucou110"; "obCol121"; "hello110"))
$son_o.cle10.push("A")
$son_o.cle10.push("C")
$son_o.cle10.push(42)

$control_o.cle10:=New collection:C1472()
$control_o.cle10.push(New object:C1471("obCol110"; "coucou110"; "obCol120"; "hell120"))
$control_o.cle10.push(New object:C1471("obCol111"; "coucou110"; "obCol121"; "hello110"))
$control_o.cle10.push("A")
$control_o.cle10.push("B")
$control_o.cle10.push(!1985-03-23!)
$control_o.cle10.push(New object:C1471("obCol112"; "coucou110"; "obCol121"; "hello110"))
$control_o.cle10.push("C")
$control_o.cle10.push(42)

// Test 11 : merge collection avec ID (ID, PK, UUID, PKU)
$parent_o.cle11:=New collection:C1472()
$parent_o.cle11.push(New object:C1471("ID"; 1; "prenom"; "charle"; "nom"; "collins"))
$parent_o.cle11.push(New object:C1471("ID"; 2; "prenom"; "Marie"; "nom"; "Lines"; "age"; "25"))
$parent_o.cle11.push(New object:C1471("ID"; 3; "prenom"; "Martin"; "nom"; "Rodriguez"))

$son_o.cle11:=New collection:C1472()
$son_o.cle11.push(New object:C1471("ID"; 1; "prenom"; "Miguel"; "nom"; "collins"))
$son_o.cle11.push(New object:C1471("ID"; 2; "prenom"; "Marie"; "nom"; "Lines"; "ville"; "Paris"))
$son_o.cle11.push(New object:C1471("ID"; 4; "prenom"; "Sophie"; "nom"; "Milano"))

$control_o.cle11:=New collection:C1472()
$control_o.cle11.push(New object:C1471("ID"; 1; "prenom"; "Miguel"; "nom"; "collins"))
$control_o.cle11.push(New object:C1471("ID"; 2; "prenom"; "Marie"; "nom"; "Lines"; "age"; "25"; "ville"; "Paris"))
$control_o.cle11.push(New object:C1471("ID"; 3; "prenom"; "Martin"; "nom"; "Rodriguez"))
$control_o.cle11.push(New object:C1471("ID"; 4; "prenom"; "Sophie"; "nom"; "Milano"))


// Test 12 : merge collection dans une collection (ID, PK, UUID, PKU)
$habitant_c:=New collection:C1472()
$habitant_c.push(New object:C1471("ID"; 1; "prenom"; "Martin"; "nom"; "Rodriguez"))
$habitant_c.push(New object:C1471("ID"; 2; "prenom"; "Marie"; "nom"; "Lines"))

$parent_o.cle12:=New collection:C1472()
$parent_o.cle12.push(New object:C1471("ID"; 1; "city"; "Cannes"; "habitant"; $habitant_c))


$habitant_c:=New collection:C1472()
$habitant_c.push(New object:C1471("ID"; 4; "prenom"; "Sophie"; "nom"; "Milano"))
$son_o.cle12:=New collection:C1472()
$son_o.cle12.push(New object:C1471("ID"; 1; "city"; "Paris"; "habitant"; $habitant_c))
$son_o.cle12.push(New object:C1471("ID"; 2; "city"; "Lyon"; "habitant"; New collection:C1472()))


$habitant_c:=New collection:C1472()
$habitant_c.push(New object:C1471("ID"; 1; "prenom"; "Martin"; "nom"; "Rodriguez"))
$habitant_c.push(New object:C1471("ID"; 2; "prenom"; "Marie"; "nom"; "Lines"))
$habitant_c.push(New object:C1471("ID"; 4; "prenom"; "Sophie"; "nom"; "Milano"))

$control_o.cle12:=New collection:C1472()
$control_o.cle12.push(New object:C1471("ID"; 1; "city"; "Paris"; "habitant"; $habitant_c))
$control_o.cle12.push(New object:C1471("ID"; 2; "city"; "Lyon"; "habitant"; New collection:C1472()))


// Test 13 : merge collection dans une collection avec un fils vide
$habitant_c:=New collection:C1472()
$habitant_c.push(New object:C1471("ID"; 1; "prenom"; "Martin"; "nom"; "Rodriguez"))
$habitant_c.push(New object:C1471("ID"; 2; "prenom"; "Marie"; "nom"; "Lines"))

$parent_o.cle13:=New collection:C1472()
$parent_o.cle13.push(New object:C1471("ID"; 1; "city"; "Cannes"; "habitant"; $habitant_c))


$habitant_c:=New collection:C1472()
$son_o.cle13:=New collection:C1472()
$son_o.cle13.push(New object:C1471("ID"; 1; "city"; "Paris"; "habitant"; $habitant_c))


$habitant_c:=New collection:C1472()
$habitant_c.push(New object:C1471("ID"; 1; "prenom"; "Martin"; "nom"; "Rodriguez"))
$habitant_c.push(New object:C1471("ID"; 2; "prenom"; "Marie"; "nom"; "Lines"))

$control_o.cle13:=New collection:C1472()
$control_o.cle13.push(New object:C1471("ID"; 1; "city"; "Paris"; "habitant"; $habitant_c))

// On merge les objects
$fusion_o:=cwToolObjectMerge($parent_o; $son_o)

// On fait une boucle de controle.
$0:="Ok"
For each ($key_t; $control_o)
	
	If (JSON Stringify:C1217($fusion_o[$key_t])#JSON Stringify:C1217($control_o[$key_t]))
		TRACE:C157
		$0:="cwToolObjectMergeTest : Error test "+$key_t
	End if 
	
End for each 