/* 
Cette class permet de centraliser toutes les données de l'application web.

Historique
15/07/20 - gregory@connect-io.fr - Mise en place de l'historique

*/

  // ----- Initialisation de l'application web -----
Class constructor
	
	C_OBJECT:C1216($source_o)  // dossier sources
	C_TEXT:C284($subDomain_t)  // Nom du sous domaine
	C_OBJECT:C1216($folderSubDomaine_o)  // Dossier du sous domaine.
	
	This:C1470.config:=New object:C1471()
	This:C1470.config.folderName_o:=New object:C1471()
	This:C1470.config.folderName_o.webApp:="WebApp"
	This:C1470.config.folderName_o.source:="Sources"
	This:C1470.config.folderName_o.webFolder:="WebFolder"
	This:C1470.config.folderName_o.viewCache:="View"
	
	
	
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
	If (This:C1470.sites=Null:C1517)
		This:C1470.sites:=New object:C1471
	End if 
	
	
	For each ($subDomain_t;This:C1470.config.subDomain_c)
		If (This:C1470.sites[$subDomain_t]=Null:C1517)
			This:C1470.sites[$subDomain_t]:=New object:C1471
		End if 
	End for each 
	
	
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
	If (Test path name:C476(This:C1470.viewCachePath())#Is a folder:K24:2)
		  // Il n'existe pas... On crée le dossier avec son arborescence.
		CREATE FOLDER:C475(This:C1470.viewCachePath();*)
	End if 
	
	  // Controle sur les sous domaine
	For each ($subDomain_t;This:C1470.config.subDomain_c)
		  // On récupére des infos sur le dossier web du sous domaine.
		$folderSubDomaine_o:=Folder:C1567(This:C1470.viewCacheSubdomainPath($subDomain_t);fk platform path:K87:2)
		
		  // Si il existe pas, on lui crée une petite arborescense.
		If (Not:C34($folderSubDomaine_o.exists))
			$folderSubDomaine_o.create()
		End if 
	End for each 
	
	
	
/*
	
C_OBJECT($config_o)  // Config du serveurWeb
	
  // LAUNCH EXTERNAL PROCESS("say Initialisation du serveur web. Initialisation du serveur web ? Initialisation du serveur web !")
$config_o:=New object()
$config_o.folderName_o:=New object()
$config_o.folderName_o.webApp:="WebApp"
	
$config_o:=cwServerWebInit 
	
For each ($propriete_t;$config_o)
	
This[$propriete_t]:=$config_o[$propriete_t]
	
Use (Storage)
Case of 
: (OB Get type($config_o;$propriete_t)=Is object)
Storage[$propriete_t]:=OB Copy($config_o[$propriete_t];ck shared)
	
	
: (OB Get type($config_o;$propriete_t)=Is collection)
Storage[$propriete_t]:=$config_o[$propriete_t].copy(ck shared)
	
Else 
ALERT("Dans le fichier de config, merci de renseigner, uniquement des objets ou collection.")
End case 
	
	
End use 
	
End for each 
*/
	
	  // ----- Chemin du dossier WebApp -----
Function webAppPath
	C_TEXT:C284($0)
	$0:=cwToolPathFolderOrAlias (Get 4D folder:C485(Database folder:K5:14;*))+This:C1470.config.folderName_o.webApp+Folder separator:K24:12
	
	
	
	  // ----- Chemin du dossier Source -----
Function sourcePath
	C_TEXT:C284($0)
	
	$0:=This:C1470.webAppPath()+This:C1470.config.folderName_o.source+Folder separator:K24:12
	
	
	
	  // ----- Chemin du dossier Source/sousDomaine -----
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
	
	
	
	  // ----- Chemin du dossier Webfolder/sousDomaine -----
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
	
	
	
	  // ----- Chemin du dossier cache des vues -----
Function viewCachePath
	C_TEXT:C284($0)
	
	$0:=This:C1470.webAppPath()+"Cache"+Folder separator:K24:12+This:C1470.config.folderName_o.viewCache+Folder separator:K24:12
	
	
	
	  // ----- Chemin du dossier cache des vues / sousDomaine -----
Function viewCacheSubdomainPath
	C_TEXT:C284($1)  //Nom du sous domaine
	C_TEXT:C284($0)
	C_TEXT:C284($sousDomaine_t)
	
	If (Count parameters:C259=1)
		$sousDomaine_t:=$1
	Else 
		$sousDomaine_t:=visiteur.sousDomaine
	End if 
	
	$0:=This:C1470.viewCachePath()+$sousDomaine_t+Folder separator:K24:12
	
	
Function serverStart
	cwWebAppServerStart 
	cwWebAppFormPreload 
	cwWebAppFuncDataTablePreload 
	  //cwI18nLoad 
	
	
Function jsMinify
	cwWebAppFuncJsMinify 
	
	
Function htmlMinify
	cwWebAppFuncHtmlMinify 
	
	
Function pageCurrent
	C_OBJECT:C1216($1)  // instance de user
	C_OBJECT:C1216($0)  // Instance de la page courante
	C_OBJECT:C1216($page_o)
	C_COLLECTION:C1488($siteRoute_c)
	
	$siteRoute_c:=This:C1470.sites[visiteur.sousDomaine].route.copy()
	
	$0:=cs:C1710.page.new($siteRoute_c;$1)
	
	
	
	
	
	
	
	
	
	
	
	
	
	