# Commencer avec le composant cioWeb

## Installation

Vous pouvez soit récupérer le composant et le copier dans votre application.
Soit ajouter le composant dans votre application 4D sous GIT comme sous-module:
```terminal
git submodule add  https://github.com/connect-io/cioWeb.4dbase.git Components/cioWeb.4dbase
```

Les sources et le build sont dans 2 branches distinctes.

## Méthode de base sur ouverture

```4d
/* -----------------------------------------------------------------------------
	Méthode : Sur ouverture
	
	Charger tous les éléments propres à l'application Web
	
	Historique
	27/07/20 - Grégory Fromain - création
----------------------------------------------------------------------------- */

If (True)  // Déclarations
	C_OBJECT(<>webApp_o)
	C_VARIANT($classWebApp_v)
End if 


  // Récupération de la class webApp depuis le composant
$classWebApp_v:=cwToolGetClass ("webApp")

  // Instanciation de la class
<>webApp_o:=$classWebApp_v.new()


MESSAGE("Arrêt du serveur web..."+Char(Carriage return))
WEB STOP SERVER

MESSAGE("Chargement de l'application web..."+Char(Carriage return))
<>webApp_o.serverStart()

MESSAGE("Redémarrage du serveur web..."+Char(Carriage return))
WEB START SERVER
If (ok#1)
	ALERT("Le serveur web n'est pas correctement démarré.")
End if 

  // Démarrage des sessions.
<>webApp_o.sessionWebStart()
```

