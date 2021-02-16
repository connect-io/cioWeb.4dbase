//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cwWebAppStart

Permet de faire l'éxécution de la partie WebApp du composant cioWeb

Historique
16/02/21 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/

// Déclarations
var $0 : Object

// Instanciation de la class
$0:=cwToolGetClass("webApp").new()

If (Application type:C494=4D Server:K5:6) | (Application type:C494=4D mode local:K5:1)
	MESSAGE:C88("Arrêt du serveur web..."+Char:C90(Retour chariot:K15:38))
	WEB STOP SERVER:C618
	
	MESSAGE:C88("Chargement de l'application web..."+Char:C90(Retour chariot:K15:38))
	$0.serverStart()
	
	MESSAGE:C88("Redémarrage du serveur web..."+Char:C90(Retour chariot:K15:38))
	WEB START SERVER:C617
	
	If (OK#1)
		ALERT:C41("Le serveur web n'est pas correctement démarré.")
	End if 
	
	// Démarrage des sessions.
	$0.sessionWebStart()
End if 

// Démarrage de la config pour l'envoie d'email
$0.eMailConfigLoad()