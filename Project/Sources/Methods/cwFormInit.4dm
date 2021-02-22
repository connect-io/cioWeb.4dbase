//%attributes = {"publishedWeb":true,"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwInputFormInit

Initialise les formulaires html

Historique
09/10/15 - Grégory Fromain <gregory@connect-io.fr> - Création
21/12/19 - Grégory Fromain <gregory@connect-io.fr> - On utilise les formulaires depuis une collection au lieux d'un objet.
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
24/11/20 - Grégory Fromain <gregory@connect-io.fr> - Utilisation du storage
02/12/20 - Alban Catoire <alban@connect-io.fr> - Gestion de la traduction dans les formulaires
----------------------------------------------------------------------------- */

// Déclarations
var $1 : Text  // Nom du formulaire html
var $0 : Text  // Code html du formulaire

var $resultForm_c : Collection
var formulaire_o : Object
var $formNom_t : Text


// Nettoyage du param
$formNom_t:=Substring:C12($1;2)
$formNom_t:=Replace string:C233($formNom_t;"/readOnly";"")

// On retrouve le formulaire
$resultForm_c:=Storage:C1525.sites[visiteur.sousDomaine].form.query("lib IS :1";$formNom_t)

If ($resultForm_c.length=1)
	formulaire_o:=OB Copy:C1225($resultForm_c[0])
	formulaire_o.readOnly:=$1="@/readOnly@"
	
Else 
	formulaire_o:=New object:C1471()
End if 

//On utilisera la variable "formulaire_o" aussi pour l'appel des inputs html.

$0:=Char:C90(1)+Replace string:C233(formulaire_o.html;"$action";cwLibToUrl(formulaire_o.action))
