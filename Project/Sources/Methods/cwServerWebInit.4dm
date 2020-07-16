//%attributes = {"shared":true}
/* ----------------------------------------------------
Méthode : cwServerWebInit

Initialisation du serveur web.

Historique
08/12/19 - Grégory Fromain <gregory@connect-io.fr> - Création
08/12/19 - Grégory Fromain <gregory@connect-io.fr> - Les fichiers de routing sont triés par ordre croissant
08/12/19 - Grégory Fromain <gregory@connect-io.fr> - Réorganisation des dossiers sous forme de WebApp
15/08/20 - Grégory Fromain <gregory@connect-io.fr> - Suppression de <>webApp_o.config.webAppOld
----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_TEXT:C284($1)  // (Optionel) chemin alternatif pour le webFolder
	
	C_OBJECT:C1216(<>webApp_o)  // Configuration global de l'application web
	C_OBJECT:C1216($source_o)  // dossier sources
	C_TEXT:C284($subDomain_t)  // Nom du sous domaine
	C_OBJECT:C1216($folderSubDomaine_o)  // Dossier du sous domaine.
	
	C_TEXT:C284($subDomain_t)
	
End if 

<>webApp_o:=New object:C1471()
<>webApp_o.config:=New object:C1471()

  // Nom de la variable visiteur dans l'application hôte.
<>webApp_o.config.varVisitorName_t:="visiteur_o"

  // ----- Gestion du dossier WebApp -----
  // Dossier principale du composant dans l'application hôte.

<>webApp_o.config.webApp:=New object:C1471()
<>webApp_o.config.webApp.folderName_t:="WebApp"
<>webApp_o.config.webApp.folder_t:=cwToolPathFolderOrAlias (Get 4D folder:C485(Database folder:K5:14;*))+<>webApp_o.config.webApp.folderName_t+Folder separator:K24:12
<>webApp_o.config.webApp.folder_f:=Formula:C1597(<>webApp_o.config.webApp.folder_t)  // Utile simplement pour l'uniformisation...
  // Utilisation : <>webApp_o.config.webApp.folder_f()



  // ----- Gestion du dossier source -----
<>webApp_o.config.source:=New object:C1471()
<>webApp_o.config.source.folderName_t:="Sources"
<>webApp_o.config.source.folder_t:=<>webApp_o.config.webApp.folder_f()+<>webApp_o.config.source.folderName_t+Folder separator:K24:12
<>webApp_o.config.source.folder_f:=Formula:C1597(<>webApp_o.config.source.folder_t+Choose:C955(Count parameters:C259=1;$1;visiteur.sousDomaine)+Folder separator:K24:12)
  // Utilisation : <>webApp_o.config.webApp.folder_f()

  // On vérifie que le dossier existe.
$source_o:=Folder:C1567(<>webApp_o.config.source.folder_t;fk platform path:K87:2)
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
<>webApp_o.config.subDomain_c:=$source_o.folders().extract("name")

  // On vérifie qu'il existe bien un fichier de config pour l'utilisation du composant dans la base hôte.
If (Not:C34($source_o.file("config.json").exists))
	$source_o.file("config.json").setText("{}")
End if 

  // On charge le fichier de config et on refusionne les data avec les informations précédentes.
<>webApp_o:=cwToolObjectMerge (<>webApp_o;JSON Parse:C1218($source_o.file("config.json").getText()))



  // ----- Gestion du webfolder -----
  // On vérifie que le repertoire WebFolder existe dans le dossier WebApp
<>webApp_o.config.webFolder:=New object:C1471()
<>webApp_o.config.webFolder.folderName_t:="WebFolder"
<>webApp_o.config.webFolder.folder_t:=<>webApp_o.config.webApp.folder_f()+<>webApp_o.config.webFolder.folderName_t+Folder separator:K24:12
<>webApp_o.config.webFolder.folder_f:=Formula:C1597(<>webApp_o.config.webFolder.folder_t+Choose:C955(Count parameters:C259=1;$1;visiteur.sousDomaine)+Folder separator:K24:12)
  // Utilisation : $dossierWebApp_t:=<>webApp_o.config.webApp.folder_f()
  // On fixe le dossier racine
If (Count parameters:C259=1)
	<>webApp_o.config.webFolder.folder_t:=$1
End if 
WEB SET ROOT FOLDER:C634(<>webApp_o.config.webFolder.folder_t)

If (Test path name:C476(<>webApp_o.config.webFolder.folder_t)#Is a folder:K24:2)
	  // Il n'existe pas... On crée le dossier avec son arborescence.
	CREATE FOLDER:C475(<>webApp_o.config.webFolder.folder_t;*)
End if 

  // Creation du dossier upload par defaut dans le dossier web public
  // La 1er lettre du nom du fichier n'est pas en majuscule, car c'est moins esthétique dans une URL
If (Test path name:C476(<>webApp_o.config.webFolder.folder_t+"uploads"+Folder separator:K24:12)#Is a folder:K24:2)
	CREATE FOLDER:C475(<>webApp_o.config.webFolder.folder_t+"uploads"+Folder separator:K24:12;*)
End if 

  // Controle sur les sous domaine
For each ($subDomain_t;<>webApp_o.config.subDomain_c)
	  // On récupére des infos sur le dossier web du sous domaine.
	$folderSubDomaine_o:=Folder:C1567(<>webApp_o.config.webFolder.folder_f($subDomain_t);fk platform path:K87:2)
	
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
<>webApp_o.config.viewCache:=New object:C1471()
<>webApp_o.config.viewCache.folderName_t:="View"
<>webApp_o.config.viewCache.folder_t:=<>webApp_o.config.webApp.folder_f()+"Cache"+Folder separator:K24:12+<>webApp_o.config.viewCache.folderName_t+Folder separator:K24:12
<>webApp_o.config.viewCache.folder_f:=Formula:C1597(<>webApp_o.config.viewCache.folder_t+Choose:C955(Count parameters:C259=1;$1;visiteur.sousDomaine)+Folder separator:K24:12)
  // Utilisation
  // Dans le cas d'une utilisation dans le process web actif, il n'est pas obligé de mettre de paramêtre.
  // Si l'on souhaite forcer le dossier page d'un sous domaine précis, il faut le passer en paramêtre.
  //$dossierPage_t:=<>webApp_o.config.viewCache.folder_f("clients")

  // On vérifie que le repertoire Pages existe dans le dossier Cache de l'application hôte.
  // Et donc implicitement les dossiers WebApp, Cache et Pages
If (Test path name:C476(<>webApp_o.config.viewCache.folder_t)#Is a folder:K24:2)
	  // Il n'existe pas... On crée le dossier avec son arborescence.
	CREATE FOLDER:C475(<>webApp_o.config.viewCache.folder_t;*)
End if 

  // Controle sur les sous domaine
For each ($subDomain_t;<>webApp_o.config.subDomain_c)
	  // On récupére des infos sur le dossier web du sous domaine.
	$folderSubDomaine_o:=Folder:C1567(<>webApp_o.config.viewCache.folder_f($subDomain_t);fk platform path:K87:2)
	
	  // Si il existe pas, on lui crée une petite arborescense.
	If (Not:C34($folderSubDomaine_o.exists))
		$folderSubDomaine_o.create()
	End if 
End for each 


  // On remonte les informations à la base hôte.
$0:=<>webApp_o