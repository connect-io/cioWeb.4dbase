//%attributes = {"shared":true}
  // ----------------------------------------------------
  // Méthode : cwSessionUserFolder
  // Si possible l'on renvoi, le dossier de session du visiteur.
  // 
  //
  // Paramètres
  // $1 = [objet] visiteur 
  // $0 = [text] chemin du dossier de session du visiteur
  // ----------------------------------------------------

If (False:C215)  // Historique
	  // 31/07/19 - Grégory Fromain <gregory@connect-io.fr> - Création
End if 

If (True:C214)  // Déclarations
	C_OBJECT:C1216($1;$visiteur_o)
	C_TEXT:C284($0;$chFolderSession_t)
	C_OBJECT:C1216($logErreur_o)
End if 


$visiteur_o:=$1
$logErreur_o:=New object:C1471

  // On vérifie que la gestion des sessions est actif
If (String:C10(<>sessionWeb.folder)="")
	$logErreur_o.detailErreur:="La gestion des sessions n'est pas actif."
End if 

If (String:C10($logErreur_o.detailErreur)="")
	
	  // il faut récupérer l'UUID de la session du visiteur
	If (String:C10($visiteur_o[<>sessionWeb.name])="")
		$logErreur_o.detailErreur:="Impossible de récupérer ID de la session du visiteur."
	End if 
End if 


If (String:C10($logErreur_o.detailErreur)="")
	
	  //On monte le chemin du dossier.
	$chFolderSession_t:=<>sessionWeb.folder+$visiteur_o[<>sessionWeb.name]+Folder separator:K24:12
	
	If (Test path name:C476($chFolderSession_t)#Is a folder:K24:2)
		CREATE FOLDER:C475($chFolderSession_t;*)
	End if 
	
	$0:=$chFolderSession_t
End if 


If (String:C10($logErreur_o.detailErreur)#"")
	$logErreur_o.methode:=Current method name:C684
	$logErreur_o.visiteur:=$visiteur_o
	cwLogErreurAjout ("erreur session";$logErreur_o)
	
	ALERT:C41($logErreur_o.detailErreur)
	
	  // On renvoit ce que l'on peut faire de mieux...
	$0:=Get 4D folder:C485(Database folder:K5:14;*)
End if 