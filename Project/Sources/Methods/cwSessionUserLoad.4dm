//%attributes = {"shared":true}
/* ----------------------------------------------------
Méthode : cwSessionUserLoad

Si possible l'on vient charger la $session web de l'utilisateur.

Historique
20/02/15 - Grégory Fromain <gregory@connect-io.fr> - Création
31/07/19 - Grégory Fromain <gregory@connect-io.fr> - Ré-écriture de la méthode
13/05/20 - Grégory Fromain <gregory@connect-io.fr> - Fix bug dans la mise à jour des dossiers temporaires.
----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_POINTER:C301($1)  // $1 : [objet] visiteur
	
	C_TEXT:C284($chFichierSession_t;$chAncienDossier_t;$chNouveauDossier_t)
	C_OBJECT:C1216($session_o;$visiteur_o)
	C_LONGINT:C283($i_l)
End if 


$visiteur_o:=$1->
If (Bool:C1537($visiteur_o.sessionActive)=False:C215)
	
	  // La $session n'existe pas.
	  // Si le navigateur envoi un cookies on doit pourvoir la recreer...
	If (OB Is defined:C1231($visiteur_o;<>sessionWeb.name))
		
		  //On regarde si dans le dossier des session, un fichier existe...
		$chFichierSession_t:=<>sessionWeb.folder+$visiteur_o[<>sessionWeb.name]+".json"
		If (Test path name:C476($chFichierSession_t)=Is a document:K24:1)
			
			  // On récupere le contenu du fichier
			$session_o:=JSON Parse:C1218(Document to text:C1236($chFichierSession_t;"UTF-8"))
			
			  // On fusionne les informations du visiteur.
			$visiteur_o:=cwToolObjectMerge ($session_o;$visiteur_o)
			
			  // On supprime le fichier car maintenant obsolete
			DELETE DOCUMENT:C159($chFichierSession_t)
			
			  // On regarde si un dossier temporaire existe pour cette session.
			If (Test path name:C476(<>sessionWeb.folder+$visiteur_o[<>sessionWeb.name])=Is a folder:K24:2)
				
				  // Il existe un dossier, il faut le renomer avec la nouvelle session en cours.
				  // Mais ce n'est pas possible... On va donc d'abort créer un nouveau dossier.
				$chAncienDossier_t:=<>sessionWeb.folder+$visiteur_o[<>sessionWeb.name]+Folder separator:K24:12
				$chNouveauDossier_t:=<>sessionWeb.folder+WEB Get current session ID:C1162+Folder separator:K24:12
				CREATE FOLDER:C475($chNouveauDossier_t;*)
				
				  // On transfert les fichiers
				  //COPY DOCUMENT($chAncienDossier_t;$chNouveauDossier_t;*)
				
				ARRAY TEXT:C222($dossiersEnfant_t;0)
				FOLDER LIST:C473($chAncienDossier_t;$dossiersEnfant_t)
				
				For ($i_l;1;Size of array:C274($dossiersEnfant_t))
					COPY DOCUMENT:C541($chAncienDossier_t+$dossiersEnfant_t{$i_l}+Folder separator:K24:12;$chNouveauDossier_t;*)
				End for 
				
				  // On supprime l'ancien dossier.
				DELETE FOLDER:C693($chAncienDossier_t;Delete with contents:K24:24)
			End if 
			
			  // On change dans la variable visiteur, uuid de la session courante.
			OB SET:C1220($visiteur_o;<>sessionWeb.name;WEB Get current session ID:C1162)
			
		End if 
	End if 
	
	  //Recupération ou pas des sessions, on n'y retournera pas pendant la session
	$visiteur_o.sessionActive:=True:C214
	
	  // On en profile pour resynchroniser le composant (Appel dans pageGetInfo)
	cwVisiteurLoad ($visiteur_o)
	
	  // Et on remonte tout dans la base hote.
	$1->:=$visiteur_o
End if 

$0:=Bool:C1537($visiteur_o.sessionActive)

