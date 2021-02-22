//%attributes = {"publishedWeb":true,"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwInputHtml

Génére le code html d'un input

Historique
30/09/15 - Grégory Fromain <gregory@connect-io.fr> - Création
18/03/20 - Grégory Fromain <gregory@connect-io.fr> - Les inputs sont traités depuis une collection au lieu d'un objet.
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */

// Déclarations
var $1 : Text  // Nom de la variable du formulaire web
var $0 : Text  // Code html du formulaire


If (OB Is defined:C1231(formulaire_o))
	If (formulaire_o.input.query("lib IS :1";Substring:C12($1;2))#Null:C1517)
		
		If (Bool:C1537(formulaire_o.readOnly))
			$0:=Char:C90(1)+formulaire_o.input.query("lib IS :1";Substring:C12($1;2))[0].htmlReadOnly
		Else 
			$0:=Char:C90(1)+formulaire_o.input.query("lib IS :1";Substring:C12($1;2))[0].html
		End if 
		
	Else 
		$0:="L'input "+Substring:C12($1;2)+" n'est pas initialisé dans ce formulaire.<br />"
	End if 
Else 
	$0:="Aucun formulaire est initialisé."
End if 

$0:=cwI18nConvertJson($0)

// TODO : Penser à faire une gestion des erreurs.