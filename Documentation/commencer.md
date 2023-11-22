# Commencer avec le composant cioWeb

## Installation

Vous pouvez soit récupérer le composant et le copier dans votre application.
Ou ajouter le composant dans votre application 4D sous GIT comme sous-module :
```terminal
git submodule add  https://github.com/connect-io/cioWeb.4dbase.git Components/cioWeb.4dbase
```

Voici quelques méthodes à intégrer dans votre application pour le bon fonctionnement du serveur web.

```4d
/*------------------------------------------------------------------------------
	Méthode : webAppErrorCallback
	
	Gestion des appels sur erreur du serveur web.
	
	Historique
	22/02/15 gregory@connect-io.fr - Création
	15/11/20 gregory@connect-io.fr - Clean code
	24/02/21 gregory@connect-io.fr - Modernisation du code
------------------------------------------------------------------------------*/

// Déclarations
var $error_o : Object

ARRAY LONGINT($code_ai; 0)
ARRAY TEXT($composantInterne_at; 0)
ARRAY TEXT($lib_at; 0)

If (Error#0)
	GET LAST ERROR STACK($code_ai; $composantInterne_at; $lib_at)
	$error_o:=New object
	$error_o.libelle:=$lib_at{1}
	$error_o.methode:=Error Method
	$error_o.ligne:=Error Line
	$error_o.code:=Error
	
	If (OB Is defined(visiteur_o))
		$error_o.visiteur:=visiteur_o
	End if 
	
	cwLogErreurAjout("Serveur Web"; $error_o)
	
	If (Get assert enabled)
		WEB SEND TEXT(JSON Stringify($error_o; *))
		TRACE
	End if 
	
Else 
	cwGestionErreur
End if 
```


```4d
//%attributes = {"preemptive":"capable"}
/*------------------------------------------------------------------------------
	Methode projet : webAppWorkerRun
	
	Appel d'une fonction de la class WebApp depuis un nouveau process.
	
	Historique
	28/01/21 - Grégory Fromain <gregory@connect-io.fr> - Création
------------------------------------------------------------------------------*/

var $1 : Text  // Nom de la fonction de la class WebApp à éxécuter
var $2 : 4D.signal

ASSERT($1#""; "webAppWorkerRun : Le param $1 ne doit pas être vide.")
ASSERT(Count parameters=2; "webAppWorkerRun : Il manque un paramêtre à l'appel de la méthode.")

Formula from string("this."+$1+"()").call(<>webApp_o)

$2.trigger()  // On libére le signal
```

```4d
/*------------------------------------------------------------------------------
	Methode projet : webAppWorkerCall
	
	Detail des entreprises
	
	Historique
	28/01/21 - Grégory Fromain <gregory@connect-io.fr> - Création
------------------------------------------------------------------------------*/

// Déclarations
var $1 : Text  // Fonction à appeler dans webApp

ASSERT($1#""; "webAppWorkerCall : Le param $1 ne doit pas être vide.")

$signal_o:=New signal("Call fonction Web app : "+$1)

CALL WORKER("webAppGestion : "+$1; "webAppWorkerRun"; $1; $signal_o)

$signal_o.wait(60)  // Sécurité si jamais l'import prends plus que 60 sec
```


## Méthode de base sur ouverture

```4d
/*------------------------------------------------------------------------------
	Méthode : Sur ouverture
	
	Charger tous les éléments propres à l'application Web
	
	Historique
	27/07/20 - Grégory Fromain - création
	24/02/21 - Grégory Fromain - Modernisation du code
	22/11/22 - Jonathan Fernandez - Modernisation du code
------------------------------------------------------------------------------*/

// Déclarations
var webApp_o : cs.WebApp
C_OBJECT(<>webApp_o)

If (Application type#4D Remote mode)
	
	// Instanciation de la class
	<>webApp_o:=cwToolGetClass("WebApp").new()
	
	MESSAGE("Arrêt du serveur web..."+Char(Carriage return))
	$webServer_o:=WEB Server()
	
	MESSAGE("Chargement de l'application web..."+Char(Carriage return))
	<>webApp_o.serverStart()
	
	MESSAGE("Redémarrage du serveur web..."+Char(Carriage return))
	$state:=$webServer_o.start()
	
	If (Not($state.success))
		ALERT("Le serveur web n'est pas correctement démarré.")
	End if 
	
	// Démarrage des sessions
	<>webApp_o.sessionWebStart()
	
End if 

```

