/* 
Class : cs.User

Gére l'utilisateur / client web

Utilisateur sur le serveur web peut-être un visiteur d'une page web, 
un robot google ou un autre serveur qui vient interroger le notre.

*/


Class constructor
/* -----------------------------------------------------------------------------
Fonction : User.constructor
	
Initialisation d'un utilisateur
ATTENTION : L'instance de la class "User" doit se faire obligatoirement par la fonction : webApp.userNew()
	
Historique
17/07/20 - Grégory Fromain <gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
27/01/21 - Grégory Fromain <gregory@connect-io.fr> - Purge constructeur (retrait session)
------------------------------------------------------------------------------ */
	
	This:C1470.updateVarVisiteur()
	
	
Function entityToForm
/* -----------------------------------------------------------------------------
Fonction : User.entityToForm
	
Remplit un formulaire avec les infos d'une entité.
	
Historique
23/11/20 - Alban Catoire alban@connect-io.fr> - Reprise de code en fonction
23/11/20 - Grégory Fromain <gregory@connect-io.fr> - Clean code
----------------------------------------------------------------------------- */
	
	var $1;$entity : Object  // l'entité dont on charge les infos
	var $2;$nomForm_t : Text  // Nom du formulaire 
	
	var $Form_o : Object
	var $entityNameCalcule_t : Text
	var $compatible_b : Boolean
	var $input : Object
	
	ASSERT:C1129(Count parameters:C259=2;"Le nombre de paramêtre n'est pas bon.")
	ASSERT:C1129(Type:C295($2)=Is text:K8:3;"Le param $2, doit être de type text.")
	
	$nomForm_t:=$2
	$entity:=$1
	
	$Form_o:=This:C1470.formInfo($nomForm_t)
	
	If ($Form_o#Null:C1517)
		
		For each ($input;$Form_o.input)
			$compatible_b:=False:C215
			
			$entityNameCalcule_t:=Replace string:C233($input.lib;$Form_o.inputPrefixe;"")
			
			If ($entity[$entityNameCalcule_t]#Null:C1517)
				// Dans le cas ou le champ commence par une majuscule.
				visiteur_o[$input.lib]:=$entity[$entityNameCalcule_t]
				$compatible_b:=True:C214
			Else 
				//$entityNameCalcule_t:=Lowercase(Substring($entityNameCalcule_t;1;1))+Substring($entityNameCalcule_t;2)
				
				// 1er caractère en minuscule.
				$entityNameCalcule_t[[1]]:=Lowercase:C14($entityNameCalcule_t[[1]])
				
				// Dans le cas ou le champ commence par une minuscule.
				$compatible_b:=$entity[$entityNameCalcule_t]#Null:C1517
			End if 
			
			If ($compatible_b)
				$infoAEnregistrer:=$entity[$entityNameCalcule_t]
				Case of 
					: (Value type:C1509($entity[$entityNameCalcule_t])=Is boolean:K8:9)
						This:C1470[$input.lib]:=Choose:C955($entity[$entityNameCalcule_t];"1";"0")
						
					: (Value type:C1509($entity[$entityNameCalcule_t])=Is text:K8:3)
						This:C1470[$input.lib]:=String:C10($entity[$entityNameCalcule_t])
						
					: (Value type:C1509($entity[$entityNameCalcule_t])=Is real:K8:4) | (Value type:C1509($entity[$entityNameCalcule_t])=Is longint:K8:6)
						This:C1470[$input.lib]:=String:C10($entity[$entityNameCalcule_t])
						
					Else 
						// Ne pas traiter... (Exemple image, blog, object,..)
				End case 
			End if 
			
		End for each 
	End if 
	
	
	
Function formInfo
/* -----------------------------------------------------------------------------
Fonction : User.formInfo
	
Retourne les informations d'un formulaire.
	
Historique
24/11/20 - Grégory Fromain <gregory@connect-io.fr> - Création
----------------------------------------------------------------------------- */
	
	var $1;$nomForm_t : Text  // Nom du formulaire
	var $0 : Object  // Information sur le formulaire.
	
	ASSERT:C1129(String:C10($1)#"";"Le param $1, ne doit pas être vide.")
	
	$nomForm_t:=$1
	
	$Form_c:=Storage:C1525.sites[This:C1470.sousDomaine].form.query("lib = :1";$nomForm_t)
	
	If ($Form_c.length=1)
		$0:=OB Copy:C1225($Form_c[0])
	End if 
	
	
	
Function formToEntity
/* -----------------------------------------------------------------------------
Fonction : User.formToEntity
	
Charger les valeurs d'un formulaire vers une entité (ou objet).
	
Historique
04/01/21 - Grégory Fromain <gregory@connect-io.fr> - Création
----------------------------------------------------------------------------- */
	
	// Déclarations
	var $1 : Pointer  // Objet qui sert à remplir les inputs du formulaire $1
	// Si true : On ne modifie pas le input.
	
	var $inputName_t : Text
	
	For each ($inputName_t;This:C1470.dataFormTyping)
		If ($inputName_t#"token")
			ASSERT:C1129($1->[$inputName_t]#Null:C1517;"La propriete "+$inputName_t+" n'est pas déclaré dans l'entité.")
			
			$1->[$inputName_t]:=This:C1470.dataFormTyping[$inputName_t]
		End if 
	End for each 
	
	
	
Function getInfo
/* -----------------------------------------------------------------------------
Fonction : User.getInfo
	
Chargement des éléments sur l'utilisateur / visiteur
Remplace la méthode : cwVisiteurGetInfo
	
Historique
19/02/15 - Grégory Fromain <gregory@connect-io.fr> - Recopie de la methode depuis le composant CioGénérique
26/10/19 - Grégory Fromain <gregory@connect-io.fr> - Passage notation objet
17/07/20 - Grégory Fromain <gregory@connect-io.fr> - Conversion en fonction
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
------------------------------------------------------------------------------ */
	
	var $i_l : Integer
	ARRAY TEXT:C222($nom_at;0)
	ARRAY TEXT:C222($valeur_at;0)
	
	//On retire la propriété "formSubmit" si elle existe... Elle est périmé.
	If (This:C1470.formSubmit#Null:C1517)
		OB REMOVE:C1226(This:C1470;"formSubmit")
	End if 
	
	// ----- Entete HTTP -----
	//récupération des informations dans l'entete HTTP
	WEB GET HTTP HEADER:C697($nom_at;$valeur_at)
	For ($i_l;1;Size of array:C274($nom_at))
		OB SET:C1220(This:C1470;$nom_at{$i_l};$valeur_at{$i_l})
	End for 
	
	// ----- Gestion des cookies -----
	$cookies:=OB Get:C1224(This:C1470;"Cookie";Is text:K8:3)
	If ($cookies#"")
		While ($cookies#"")
			$pos_egal:=Position:C15("=";$cookies)+1
			$pos_point:=Position:C15("; ";$cookies)
			If ($pos_point=0)
				$pos_point:=99999
			End if 
			
			OB SET:C1220(This:C1470;\
				Substring:C12($cookies;1;$pos_egal-2);\
				Substring:C12($cookies;$pos_egal;$pos_point-$pos_egal))
			
			$cookies:=Substring:C12($cookies;$pos_point+2)
		End while 
	End if 
	
	// ----- Récuperation des variables du formulaire -----
	// On reset le tableau
	ARRAY TEXT:C222($nom_at;0)
	ARRAY TEXT:C222($valeur_at;0)
	WEB GET VARIABLES:C683($nom_at;$valeur_at)
	
	For ($i_l;1;Size of array:C274($nom_at))
		OB SET:C1220(This:C1470;$nom_at{$i_l};$valeur_at{$i_l})
	End for 
	
	// ----- Calcul de variable -----
	This:C1470.sousDomaine:=Substring:C12(This:C1470.Host;1;Position:C15(".";This:C1470.Host)-1)
	This:C1470.domaine:=Substring:C12(This:C1470.Host;Position:C15(".";This:C1470.Host)+1)
	
	// On retire les parametres de l'url.
	$url_t:=This:C1470["X-URL"]
	This:C1470.url:=Choose:C955(Position:C15("?";$url_t)#0;Substring:C12($url_t;1;Position:C15("?";$url_t)-1);$url_t)
	
	//On efface les messages d'erreur eventuel
	// Sauf si on vient d'une redirection
	If (OB Is defined:C1231(This:C1470;"envoiHttpRedirection"))
		// Pour ce chargement on efface pas les message d'information.
		OB REMOVE:C1226(This:C1470;"envoiHttpRedirection")
	Else 
		// Nouveau format
		This:C1470.notificationError:=""
		This:C1470.notificationSuccess:=""
		This:C1470.notificationWarning:=""
		This:C1470.notificationInfo:=""
	End if 
	
	This:C1470.updateVarVisiteur()
	
	
	
Function login
/* -----------------------------------------------------------------------------
Fonction : User.login
	
À utiliser après la vérification des utilisateurs.
Permet de garder l'information durant la  session.
	
Remplace la méthode : cwVisiteurLogin
	
Historique
29/09/15 - Grégory Fromain <gregory@connect-io.fr> - Création
14/08/19 - Grégory Fromain <gregory@connect-io.fr> - Mise au propre et ajout visiteur .action
17/07/20 - Grégory Fromain <gregory@connect-io.fr> - Conversion en fonction
------------------------------------------------------------------------------ */
	
	This:C1470.loginDomaine:=String:C10(This:C1470.domaine)
	This:C1470.loginEMail:=String:C10(This:C1470.eMail)
	
	This:C1470.loginExpire_ts:=cwTimestamp(Current date:C33;?23:59:59?)
	
	// Peut être utilisé dans certaine requête pour la suite.
	This:C1470.action:=Null:C1517
	
	// On redirige vers la page d'index.
	cwHttpRedirect("index")
	
	
	
Function logout
/* -----------------------------------------------------------------------------
Fonction : User.logout
	
Déconnexion de l'utilisateur
Remplace la méthode : cwVisiteurLogout
	
Historique
17/07/20 - Grégory Fromain <gregory@connect-io.fr> - Conversion en fonction
------------------------------------------------------------------------------ */
	
	This:C1470.loginDomaine:=""
	This:C1470.loginEMail:=""
	This:C1470.loginLevel:=""
	
	
	
Function objectMerge
/* -----------------------------------------------------------------------------
Fonction : User.objectMerge
	
Permet la fusion proprement d'un objet avec l'instance utilisateur
	
Historique
17/07/20 - Grégory Fromain <gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
------------------------------------------------------------------------------ */
	
	var $1 : Object
	
	var $objectMerge_o : Object
	var $key_t : Text
	
	$objectMerge_o:=cwToolObjectMerge(This:C1470;$1)
	
	For each ($key_t;$objectMerge_o)
		This:C1470[$key_t]:=$objectMerge_o[$key_t]
	End for each 
	
	
	
Function sessionWebFolderPath
/* -----------------------------------------------------------------------------
Fonction : User.sessionWebFolderPath
	
Chemin du dossier des sessions web de l'utilisateur.
Remplace la méthode : cwSessionUserFolder
	
Historique
31/07/19 - Grégory Fromain <gregory@connect-io.fr> - Création
17/07/20 - Grégory Fromain <gregory@connect-io.fr> - Conversion en fonction
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
------------------------------------------------------------------------------ */
	
	var $0;$chFolderSession_t : Text  // $0 = [text] chemin du dossier de session du visiteur
	
	var $logErreur_o : Object
	
	$logErreur_o:=New object:C1471
	
	// On vérifie que la gestion des sessions est actif
	If (String:C10(Storage:C1525.sessionWeb.path)="")
		$logErreur_o.detailErreur:="La gestion des sessions n'est pas actif."
	End if 
	
	If (String:C10($logErreur_o.detailErreur)="")
		
		// il faut récupérer l'UUID de la session du visiteur
		If (String:C10(This:C1470[Storage:C1525.sessionWeb.name])="")
			$logErreur_o.detailErreur:="Impossible de récupérer ID de la session du visiteur."
		End if 
	End if 
	
	If (String:C10($logErreur_o.detailErreur)="")
		
		//On monte le chemin du dossier.
		$chFolderSession_t:=Storage:C1525.sessionWeb.path+This:C1470[Storage:C1525.sessionWeb.name]+Folder separator:K24:12
		
		If (Test path name:C476($chFolderSession_t)#Is a folder:K24:2)
			CREATE FOLDER:C475($chFolderSession_t;*)
		End if 
		
		$0:=$chFolderSession_t
	End if 
	
	If (String:C10($logErreur_o.detailErreur)#"")
		$logErreur_o.methode:=Current method name:C684
		$logErreur_o.visiteur:=This:C1470
		cwLogErreurAjout("erreur session";$logErreur_o)
		
		ALERT:C41($logErreur_o.detailErreur)
		
		// On renvoie ce que l'on peut faire de mieux...
		$0:=Get 4D folder:C485(Database folder:K5:14;*)
	End if 
	
	
	
Function sessionWebLoad
/* -----------------------------------------------------------------------------
Fonction : User.sessionWebLoad
	
Chargement des sessions web de l'utilisateur.
Remplace la méthode : cwSessionUserLoad
	
Historique
20/02/15 - Grégory Fromain <gregory@connect-io.fr> - Création
31/07/19 - Grégory Fromain <gregory@connect-io.fr> - Ré-écriture de la méthode
13/05/20 - Grégory Fromain <gregory@connect-io.fr> - Fix bug dans la mise à jour des dossiers temporaires.
17/07/20 - Grégory Fromain <gregory@connect-io.fr> - Conversion en fonction
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
------------------------------------------------------------------------------*/
	
	var $chFichierSession_t : Text
	var $chAncienDossier_t : Text
	var $chNouveauDossier_t : Text
	var $session_o : Object
	var $i_l : Integer
	var $propriete_t : Text
	
	If (Bool:C1537(This:C1470.sessionWebActive)=False:C215)
		
		// La $session n'existe pas.
		// Si le navigateur envoi un cookies on doit pourvoir la recreer...
		If (This:C1470[Storage:C1525.sessionWeb.name]#Null:C1517)
			
			//On regarde si dans le dossier des session, un fichier existe...
			$chFichierSession_t:=Storage:C1525.sessionWeb.path+This:C1470[Storage:C1525.sessionWeb.name]+".json"
			If (Test path name:C476($chFichierSession_t)=Is a document:K24:1)
				
				// On récupere le contenu du fichier
				$session_o:=JSON Parse:C1218(Document to text:C1236($chFichierSession_t;"UTF-8"))
				
				// On fusionne les informations du visiteur
				$session_o:=cwToolObjectMerge($session_o;This:C1470)
				
				For each ($propriete_t;$session_o)
					This:C1470[$propriete_t]:=$session_o[$propriete_t]
				End for each 
				
				// On supprime le fichier car maintenant obsolete
				DELETE DOCUMENT:C159($chFichierSession_t)
				
				// On regarde si un dossier temporaire existe pour cette session.
				If (Test path name:C476(Storage:C1525.sessionWeb.path+This:C1470[Storage:C1525.sessionWeb.name])=Is a folder:K24:2)
					
					// Il existe un dossier, il faut le renomer avec la nouvelle session en cours.
					// Mais ce n'est pas possible... On va donc d'abort créer un nouveau dossier.
					$chAncienDossier_t:=Storage:C1525.sessionWeb.path+This:C1470[Storage:C1525.sessionWeb.name]+Folder separator:K24:12
					$chNouveauDossier_t:=Storage:C1525.sessionWeb.path+WEB Get current session ID:C1162+Folder separator:K24:12
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
				This:C1470[Storage:C1525.sessionWeb.name]:=WEB Get current session ID:C1162
				
			End if 
		End if 
		
		//Recupération ou pas des sessions, on n'y retournera pas pendant la session
		This:C1470.sessionWebActive:=True:C214
		
		// On en profile pour resynchroniser le composant (Appel dans pageGetInfo)
		This:C1470.updateVarVisiteur()
		
	End if 
	
	$0:=Bool:C1537(This:C1470.sessionWebActive)
	
	
	
Function sessionWebSave
/* -----------------------------------------------------------------------------
Fonction : User.sessionWebSave
	
Sauvegarder des sessions web de l'utilisateur.
Remplace la méthode : cwSessionUserSave
	
Historique
31/07/19 - Grégory Fromain <gregory@connect-io.fr> - Création
13/05/20 - Grégory Fromain <gregory@connect-io.fr> - Modification des notications d'erreur en cas de chargement d'une seule page
17/07/20 - Grégory Fromain <gregory@connect-io.fr> - Conversion en fonction
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
------------------------------------------------------------------------------ */
	
	var $logErreur_o : Object
	var $chSessionWeb_t : Text
	
	$logErreur_o:=New object:C1471
	
	// On vérifie que la gestion des sessions est actif
	If (String:C10(Storage:C1525.sessionWeb.path)="")
		$logErreur_o.detailErreur:="La gestion des sessions n'est pas actif."
	End if 
	
	If (String:C10($logErreur_o.detailErreur)="")
		
		If (String:C10(This:C1470[Storage:C1525.sessionWeb.name])#"")
			// Chemin du fichier dans lequel sera stocké la session.
			$chSessionWeb_t:=Storage:C1525.sessionWeb.path+This:C1470[Storage:C1525.sessionWeb.name]+".json"
			
			TEXT TO DOCUMENT:C1237($chSessionWeb_t;JSON Stringify:C1217(This:C1470;*))
			
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
		$logErreur_o.visiteur:=This:C1470
		cwLogErreurAjout("erreur session";$logErreur_o)
	End if 
	
	
	
Function tokenCheck
/* -----------------------------------------------------------------------------
Fonction : User.tokenCheck
	
Vérifie un jeton pour la validation d'une pages web.
Remplace la méthode : cwVisiteurTokenVerifier
	
Historique
17/07/20 - Grégory Fromain <gregory@connect-io.fr> - Conversion en fonction
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
------------------------------------------------------------------------------ */
	
	var $0 : Boolean  // Vrai si valide
	
	var $logErreur_o : Object
	
	$0:=False:C215
	
	If (This:C1470.token#Null:C1517)
		If (This:C1470.tokenControle#Null:C1517)
			If (This:C1470.token=This:C1470.tokenControle)
				$0:=True:C214
			Else 
				$logErreur_o:=New object:C1471()
				$logErreur_o.detailErreur:="Erreur de Token du visiteur"
				$logErreur_o.methode:=Current method name:C684
				$logErreur_o.visiteur:=This:C1470
				cwLogErreurAjout("Configuration serveur";$logErreur_o)
			End if 
		End if 
	End if 
	
	
	
Function tokenGenerate
/* -----------------------------------------------------------------------------
Fonction : User.tokenGenerate
	
Génere un jeton pour la validation des pages web.
Remplace la méthode : cwVisiteurTokenGenerer
	
Historique
17/07/20 - Grégory Fromain <gregory@connect-io.fr> - Conversion en fonction
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
------------------------------------------------------------------------------ */
	
	var $t_uuid : Text
	
	$t_uuid:=Generate UUID:C1066
	This:C1470.token:=$t_uuid
	This:C1470.tokenControle:=$t_uuid
	
	
	
Function updateVarVisiteur
/* -----------------------------------------------------------------------------
Fonction : User.updateVarVisiteur
	
Synchro avec du vieux code
	
Historique
17/07/20 - Grégory Fromain <gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
------------------------------------------------------------------------------ */
	
	// A défaut de faire mieux pour le moment... (Comptatibilité avec du vieux code)
	var visiteur : Object
	visiteur:=This:C1470
	
	
	
	