## Méthode de base sur connexion web
```4d
/* -----------------------------------------------------------------------------
	Méthode : Sur connexion web
	
	Traitement de la réquête web
	
	Historique
	28/07/20 - Grégory Fromain - création
	28/07/20 - Grégory Fromain - Gestion des blocks recursifs.
----------------------------------------------------------------------------- */

If (True)  // Déclarations
	C_TEXT($3)  // Adresse IP du navigateur.
	
	C_OBJECT(visiteur_o;pageWeb_o)
	C_TEXT($htmlFichierChemin_t;$resultatMethode_t;$methodeNom_t)
	C_OBJECT(dataTables_o)
	C_TEXT($retour_t)
End if 

  // ===== Chargement des informations du visiteur du site =====
If (visiteur_o=Null)
	visiteur_o:=cwToolGetClass("User").new()
End if 

  // Récupération des informations du visiteur.
visiteur_o.getInfo()
visiteur_o.ip:=$3

  //Gestion des sessions web.
visiteur_o.sessionWebLoad()


  // Petit hack pour simplifier, le premier démarrage.
  // C'est à supprimer après la configuration du fichier host de la machine.
If (visiteur_o.Host="127.0.0.1")
	visiteur_o.sousDomaine:=OB Keys(<>webApp_o.sites)[0]
	visiteur_o.Host:=visiteur_o.sousDomaine+".dev.local"
End if 

  // Dectection du mode développement
visiteur_o.devMode:=visiteur_o.Host="@dev@"


  // ===== Rechargement des variables de l'application =====
If (visiteur_o.devMode)
	SET ASSERT ENABLED(True)
	<>webApp_o.serverStart()
	<>webApp_o.urlCDN:=""
End if 


  // ===== Chargement des informations sur la page =====
pageWeb_o:=cwToolGetClass("Page").new(visiteur_o)

// On purge les dataTables.
If (pageWeb_o.lib#"@ajax@")|(dataTables_o=null)
	// Contient les datatables que le visiteur va utiliser dans son processs
	dataTables_o:=New object()
End if

  // On va fusionner les datas de la route de l'URL sur le visiteur.
If (pageWeb_o.route.data#Null)
	For each ($routeData_t;pageWeb_o.route.data)
		visiteur_o[$routeData_t]:=pageWeb_o.route.data[$routeData_t]
	End for each 
End if 

  // On exécute si besoin les méthodes relatives à la page
For each ($methodeNom_t;pageWeb_o.methode)
	EXECUTE METHOD($methodeNom_t;$resultatMethode_t)
	pageWeb_o.resulatMethode_t:=$resultatMethode_t
End for each 

  //Si il y a un fichier HTML à renvoyer... on lance le constructeur.
visiteur_o.updateVarVisiteur()


Case of 
	: (pageWeb_o.viewPath.length=0) & (String(pageWeb_o.resulatMethode_t)#"")
		  // Si c'est du hard code. (ex : requete ajax)
		WEB SEND TEXT(pageWeb_o.resulatMethode_t;pageWeb_o.type)
		
	: (pageWeb_o.viewPath.length=0)
		  // On ne fait rien la méthode d'appel renvoie déjà du contenu
		  // (Exemple fichier Excel)
		
	Else 
		  // Si nous ne sommes pas en ajax et pas en page d'erreur, on génére un nouveau token pour le visiteur
		If (pageWeb_o.lib#"404")
			visiteur_o.tokenGenerate()
		End if 
		
		For each ($htmlFichierChemin_t;pageWeb_o.viewPath)
			$retour_t:=pageWeb_o.scanBlock(Document to text($htmlFichierChemin_t))
		End for each 
		
		WEB SEND TEXT($retour_t;pageWeb_o.type)
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


A partir d'ici, vous pouvez redémarrer votre application pour prendre en charge le composant et la méthode sur Ouverture.<br />
Au lancement de l'application, le logiciel vous demande quel sous-domaine vous souhaitez créer ? Par défaut il propose www, nous vous conseillons dans un premier temps de laisser celui-ci.

Lors de la première réouverture de votre application, le composant génère automatiquement l'arborescence de votre application web.

Vous pouvez dès à présent tester le serveur web via votre navigateur : http://127.0.0.1


## Arborescence des fichiers de votre application web
```
 📦VotreApplication
 ┣ 📂Components
 ┃ ┣ 📂cioWeb.4dbase                     // Composant cioWeb
 ┣ 📂Data
 ┣ 📂Project
 ┣ 📂Resources
 ┣ 📂WebApp                              // Répertoire principale de votre application web                           
 ┃ ┣ 📂Cache                             // Contient tous les fichiers caches de votre application web
 ┃ ┃ ┗ 📂View                            // Contient toutes les vues en HTML minifié
 ┃ ┃   ┗ 📂www
 ┃ ┃     ┣ 📂_cioWeb
 ┃ ┃     ┃ ┗ 📂view
 ┃ ┃     ┃   ┣ 📜notification.html       // HTML minifié
 ┃ ┃     ┃   ┣ 📜...
 ┃ ┃     ┗ 📂...
 ┃ ┣ 📂Sources                           // Dossier principal de code source
 ┃ ┃ ┣ 📂www                             // Dossier du sous domaine de votre application
 ┃ ┃ ┃ ┣ 📂_cioWeb                       // [Obligatoire] Il personnalise certain affichage web
 ┃ ┃ ┃ ┃ ┗ 📂view                        // Les dossiers view ne sont pas obligatoire, ils permettent d'organiser le code
 ┃ ┃ ┃ ┃   ┣ 📜notification.html         // Personnalisation des notifications
 ┃ ┃ ┃ ┃   ┣ 📜input.html                // Personnalisation des inputs des formulaires
 ┃ ┃ ┃ ┃   ┗ 📜inputReadOnly.html        // Personnalisation des inputs des formulaires en lecture seule
 ┃ ┃ ┃ ┣ 📂_layout                       // [Obligatoire] Il permet la construction de page web sous forme de layout
 ┃ ┃ ┃ ┃ ┣ 📂view
 ┃ ┃ ┃ ┃ ┃ ┗ 📜layoutDemo.html
 ┃ ┃ ┃ ┃ ┗ 📜route.json                  // Configuration des routes du layout
 ┃ ┃ ┃ ┣ 📂basicPage
 ┃ ┃ ┃ ┃ ┣ 📂view
 ┃ ┃ ┃ ┃ ┃ ┗ 📜index.html                // HTML de votre page
 ┃ ┃ ┃ ┃ ┗ 📜route.json
 ┃ ┃ ┃ ┗ 📂demo                          // Module de demonstration
 ┃ ┃ ┃   ┣ 📂form
 ┃ ┃ ┃   ┃ ┗ 📜helloWord.form.json       // Configuration du formulaire helloWord
 ┃ ┃ ┃   ┣ 📂view
 ┃ ┃ ┃   ┃ ┗ 📜helloWord.html
 ┃ ┃ ┃   ┗ 📜route.json
 ┃ ┃ ┗ 📜config.json                     // Configuration générale de application web
 ┃ ┗ 📂WebFolder                         // Le dossier web public, attention tout ce qui est dans ce dossier est accessible sur internet.
 ┃   ┣ 📂uploads                         // Stocker les documents que les utilisateurs charges, photos de profil, photo d'article,...
 ┃   ┗ 📂www                             // Dossier public de votre sous-domaine
 ┃     ┣ 📂css
 ┃     ┣ 📂img
 ┃     ┗ 📂js
 ┗ 📂userPreferences.XXX
 ```

 Une chose importante, chaque sous domaine est géré de façon indépendante, seul le fichier  ```Sources>config.json ``` est partagé entre les sous-domaines.

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
Par exemple si votre application possède un sous domaine www., admin. ou alors api.:

```
127.0.0.1       www.dev.local
127.0.0.1       admin.dev.local
127.0.0.1       api.dev.local
```

[Continuer avec la présentation des routes](/Documentation/route.md)