//%attributes = {"shared":true}
  // ----------------------------------------------------
  // Méthode : cwServerWebInit
  // 
  // Initialisation du serveur web.
  //
  // Appel de la methode
  // C_OBJECT(<>configPage;<>urlToLibelle)
  // cwStartServeur(-><>configPage;-><>urlToLibelle)
  // ----------------------------------------------------

If (False:C215)  // Historique
	  // 08/12/19 - Grégory Fromain <gregory@connect-io.fr> - Création
	  // 08/12/19 - Grégory Fromain <gregory@connect-io.fr> - Les fichiers de routing sont triés par ordre croissant
End if 

If (True:C214)  // Déclarations
	C_POINTER:C301($1)
	
	C_OBJECT:C1216(<>webApp_o)  // Configuration global de l'application web
	C_OBJECT:C1216($cwConfig_o)  // Configuration de base du composant cioWeb
	C_TEXT:C284($chDossier;$subDomain_t)
	
	ARRAY TEXT:C222($subDomain_at;0)
End if 

<>webApp_o:=New object:C1471()

$cwConfig_o:=New object:C1471()
  // Nom de la variable visiteur dans l'application hôte.
$cwConfig_o.varVisitorName_t:="visiteur_o"

  // Dossier principale du composant dans l'application hôte.
  //$cwConfig_o.pathWebApp_t:=cwToolPathFolderOrAlias (Get 4D folder(Current resources folder;*))+"sites"
$cwConfig_o.webApp:=New object:C1471()
$cwConfig_o.webApp.folderName_t:="sites"
$cwConfig_o.webApp.folder_t:=cwToolPathFolderOrAlias (Get 4D folder:C485(Current resources folder:K5:16;*))+$cwConfig_o.webApp.folderName_t+Folder separator:K24:12
$cwConfig_o.webApp.folder_f:=Formula:C1597(<>webApp_o.config.webApp.folder_t)  // Utile simplement pour l'uniformisation...
  // Utilisation : $dossierWebApp_t:=<>webApp_o.config.webApp.folder_f()

$cwConfig_o.page:=New object:C1471()
$cwConfig_o.page.folderName_t:="pages"
$cwConfig_o.page.folder_f:=Formula:C1597(<>webApp_o.config.webApp.folder_t+Choose:C955(Count parameters:C259=1;$1;visiteur.sousDomaine)+Folder separator:K24:12+<>webApp_o.config.page.folderName_t+Folder separator:K24:12)
  // Utilisation
  // Dans le cas d'une utilisation dans le process web actif, il n'est pas obligé de mettre de paramêtre.
  // Si l'on souhaite forcer le dossier page d'un sous domaine précis, il faut le passer en paramêtre.
  //$dossierPage_t:=<>webApp_o.config.page.folder_f("clients")

$cwConfig_o.pageDev:=New object:C1471()
$cwConfig_o.pageDev.folderName_t:="pages-dev"
$cwConfig_o.pageDev.folder_f:=Formula:C1597(<>webApp_o.config.webApp.folder_t+Choose:C955(Count parameters:C259=1;$1;visiteur.sousDomaine)+Folder separator:K24:12+<>webApp_o.config.pageDev.folderName_t+Folder separator:K24:12)
  // Utilisation : $dossierForm_t:=<>webApp_o.config.pageDev.folder_f("www")

$cwConfig_o.form:=New object:C1471()
$cwConfig_o.form.folderName_t:="form"
$cwConfig_o.form.folder_f:=Formula:C1597(<>webApp_o.config.webApp.folder_t+Choose:C955(Count parameters:C259=1;$1;visiteur.sousDomaine)+Folder separator:K24:12+<>webApp_o.config.form.folderName_t+Folder separator:K24:12)
  // Utilisation : $dossierForm_t:=<>webApp_o.config.form.folder_f("www")

