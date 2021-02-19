/* 
Class : cs.WebApp

Cette class permet de centraliser toutes les données de l'application web.

*/


Class constructor
/* -----------------------------------------------------------------------------
Fonction : WebApp.constructor
	
Initialisation de l'application web
	
Historique
08/12/19 - Grégory Fromain <gregory@connect-io.fr> - Création
08/12/19 - Grégory Fromain <gregory@connect-io.fr> - Les fichiers de routing sont triés par ordre croissant
08/12/19 - Grégory Fromain <gregory@connect-io.fr> - Réorganisation des dossiers sous forme de WebApp
15/08/20 - Grégory Fromain <gregory@connect-io.fr> - Suppression de <>webApp_o.param.webAppOld
01/10/20 - Grégory Fromain <gregory@connect-io.fr> - Ajout des fichiers de config au format JSONC.
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
29/11/20 - Grégory Fromain <gregory@connect-io.fr> - Création automatique de custom.css si besoin.
-----------------------------------------------------------------------------*/
	
	var $source_o : Object  // dossier sources
	var $subDomain_t : Text  // Nom du sous domaine
	var $folderSubDomaine_o : Object  // Dossier du sous domaine.
	var $resultat_i : Integer
	
	Use (Storage:C1525)
		Storage:C1525.sites:=New shared object:C1526
		Storage:C1525.config:=New shared object:C1526
		Storage:C1525.param:=New shared object:C1526
		
		// Objet des datas pour les sesssions.
		Storage:C1525.sessionWeb:=New shared object:C1526
	End use 
	
	Use (Storage:C1525.param)
		// Nom de la variable visiteur dans l'application hôte.
		Storage:C1525.param.varVisitorName_t:="visiteur_o"
		
		Storage:C1525.param.folderPath:=New shared object:C1526
	End use 
	
	// Chemin des répertoires de base
	Use (Storage:C1525.param.folderPath)
		Storage:C1525.param.folderPath.webApp_t:=Get 4D folder:C485(Database folder:K5:14; *)+"WebApp"+Folder separator:K24:12
		Storage:C1525.param.folderPath.source_t:=Storage:C1525.param.folderPath.webApp_t+"Sources"+Folder separator:K24:12
		Storage:C1525.param.folderPath.webFolder_t:=Storage:C1525.param.folderPath.webApp_t+"WebFolder"+Folder separator:K24:12
		Storage:C1525.param.folderPath.cache_t:=Storage:C1525.param.folderPath.webApp_t+"Cache"+Folder separator:K24:12
		Storage:C1525.param.folderPath.cacheView_t:=Storage:C1525.param.folderPath.cache_t+"View"+Folder separator:K24:12
	End use 
	
	
	// ----- Gestion du dossier source -----
	// On vérifie que le dossier existe.
	$source_o:=Folder:C1567(Storage:C1525.param.folderPath.source_t; fk platform path:K87:2)
	If ($source_o.isFolder)
		$source_o.create()
	End if 
	
	// On regarde si des sous-domaines sont inialisés.
	If ($source_o.folders().length=0)
		$subDomain_t:=Request:C163("indiquez le sous domaine du site à creer ?"; "www")
		If (ok=1)
			// On crée le repertoire du nouveau sous domaine et l'on ajoute quelques fichiers de démo.
			Folder:C1567(fk resources folder:K87:11).folder("modelSources").copyTo($source_o; $subDomain_t)
		End if 
	End if 
	
	// On récupére la liste des sous-domaines de l'application.
	Use (Storage:C1525.param)
		Storage:C1525.param.subDomain_c:=$source_o.folders().extract("name").copy(ck shared:K85:29)
	End use 
	
	// On créer les objets qui auront les datas des differents site. (route, form, dataTable,...)
	For each ($subDomain_t; Storage:C1525.param.subDomain_c)
		If (Storage:C1525.sites[$subDomain_t]=Null:C1517)
			Use (Storage:C1525.sites)
				Storage:C1525.sites[$subDomain_t]:=New shared object:C1526
			End use 
		End if 
	End for each 
	
	
	// ----- Chargement du fichier de config -----
	MESSAGE:C88("Chargement du fichier de config..."+Char:C90(Carriage return:K15:38))
	Case of 
			// Si il existe un fichier de config dans l'ancien format, on le renome.
		: ($source_o.file("config.json").exists)
			$source_o.file("config.json").rename("config.jsonc")
			
		: (Not:C34($source_o.file("config.jsonc").exists))
			// Il n'existe pas de fichier de configuration pour l'utilisation du composant dans la base hôte, on le crée
			$source_o.file("config.jsonc").setText("{}")
	End case 
	
	// On charge le fichier de config et on refusionne les data avec les informations précédentes.
	$config_o:=cwToolObjectFromFile($source_o.file("config.jsonc"))
	
	// A supprimer le jour ou toutes les app seront préemptif
	For each ($propriete_t; $config_o)
		This:C1470[$propriete_t]:=$config_o[$propriete_t]
	End for each 
	
	Use (Storage:C1525)
		Storage:C1525.config:=OB Copy:C1225($config_o; ck shared:K85:29)
	End use 
	
	// ----- Gestion du webfolder -----
	MESSAGE:C88("Validation du webfolder..."+Char:C90(Carriage return:K15:38))
	
	// On vérifie que le repertoire WebFolder existe dans le dossier WebApp
	// On fixe le dossier racine
	If (Count parameters:C259=1)
		WEB SET ROOT FOLDER:C634($1)
		Use (Storage:C1525.param.folderPath)
			Storage:C1525.param.folderPath.webFolder_t:=$1
		End use 
	Else 
		
		WEB SET ROOT FOLDER:C634(Storage:C1525.param.folderPath.webFolder_t)
	End if 
	
	If (Test path name:C476(Get 4D folder:C485(HTML Root folder:K5:20; *))#Is a folder:K24:2)
		// Il n'existe pas... On crée le dossier avec son arborescence.
		CREATE FOLDER:C475(Get 4D folder:C485(HTML Root folder:K5:20; *); *)
	End if 
	
	// Creation du dossier upload par defaut dans le dossier web public
	// La 1er lettre du nom du fichier n'est pas en majuscule, car c'est moins esthétique dans une URL
	If (Test path name:C476(Get 4D folder:C485(HTML Root folder:K5:20; *)+"uploads"+Folder separator:K24:12)#Is a folder:K24:2)
		CREATE FOLDER:C475(Get 4D folder:C485(HTML Root folder:K5:20; *)+"uploads"+Folder separator:K24:12; *)
	End if 
	
	// Controle sur les sous domaine
	For each ($subDomain_t; Storage:C1525.param.subDomain_c)
		// On récupére des infos sur le dossier web du sous domaine.
		$folderSubDomaine_o:=Folder:C1567(This:C1470.webfolderSubdomainPath($subDomain_t); fk platform path:K87:2)
		
		// Si il existe pas, on lui crée une petite arborescense.
		If (Not:C34($folderSubDomaine_o.exists))
			$folderSubDomaine_o.create()
		End if 
		
		If (Not:C34($folderSubDomaine_o.folder("css").exists))
			$folderSubDomaine_o.folder("css").create()
		End if 
		
		// On ajoute un fichier custom.css pour chaque domaine, il sera inséré automatiquement dans chaque page en dernier.
		If (Not:C34($folderSubDomaine_o.folder("css").file("custom.css").exists))
			$folderSubDomaine_o.folder("css").file("custom.css").create()
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
	If (Test path name:C476(Storage:C1525.param.folderPath.cacheView_t)#Is a folder:K24:2)
		// Il n'existe pas... On crée le dossier avec son arborescence.
		CREATE FOLDER:C475(Storage:C1525.param.folderPath.cacheView_t; *)
	End if 
	
	// Controle sur les sous domaine
	For each ($subDomain_t; Storage:C1525.param.subDomain_c)
		// On récupére des infos sur le dossier web du sous domaine.
		$folderSubDomaine_o:=Folder:C1567(This:C1470.cacheViewSubdomainPath($subDomain_t); fk platform path:K87:2)
		
		// Si il existe pas, on lui crée une petite arborescense.
		If (Not:C34($folderSubDomaine_o.exists))
			$folderSubDomaine_o.create()
		End if 
	End for each 
	
	
	
Function cachePath()
/* -----------------------------------------------------------------------------
Fonction : WebApp.cachePath
	
Chemin complet plateforme du dossier cache
	
Historique
16/08/20 - Grégory Fromain <gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
19/02/21 - Grégory Fromain <gregory@connect-io.fr> - Fonction obsolette
-----------------------------------------------------------------------------*/
	
	var $cheminObjet_t; $message_t : Text
	
	$cheminObjet_t:="param.folderPath.cache_t"
	
	$message_t:="WebApp.cachePath() : Cette fonction est obsolette."+Char:C90(Carriage return:K15:38)\
		+"Merci d'utiliser maintenant le storage du composant."+Char:C90(Carriage return:K15:38)\
		+"Base hôte :"+Char:C90(Carriage return:K15:38)+"cwStorage."+$cheminObjet_t+Char:C90(Carriage return:K15:38)\
		+"Dans le composant :"+Char:C90(Carriage return:K15:38)+"Storage."+$cheminObjet_t
	ALERT:C41($message_t)
	
	
	
Function cacheSessionWebPath($pathDefault_t : Text)->$path_t : Text
/* -----------------------------------------------------------------------------
Fonction : WebApp.cacheSessionWebPath
	
Chemin complet plateforme des sessions web
	
Paramètres
$pathDefault_t : (Optionel) Forcer le chemin par defaut.
$path_t : Chemin des sessions web
	
Historique
16/07/20 - Grégory Fromain <gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
-----------------------------------------------------------------------------*/
	
	Use (Storage:C1525.sessionWeb)
		If (Storage:C1525.sessionWeb.path=Null:C1517)
			Storage:C1525.sessionWeb.path:=Storage:C1525.param.folderPath.cache_t+"SessionWeb"+Folder separator:K24:12
		End if 
		
		// Si il y a un param c'est que l'on souhaite definir un nouveau chemin pour les sessions.
		If (Count parameters:C259=1)
			If (String:C10($1)#"")
				Storage:C1525.sessionWeb.path:=$1
			Else 
				
				// On reset le chemin pas defaut.
				Storage:C1525.sessionWeb.path:=Storage:C1525.param.folderPath.cache_t+"SessionWeb"+Folder separator:K24:12
			End if 
		End if 
	End use 
	
	// Dans tout les cas, on retourne un chemin
	$0:=Storage:C1525.sessionWeb.path
	
	
	
Function cacheViewPath()
/* -----------------------------------------------------------------------------
Fonction : WebApp.cacheViewPath
	
Chemin complet plateforme du dossier cache des vues
	
Historique
16/08/20 - Grégory Fromain <gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
19/02/21 - Grégory Fromain <gregory@connect-io.fr> - Fonction obsolette
-----------------------------------------------------------------------------*/
	
	var $cheminObjet_t; $message_t : Text
	
	$cheminObjet_t:="param.folderPath.cacheView_t"
	
	$message_t:="WebApp.cacheViewPath() : Cette fonction est obsolette."+Char:C90(Carriage return:K15:38)\
		+"Merci d'utiliser maintenant le storage du composant."+Char:C90(Carriage return:K15:38)\
		+"Base hôte :"+Char:C90(Carriage return:K15:38)+"cwStorage."+$cheminObjet_t+Char:C90(Carriage return:K15:38)\
		+"Dans le composant :"+Char:C90(Carriage return:K15:38)+"Storage."+$cheminObjet_t
	ALERT:C41($message_t)
	
	
	
Function cacheViewSubdomainPath($forceSousDomaine_t : Text)->$path_t : Text
/* -----------------------------------------------------------------------------
Fonction : WebApp.cacheViewSubdomainPath
	
Chemin complet plateforme du dossier cache des vues / sousDomaine
	
Paramètres
$forceSousDomaine_t : Nom du sous domaine
$path_t : Chemin des vues du sous domaine
	
Historique
16/08/20 - Grégory Fromain <gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
-----------------------------------------------------------------------------*/
	
	var $sousDomaine_t : Text
	
	If (Count parameters:C259=1)
		$sousDomaine_t:=$forceSousDomaine_t
	Else 
		$sousDomaine_t:=visiteur.sousDomaine
	End if 
	
	$0:=Storage:C1525.param.folderPath.cacheView_t+$sousDomaine_t+Folder separator:K24:12
	
	
	
Function I18NLoad
/* -----------------------------------------------------------------------------
Fonction : I18NLoad
	
Charge tout les fichiers de langue du dossier ressource/I18n pour le serveur web.
	
Historique
15/08/20 - Grégory Fromain <gregory@connect-io.fr> - Mise en veille de l'internalisation
27/11/20 - Alban Catoire <Alban@connect-io.fr> - Mise à jour avec Storage
-----------------------------------------------------------------------------*/
	
	var $analyseTrad_b : Boolean
	var $subDomain_t : Text  // Nom du sous domaine
	var $SplitNomDoc : Collection
	var $type_t : Text
	var $langue_t : Text
	var $tsModification_i : Integer
	var $tsLastUpload_i : Integer
	
	$SplitNomDoc:=New collection:C1472
	// On parcourt les sous domaine ("www" et "admin")
	For each ($subDomain_t; Storage:C1525.param.subDomain_c)
		
		//Si pour un sous domaine la traduction n'est pas chargé dans le storage on la crée
		If (Storage:C1525.sites[$subDomain_t].I18n=Null:C1517)
			Use (Storage:C1525.sites[$subDomain_t])
				Storage:C1525.sites[$subDomain_t].I18n:=New shared object:C1526()
			End use 
		End if 
		//On charge la collection de fichier du dossier
		$files_c:=Folder:C1567(This:C1470.sourceSubdomainPath($subDomain_t); fk platform path:K87:2).files(fk recursive:K87:7)
		
		For each ($file_o; $files_c)
			//Si le fichier est un fichier de traduction
			If ($file_o.name="@.i18n@")
				
				// On recupere le type ("form" ou "page") et la langue ("fr", "en" ou "es")
				$SplitNomDoc:=Split string:C1554($file_o.name; ".")
				$type_t:=$SplitNomDoc[0]
				$langue_t:=$SplitNomDoc[1]
				
				//Si le storage n'existe pas encore pour ce fichier on le crée
				If (Storage:C1525.sites[$subDomain_t].I18n[$type_t]=Null:C1517)
					Use (Storage:C1525.sites[$subDomain_t].I18n)
						Storage:C1525.sites[$subDomain_t].I18n[$type_t]:=New shared object:C1526()
					End use 
				End if 
				
				If (Storage:C1525.sites[$subDomain_t].I18n[$type_t][$langue_t]=Null:C1517)
					Use (Storage:C1525.sites[$subDomain_t].I18n[$type_t])
						Storage:C1525.sites[$subDomain_t].I18n[$type_t][$langue_t]:=New shared object:C1526()
					End use 
				End if 
				
				// Date de la derniere modification du fichier de traduction
				$tsModification_i:=Num:C11(cwTimestamp($file_o.modificationDate; $file_o.modificationTime))
				// Date du dernier chargement du fichier de traduction
				$tsLastUpload_i:=Num:C11(Storage:C1525.sites[$subDomain_t].I18n[$type_t][$langue_t].maj_ts)
				
				//Si le fichier n'a jamais été chargé ou n'est pas à jour, on le recharge
				If (($tsLastUpload_i=0) | (Num:C11($tsModification_i)>Num:C11($tsLastUpload_i)))
					$trad:=cwToolObjectFromFile($file_o)
					$trad.maj_ts:=cwTimestamp
					Use (Storage:C1525.sites[$subDomain_t].I18n[$type_t][$langue_t])
						Storage:C1525.sites[$subDomain_t].I18n[$type_t][$langue_t]:=OB Copy:C1225($trad; ck shared:K85:29; Storage:C1525.sites[$subDomain_t].I18n[$type_t][$langue_t])
					End use 
				End if 
				
			End if 
			
		End for each 
	End for each 
	
	//On remplit les traductions utiles à chaque page dans WebApp
	
	For each ($page_o; Storage:C1525.sites[$subDomain_t].route)
		Use ($page_o)
			$page_o.i18n:=New shared object:C1526()
		End use 
		
		For each ($lang; New collection:C1472("en"; "es"; "fr"))
			
			Use ($page_o.i18n)
				$page_o.i18n[$lang]:=New shared object:C1526()
			End use 
			
			//Chargment des traductions du corps de la page
			If (Storage:C1525.sites[$subDomain_t].I18n.page[$lang][$page_o.lib]#Null:C1517)
				Use ($page_o.i18n)
					$page_o.i18n[$lang]:=Storage:C1525.sites[$subDomain_t].I18n.page[$lang][$page_o.lib]
				End use 
			End if 
			
			//Chargement des traductions des parents 
			If ($page_o.parents#Null:C1517)
				For each ($parentName_t; $page_o.parents)
					//Si on connait la traduction du parent
					If (Storage:C1525.sites[$subDomain_t].I18n.page[$lang][$parentName_t]#Null:C1517)
						Use ($page_o.i18n)
							$page_o.i18n[$lang]:=OB Copy:C1225(cwToolObjectMerge($page_o.i18n[$lang]; Storage:C1525.sites[$subDomain_t].I18n.page[$lang][$parentName_t]); ck shared:K85:29)
						End use 
					End if 
				End for each 
			End if 
			
		End for each 
	End for each 
	
	
	
Function eMailConfigLoad
/* -----------------------------------------------------------------------------
Fonction : WebApp.eMailConfigLoad
	
Precharge toutes les e-mails de l'application web.
	
Historique
10/11/20 - Grégory Fromain <gregory@connect-io.fr> - Reécriture du code du composant plume.
-----------------------------------------------------------------------------*/
	
	$message_t:="WebApp.eMailConfigLoad() : Cette fonction est obsolette."+Char:C90(Carriage return:K15:38)\
		+"Merci d'utiliser maintenant la méthode : cwEMailConfigLoad"
	ALERT:C41($message_t)
	
	
	
Function htmlMinify()
/* -----------------------------------------------------------------------------
Fonction : WebApp.htmlMinify
	
Minification du HTML
	
Historique
16/04/12 - Grégory Fromain <gregory@connect-io.fr> - Création
21/12/19 - Grégory Fromain <gregory@connect-io.fr> - Ajout de la possibilité de créer une arborescence dans les fichiers des pages html.
16/07/20 - Grégory Fromain <gregory@connect-io.fr> - Convertion en fonction de la class webApp
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
-----------------------------------------------------------------------------*/
	
	var $texteIn : Text
	var $texteOut : Text
	var $dirIn : Text
	var $dirOut : Text
	var $compression_b : Boolean
	var $subDomain_t : Text  // Nom du sous domaine
	
	For each ($subDomain_t; Storage:C1525.param.subDomain_c)
		//Le dossier avec le html non minifié.
		$dirIn:=This:C1470.sourceSubdomainPath($subDomain_t)
		
		//Le dossier avec le html minifié.
		$dirOut:=This:C1470.cacheViewSubdomainPath($subDomain_t)
		
		//On recupere la liste des documents dans le répertoire.
		DOCUMENT LIST:C474($dirIn; $fichierHtmlIn; Recursive parsing:K24:13)
		
		For ($i; 1; Size of array:C274($fichierHtmlIn))
			
			If ($fichierHtmlIn{$i}="@.html")
				$compression_b:=True:C214
				
			Else 
				$compression_b:=False:C215
			End if 
			
			If ($compression_b)
				// Dans le cas d'un fichier dans un sous dossier, il faut supprimer le séparateur.
				If ($fichierHtmlIn{$i}=(Folder separator:K24:12+"@"))
					$fichierHtmlIn{$i}:=Substring:C12($fichierHtmlIn{$i}; 2)
					//Si besoin on creer le dossier dans le repertoire de destination...
					CREATE FOLDER:C475($dirOut+$fichierHtmlIn{$i}; *)
				End if 
				
				//Sauf si le dossier compressé existe deja et qu'il est plus jeune que le fichier d'origine.
				If (Test path name:C476($dirOut+$fichierHtmlIn{$i})=Is a document:K24:1)
					GET DOCUMENT PROPERTIES:C477($dirIn+$fichierHtmlIn{$i}; $verrouilleIn; $invisibleIn; $creeLeIn; $creeAIn; $modifieLeIn; $modifieAIn)
					GET DOCUMENT PROPERTIES:C477($dirOut+$fichierHtmlIn{$i}; $verrouilleOut; $invisibleOut; $creeLeOut; $creeAOut; $modifieLeOut; $modifieAOut)
					
					Case of 
						: ($modifieLeIn<$modifieLeOut)
							$compression_b:=False:C215
						: ($modifieLeIn=$modifieLeOut) & ($modifieAIn<$modifieAOut)
							$compression_b:=False:C215
					End case 
					
					If ($compression_b)
						//Il faut donc faire la minification et l'ancien fichier existe.
						//On le suppprime donc.
						DELETE DOCUMENT:C159($dirOut+$fichierHtmlIn{$i})
					End if 
				End if 
			End if 
			
			If ($compression_b)
				
				$texteIn:=Document to text:C1236($dirIn+$fichierHtmlIn{$i}; "UTF-8")
				ASSERT:C1129(Length:C16($texteIn)#0; "Impossible de charger le fichier : "+$dirIn+$fichierHtmlIn{$i})
				$texteOut:=Replace string:C233(cwMinifier($texteIn); "\n"; "")
				
				// On retire les commentaires HTML mais pas les balises 4D.
				$texteOut:=cwToolTextReplaceByRegex($texteOut; "<!-- (.*?)-->"; "")
				
				// On vérifie les espace insécable.
				$texteOut:=Replace string:C233($texteOut; " ;"; Char:C90(160)+";")
				$texteOut:=Replace string:C233($texteOut; " ?"; Char:C90(160)+"?")
				$texteOut:=Replace string:C233($texteOut; " !"; Char:C90(160)+"!")
				$texteOut:=Replace string:C233($texteOut; " :"; Char:C90(160)+":")
				$texteOut:=Replace string:C233($texteOut; " %"; Char:C90(160)+"%")
				$texteOut:=Replace string:C233($texteOut; " €"; Char:C90(160)+"€")
				
				TEXT TO DOCUMENT:C1237($dirOut+$fichierHtmlIn{$i}; $texteOut; "UTF-8")  //Et on creer le nouvau fichier.
			End if 
		End for 
	End for each 
	
	
	
Function jsMinify
/* -----------------------------------------------------------------------------
Fonction : WebApp.jsMinify
	
Minification du javascript
	
Historique
16/04/12 - Grégory Fromain <gregory@connect-io.fr> - Création
21/12/19 - Grégory Fromain <gregory@connect-io.fr> - Ajout de la possibilité de créer une arborescence dans les fichiers JS.
16/07/20 - Grégory Fromain <gregory@connect-io.fr> - Convertion en fonction de la class WebApp
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
-----------------------------------------------------------------------------*/
	
	var $texteIn : Text
	var $dirIn : Text
	var $dirOut : Text
	var $compression : Boolean
	var $subDomain_t : Text  // Nom du sous domaine
	
	For each ($subDomain_t; Storage:C1525.param.subDomain_c)
		//Le dossier avec le js non minifié.
		$dirIn:=This:C1470.sourceSubdomainPath($subDomain_t)
		
		//Le dossier avec les javascripts minimifié.
		$dirOut:=This:C1470.webfolderSubdomainPath($subDomain_t)+"js"+Folder separator:K24:12
		
		//On recupere la liste des documents dans le répertoire.
		DOCUMENT LIST:C474($dirIn; $fichierHtmlIn; Recursive parsing:K24:13)
		
		For ($i; 1; Size of array:C274($fichierHtmlIn))
			If ($fichierHtmlIn{$i}="@.js")
				$compression:=True:C214
				
			Else 
				$compression:=False:C215
			End if 
			
			If ($compression)
				// Dans le cas d'un fichier dans un sous dossier, il faut supprimer le séparateur.
				If ($fichierHtmlIn{$i}=(Folder separator:K24:12+"@"))
					$fichierHtmlIn{$i}:=Substring:C12($fichierHtmlIn{$i}; 2)
					// Si besoin on crée le dossier dans le repertoire de destination.
					CREATE FOLDER:C475($dirOut+$fichierHtmlIn{$i}; *)
				End if 
				
				//Sauf si le dossier compressé existe deja et qu'il est plus jeune que le fichier d'origine.
				If (Test path name:C476($dirOut+$fichierHtmlIn{$i})=Is a document:K24:1)
					GET DOCUMENT PROPERTIES:C477($dirIn+$fichierHtmlIn{$i}; $verrouilleIn; $invisibleIn; $creeLeIn; $creeAIn; $modifieLeIn; $modifieAIn)
					GET DOCUMENT PROPERTIES:C477($dirOut+$fichierHtmlIn{$i}; $verrouilleOut; $invisibleOut; $creeLeOut; $creeAOut; $modifieLeOut; $modifieAOut)
					
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
				
				$texteIn:=Document to text:C1236($dirIn+$fichierHtmlIn{$i}; "UTF-8")
				TEXT TO DOCUMENT:C1237($dirOut+$fichierHtmlIn{$i}; cwMinifier($texteIn); "UTF-8")  //Et on creer le nouvau fichier.
			End if 
		End for 
		
	End for each 
	
	
	
Function serverStart
/* -----------------------------------------------------------------------------
Fonction : WebApp.serverStart
	
Démarrage du serveur web
	
Historique
19/02/15 - Grégory Fromain <gregory@connect-io.fr> - Création
21/12/19 - Grégory Fromain <gregory@connect-io.fr> - Ajout de la possibilité de créer une arborescence dans les fichiers des pages html.
31/03/20 - Grégory Fromain <gregory@connect-io.fr> - Gestion des héritages
25/06/20 - Grégory Fromain <gregory@connect-io.fr> - Mise à jour emplacement des routes.
25/06/20 - Grégory Fromain <gregory@connect-io.fr> - Mise à jour emplacement des views.
16/07/20 - Grégory Fromain <gregory@connect-io.fr> - Gestion des routes sous forme de collection.
18/07/20 - Grégory Fromain <gregory@connect-io.fr> - Conversion en fonction
23/09/20 - Grégory Fromain <gregory@connect-io.fr> - Gestion de parent multiple
29/09/20 - Grégory Fromain <gregory@connect-io.fr> - On inverse l'ordre de chargement des méthodes et view.
01/10/20 - Grégory Fromain <gregory@connect-io.fr> - Ajout des fichiers de config au format JSONC.
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
19/02/21 - Grégory Fromain <gregory@connect-io.fr> - Suppression de la gestion des routes sous le format : page.url
-----------------------------------------------------------------------------*/
	
	// La fonction ne requiere pas de paramêtre.
	var $j : Integer
	var $r : Integer
	var $routeVar : Text
	var $routeRegex : Text
	var $routeFormatData : Text
	var $temp_t : Text
	var $subDomain_t : Text
	var $configPage : Object
	var $page : Object
	var $route : Object
	var $routeDefault : Object
	var $routeFormat : Object
	var $parentLibPage : Text  // Permet de gérer l'héritage des routes.
	var $i_l : Integer  // Permet de gérer l'héritage des fichiers HTML
	var $methodeNom_t : Text  //  Permet de gérer l'héritage des méthodes de la page
	var $route_c : Collection
	ARRAY TEXT:C222($libpage_at; 0)
	ARRAY TEXT:C222($routeFormatCle; 0)
	
	// Minification du JS.
	MESSAGE:C88("Minification du JS..."+Char:C90(Carriage return:K15:38))
	This:C1470.jsMinify()
	
	// Minification du HTML.
	MESSAGE:C88("Minification du HTML..."+Char:C90(Carriage return:K15:38))
	This:C1470.htmlMinify()
	
	
	// On boucle sur chaque sous domaine.
	MESSAGE:C88("Chargement des routes..."+Char:C90(Carriage return:K15:38))
	For each ($subDomain_t; Storage:C1525.param.subDomain_c)
		// On purge la liste des routes
		$route_c:=New collection:C1472()
		//Récupération du plan des pages web des sites.
		$configPage:=New object:C1471
		ARRAY TEXT:C222($routeFile_at; 0)
		DOCUMENT LIST:C474(This:C1470.sourceSubdomainPath($subDomain_t); $routeFile_at; Recursive parsing:K24:13+Absolute path:K24:14)
		
		// Chargement de tous les fichiers de routing.
		For ($routeNum; 1; Size of array:C274($routeFile_at))
			// On charge toutes les routes, mais pas le modele
			If ($routeFile_at{$routeNum}="@route.json@")
				$configPage:=cwToolObjectMerge($configPage; cwToolObjectFromPlatformPath($routeFile_at{$routeNum}))
			End if 
		End for 
		
		//---------- On merge les routes parents ----------
		For each ($libPage; $configPage)
			// On ne merge pas les routes qui n'ont pas de parent... Pas d'intéret.
			// On ne merge pas les routes qui n'ont pas d'url... Cela crée des doublons car ce sont des routes de layout...
			If ($configPage[$libPage].parents#Null:C1517) & ($configPage[$libPage].route#Null:C1517)
				If ($configPage[$libPage].route.path#Null:C1517)
					
					$iReel_l:=-1
					$i:=0
					While ($i<$configPage[$libPage].parents.length)
						
						$iReel_l:=$configPage[$libPage].parents.length-$i-1
						
						$parentLibPage:=$configPage[$libPage].parents[$iReel_l]
						If ($configPage[$parentLibPage]=Null:C1517)
							ALERT:C41("La route parent suivante n'est pas définie :"+$parentLibPage)
							$parentLibPage:=""  // Permet de sortir de la boucle.
						Else 
							$configPage[$libPage]:=cwToolObjectMerge($configPage[$parentLibPage]; $configPage[$libPage])
						End if 
						
						$i:=$i+1
					End while 
					
					
				End if 
			End if 
		End for each 
		
		// Une fois que l'on a merge les routes avec des dependance, on supprime les pages de configuration qui n'ont pas de route.
		For each ($libPage; $configPage)
			Case of 
				: ($configPage[$libPage].route=Null:C1517)
					OB REMOVE:C1226($configPage; $libPage)
					
				: ($configPage[$libPage].route.path=Null:C1517)
					OB REMOVE:C1226($configPage; $libPage)
					
			End case 
		End for each 
		
		
		
		// On precharge les routes
		OB GET PROPERTY NAMES:C1232($configPage; $libpage_at)
		For ($j; 1; Size of array:C274($libpage_at))
			
			$page:=OB Get:C1224($configPage; $libpage_at{$j})
			
			$page.lib:=$libpage_at{$j}
			
			If ($page.route#Null:C1517)
				// On récupére la route de la page.
				$route:=$page.route
				// On fabrique la regex de la route.
				// On prend le path
				$routeRegex:=$route.path
				
				// On charge les variables de l'url
				$routeFormat:=Choose:C955(OB Is defined:C1231($route; "format"); $route.format; New object:C1471)
				
				// On charge les valeurs des variables par defaut.
				$routeDefault:=Choose:C955(OB Is defined:C1231($route; "default"); $route.default; New object:C1471)
				
				// On boucle sur les formats de variables
				If (OB Is defined:C1231($route; "format"))
					OB GET PROPERTY NAMES:C1232($route.format; $routeFormatCle)
					For ($r; 1; Size of array:C274($routeFormatCle))
						$temp_t:=$route.format[$routeFormatCle{$r}]
						$routeRegex:=Replace string:C233($routeRegex; $routeFormatCle{$r}; "("+$temp_t+")")
					End for 
				End if 
				
				$route.regex:=$routeRegex
				
				$routeVar:=$route.path
				
				
				For ($r; 1; Size of array:C274($routeFormatCle))
					If (OB Is defined:C1231($routeDefault; $routeFormatCle{$r}))
						$routeFormatData:="<!--#4DIF (OB is defined(routeVar;\""+$routeFormatCle{$r}+"\"))--><!--#4DTEXT OB Get(routeVar;\""+$routeFormatCle{$r}+"\")--><!--#4DELSE-->"+OB Get:C1224($routeDefault; $routeFormatCle{$r})+"<!--#4DENDIF-->"
					Else 
						$routeFormatData:="<!--#4DIF (OB is defined(routeVar;\""+$routeFormatCle{$r}+"\"))--><!--#4DTEXT OB Get(routeVar;\""+$routeFormatCle{$r}+"\")--><!--#4DELSE--> il manque la variable "+$routeFormatCle{$r}+"+<!--#4DENDIF-->"
					End if 
					$routeVar:=Replace string:C233($routeVar; $routeFormatCle{$r}; $routeFormatData)
				End for 
				$route.variable:=$routeVar
				
				$page.route:=$route
				OB SET:C1220($configPage; $libpage_at{$j}; $page)
			End if 
		End for 
		
		
		//Creation du chemin complet du fichier html
		For ($j; 1; Size of array:C274($libpage_at))
			$page:=$configPage[$libpage_at{$j}]
			If ($page.viewPath#Null:C1517)
				
				// Attention : On ne peut pas utiliser ici de boucle for each car sa modification ne sera pas répercutée sur l'élément de la collection.
				For ($i_l; 0; $page.viewPath.length-1)
					// On gére la possibilité de créer une arborescence dans les dossiers des pages HTML
					$page.viewPath[$i_l]:=This:C1470.cacheViewSubdomainPath($subDomain_t)+cwToolPathSeparator($page.viewPath[$i_l])
					
					// On vérifie que le fichier existe bien
					If (Test path name:C476($page.viewPath[$i_l])#Is a document:K24:1)
						ALERT:C41("Il manque le fichier view suivant : "+$page.viewPath[$i_l])
					End if 
					
				End for 
				
				// On retourne l'ordre des pages HTML pour commencer par les pages de plus bas niveau.
				$page.viewPath:=$page.viewPath.reverse()
				
			Else 
				$page.viewPath:=New collection:C1472
			End if 
			
			
			If ($page.methode#Null:C1517)
				
				For each ($methodeNom_t; $page.methode)
					ARRAY TEXT:C222($methodName_at; 0)
					METHOD GET NAMES:C1166($methodName_at; $methodeNom_t+"@"; *)
					If (Size of array:C274($methodName_at)=0)
						ALERT:C41("Il manque la méthode suivante de l'application : "+$methodeNom_t)
					End if 
				End for each 
				
				// On retourne l'ordre des méthodes pour commencer par les méthodes de plus bas niveau.
				$page.methode:=$page.methode.reverse()
			Else 
				$page.methode:=New collection:C1472
			End if 
			
			// On determine le type de fichier que l'on va traiter.
			Case of 
				: (cwExtensionFichier(String:C10($page.route.path))#"")
					$page.type:=cwExtensionFichier($page.route.path)
					
				: ($page.viewPath.length#0)
					$page.type:=cwExtensionFichier($page.viewPath[($page.viewPath.length-1)])
					
				Else 
					// Si l'on arrive pas à le determiner, on fixe .html par defaut...
					$page.type:=".html"
			End case 
			
			//OB SET($configPage;$libpage_at{$j};OB Copy($page))
			$route_c.push(OB Copy:C1225($page))
		End for 
		
		// Si besoin, on réintégre les forms...
		If ($copyForm_o[$subDomain_t]#Null:C1517)
			$configPage.form:=$copyForm_o[$subDomain_t]
		End if 
		
		Use (Storage:C1525.sites[$subDomain_t])
			Storage:C1525.sites[$subDomain_t].route:=$route_c.copy(ck shared:K85:29; Storage:C1525.sites[$subDomain_t])
		End use 
		
	End for each 
	
	MESSAGE:C88("Chargement des formulaires..."+Char:C90(Carriage return:K15:38))
	cwWebAppFormPreload
	
	MESSAGE:C88("Chargement des datatables..."+Char:C90(Carriage return:K15:38))
	cwWebAppFuncDataTablePreload
	
	MESSAGE:C88("Chargement des Traductions..."+Char:C90(Carriage return:K15:38))
	This:C1470.I18NLoad()
	
	MESSAGE:C88("Chargement des graphiques..."+Char:C90(Carriage return:K15:38))
	cwWebAppFuncChartPreload
	
	
	
Function sessionWebStart
/* -----------------------------------------------------------------------------
Fonction : WebApp.sessionWebStart
	
Démarrage des sessions Web
	
Historique
30/07/19 - Grégory Fromain <gregory@connect-io.fr> - Création
16/07/20 - Grégory Fromain <gregory@connect-io.fr> - Conversion en fonction
15/09/20 - Grégory Fromain <gregory@connect-io.fr> - Suppression de $0
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
-----------------------------------------------------------------------------*/
	
	var $1 : Collection  // Option, option du serveur web
	
	var $options_c : Collection
	var $option_o : Object
	var $valideMinute_l : Integer
	var $creerLe_d : Date
	var $modifierLe_d : Date
	var $dernierJourValide_d : Date
	var $creerA_t : Time
	var $modifierA_t : Time
	var $verrou_b : Boolean
	var $invisible_b : Boolean
	var $infoFichier_o : Object
	ARRAY TEXT:C222($listeSessionWeb_t; 0)
	
	
	// On applique quelques valeurs par defaut, pour que cela fonctionne même sans param.
	$options_c:=New collection:C1472
	$options_c.push(New object:C1471("key"; Web session cookie name:K73:4; "value"; "CIOSID"))  // nom du cookies de la session
	$options_c.push(New object:C1471("key"; Web inactive session timeout:K73:3; "value"; 30*24*60))  // 30 jours, en minute
	$options_c.push(New object:C1471("key"; Web inactive process timeout:K73:13; "value"; 480))  // 480 min de durée de vie des process inactifs associés aux sessions
	$options_c.push(New object:C1471("key"; Web max sessions:K73:2; "value"; 300))  // 300 sessions simultanées
	$options_c.push(New object:C1471("key"; Web Session IP address validation enabled:K73:17; "value"; 0))  // Déconnecte la relation entre l'IP et le cookies
	$options_c.push(New object:C1471("key"; Web keep session:K73:1; "value"; 1))  // activation de la gestion automatique des sessions.
	$options_c.push(New object:C1471("key"; Web HTTP compression level:K73:11; "value"; -1))  // Niveau de compression des pages automatique.
	$options_c.push(New object:C1471("key"; Web max concurrent processes:K73:7; "value"; 1000))  // Limite du nombre de process Web acceptés et retourne le message “Serveur non disponible”.
	
	// Puis l'on vient combiner avec les informations 
	If (Count parameters:C259>=1)
		If (Type:C295($1)=Is collection:K8:32)
			
			$options_c:=$options_c.query("NOT (key IN :1)"; $1.extract("key"))
			$options_c.combine($1)
		End if 
	End if 
	
	// Pour les options il suffit de faire une boucle
	For each ($option_o; $options_c)
		WEB SET OPTION:C1210($option_o.key; $option_o.value)
	End for each 
	
	
	// On test que le dossier des sessions web existe bien, sinon on le crée.
	If (Test path name:C476(This:C1470.cacheSessionWebPath())#Is a folder:K24:2)
		CREATE FOLDER:C475(This:C1470.cacheSessionWebPath(); *)
		If (ok=0)
			ALERT:C41("Impossible de créer le dossier des sessions Web : "+This:C1470.cacheSessionWebPath())
			
			// Il y a une erreur dans le dossier des sessions web, on va mettre le chemin par defaut avec le param "" et le créer au besoin.
			CREATE FOLDER:C475(This:C1470.cacheSessionWebPath(""); *)
		End if 
	End if 
	
	
	// On va conserver des informations importantes a porté de main...
	Use (Storage:C1525.sessionWeb)
		Storage:C1525.sessionWeb.name:=$options_c.query("key IS :1"; Web session cookie name:K73:4)[0].value
	End use 
	
	// ----- Nettoyage des sessions périmée -----
	// On en profite pour nettoyer les sessions périmées...
	MESSAGE:C88("Nettoyage des sessions web")
	
	$valideMinute_l:=$options_c.query("key IS :1"; Web inactive session timeout:K73:3)[0].value
	Use (Storage:C1525.sessionWeb)
		Storage:C1525.sessionWeb.valideDay:=Int:C8($valideMinute_l/60/24)
	End use 
	
	DOCUMENT LIST:C474(This:C1470.cacheSessionWebPath(); $listeSessionWeb_t; Recursive parsing:K24:13+Absolute path:K24:14)
	$dernierJourValide_d:=Current date:C33-Num:C11(Storage:C1525.sessionWeb.valideDay)
	For ($i; 1; Size of array:C274($listeSessionWeb_t))
		// On verifie une derniere fois que le fichier existe,
		// Possibilité d'être supprimé par un autre process parallele...
		If (Test path name:C476($listeSessionWeb_t{$i})=Is a document:K24:1)
			GET DOCUMENT PROPERTIES:C477($listeSessionWeb_t{$i}; $verrou_b; $invisible_b; $creerLe_d; $creerA_t; $modifierLe_d; $modifierA_t)
			
			If ($creerLe_d<$dernierJourValide_d)
				//Il faut le supprimer, mais avant l'on regarde si il n'a pas un dossier temporaire associé.
				$infoFichier_o:=Path to object:C1547($listeSessionWeb_t{$i})
				
				// c'est un dossier qui porte le même nom que le fichier mais sans extension.
				$infoFichier_o.folderTemp:=$infoFichier_o.parentFolder+$infoFichier_o.name+Folder separator:K24:12
				
				If (Test path name:C476($infoFichier_o.folderTemp)=Is a folder:K24:2)
					DELETE FOLDER:C693($infoFichier_o.folderTemp; Delete with contents:K24:24)
				End if 
				
				// Maintenant on supprime le fichier de session
				DELETE DOCUMENT:C159($listeSessionWeb_t{$i})
			End if 
		End if 
		
	End for 
	
	
	
Function sourcesPath
/* -----------------------------------------------------------------------------
Fonction : WebApp.sourcesPath
	
Chemin complet plateforme du dossier Source
	
Historique
16/08/20 - Grégory Fromain <gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
19/02/21 - Grégory Fromain <gregory@connect-io.fr> - Fonction obsolette
-----------------------------------------------------------------------------*/
	
	var $cheminObjet_t; $message_t : Text
	
	$cheminObjet_t:="param.folderPath.source_t"
	
	$message_t:="WebApp.webAppPath : Cette fonction est obsolette."+Char:C90(Carriage return:K15:38)\
		+"Merci d'utiliser maintenant le storage du composant."+Char:C90(Carriage return:K15:38)\
		+"Base hôte :"+Char:C90(Carriage return:K15:38)+"cwStorage."+$cheminObjet_t+Char:C90(Carriage return:K15:38)\
		+"Dans le composant :"+Char:C90(Carriage return:K15:38)+"Storage."+$cheminObjet_t
	ALERT:C41($message_t)
	
	
	
Function sourceSubdomainPath
/* -----------------------------------------------------------------------------
Fonction : WebApp.sourceSubdomainPath
	
Chemin complet plateforme du dossier Source/sousDomaine
	
Historique
16/08/20 - Grégory Fromain <gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
-----------------------------------------------------------------------------*/
	
	var $1 : Text  // Nom du sous domaine
	var $0 : Text  // Chemin du dossier source du sous domaine
	
	var $sousDomaine_t : Text
	
	If (Count parameters:C259=1)
		$sousDomaine_t:=$1
	Else 
		$sousDomaine_t:=visiteur.sousDomaine
	End if 
	
	$0:=Storage:C1525.param.folderPath.source_t+$sousDomaine_t+Folder separator:K24:12
	
	
	
	
Function webAppPath
/* -----------------------------------------------------------------------------
Fonction : WebApp.webAppPath
	
Chemin complet plateforme du dossier WebApp
	
Historique
16/08/20 - Grégory Fromain <gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
19/02/21 - Grégory Fromain <gregory@connect-io.fr> - Fonction obsolette
-----------------------------------------------------------------------------*/
	
	var $cheminObjet_t; $message_t : Text
	
	$cheminObjet_t:="param.folderPath.webApp_t"
	
	$message_t:="WebApp.webAppPath() : Cette fonction est obsolette."+Char:C90(Carriage return:K15:38)\
		+"Merci d'utiliser maintenant le storage du composant."+Char:C90(Carriage return:K15:38)\
		+"Base hôte :"+Char:C90(Carriage return:K15:38)+"cwStorage."+$cheminObjet_t+Char:C90(Carriage return:K15:38)\
		+"Dans le composant :"+Char:C90(Carriage return:K15:38)+"Storage."+$cheminObjet_t
	ALERT:C41($message_t)
	
	
	
Function webfolderSubdomainPath
/* -----------------------------------------------------------------------------
Fonction : WebApp.webfolderSubdomainPath
	
Chemin complet plateforme du dossier Webfolder/sousDomaine
	
Historique
16/08/20 - Grégory Fromain <gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
-----------------------------------------------------------------------------*/
	
	var $1 : Text  // Nom du sous domaine
	var $0 : Text  // Chemin du dossier webfolder du sous domaine
	var $sousDomaine_t : Text
	
	If (Count parameters:C259=1)
		$sousDomaine_t:=$1
	Else 
		$sousDomaine_t:=visiteur.sousDomaine
	End if 
	
	$0:=Get 4D folder:C485(HTML Root folder:K5:20; *)+$sousDomaine_t+Folder separator:K24:12
	
	
	