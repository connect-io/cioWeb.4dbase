//%attributes = {}
/*------------------------------------------------------------------------------
Methode projet : OauthMS()

Connexion à Microsoft Graph

Historique
18/11/25 <remyEtGreg@connect-io.fr> - Création
------------------------------------------------------------------------------*/

#DECLARE($service_o : Object; $office365 : cs:C1710.NetKit.Office365)

var $credential : Object

If ($service_o.success=False:C215)
	return {success: False:C215; statusText: "La configuration du service Microsoft Graph n'existe pas."}
End if 

// 1) Paramètres OAuth2 en mode "service" (client credentials)
$credential:=New object:C1471
$credential.name:="Microsoft"
$credential.permission:="service"

$credential.clientId:=$service_o.login  // Application (client) ID
$credential.clientSecret:=$service_o.password  // VALUE du client secret
$credential.tenant:=$service_o.token  // GUID du tenant OU "ton-tenant.onmicrosoft.com"

// Scope Graph en mode service : utilisera les Application permissions cochées sur l’app
$credential.scope:=$service_o.url

// (Optionnel) timeout HTTP vers login.microsoftonline.com
$credential.timeout:=30  // secondes

// 2) Création du provider OAuth2 (classe cs.NetKit)
var $oAuth2 : cs:C1710.NetKit.OAuth2Provider:=cs:C1710.NetKit.OAuth2Provider.new($credential)

// --- Optionnel : test direct du token, pour vérifier la conf Azure ---
// Tu peux commenter ce bloc une fois que tout marche.

/*
$token:=$oAuth2.getToken()
If ($token=Null)
If (Size of(Last errors)>0)
ALERT("Erreur OAuth2 : "+String(Last errors[0].errcode)+" - "+Last errors[0].message)
Else 
ALERT("getToken a échoué sans détail. Vérifie clientId / secret / tenant / permissions Graph / réseau.")
End if 
Quit method
End if 
*/

// 3) Création de l’instance Office365 à partir du PROVIDER
$office365:=cs:C1710.NetKit.Office365.new($oAuth2; {mailType: "JMAP"})  // Format avec les entete SMTP 4D.

$office365.mail.userId:=$service_o.eMail

return $office365