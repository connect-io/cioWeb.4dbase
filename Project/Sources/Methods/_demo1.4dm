//%attributes = {"shared":true,"lang":"en"}

C_VARIANT:C1683($1)

// Dans cette demo on veut envoyer un email simple à une personne.
var $marketingAutomation_o : Object
var $statut_o; $eMail_o; $personne_o : Object

// Instanciation de la class
$marketingAutomation_o:=cwToolGetClass("MarketingAutomation").new()

// Création de la passerelle entre la class $marketingAutomation_o et la base hôte
//$marketingAutomation_o.loadPasserelle("Personne")

$personne_o:=cwToolGetClass("MAPersonne").new()

$personne_o.loadByPrimaryKey($1)  // Recherche et chargement de l'entité de la personne

//----- Envoi d'un e-mail simple -----
$eMail_o:=cwToolGetClass("EMail").new("Marketing")

$eMail_o.to:=$personne_o.email
$eMail_o.object:="Test demo 1"
$eMail_o.textBody:="Coucou"

$statut_o:=$eMail_o.send()

If (String:C10($statut_o.statusText)="ok@")  // Statut de l'envoie du mail
	ALERT:C41("Votre email a bien été envoyé")
Else 
	ALERT:C41("Une erreur est survenue lors de l'envoi de l'e-mail : "+$statut_o.statusText)
End if 



///////////////////////////////


// Dans cette demo on veut envoyer un email simple à une personne.
var $marketingAutomation_cs; $marketingAutomation_o : Object
var $statut_o; $variable_o; $personne_o : Object

$marketingAutomation_cs:=cwToolGetClass("MarketingAutomation")  // Initialisation de la class

$marketingAutomation_o:=$marketingAutomation_cs.new()  // Instanciation de la class
$marketingAutomation_o.loadPasserelle("Personne")  // Création de la passerelle entre la class $marketingAutomation_o et la base hôte

$personne_o:=$marketingAutomation_o.loadPeopleByUID("2237F6C0D8AC4A78AC7AB423C57AF5F8")  // Recherche et chargement de l'entité de la personne

//----- Envoi d'un e-mail simple -----
$statut_o:=$personne_o.sendMail("Objet du mail"; "Contenue de l'email")

If (String:C10($statut_o.statusText)="ok@")  // Statut de l'envoie du mail
	ALERT:C41("Votre email a bien été envoyé")
Else 
	ALERT:C41("Une erreur est survenue lors de l'envoi de l'e-mail : "+$statut_o.statusText)
End if 

//----- Envoi d'un e-mail depuis un modele -----
$variable_o:=New object:C1471()

$variable_o.name:="Antoine"
$variable_o.email:="XxXxXxXx@outlook.fr"

$statut_o:=$personne_o.sendMailModel("Demo8"; $variable_o)

If (String:C10($statut_o.statusText)="ok")  // Statut de l'envoie du mail
	ALERT:C41("Votre email a bien été envoyé")
Else 
	ALERT:C41("Une erreur est survenue lors de l'envoi de l'e-mail : "+$statut_o.statusText)
End if 

// Todo : Est-ce que cela fonctionne avec mjml et des piéces jointes ?

