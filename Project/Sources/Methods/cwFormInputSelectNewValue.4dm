//%attributes = {"shared":true,"preemptive":"capable"}
/*------------------------------------------------------------------------------
Méthode : cwFormInputSelectNewValue

Générer des nouvelles entrée dans un input de type select.

Historique
03/07/19 - Grégory Fromain <gregory@connect-io.fr> - Utilisation avec des collections
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var

Struture de la collection
[
  "value": "1",
  "lib": "est un admin",
  "selected": true (optionnel),
  "disabled": true (optionnel)
,...
]
------------------------------------------------------------------------------*/

// Déclarations

var $1; $inputName_t : Text  // nom du input html
var $2; $option_c : Collection  // {"lib" : "valeur"}
var $3 : Text  // resultat par defaut (optionnel)

var $selectOption_t : Text
var $optionSelected_c : Collection
var $visiteur : Object
var $option_o : Object

$inputName_t:=String:C10($1)
$option_c:=$2.copy()
$selectOption_t:=""

If (Asserted:C1132($inputName_t#""; "le nom du formulaire ($1) est vide."))
	If (Asserted:C1132(Type:C295($option_c)=Is collection:K8:32; Current method name:C684+", le type de $2 n'est pas valide pour le formulaire "+$inputName_t))
		
		If (Count parameters:C259=4)
			// Si le param 4 est définit, on essai de séléctionner l'option en question.
			$optionSelected_c:=$option_c.query("value IS :1"; String:C10($3))
			If ($optionSelected_c.length=1)
				$optionSelected_c[0].selected:=True:C214
			End if 
		End if 
		
		For each ($option_o; $option_c)
			$selectOption_t:=$selectOption_t+\
				"<option value=\""+String:C10($option_o.value)+"\""+Choose:C955(Bool:C1537($option_o.selected); " selected"; "")+Choose:C955(Bool:C1537($option_o.disabled); " disabled"; "")+">"+\
				String:C10($option_o.lib)+"</option>"
		End for each 
		
		//OB SET($visiteur; "selectOption"+$1; $selectOption_t)
		Use (Session:C1714.storage.user)
			Session:C1714.storage.user["selectOption"+$1]:=$selectOption_t
		End use 
	End if 
End if 