## Méthode de base sur connexion web
```4d
/* -----------------------------------------------------------------------------
	Méthode : Sur connexion web
	
	Traitement de la réquête web
	
	Historique
	28/07/20 - Grégory Fromain - création
	28/07/20 - Grégory Fromain - Gestion des blocks recursifs.
	24/02/21 - Grégory Fromain - Modernisation du code, ajout graphique et préemptif
	22/11/22 - Jonathan Fernandez - Ajout du Session.storage
------------------------------------------------------------------------------*/

// Déclarations
var $3 : Text  // Adresse IP du navigateur

var $retour_t : Text
var $htmlFichierChemin_t : Text
var $resultatMethode_t : Text
var $methodeNom_t : Text

var $visiteur_o : cs.cioWeb.User

ARRAY TEXT($champ_at; 0)
ARRAY TEXT($valeur_at; 0)

var pageWeb_o : Object

// ----- Gestion des erreurs -----
ON ERR CALL("webAppErrorCallback")

// ----- Chargement des informations du visiteur du site -----

// Récupération des informations du visiteur.
If (Session.storage.user=Null)
	$visiteur_o:=cs.cioWeb.User.new()
	
	Use (Session.storage)
		Session.storage.user:=OB Copy($visiteur_o; ck shared)
	End use 
	
End if 

If (Semaphore("initUser"; 10*60))
	// Passage en force...
End if 

Session.storage.user.getInfo($3)

If (Session.storage.user.Origin#Null)
	APPEND TO ARRAY($champ_at; "Access-Control-Allow-Origin")
	APPEND TO ARRAY($valeur_at; Session.storage.user.Origin)
Else 
	APPEND TO ARRAY($champ_at; "Access-Control-Allow-Origin")
	APPEND TO ARRAY($valeur_at; "*")
End if 

APPEND TO ARRAY($champ_at; "Access-Control-Allow-Credentials")
APPEND TO ARRAY($valeur_at; "true")

If (Session.storage.user["X-METHOD"]="OPTIONS")
	APPEND TO ARRAY($champ_at; "Access-Control-Allow-Headers")
	APPEND TO ARRAY($valeur_at; "Accept, Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With, access-control-allow-methods, Access-Control-Allow-Origin, Access-Control-Allow-Credentials")
End if 

WEB SET HTTP HEADER($champ_at; $valeur_at)

If (Session.storage.user["X-METHOD"]="OPTIONS")
	WEB SEND TEXT("options")
	return 
End if 

// ----- Rechargement des variables de l'application -----
// Dectection du mode développement
If (Session.storage.user.devMode)
	SET ASSERT ENABLED(True)
	webAppWorkerCall("serverStart")
End if 

// ----- Chargement des informations sur la page -----
pageWeb_o:=cwToolGetClass("Page").new(Session.storage.user)
CLEAR SEMAPHORE("initUser")

If (pageWeb_o.lib#"@ajax@") | (Session.storage.dataTables=Null)  // On purge les dataTables
	
	Use (Session.storage)
		Session.storage.dataTables:=New shared object()
	End use 
	
End if 

If (pageWeb_o.lib#"@ajax@") | (charts_o=Null)  // On purge les graphiques
	charts_o:=New object()
End if 

// On va fusionner les datas de la route de l'URL sur le visiteur
Use (Session.storage.user)
	
	For each ($routeData_t; pageWeb_o.route.data)
		Session.storage.user[$routeData_t]:=pageWeb_o.route.data[$routeData_t]
	End for each 
	
End use 

// On exécute si besoin les méthodes relatives à la page
For each ($methodeNom_t; pageWeb_o.methode)
	EXECUTE METHOD($methodeNom_t; $resultatMethode_t)
	pageWeb_o.resulatMethode_t:=$resultatMethode_t
End for each 

//Si il y a un fichier HTML à renvoyer... on lance le constructeur.
Session.storage.user.updateVarVisiteur()

Case of 
	: (pageWeb_o.viewPath.length=0) & (String(pageWeb_o.resulatMethode_t)#"")  // Si c'est du hard code. (ex : requete ajax)
		WEB SEND TEXT(pageWeb_o.resulatMethode_t; pageWeb_o.type)
	: (pageWeb_o.viewPath.length=0)  // On ne fait rien la méthode d'appel renvoie déjà du contenu (Exemple fichier Excel)
	Else 
		
		If (pageWeb_o.lib#"404")  // Si nous ne sommes pas en ajax et pas en page d'erreur, on génére un nouveau token pour le visiteur
			Session.storage.user.tokenGenerate()
		End if 
		
		For each ($htmlFichierChemin_t; pageWeb_o.viewPath)
			$retour_t:=pageWeb_o.scanBlock(Document to text($htmlFichierChemin_t))
		End for each 
		
		WEB SEND TEXT($retour_t; pageWeb_o.type)
End case 

```

## Méthode de base sur fermeture process web
```4d
/* -----------------------------------------------------------------------------
	Méthode : Sur fermeture process web
	
	Stock les datas du visiteur, correctement.
	
	Historique
	14/09/20 - Grégory Fromain - Création
----------------------------------------------------------------------------- */


  // On utilise la fonction du composant pour stocker les informations du visiteur.
visiteur_o.sessionWebSave()
```