$cwConfig_o.js:=New object:C1471()
$cwConfig_o.js.folderName_t:="js"
$cwConfig_o.js.folder_f:=Formula:C1597(<>webApp_o.config.webApp.folder_t+Choose:C955(Count parameters:C259=1;$1;visiteur.sousDomaine)+Folder separator:K24:12+<>webApp_o.config.js.folderName_t+Folder separator:K24:12)
  // Utilisation : $dossierForm_t:=<>webApp_o.config.js.folder_f("www")

$cwConfig_o.i18n:=New object:C1471()
$cwConfig_o.i18n.folderName_t:="i18n"
$cwConfig_o.i18n.folder_f:=Formula:C1597(<>webApp_o.config.webApp.folder_t+Choose:C955(Count parameters:C259=1;$1;visiteur.sousDomaine)+Folder separator:K24:12+<>webApp_o.config.i18n.folderName_t+Folder separator:K24:12)
  // Utilisation : $dossierForm_t:=<>webApp_o.config.i18n.folder_f("www")

$cwConfig_o.route:=New object:C1471()
$cwConfig_o.route.folderName_t:="route"
$cwConfig_o.route.folder_f:=Formula:C1597(<>webApp_o.config.webApp.folder_t+Choose:C955(Count parameters:C259=1;$1;visiteur.sousDomaine)+Folder separator:K24:12+<>webApp_o.config.route.folderName_t+Folder separator:K24:12)
  // Utilisation : $dossierForm_t:=<>webApp_o.config.route.folder_f("www")


If (<>webApp_o.config=Null:C1517)
	  // On applique la config de base à notre composant.
	<>webApp_o.config:=$cwConfig_o
	
Else 
	  // On fusionne la config de base avec les param.
	<>webApp_o.config:=cwToolObjectMerge ($cwConfig_o;<>webApp_o.config)
End if 


  // On vérifie que le repertoire webApp existe dans le dossier ressources de l'application hôte.
