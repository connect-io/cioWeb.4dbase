//%attributes = {"shared":true,"lang":"en"}
C_VARIANT:C1683($1)

// Dans cette demo on veut envoyer un email simple à une personne.
var $marketingAutomation_o : Object
var $statut_o; $eMail_o; $personne_o : Object

// Instanciation de la class
$marketingAutomation_o:=cwToolGetClass("MarketingAutomation").new()

$personne_o:=cwToolGetClass("MAPersonne").new()
$personne_o.loadByPrimaryKey($1)  // Recherche et chargement de l'entité de la personne

//----- Envoi d'un e-mail simple -----
$eMail_o:=cwToolGetClass("EMail").new("connectIO")

$eMail_o.to:=$personne_o.eMail
$eMail_o.object:="Test demo 1"
$eMail_o.textBody:="Coucou"

$statut_o:=$eMail_o.send()

If (String:C10($statut_o.statusText)="ok@")  // Statut de l'envoie du mail
	ALERT:C41("Votre email a bien été envoyé")
Else 
	ALERT:C41("Une erreur est survenue lors de l'envoi de l'e-mail : "+$statut_o.statusText)
End if 

//----- Envoi d'un e-mail depuis un modele -----
$eMail_o:=cwToolGetClass("EMail").new("connectIO")

$eMail_o.to:=$personne_o.eMail
$eMail_o.object:="Test demo 2"
$eMail_o.textBody:="Coucou"

$variable_o:=New object:C1471("name"; "Antoine"; "email"; "XxXxXxXx@outlook.fr")

$statut_o:=$eMail_o.sendModel("demo2"; $variable_o)

If (String:C10($statut_o.statusText)="ok")  // Statut de l'envoie du mail
	ALERT:C41("Votre email a bien été envoyé")
Else 
	ALERT:C41("Une erreur est survenue lors de l'envoi de l'e-mail : "+$statut_o.statusText)
End if 

// Todo : Est-ce que cela fonctionne avec mjml et des piéces jointes ?