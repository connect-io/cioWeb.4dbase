//%attributes = {"shared":true}
  // ----------------------------------------------------
  // Nom utilisateur (OS) : Grégory Fromain <gregory@connect-io.fr>
  // Date et heure : 25/10/15, 20:27:52
  // ----------------------------------------------------
  // Méthode : cwFormInputSelectNewValue
  // Description
  // Générer des nouvelles entrée dans un input de type select.
  //
  // Paramètres
  // $1 = [pointeur] ->visiteur
  // $2 = [text] nom du input html
  // $3 = [object] {"lib" : "valeur"}
  // $4 = [text] resultat par defaut (optionnel)
  // ----------------------------------------------------

  // Struture de la collection
  // [
  //   "value": "1",
  //   "lib": "est un admin",
  //   "selected": true (optionnel),
  //   "disabled": true (optionnel)
  // ,...
  // ]


If (False:C215)  // Historique
	  // 03/07/19 gregory@connect-io.fr - Utilisation avec des collections
End if 

If (True:C214)  // Déclarations
	C_POINTER:C301($1)
	C_TEXT:C284($2;$4;$inputName_t;$selectOption_t)
	C_OBJECT:C1216($visiteur;$option_o)
	C_COLLECTION:C1488($3;$option_c;$optionSelected_c)
End if 


$visiteur:=$1->
$inputName_t:=String:C10($2)
$option_c:=$3
$selectOption_t:=""


If (Asserted:C1132($inputName_t#"";"le nom du formulaire ($2) est vide."))
	If (Asserted:C1132(Type:C295($option_c)=Is collection:K8:32;Current method name:C684+", le type de $3 n'est pas valide pour le formulaire "+$inputName_t))
		
		If (Count parameters:C259=4)
			  // Si le param 4 est définit, on essai de séléctionner l'option en question.
			$optionSelected_c:=$option_c.query("value IS :1";String:C10($4))
			If ($optionSelected_c.length=1)
				$optionSelected_c[0].selected:=True:C214
			End if 
		End if 
		
		For each ($option_o;$option_c)
			$selectOption_t:=$selectOption_t+\
				"<option value=\""+String:C10($option_o.value)+"\""+Choose:C955(Bool:C1537($option_o.selected);" selected";"")+Choose:C955(Bool:C1537($option_o.disabled);" disabled";"")+">"+\
				String:C10($option_o.lib)+"</option>"
		End for each 
		OB SET:C1220($visiteur;"selectOption"+$2;$selectOption_t)
	End if 
End if 

$1->:=$visiteur








  // ----------------------------------------------------
  // Nom utilisateur (OS) : Grégory Fromain <gregory@connect-io.fr>
  // Date et heure : 25/10/15, 20:27:52
  // ----------------------------------------------------
  // Méthode : cwFormInputSelectNewValue
  // Description
  // Générer des nouvelles entrée dans un input de type select.
  //
  // Paramètres
  // $1 = [pointeur] ->visiteur
  // $2 = [text] nom du input html
  // $3 = [object] {"lib" : "valeur"}
  // $4 = [text] resultat par defaut (optionnel)
  // ----------------------------------------------------

  //C_TEXT($2;$selected;$selectOption;$4)
  //C_POINTER($1)
  //C_OBJECT($3;$option;$visiteur)

  //$visiteur:=$1->
  //$option:=$3
  //$selectOption:=""
  //$selected:=""

  //If (Asserted($2#"";"le nom du formulaire ($2) est vide."))
  //If (Asserted(OB Is defined($option);Current method name+", le type de $3 n'est pas valide pour le formulaire "+$2))


  //ARRAY TEXT($libSelection;0)
  //OB GET PROPERTY NAMES($option;$libSelection)
  //For ($nbLibSelect;1;Size of array($libSelection))
  //If (Count parameters=4)
  //$selected:=Choose($libSelection{$nbLibSelect}=$4;" selected";"")
  //End if 
  //$selectOption:=$selectOption+"<option value=\""+$libSelection{$nbLibSelect}+"\""+$selected+">"+OB Get($option;$libSelection{$nbLibSelect})+"</option>"
  //End for 
  //OB SET($visiteur;"selectOption"+$2;$selectOption)


  //End if 
  //End if 

  //$1->:=$visiteur