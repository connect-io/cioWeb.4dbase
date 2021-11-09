# Gestion des vues

## Description
Les vues (très souvent appelées view) sont le rendu des pages dynamiques du serveur vers le navigateur. Dans la grande majorité des cas, il s'agit de pages HTML, mais également du JSON, XML ou autres...

## Prérequis

## Arborescence et cache

## Les variables

## Les layouts
Les layouts sont le squelette de vos pages web, ils permettent d'organiser entre autre les entêtes, pieds de page, appel CSS & JS, les menus et arrière plan de votre page web.

Voici un exemple de layout :
```html
<!DOCTYPE html>
<html lang="fr">
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="shortcut icon" href="https://fr.4d.com/sites/all/themes/bactency/favicon.ico">
		<title><!--#4DTEXT pageWeb_o.titre--> | Composant cioWeb</title>

		<!--#4DHTML pageWeb_o.cssGetHtmlPath()-->

	</head>
	<body>
		<div class="cover-container d-flex h-100 p-3 mx-auto flex-column">
			<header class="masthead mb-auto">
				<div class="inner">
					<h3 class="masthead-brand" style="font-family: Ubuntu;">Connect <span style="color: #82E83F;">IO</span></h3>
					<nav class="nav nav-masthead justify-content-center">
						<a class="nav-link active" href="<!--4DSCRIPT/cwLibToUrl/index-->">Accueil</a>
						<a class="nav-link" href="https://github.com/connect-io/cioWeb.4dbase" target="_blank">Suivre le projet sur github</a>
						<a class="nav-link" href="mailto:contact@connect-io.fr">Contact</a>
					</nav>
				</div>
			</header>

			<!--#4DHTML pageWeb_o.corps-->

			<footer class="mastfoot mt-auto">
				<div class="inner">
					<p>Composant cioWeb, par <a href="http://www.connect-io.fr">Connect IO</a>.</p>
				</div>
			</footer>
		</div>
		
		<!--#4DHTML cwJsGetfile-->
		<!--#4DSCRIPT/cwIncludePageHtml/_cioWeb/view/notification.html-->
		
		<script>
			<!--#4DHTML string(pageWeb_o.jsInHtml_t)-->
		</script>

	</body>


</html>
```



## Les vues parents

## Les Notifications
### Configuration des notifications
Les notifications permettent d'ajouter des petits pop-up sur la page web du visiteur pour lui notifier d'une alerte, une information, une erreur ou une étape réussite.  
Les notifications utilisent Toastr : https://github.com/CodeSeven/toastr

Pour utiliser les notifications merci de vérifier :

La présence du fichier ```Sources/VotreSousDomaine/_cioWeb/view/notification.html``` au besoin vous pourrez le récupérer [ici](https://github.com/connect-io/cioWeb.4dbase/blob/18R3-source/Resources/modelSources/_cioWeb/view/notification.html), c'est également dans ce fichier que vous pourrez personnaliser vos notifications.

Les appels CSS et JS dans votre route du layout :
```json
"cssPath": [
    "https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css"

],
"jsPath": [
    "https://code.jquery.com/jquery-3.5.1.min.js",
    "https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"
]
```

L'appel de la génération du code HTML, cette ligne est à placer dans votre layout après les instructions en javascript :
```html
<!--#4DSCRIPT/cwIncludePageHtml/_cioWeb/view/notification.html-->
```

### Utilisation des notifications
Vous pouvez maintenant générer simplement une alerte depuis une méthode 4D :
```4d
  // Affichage d'une notification de succès
visiteur_o.notificationSuccess:="Votre demande est bien prise en compte."

  // Affichage d'une notification d'erreur
visiteur_o.notificationError:="Vous n'avez pas accès à cette page."

  // Affichage d'une notification d'alerte
visiteur_o.notificationWarning:="Attention le champ prénom est obligatoire."

  // Affichage d'une notification d'information
visiteur_o.notificationInfo:="Vous avez reçu un nouveau paiement."
```

Pour rappel, les variables du visiteur concernant les notifications sont réinitialisées à chaque chargement de page.

## Les blocks

## L'ajout de javascript avec balise 4D.
<!--#4DHTML string(pageWeb_o.jsInHtml_t)-->
