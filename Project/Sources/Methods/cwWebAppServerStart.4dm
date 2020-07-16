//%attributes = {}
/* ----------------------------------------------------
Méthode : cwWebAppServerStart

charge la configuration du serveur web.
Placer cette methode sur demarrage de la base)

Historique
19/02/15 - Grégory Fromain <gregory@connect-io.fr> - Création
21/12/19 - Grégory Fromain <gregory@connect-io.fr> - Ajout de la possibilité de créer une arborescence dans les fichiers des pages html.
31/03/20 - Grégory Fromain <gregory@connect-io.fr> - Gestion des héritages
25/06/20 - Grégory Fromain <gregory@connect-io.fr> - Mise à jour emplacement des routes.
25/06/20 - Grégory Fromain <gregory@connect-io.fr> - Mise à jour emplacement des views.
16/07/20 - Grégory Fromain <gregory@connect-io.fr> - Gestion des routes sous forme de collection.

Appel de la methode
C_OBJECT(<>configPage)
cwStartServeur(-><>configPage)
----------------------------------------------------*/



If (True:C214)  // Déclarations
	C_LONGINT:C283($j;$r)
	C_TEXT:C284($routeVar;$routeRegex;$routeFormatData;$temp_o;$subDomain_t)
	C_OBJECT:C1216($configPage;$page;$route;$routeDefault;$routeFormat)
	
	C_TEXT:C284($parentLibPage;$parentLibPagePrecedent)  // Permet de gérer l'héritage des routes.
	C_LONGINT:C283($i_l)  // Permet de gérer l'héritage des fichiers html
	C_TEXT:C284($methodeNom_t)  //  Permet de gérer l'héritage des méthodes de la page
	ARRAY TEXT:C222($libpage_at;0)
	ARRAY TEXT:C222($routeFormatCle;0)
	
	C_COLLECTION:C1488($route_c)
End if 



varVisiteurName_t:=This:C1470.config.varVisitorName_t



