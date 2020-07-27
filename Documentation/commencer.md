# Commencer avec le composant cioWeb

## Présentation

## Configuration du localhost

## Méthode de base sur ouverture

```4d
/* ----------------------------------------------------------------------
	Méthode : Sur ouverture
	
	Charger tout les éléments propres à l'application Web
	
	Historique
	27/07/20 -  Grégory Fromain - création
---------------------------------------------------------------------- */

If (True)  // Déclarations
	C_OBJECT(<>webApp_o)
	C_VARIANT($classWebApp_v)
End if 


  // Récupération de la class webApp depuis le composant
$classWebApp_v:=cwToolGetClass ("webApp")

  // Instanciation de la class
<>webApp_o:=$classWebApp_v.new()


MESSAGE("Arret du serveur serveur web..."+Char(Carriage return))
WEB STOP SERVER

MESSAGE("Chargement de l'application web..."+Char(Carriage return))
<>webApp_o.serverStart()

MESSAGE("Redémarrage du serveur serveur web..."+Char(Carriage return))
WEB START SERVER
If (ok#1)
	ALERT("Le serveur web n'est pas correctement démarré.")
End if 
```

## Méthode de base sur conenxion web
```4d
/* ----------------------------------------------------------------------
	Méthode : Sur connexion web
	
	La méthode reçoit tout les params de la méthode sur connexion web
	
	Historique
	27/07/20 -  Grégory Fromain & Tifenn Fabry - création
----------------------------------------------------------------------*/

If (True)  // Déclarations
	C_TEXT($3)  // Adresse IP du navigateur.
	
	C_OBJECT(visiteur_o;pageWeb_o)
	C_TEXT($htmlFichierChemin_t;$resultatMethode_t;$methodeNom_t)
End if 

  // ===== Chargement des informations du visiteur du site =====
If (visiteur_o=Null)
	visiteur_o:=<>webApp_o.userNew()
End if 

visiteur_o.getInfo()
visiteur_o.ip:=$3

  // Dectection du mode developpement
visiteur_o.devMode:=visiteur_o.Host="@dev@"


  // ===== Rechargement des variables de l'application =====
If (visiteur_o.devMode)
	SET ASSERT ENABLED(True)
	<>webApp_o.serverStart()
End if 


  // ===== Chargement des informations sur la page =====
pageWeb_o:=<>webApp_o.pageCurrent(visiteur_o)

  // On va fusionner les data de la route de l'url sur le visiteur.
If (pageWeb_o.route.data#Null)
	
	For each ($routeData_t;pageWeb_o.route.data)
		visiteur_o[$routeData_t]:=pageWeb_o.route.data[$routeData_t]
	End for each 
End if 


  // On execute si besoin les méthodes relative à la page
For each ($methodeNom_t;pageWeb_o.methode)
	EXECUTE METHOD($methodeNom_t;$resultatMethode_t)
	pageWeb_o.resulatMethode_t:=$resultatMethode_t
End for each 

  //Si il y a un fichier html à renvoyer... on lance le constructeur.
visiteur_o.updateVarVisiteur()


Case of 
	: (pageWeb_o.viewPath.length=0) & (String(pageWeb_o.resulatMethode_t)#"")
		  // Si c'est du hard code. (ex : requete ajax)
		WEB SEND TEXT(pageWeb_o.resulatMethode_t;pageWeb_o.type)
		
	: (pageWeb_o.viewPath.length=0)
		  // On ne fait rien la méthode d'appel renvoit déjà du contenu
		  // (Exemple fichier Excel)
		
	Else 
		  // On génére un nouveau token pour le visiteur
		If (pageWeb_o.lib#"404")
			visiteur_o.tokenGenerate()
		End if 
		
		  //Pour charger les éléments HTML de la page, on demarre par les éléments de plus bas niveau.
		pageWeb_o.viewPath:=pageWeb_o.viewPath.reverse()
		
		For each ($htmlFichierChemin_t;pageWeb_o.viewPath)
			$contenuFichierCorpsHtml_t:=Document to text($htmlFichierChemin_t)
			
			PROCESS 4D TAGS($contenuFichierCorpsHtml_t;$contenuFichierCorpsHtml_t)
			
			pageWeb_o.scanBlock($contenuFichierCorpsHtml_t)
			
			pageWeb_o.corps:=$contenuFichierCorpsHtml_t
		End for each 
		
		
		WEB SEND TEXT(pageWeb_o.corps;pageWeb_o.type)
		
End case 
```