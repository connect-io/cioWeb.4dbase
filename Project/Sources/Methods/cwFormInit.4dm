//%attributes = {"shared":true,"publishedWeb":true}
/* ----------------------------------------------------
Méthode : cwInputFormInit

Initialise les formulaires html

Historique
09/10/15 - Grégory Fromain <gregory@connect-io.fr> - Création
21/12/19 - Grégory Fromain <gregory@connect-io.fr> - On utilise les formulaires depuis une collection au lieux d'un objet.
----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_TEXT:C284($1)  // Nom du formulaire html
	C_TEXT:C284($0)  // Code html du formulaire
	
	C_COLLECTION:C1488($resultForm_c)
	C_OBJECT:C1216(formulaire_o)
	C_TEXT:C284($formNom_t)
End if 

  // Nettoyage du param
$formNom_t:=Substring:C12($1;2)
$formNom_t:=Replace string:C233($formNom_t;"/readOnly";"")

  // On retrouve le formulaire
$resultForm_c:=siteForm_c.query("lib IS :1";$formNom_t)

If ($resultForm_c.length=1)
	formulaire_o:=$resultForm_c[0]
	formulaire_o.readOnly:=$1="@/readOnly@"
	
Else 
	formulaire_o:=New object:C1471()
End if 


  //On utilisera la variable "formulaire_o" aussi pour l'appel des inputs html.

$0:=Char:C90(1)+Replace string:C233(formulaire_o.html;"$action";cwLibToUrl (formulaire_o.action))