If (Test path name:C476(<>webApp_o.config.webApp.folder_f())#Is a folder:K24:2)
	  // Il n'existe pas... On crée le dossier avec son arborescence.
	CREATE FOLDER:C475(<>webApp_o.config.webApp.folder_f();*)
End if 


  // On vérifie qu'il existe bien un fichier de config pour l'utilisation du composant dans la base hôte.
If (Test path name:C476(<>webApp_o.config.webApp.folder_f()+"config.json")#Is a document:K24:1)
	  // Il n'existe pas... On crée un fichier vierge
	TEXT TO DOCUMENT:C1237(<>webApp_o.config.webApp.folder_f()+"config.json";JSON Stringify:C1217(New object:C1471();*))
End if 

  // On charge le fichier de config.
$cwConfig_o:=JSON Parse:C1218(Document to text:C1236(<>webApp_o.config.webApp.folder_f()+"config.json"))

  // On refusionne les data avec les informations précédentes.
<>webApp_o:=cwToolObjectMerge (<>webApp_o;$cwConfig_o)


  // Creation du dossier sites par defaut dans le dossier ressource
  // On récupére la liste des dossiers dans le dossier site.
  // Ils correspondent au sous domaine qui vont être utilisé.
FOLDER LIST:C473(<>webApp_o.config.webApp.folder_f();$subDomain_at)

  // Si il n'y a pas de dossier, on propose de créer un dossier.
If (Size of array:C274($subDomain_at)=0)
	$subDomain_t:=Request:C163("indiquez le sous domaine du site à creer ?";"www")
	If (ok=1)
		CREATE FOLDER:C475(<>webApp_o.config.webApp.folder_f()+$subDomain_t+Folder separator:K24:12;*)
		APPEND TO ARRAY:C911($subDomain_at;$subDomain_t)
	End if 
End if 

  // On stock une collection avec le nom des sous domaines.
<>webApp_o.config.subDomain:=New collection:C1472()
ARRAY TO COLLECTION:C1563(<>webApp_o.config.subDomain;$subDomain_at)

  // On vérifie que pour chaque sous domaine web de l'application, l'arborescence des dossiers soit conforme.
For each ($subDomain_t;<>webApp_o.config.subDomain)
	
	  //Récupération du plan des pages web des sites.
	  //On regarde si le fichier de config est dans le dossier des ressources
	  // de la base hôte.
	$chDossier:=<>webApp_o.config.route.folder_f($subDomain_t)+"_goutte.route.json"
	If (Test path name:C476($chDossier)#Is a document:K24:1)
		  //Il n'existe pas... on va faire une copie du fichier de demo.
		COPY DOCUMENT:C541(Get 4D folder:C485(Current resources folder:K5:16)+"goutte.route.json";$chDossier)
	End if 
	
	
	  // Chargement du dossier des pages du composant cioWeb
	$chDossier:=<>webApp_o.config.pageDev.folder_f($subDomain_t)+"cioWeb"+Folder separator:K24:12
	If (Test path name:C476($chDossier)#Is a folder:K24:2)
		CREATE FOLDER:C475($chDossier;*)
	End if 
	
	ARRAY TEXT:C222($pagesComposant;0)
	$dossierPagesComposant:=Get 4D folder:C485(Current resources folder:K5:16)+"pages"+Folder separator:K24:12
	DOCUMENT LIST:C474($dossierPagesComposant;$pagesComposant)
	
	For ($p;1;Size of array:C274($pagesComposant))
		If (Test path name:C476($chDossier+$pagesComposant{$p})#Is a document:K24:1)
			COPY DOCUMENT:C541($dossierPagesComposant+$pagesComposant{$p};$chDossier+$pagesComposant{$p})
		End if 
	End for 
	
	
	  //Le dossier avec le HTML minifié.
	$chDossier:=<>webApp_o.config.page.folder_f($subDomain_t)
	If (Test path name:C476($chDossier)#Is a folder:K24:2)
		CREATE FOLDER:C475($chDossier;*)
	End if 
	
	  // Vérification des répertoires javascript.
	  //Le dossier avec le js non minifié.
	$chDossier:=<>webApp_o.config.js.folder_f($subDomain_t)
	If (Test path name:C476($chDossier)#Is a folder:K24:2)
		CREATE FOLDER:C475($chDossier;*)
	End if 
	
	  //Le dossier avec les javascripts minimifiés.
	$chDossier:=Get 4D folder:C485(HTML Root folder:K5:20;*)+$subDomain_t+Folder separator:K24:12+"js"+Folder separator:K24:12
	If (Test path name:C476($chDossier)#Is a folder:K24:2)
		CREATE FOLDER:C475($chDossier;*)
	End if 
	
	  // Vérification de l'emplacement des formulaires.
	$chDossier:=<>webApp_o.config.form.folder_f($subDomain_t)
	If (Test path name:C476($chDossier)#Is a folder:K24:2)
		CREATE FOLDER:C475($chDossier;*)
	End if 
	
	If (Test path name:C476($chDossier+"modele.form.json")#Is a document:K24:1)
		  //Il n'existe pas... on va faire une copie du fichier de demo.
		COPY DOCUMENT:C541(Get 4D folder:C485(Current resources folder:K5:16)+"form"+Folder separator:K24:12+"modele.form.json";$chDossier)
	End if 
	
End for each 


  // Creation du dossier upload par defaut dans le dossier web public
  // La 1er lettre du nom du fichier n'est pas en majuscule, car c'est moins esthétique dans une URL
$chDossier:=Get 4D folder:C485(HTML Root folder:K5:20;*)+"uploads"+Folder separator:K24:12
If (Test path name:C476($chDossier)#Is a folder:K24:2)
	CREATE FOLDER:C475($chDossier;*)
End if 



  // On remonte les informations à la base hôte.
$0:=<>webApp_o