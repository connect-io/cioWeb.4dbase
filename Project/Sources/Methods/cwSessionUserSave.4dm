//%attributes = {"shared":true}
  // ----------------------------------------------------
  // Méthode : cwSessionUserSave
  // On sauvegarde la session du visiteur.
  // 
  //
  // Paramètres
  // $1 = [objet] visiteur 
  // ----------------------------------------------------

If (False:C215)  // Historique
	  // 31/07/19 - Grégory Fromain <gregory@connect-io.fr> - Création
	  // 13/05/20 - Grégory Fromain <gregory@connect-io.fr> - Modification des notications d'erreur en cas de chargement d'une seule page
End if 

If (True:C214)  // Déclarations
	C_OBJECT:C1216($1;$visiteur_o)
	C_OBJECT:C1216($logErreur_o)
	C_TEXT:C284($chSessionWeb_t)
End if 

$visiteur_o:=$1
$logErreur_o:=New object:C1471

  // On vérifie que la gestion des sessions est actif
If (String:C10(<>sessionWeb.folder)="")
	$logErreur_o.detailErreur:="La gestion des sessions n'est pas actif."
End if 

  //If (String($logErreur_o.detailErreur)="")
  //If (String(visiteur.infoCookies)#"init")

  //  // il faut récupérer l'UUID de la session du visiteur
  //If (String($visiteur_o[<>sessionWeb.name])="")
  //$logErreur_o.detailErreur:="Impossible de récupérer ID de la session du visiteur."
  //End if 
  //End if 
  //End if 


If (String:C10($logErreur_o.detailErreur)="")
	
	If (String:C10($visiteur_o[<>sessionWeb.name])#"")
		  // Chemin du fichier dans lequel sera stocké la session.
		$chSessionWeb_t:=<>sessionWeb.folder+$visiteur_o[<>sessionWeb.name]+".json"
		
		TEXT TO DOCUMENT:C1237($chSessionWeb_t;JSON Stringify:C1217(visiteur;*))
		
		If (Test path name:C476($chSessionWeb_t)#Is a document:K24:1)
			
			$logErreur_o.detailErreur:="Impossible d'ecrire le fichier : "+$chSessionWeb_t
		End if 
		
	Else 
		  // Il est possible que le cookies de session ne soit pas remonté.
		  // ex : Robot ou chargement d'une page unique...
		  // Dans ce cas on ne stock pas de session.
		
	End if 
End if 


If (String:C10($logErreur_o.detailErreur)#"")
	$logErreur_o.methode:=Current method name:C684
	$logErreur_o.visiteur:=$visiteur_o
	cwLogErreurAjout ("erreur session";$logErreur_o)
End if 


  // Précendente version
  //If (visiteur.infoCookies#Null) & (visiteur.CIOSID#Null)
  //If (OB Get(visiteur;"infoCookies")#"init")
  //If (OB Get(visiteur;"CIOSID";Is text)#"")
  //$chSessionWeb:=Get 4D folder(Database folder;*)+"data"+Folder separator+"sessionWeb"+Folder separator
  //If (Test path name($chSessionWeb)#Is a folder)
  //CREATE FOLDER($chSessionWeb;*)
  //End if 

  //$chSessionWeb:=$chSessionWeb+OB Get(visiteur;"CIOSID";Is text)

  //TEXT TO DOCUMENT($chSessionWeb;JSON Stringify(visiteur;*))

  //If (Test path name($chSessionWeb)#Is a document)
  //C_OBJECT($logErreur)
  //$logErreur:=New object
  //$logErreur.methode:=Current method name
  //$logErreur.detailErreur:="Impossible d'ecrire le fichier : "+$chSessionWeb
  //$logErreur.visiteur:=visiteur
  //cwLogErreurAjout ("erreur session";$logErreur)
  //End if 
  //End if 
  //End if 
  //End if 