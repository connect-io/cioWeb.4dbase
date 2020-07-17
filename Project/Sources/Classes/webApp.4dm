/* 
Class : webApp

Cette class permet de centraliser toutes les données de l'application web.

*/


/* ----------------------------------------------------
Fonction : webApp.constructor

Initialisation d'un utilisateur

Historique
08/12/19 - Grégory Fromain <gregory@connect-io.fr> - Création
08/12/19 - Grégory Fromain <gregory@connect-io.fr> - Les fichiers de routing sont triés par ordre croissant
08/12/19 - Grégory Fromain <gregory@connect-io.fr> - Réorganisation des dossiers sous forme de WebApp
15/08/20 - Grégory Fromain <gregory@connect-io.fr> - Suppression de <>webApp_o.config.webAppOld
-----------------------------------------------------*/
Class constructor
	
	C_OBJECT:C1216($source_o)  // dossier sources
	C_TEXT:C284($subDomain_t)  // Nom du sous domaine
	C_OBJECT:C1216($folderSubDomaine_o)  // Dossier du sous domaine.
	
	This:C1470.config:=New object:C1471
	This:C1470.config.folderName_o:=New object:C1471
	This:C1470.config.folderName_o.webApp:="WebApp"
	This:C1470.config.folderName_o.source:="Sources"
	This:C1470.config.folderName_o.webFolder:="WebFolder"
	This:C1470.config.folderName_o.viewCache:="View"
	
	  // Objet des datas pour les sesssions.
	This:C1470.sessionWeb:=New object:C1471
	
	  // Objet des datas pour les sites.
	This:C1470.sites:=New object:C1471
	
	  // Nom de la variable visiteur dans l'application hôte.
	This:C1470.config.varVisitorName_t:="visiteur_o"
	
	  // ----- Gestion du dossier source -----
	  // On vérifie que le dossier existe.
	$source_o:=Folder:C1567(This:C1470.sourcePath();fk platform path:K87:2)
	If ($source_o.isFolder)
		$source_o.create()
	End if 
	
	  // On regarde si des sous-domaines sont inialisés.
	If ($source_o.folders().length=0)
		$subDomain_t:=Request:C163("indiquez le sous domaine du site à creer ?";"www")
		If (ok=1)
			  // On crée le repertoire du nouveau sous domaine.
			$source_o.folder($subDomain_t).create()
			
			  // On ajoute quelques fichiers de démo.
			Folder:C1567(fk resources folder:K87:11).folder("modelSources").folder("_cioWeb").copyTo($source_o.folder($subDomain_t);fk overwrite:K87:5)
			Folder:C1567(fk resources folder:K87:11).folder("modelSources").folder("helloWord").copyTo($source_o.folder($subDomain_t);fk overwrite:K87:5)
			Folder:C1567(fk resources folder:K87:11).folder("modelSources").folder("layout").copyTo($source_o.folder($subDomain_t);fk overwrite:K87:5)
			Folder:C1567(fk resources folder:K87:11).folder("modelSources").folder("main").copyTo($source_o.folder($subDomain_t);fk overwrite:K87:5)
		End if 
	End if 
	
	  // On récupére la liste des sous-domaines de l'application.
	This:C1470.config.subDomain_c:=$source_o.folders().extract("name")
	
	  // On créer les objets qui auront les datas des differents site. (route, form, dataTable,...)
	For each ($subDomain_t;This:C1470.config.subDomain_c)
		If (This:C1470.sites[$subDomain_t]=Null:C1517)
			This:C1470.sites[$subDomain_t]:=New object:C1471
		End if 
	End for each 
	
	
	  // ----- Chargement du fichier de config -----
	  // On vérifie qu'il existe bien un fichier de config pour l'utilisation du composant dans la base hôte.
	If (Not:C34($source_o.file("config.json").exists))
		$source_o.file("config.json").setText("{}")
	End if 
	
	  // On charge le fichier de config et on refusionne les data avec les informations précédentes.
	$config_o:=cwToolObjectMerge (This:C1470;JSON Parse:C1218($source_o.file("config.json").getText()))
	
	For each ($propriete_t;$config_o)
		This:C1470[$propriete_t]:=$config_o[$propriete_t]
	End for each 
	
	
	  // ----- Gestion du webfolder -----
	  // On vérifie que le repertoire WebFolder existe dans le dossier WebApp
	  // On fixe le dossier racine
	If (Count parameters:C259=1)
		WEB SET ROOT FOLDER:C634($1)
	Else 
		
		WEB SET ROOT FOLDER:C634(This:C1470.webAppPath()+This:C1470.config.folderName_o.webFolder+Folder separator:K24:12)
	End if 
	
	If (Test path name:C476(Get 4D folder:C485(HTML Root folder:K5:20;*))#Is a folder:K24:2)
		  // Il n'existe pas... On crée le dossier avec son arborescence.
		CREATE FOLDER:C475(Get 4D folder:C485(HTML Root folder:K5:20;*);*)
	End if 
	
	  // Creation du dossier upload par defaut dans le dossier web public
	  // La 1er lettre du nom du fichier n'est pas en majuscule, car c'est moins esthétique dans une URL
	If (Test path name:C476(Get 4D folder:C485(HTML Root folder:K5:20;*)+"uploads"+Folder separator:K24:12)#Is a folder:K24:2)
		CREATE FOLDER:C475(Get 4D folder:C485(HTML Root folder:K5:20;*)+"uploads"+Folder separator:K24:12;*)
	End if 
	
	  // Controle sur les sous domaine
	For each ($subDomain_t;This:C1470.config.subDomain_c)
		  // On récupére des infos sur le dossier web du sous domaine.
		$folderSubDomaine_o:=Folder:C1567(This:C1470.webfolderSubdomainPath($subDomain_t);fk platform path:K87:2)
		
		  // Si il existe pas, on lui crée une petite arborescense.
		If (Not:C34($folderSubDomaine_o.exists))
			$folderSubDomaine_o.create()
		End if 
		
		If (Not:C34($folderSubDomaine_o.folder("css").exists))
			$folderSubDomaine_o.folder("css").create()
		End if 
		
		If (Not:C34($folderSubDomaine_o.folder("img").exists))
			$folderSubDomaine_o.folder("img").create()
		End if 
		
		If (Not:C34($folderSubDomaine_o.folder("js").exists))
			$folderSubDomaine_o.folder("js").create()
		End if 
	End for each 
	
	
	  // ----- Gestion des vues en cache -----
	  // On vérifie que le repertoire Pages existe dans le dossier Cache de l'application hôte.
	  // Et donc implicitement les dossiers WebApp, Cache et View
	If (Test path name:C476(This:C1470.cacheViewPath())#Is a folder:K24:2)
		  // Il n'existe pas... On crée le dossier avec son arborescence.
		CREATE FOLDER:C475(This:C1470.cacheViewPath();*)
	End if 
	
	  // Controle sur les sous domaine
	For each ($subDomain_t;This:C1470.config.subDomain_c)
		  // On récupére des infos sur le dossier web du sous domaine.
		$folderSubDomaine_o:=Folder:C1567(This:C1470.cacheViewSubdomainPath($subDomain_t);fk platform path:K87:2)
		
		  // Si il existe pas, on lui crée une petite arborescense.
		If (Not:C34($folderSubDomaine_o.exists))
			$folderSubDomaine_o.create()
		End if 
	End for each 
	
	
	
/* ----------------------------------------------------
Fonction : webApp.webAppPath
	
Chemin du dossier WebApp
	
Historique
16/08/20 - Grégory Fromain <gregory@connect-io.fr> - Création
-----------------------------------------------------*/
Function webAppPath
	C_TEXT:C284($0)
	$0:=cwToolPathFolderOrAlias (Get 4D folder:C485(Database folder:K5:14;*))+This:C1470.config.folderName_o.webApp+Folder separator:K24:12
	
	
	
/* ----------------------------------------------------
Fonction : webApp.sourcePath
	
Chemin du dossier Source
	
Historique
16/08/20 - Grégory Fromain <gregory@connect-io.fr> - Création
-----------------------------------------------------*/
Function sourcePath
	C_TEXT:C284($0)  // Chemin du dossier source
	
	$0:=This:C1470.webAppPath()+This:C1470.config.folderName_o.source+Folder separator:K24:12
	
	
	
/* ----------------------------------------------------
Fonction : webApp.sourceSubdomainPath
	
Chemin du dossier Source/sousDomaine
	
Historique
16/08/20 - Grégory Fromain <gregory@connect-io.fr> - Création
-----------------------------------------------------*/
Function sourceSubdomainPath
	C_TEXT:C284($1)  //Nom du sous domaine
	C_TEXT:C284($0)
	C_TEXT:C284($sousDomaine_t)
	
	If (Count parameters:C259=1)
		$sousDomaine_t:=$1
	Else 
		$sousDomaine_t:=visiteur.sousDomaine
	End if 
	
	$0:=This:C1470.sourcePath()+$sousDomaine_t+Folder separator:K24:12
	
	
	
/* ----------------------------------------------------
Fonction : webApp.webfolderSubdomainPath
	
Chemin du dossier Webfolder/sousDomaine
	
Historique
16/08/20 - Grégory Fromain <gregory@connect-io.fr> - Création
-----------------------------------------------------*/
Function webfolderSubdomainPath
	C_TEXT:C284($1)  //Nom du sous domaine
	C_TEXT:C284($0)
	C_TEXT:C284($sousDomaine_t)
	
	If (Count parameters:C259=1)
		$sousDomaine_t:=$1
	Else 
		$sousDomaine_t:=visiteur.sousDomaine
	End if 
	
	$0:=Get 4D folder:C485(HTML Root folder:K5:20;*)+$sousDomaine_t+Folder separator:K24:12
	
	
	
/* ----------------------------------------------------
Fonction : webApp.cachePath
	
Chemin du dossier cache
	
Historique
16/08/20 - Grégory Fromain <gregory@connect-io.fr> - Création
-----------------------------------------------------*/
Function cachePath
	C_TEXT:C284($0)
	
	$0:=This:C1470.webAppPath()+"Cache"+Folder separator:K24:12
	
	
	
/* ----------------------------------------------------
Fonction : webApp.cacheViewPath
	
Chemin du dossier cache des vues
	
Historique
16/08/20 - Grégory Fromain <gregory@connect-io.fr> - Création
-----------------------------------------------------*/
Function cacheViewPath
	C_TEXT:C284($0)
	
	$0:=This:C1470.cachePath()+This:C1470.config.folderName_o.viewCache+Folder separator:K24:12
	
	
	
/* ----------------------------------------------------
Fonction : webApp.cacheViewSubdomainPath
	
Chemin du dossier cache des vues / sousDomaine
	
Historique
16/08/20 - Grégory Fromain <gregory@connect-io.fr> - Création
-----------------------------------------------------*/
Function cacheViewSubdomainPath
	C_TEXT:C284($1)  // Nom du sous domaine
	C_TEXT:C284($0)  // Chemin
	C_TEXT:C284($sousDomaine_t)
	
	If (Count parameters:C259=1)
		$sousDomaine_t:=$1
	Else 
		$sousDomaine_t:=visiteur.sousDomaine
	End if 
	
	$0:=This:C1470.cacheViewPath()+$sousDomaine_t+Folder separator:K24:12
	
	
	
/* ----------------------------------------------------
Fonction : webApp.serverStart
	
Démérrage du serveur web
	
Historique
16/08/20 - Grégory Fromain <gregory@connect-io.fr> - Création
-----------------------------------------------------*/
Function serverStart
	cwWebAppServerStart 
	cwWebAppFormPreload 
	cwWebAppFuncDataTablePreload 
	  //cwI18nLoad 
	
	
	
/* ----------------------------------------------------
Fonction : webApp.jsMinify
	
Minification du javascript
	
Historique
16/04/12 - Grégory Fromain <gregory@connect-io.fr> - Création
21/12/19 - Grégory Fromain <gregory@connect-io.fr> - Ajout de la possibilité de créer une arborescence dans les fichiers JS.
16/07/20 - Grégory Fromain <gregory@connect-io.fr> - Convertion en fonction de la class webApp
-----------------------------------------------------*/
Function jsMinify
	C_TEXT:C284($texteIn;$dirIn;$dirOut)
	C_BOOLEAN:C305($compression)
	C_TEXT:C284($subDomain_t)  // Nom du sous domaine
	
	For each ($subDomain_t;This:C1470.config.subDomain_c)
		  //Le dossier avec le js non minifié.
		$dirIn:=This:C1470.sourceSubdomainPath($subDomain_t)
		
		  //Le dossier avec les javascripts minimifié.
		$dirOut:=This:C1470.webfolderSubdomainPath($subDomain_t)+"js"+Folder separator:K24:12
		
		  //On recupere la liste des documents dans le répertoire.
		DOCUMENT LIST:C474($dirIn;$fichierHtmlIn;Recursive parsing:K24:13)
		
		For ($i;1;Size of array:C274($fichierHtmlIn))
			If ($fichierHtmlIn{$i}="@.js")
				$compression:=True:C214
				
			Else 
				$compression:=False:C215
			End if 
			
			If ($compression)
				  // Dans le cas d'un fichier dans un sous dossier, il faut supprimer le séparateur.
				If ($fichierHtmlIn{$i}=(Folder separator:K24:12+"@"))
					$fichierHtmlIn{$i}:=Substring:C12($fichierHtmlIn{$i};2)
					  // Si besoin on crée le dossier dans le repertoire de destination.
					CREATE FOLDER:C475($dirOut+$fichierHtmlIn{$i};*)
				End if 
				
				  //Sauf si le dossier compressé existe deja et qu'il est plus jeune que le fichier d'origine.
				If (Test path name:C476($dirOut+$fichierHtmlIn{$i})=Is a document:K24:1)
					GET DOCUMENT PROPERTIES:C477($dirIn+$fichierHtmlIn{$i};$verrouilleIn;$invisibleIn;$creeLeIn;$creeAIn;$modifieLeIn;$modifieAIn)
					GET DOCUMENT PROPERTIES:C477($dirOut+$fichierHtmlIn{$i};$verrouilleOut;$invisibleOut;$creeLeOut;$creeAOut;$modifieLeOut;$modifieAOut)
					
					Case of 
						: ($modifieLeIn<$modifieLeOut)
							$compression:=False:C215
						: ($modifieLeIn=$modifieLeOut) & ($modifieAIn<$modifieAOut)
							$compression:=False:C215
					End case 
					
					If ($compression)
						  //Il faut donc faire la minification et l'ancien fichier existe.
						  //On le suppprime donc.
						DELETE DOCUMENT:C159($dirOut+$fichierHtmlIn{$i})
					End if 
				End if 
			End if 
			
			If ($compression)
				
				$texteIn:=Document to text:C1236($dirIn+$fichierHtmlIn{$i};"UTF-8")
				TEXT TO DOCUMENT:C1237($dirOut+$fichierHtmlIn{$i};cwMinifier ($texteIn);"UTF-8")  //Et on creer le nouvau fichier.
			End if 
		End for 
		
	End for each 
	
	
	
/* ----------------------------------------------------
Fonction : webApp.htmlMinify
	
Minification du HTML
	
Historique
16/04/12 - Grégory Fromain <gregory@connect-io.fr> - Création
21/12/19 - Grégory Fromain <gregory@connect-io.fr> - Ajout de la possibilité de créer une arborescence dans les fichiers des pages html.
16/07/20 - Grégory Fromain <gregory@connect-io.fr> - Convertion en fonction de la class webApp
-----------------------------------------------------*/
Function htmlMinify
	C_TEXT:C284($texteIn;$texteOut;$dirIn;$dirOut)
	C_BOOLEAN:C305($compression)
	C_TEXT:C284($subDomain_t)  // Nom du sous domaine
	
	For each ($subDomain_t;This:C1470.config.subDomain_c)
		  //Le dossier avec le html non minifié.
		$dirIn:=This:C1470.sourceSubdomainPath($subDomain_t)
		
		  //Le dossier avec le html minifié.
		$dirOut:=This:C1470.cacheViewSubdomainPath($subDomain_t)
		
		  //On recupere la liste des documents dans le répertoire.
		DOCUMENT LIST:C474($dirIn;$fichierHtmlIn;Recursive parsing:K24:13)
		
		For ($i;1;Size of array:C274($fichierHtmlIn))
			
			If ($fichierHtmlIn{$i}="@.html")
				$compression:=True:C214
				
			Else 
				$compression:=False:C215
			End if 
			
			If ($compression)
				  // Dans le cas d'un fichier dans un sous dossier, il faut supprimer le séparateur.
				If ($fichierHtmlIn{$i}=(Folder separator:K24:12+"@"))
					$fichierHtmlIn{$i}:=Substring:C12($fichierHtmlIn{$i};2)
					  //Si besoin on creer le dossier dans le repertoire de destination...
					CREATE FOLDER:C475($dirOut+$fichierHtmlIn{$i};*)
				End if 
				
				  //Sauf si le dossier compressé existe deja et qu'il est plus jeune que le fichier d'origine.
				If (Test path name:C476($dirOut+$fichierHtmlIn{$i})=Is a document:K24:1)
					GET DOCUMENT PROPERTIES:C477($dirIn+$fichierHtmlIn{$i};$verrouilleIn;$invisibleIn;$creeLeIn;$creeAIn;$modifieLeIn;$modifieAIn)
					GET DOCUMENT PROPERTIES:C477($dirOut+$fichierHtmlIn{$i};$verrouilleOut;$invisibleOut;$creeLeOut;$creeAOut;$modifieLeOut;$modifieAOut)
					
					Case of 
						: ($modifieLeIn<$modifieLeOut)
							$compression:=False:C215
						: ($modifieLeIn=$modifieLeOut) & ($modifieAIn<$modifieAOut)
							$compression:=False:C215
					End case 
					
					If ($compression)
						  //Il faut donc faire la minification et l'ancien fichier existe.
						  //On le suppprime donc.
						DELETE DOCUMENT:C159($dirOut+$fichierHtmlIn{$i})
					End if 
				End if 
			End if 
			
			If ($compression)
				
				$texteIn:=Document to text:C1236($dirIn+$fichierHtmlIn{$i};"UTF-8")
				ASSERT:C1129(Length:C16($texteIn)#0;"Impossible de charger le fichier : "+$dirIn+$fichierHtmlIn{$i})
				$texteOut:=Replace string:C233(cwMinifier ($texteIn);"\n";"")
				
				  // On retire les commentaires HTML mais pas les balises 4D.
				  //$texteOut:=cwToolTextReplaceByRegex ($texteOut;"<!-- (.*?)-->";"")
				
				  // On vérifie les espace insécable.
				$texteOut:=Replace string:C233($texteOut;" ;";Char:C90(160)+";")
				$texteOut:=Replace string:C233($texteOut;" ?";Char:C90(160)+"?")
				$texteOut:=Replace string:C233($texteOut;" !";Char:C90(160)+"!")
				$texteOut:=Replace string:C233($texteOut;" :";Char:C90(160)+":")
				$texteOut:=Replace string:C233($texteOut;" %";Char:C90(160)+"%")
				$texteOut:=Replace string:C233($texteOut;" €";Char:C90(160)+"€")
				
				TEXT TO DOCUMENT:C1237($dirOut+$fichierHtmlIn{$i};$texteOut;"UTF-8")  //Et on creer le nouvau fichier.
			End if 
		End for 
	End for each 
	
	
	
/* ----------------------------------------------------
Fonction : webApp.pageCurrent
	
Chargement des éléments de la page courante
	
Historique
16/07/20 - Grégory Fromain <gregory@connect-io.fr> - Création
-----------------------------------------------------*/
Function pageCurrent
	C_OBJECT:C1216($1;$user_o)  // instance de user
	C_OBJECT:C1216($0)  // Instance de la page courante
	C_COLLECTION:C1488(siteRoute_c)
	C_COLLECTION:C1488(siteForm_c)
	C_COLLECTION:C1488(siteDataTable_c)
	C_TEXT:C284(cachePath_t)
	
	$user_o:=$1
	
	  // En attendant de faire mieux, je passe la variable en process
	siteRoute_c:=This:C1470.sites[$user_o.sousDomaine].route.copy()
	
	$0:=cs:C1710.page.new(siteRoute_c;$1)
	
	  // Petit hack pour les formulaires en attendant des jours meilleurs.
	siteForm_c:=This:C1470.sites[$user_o.sousDomaine].form
	
	  // Petit hack pour les datatables en attendant des jours meilleurs.
	siteDataTable_c:=This:C1470.sites[$user_o.sousDomaine].dataTable
	
	  // en attendant de faire mieux
	cachePath_t:=This:C1470.cacheViewSubdomainPath()
	
	
	
/* ----------------------------------------------------
Fonction : webApp.cacheSessionWebPath
	
Chemin des sessions Web
	
Historique
16/07/20 - Grégory Fromain <gregory@connect-io.fr> - Création
-----------------------------------------------------*/
Function cacheSessionWebPath
	C_TEXT:C284($1)  // (Optionel) Forcer le chemin par defaut.
	C_TEXT:C284($0)  // Chemin des sessions web
	
	If (This:C1470.sessionWeb.path=Null:C1517)
		This:C1470.sessionWeb.path:=This:C1470.cachePath()+"SessionWeb"+Folder separator:K24:12
	End if 
	
	  // Si il y a un param c'est que l'on souhaite definir un nouveau chemin pour les sessions.
	If (Count parameters:C259=1)
		If (String:C10($1)#"")
			This:C1470.sessionWeb.path:=$1
		Else 
			  // On reset le chemin pas defaut.
			This:C1470.sessionWeb.path:=This:C1470.cachePath()+"SessionWeb"+Folder separator:K24:12
		End if 
	End if 
	
	  // Dans tout les cas, on retourne un chemin
	$0:=This:C1470.sessionWeb.path
	
	
	
/* ----------------------------------------------------
Fonction : webApp.sessionWebStart
	
Démarrage des sessions Web
	
Historique
30/07/19 - Grégory Fromain <gregory@connect-io.fr> - Création
16/07/20 - Grégory Fromain <gregory@connect-io.fr> - Conversion en fonction
-----------------------------------------------------*/
Function sessionWebStart
	C_COLLECTION:C1488($1;$options_c)  // Option, option du serveur web
	C_OBJECT:C1216($0;$option_o)
	
	C_LONGINT:C283($valideMinute_l;$refProcess_l)
	C_DATE:C307($creerLe_d;$modifierLe_d;$dernierJourValide_d)
	C_TIME:C306($creerA_t;$modifierA_t)
	C_BOOLEAN:C305($verrou_b;$invisible_b)
	ARRAY TEXT:C222($listeSessionWeb_t;0)
	C_OBJECT:C1216($infoFichier_o)
	
	
	  // On applique quelques valeurs par defaut, pour que cela fonctionne même sans param.
	$options_c:=New collection:C1472
	$options_c.push(New object:C1471("key";Web session cookie name:K73:4;"value";"CIOSID"))  // nom du cookies de la session
	$options_c.push(New object:C1471("key";Web inactive session timeout:K73:3;"value";30*24*60))  // 30 jours, en minute
	$options_c.push(New object:C1471("key";Web inactive process timeout:K73:13;"value";60))
	$options_c.push(New object:C1471("key";Web max sessions:K73:2;"value";200))
	$options_c.push(New object:C1471("key";Web Session IP address validation enabled:K73:17;"value";0))
	$options_c.push(New object:C1471("key";Web keep session:K73:1;"value";1))
	
	  // Puis l'on vient combiner avec les informations 
	If (Count parameters:C259>=1)
		If (Type:C295($1)=Is collection:K8:32)
			
			$options_c:=$options_c.query("NOT (key IN :1)";$1.extract("key"))
			$options_c.combine($1)
		End if 
	End if 
	
	  // Pour les options il suffit de faire une boucle
	For each ($option_o;$options_c)
		WEB SET OPTION:C1210($option_o.key;$option_o.value)
	End for each 
	
	
	  // On test que le dossier des sessions web existe bien, sinon on le crée.
	If (Test path name:C476(This:C1470.cacheSessionWebPath())#Is a folder:K24:2)
		CREATE FOLDER:C475(This:C1470.cacheSessionWebPath();*)
		If (ok=0)
			ALERT:C41("Impossible de créer le dossier des sessions Web : "+This:C1470.cacheSessionWebPath())
			
			  // Il y a une erreur dans le dossier des sessions web, on va mettre le chemin par defaut avec le param "" et le créer au besoin.
			CREATE FOLDER:C475(This:C1470.cacheSessionWebPath("");*)
		End if 
	End if 
	
	
	  // On va conserver des informations importantes a porté de main...
	This:C1470.sessionWeb.name:=$options_c.query("key IS :1";Web session cookie name:K73:4)[0].value
	
	
	  // ----- Nettoyage des sessions périmée -----
	  // On en profite pour nettoyer les sessions périmées...
	MESSAGE:C88("Nettoyage des sessions web")
	
	$valideMinute_l:=$options_c.query("key IS :1";Web inactive session timeout:K73:3)[0].value
	This:C1470.sessionWeb.valideDay:=Int:C8($valideMinute_l/60/24)
	
	
	DOCUMENT LIST:C474(This:C1470.cacheSessionWebPath();$listeSessionWeb_t;Recursive parsing:K24:13+Absolute path:K24:14)
	$dernierJourValide_d:=Current date:C33-Num:C11(This:C1470.sessionWeb.valideDay)
	For ($i;1;Size of array:C274($listeSessionWeb_t))
		  // On verifie une derniere fois que le fichier existe,
		  // Possibilité d'être supprimé par un autre process parallele...
		If (Test path name:C476($listeSessionWeb_t{$i})=Is a document:K24:1)
			GET DOCUMENT PROPERTIES:C477($listeSessionWeb_t{$i};$verrou_b;$invisible_b;$creerLe_d;$creerA_t;$modifierLe_d;$modifierA_t)
			
			If ($creerLe_d<$dernierJourValide_d)
				  //Il faut le supprimer, mais avant l'on regarde si il n'a pas un dossier temporaire associé.
				$infoFichier_o:=Path to object:C1547($listeSessionWeb_t{$i})
				
				  // c'est un dossier qui porte le même nom que le fichier mais sans extension.
				$infoFichier_o.folderTemp:=$infoFichier_o.parentFolder+$infoFichier_o.name+Folder separator:K24:12
				
				If (Test path name:C476($infoFichier_o.folderTemp)=Is a folder:K24:2)
					DELETE FOLDER:C693($infoFichier_o.folderTemp;Delete with contents:K24:24)
				End if 
				
				  // Maintenant on supprime le fichier de session
				DELETE DOCUMENT:C159($listeSessionWeb_t{$i})
			End if 
		End if 
		
	End for 
	
	  // Et on retourne les infos pour l'application
	$0:=This:C1470.sessionWeb
	
	
	
/* ----------------------------------------------------
Fonction : webApp.userNew
	
Chargement des éléments sur l'utilisateur / visiteur
	
Historique
16/07/20 - Grégory Fromain <gregory@connect-io.fr> - Création
-----------------------------------------------------*/
Function userNew
	C_OBJECT:C1216($0)  // Instance de l'utilisateur en cours
	
	C_OBJECT:C1216($infoWebApp_o)
	$infoWebApp_o:=New object:C1471()
	$infoWebApp_o.sessionWeb:=This:C1470.sessionWeb
	
	$0:=cs:C1710.user.new($infoWebApp_o)
	
	