For each ($subDomain_t;This:C1470.config.subDomain_c)
	  // On purge la liste des routes
	$route_c:=New collection:C1472()
	  //Récupération du plan des pages web des sites.
	$configPage:=New object:C1471
	ARRAY TEXT:C222($routeFile_at;0)
	DOCUMENT LIST:C474(This:C1470.sourceSubdomainPath($subDomain_t);$routeFile_at;Recursive parsing:K24:13+Absolute path:K24:14)
	
	  // Chargement de tout les fichiers de routing.
	For ($routeNum;1;Size of array:C274($routeFile_at))
		  // On charge toutes les routes, mais pas le modele
		If ($routeFile_at{$routeNum}="@route.json")
			$configPage:=cwToolObjectMerge ($configPage;JSON Parse:C1218(Document to text:C1236($routeFile_at{$routeNum};"UTF-8")))
		End if 
	End for 
	
	  //---------- On merge les routes parents ----------
	
	For each ($libPage;$configPage)
		
		If ($libPage#"parent@")
			
			If ($configPage[$libPage].parents#Null:C1517)
				$parentLibPage:=$configPage[$libPage].parents[0]
				Repeat 
					$parentLibPagePrecedent:=$parentLibPage
					
					If ($configPage[$parentLibPage]=Null:C1517)
						ALERT:C41("La route parent suivante n'est pas définit :"+$parentLibPage)
						$parentLibPage:=""  // Permet de sortir de la boucle.
					Else 
						$configPage[$libPage]:=cwToolObjectMerge ($configPage[$parentLibPage];$configPage[$libPage])
						$parentLibPage:=$configPage[$libPage].parents[0]
					End if 
					
					
				Until ($parentLibPagePrecedent=$parentLibPage)
				
			End if 
		End if 
	End for each 
	
	  // Une fois que l'on a merge les routes parents, on peut les supprimer...
	For each ($libPage;$configPage)
		If ($libPage="parent@")
			OB REMOVE:C1226($configPage;$libPage)
		End if 
	End for each 
	
	
	  // On precharge les routes
	OB GET PROPERTY NAMES:C1232($configPage;$libpage_at)
	For ($j;1;Size of array:C274($libpage_at))
		
		$page:=OB Get:C1224($configPage;$libpage_at{$j})
		
		$page.lib:=$libpage_at{$j}
		
		If ($page.route#Null:C1517)
			  // On récupére la route de la page.
			$route:=$page.route
			  // On fabrique la regex de la route.
			  // On prend le path
			$routeRegex:=$route.path
			
			  // On charge les variables de l'url
			$routeFormat:=Choose:C955(OB Is defined:C1231($route;"format");$route.format;New object:C1471)
			
			  // On charge les valeurs des variables par defaut.
			$routeDefault:=Choose:C955(OB Is defined:C1231($route;"default");$route.default;New object:C1471)
			
			  // On boucle sur les formats de variables
			If (OB Is defined:C1231($route;"format"))
				OB GET PROPERTY NAMES:C1232($route.format;$routeFormatCle)
				For ($r;1;Size of array:C274($routeFormatCle))
					$temp_o:=$route.format[$routeFormatCle{$r}]
					$routeRegex:=Replace string:C233($routeRegex;$routeFormatCle{$r};"("+$temp_o+")")
				End for 
			End if 
			
			$route.regex:=$routeRegex
			
			$routeVar:=$route.path
			
			
			For ($r;1;Size of array:C274($routeFormatCle))
				If (OB Is defined:C1231($routeDefault;$routeFormatCle{$r}))
					$routeFormatData:="<!--#4DIF (OB is defined(routeVar;\""+$routeFormatCle{$r}+"\"))--><!--#4DTEXT OB Get(routeVar;\""+$routeFormatCle{$r}+"\")--><!--#4DELSE-->"+OB Get:C1224($routeDefault;$routeFormatCle{$r})+"<!--#4DENDIF-->"
				Else 
					$routeFormatData:="<!--#4DIF (OB is defined(routeVar;\""+$routeFormatCle{$r}+"\"))--><!--#4DTEXT OB Get(routeVar;\""+$routeFormatCle{$r}+"\")--><!--#4DELSE--> il manque la variable "+$routeFormatCle{$r}+"+<!--#4DENDIF-->"
				End if 
				$routeVar:=Replace string:C233($routeVar;$routeFormatCle{$r};$routeFormatData)
			End for 
			OB SET:C1220($route;"variable";$routeVar)
			
			OB SET:C1220($page;"route";$route)
			OB SET:C1220($configPage;$libpage_at{$j};$page)
		End if 
	End for 
	
	
	  //Creation du chemin complet du fichier html
	For ($j;1;Size of array:C274($libpage_at))
		$page:=$configPage[$libpage_at{$j}]
		If ($page.fichier#Null:C1517)
			
			  // Attention : On ne peut pas utiliser ici de boucle for each car sa modification ne sera pas répercutée sur l'élément de la collection.
			For ($i_l;0;$page.fichier.length-1)
				  // On gére la possibilité de créer une arborescence dans les dossiers des pages HTML
				$page.fichier[$i_l]:=Replace string:C233($page.fichier[$i_l];":";Folder separator:K24:12)  // Séparateur mac
				$page.fichier[$i_l]:=Replace string:C233($page.fichier[$i_l];"/";Folder separator:K24:12)  // Séparateur unix
				$page.fichier[$i_l]:=Replace string:C233($page.fichier[$i_l];"\\";Folder separator:K24:12)  // Séparateur windows
				$page.fichier[$i_l]:=This:C1470.viewCacheSubdomainPath($subDomain_t)+$page.fichier[$i_l]
				
				  // On vérifie que le fichier existe bien
				If (Test path name:C476($page.fichier[$i_l])#Is a document:K24:1)
					ALERT:C41("Il manque le fichier suivant : "+$page.fichier[$i_l])
				End if 
				
			End for 
		Else 
			$page.fichier:=New collection:C1472
		End if 
		
		
		If ($page.methode#Null:C1517)
			
			For each ($methodeNom_t;$page.methode)
				ARRAY TEXT:C222($methodName_at;0)
				METHOD GET NAMES:C1166($methodName_at;$methodeNom_t+"@";*)
				If (Size of array:C274($methodName_at)=0)
					ALERT:C41("Il manque la méthode suivante de l'application : "+$methodeNom_t)
				End if 
			End for each 
		Else 
			$page.methode:=New collection:C1472
		End if 
		
		
		  // On determine le type de fichier que l'on va traiter.
		Case of 
			: (cwExtensionFichier (String:C10($page.route.path))#"")
				$page.type:=cwExtensionFichier ($page.route.path)
				
			: (cwExtensionFichier (String:C10($page.url))#"")
				$page.type:=cwExtensionFichier ($page.url)
				
				  //: (cwExtensionFichier (String($page.fichier))#"")
				  //$page.type:=cwExtensionFichier ($page.fichier)
				
			: ($page.fichier.length#0)
				$page.type:=cwExtensionFichier ($page.fichier[($page.fichier.length-1)])
				
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
	
	This:C1470.sites[$subDomain_t].route:=$route_c
End for each 

