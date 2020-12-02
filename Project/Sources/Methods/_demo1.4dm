//%attributes = {"shared":true}
// Dans cette demo on veut envoyer un email simple à une personne.
C_OBJECT:C1216($marketingAutomation_cs;$marketingAutomation_o)
C_OBJECT:C1216($statut_o;$variable_o;$personne_o)

$marketingAutomation_cs:=cwToolGetClass("MarketingAutomation")  // Initialisation de la class

$marketingAutomation_o:=$marketingAutomation_cs.new()  // Instanciation de la class
$marketingAutomation_o.loadPasserelle("Personne")  // Création de la passerelle entre la class $marketingAutomation_o et la base hôte

$personne_o:=$marketingAutomation_o.loadPeopleByUID("2237F6C0D8AC4A78AC7AB423C57AF5F8")  // Recherche et chargement de l'entité de la personne

//----- Envoi d'un e-mail simple -----
$statut_o:=$personne_o.sendMail("Objet du mail";"Contenue de l'email")

If (String:C10($statut_o.statusText)="ok@")  // Statut de l'envoie du mail
	ALERT:C41("Votre email a bien été envoyé")
Else 
	ALERT:C41("Une erreur est survenue lors de l'envoi de l'e-mail : "+$statut_o.statusText)
End if 

//----- Envoi d'un e-mail depuis un modele -----
$variable_o:=New object:C1471()

$variable_o.name:="Antoine"
$variable_o.email:="XxXxXxXx@outlook.fr"

$statut_o:=$personne_o.sendMailModel("Demo8";$variable_o)

If (String:C10($statut_o.statusText)="ok")  // Statut de l'envoie du mail
	ALERT:C41("Votre email a bien été envoyé")
Else 
	ALERT:C41("Une erreur est survenue lors de l'envoi de l'e-mail : "+$statut_o.statusText)
End if 

// Todo : Est-ce que cela fonctionne avec mjml et des piéces jointes ?