À partir d'ici, vous pouvez redémarrer votre application pour prendre en charge le composant et la méthode sur Ouverture.<br />
Au lancement de l'application, le logiciel vous demande quel sous-domaine vous souhaitez créer ? Par défaut, il propose www, nous vous conseillons dans un premier temps de laisser celui-ci.

Lors de la première réouverture de votre application, le composant génère automatiquement l'arborescence de votre application web.

Vous pouvez dès à présent tester le serveur web via votre navigateur : http://127.0.0.1


## Arborescence des fichiers de votre application web
```
 📦 VotreApplication
 ┣ 📂 Components
 ┃ ┣ 📂 cioWeb.4dbase                     // Composant cioWeb.
 ┣ 📂 Data
 ┣ 📂 Project
 ┣ 📂 Resources
 ┣ 📂 WebApp                              // Répertoire principale de votre application web.                       
 ┃ ┣ 📂 Cache                             // Contient tous les fichiers caches de votre application web.
 ┃ ┃ ┗ 📂 View                            // Contient toutes les vues en HTML minifié.
 ┃ ┃   ┗ 📂 www
 ┃ ┃     ┣ 📂 _cioWeb
 ┃ ┃     ┃ ┗ 📂 view
 ┃ ┃     ┃   ┣ 📜 notification.html       // HTML minifié.
 ┃ ┃     ┃   ┣ 📜 ...
 ┃ ┃     ┗ 📂 ...
 ┃ ┣ 📂 Sources                           // Dossier principal de code source.
 ┃ ┃ ┣ 📂 www                             // Dossier du sous-domaine de votre application.
 ┃ ┃ ┃ ┣ 📂 _cioWeb                       // [Obligatoire] Il personnalise certains affichages web.
 ┃ ┃ ┃ ┃ ┗ 📂 view                        // Les dossiers view ne sont pas obligatoire, ils permettent d'organiser le code.
 ┃ ┃ ┃ ┃   ┣ 📜 notification.html         // Personnalisation des notifications.
 ┃ ┃ ┃ ┃   ┣ 📜 input.html                // Personnalisation des inputs des formulaires.
 ┃ ┃ ┃ ┃   ┗ 📜 inputReadOnly.html        // Personnalisation des inputs des formulaires en lecture seule.
 ┃ ┃ ┃ ┣ 📂 _layout                       // [Obligatoire] Il permet la construction de pages web sous forme de layout.
 ┃ ┃ ┃ ┃ ┣ 📂 view
 ┃ ┃ ┃ ┃ ┃ ┗ 📜 layoutDemo.html
 ┃ ┃ ┃ ┃ ┗ 📜 route.json                  // Configuration des routes du layout.
 ┃ ┃ ┃ ┣ 📂 basicPage
 ┃ ┃ ┃ ┃ ┣ 📂 view
 ┃ ┃ ┃ ┃ ┃ ┗ 📜 index.html                // HTML de votre page.
 ┃ ┃ ┃ ┃ ┗ 📜 route.json
 ┃ ┃ ┃ ┗ 📂 demo                          // Module de démonstration.
 ┃ ┃ ┃   ┣ 📂 form
 ┃ ┃ ┃   ┃ ┗ 📜 helloWord.form.json       // Configuration du formulaire helloWord.
 ┃ ┃ ┃   ┣ 📂 view
 ┃ ┃ ┃   ┃ ┗ 📜 helloWord.html
 ┃ ┃ ┃   ┗ 📜 route.json
 ┃ ┃ ┗ 📜 config.json                     // Configuration générale d'application web.
 ┃ ┗ 📂 WebFolder                         // Le dossier web public, attention tout ce qui est dans ce dossier est accessible sur internet.
 ┃   ┣ 📂 uploads                         // Stocker les documents que les utilisateurs charges, photos de profil, photo d'article,...
 ┃   ┗ 📂 www                             // Dossier public de votre sous-domaine.
 ┃     ┣ 📂 css
 ┃     ┣ 📂 img
 ┃     ┗ 📂 js
 ┗ 📂 userPreferences.XXX
 ```

 Une chose importante, chaque sous-domaine est gérés de façon indépendante, seul le fichier  ```Sources>config.json ``` est partagé entre les sous-domaines.

## Configuration du localhost

La gestion du composant fonctionne en fonction des sous-domaines pour définir les environnements de travail. Il est donc essentiel de les configurer sur le fichier hosts du poste de travail de développement :

Depuis MacOS :
Lancer un terminal (Cmd + espace)
```
# Ouvrir le fichier hosts en sudo.
# Pour éditer, touche : Entrée
# Pour sauvegarder, touche : Ctrl+O

sudo nano /etc/hosts
```

Il faut maintenant ajouter les sous-domaines sur lesquels on souhaite travailler.
Par exemple, si votre application possède un sous domaine www., admin. ou alors api.:

```
127.0.0.1       www.dev.local
127.0.0.1       admin.dev.local
127.0.0.1       api.dev.local
```

[Continuer avec la présentation des routes](/Documentation/route.md)