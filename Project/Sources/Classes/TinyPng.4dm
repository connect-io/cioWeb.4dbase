/* 
Classe : cs.TinyPng
Permet l'utilisation de l'api du site tinypng.com

*/


Class constructor($ApiKey : Text)
/*------------------------------------------------------------------------------
Fonction : TinyPng.constructor
	
Initialisation de la clé de l'API
Si aucune clé n'est renseignée, on utilisera une clé de "démonstration"

Paramètre :
	$ApiKey -> Clé de l'API

Historiques
01/09/17 - Grégory Fromain<gregory@connect-io.fr> -  Création de la méthode
05/11/20 - Titouan Guillon <titouan@connect-io.fr> - Clean méthode + adaptation aux nouvelles formulations
06/11/20 - Titouan Guillon <titouan@connect-io.fr> - Création du constructeur
01/12/21 - Jonathan Fernandez <jonathan@connect-io.fr> - Maj param dans du constructor
------------------------------------------------------------------------------*/
	
	If (Count parameters:C259=1)
		This:C1470.keys:=$ApiKey
	Else 
		This:C1470.keys:="Kzioor4VCZXDlMTnAB093q46JJRFr03Q"
	End if 
	This:C1470.host:="https://api.tinify.com/"
	
	This:C1470.lastExportInfo:=New object:C1471
	This:C1470.CompressionCount:=-1  // On ne connait pas encore le nombre de requete
	
	
	
Function downloadRequest($cheminDownload_t : Text; $methodResize_t : Text; $largeur_i : Integer; $hauteur_i : Integer)->$fichierCollect_o : Object
/*------------------------------------------------------------------------------
Fonction : TinyPng.downloadRequest
	
Récupération du fichier depuis l'API
Doc : https://tinypng.com/developers/reference

Paramètres :
	$cheminDownload_t -> (optionnel) Destination du fichier sur le disque.
	$methodResize_t   -> (optionnel) type de retaillage (scale, fit, cover)
	$largeur_i        -> (optionnel) largueur en px
	$hauteur_i        -> (optionnel) hauteur en px
	$fichierCollect_o <- renvoie le résultat de la requête de download de l'api

Historiques
01/09/17 - Grégory Fromain<gregory@connect-io.fr> -  Création de la méthode
05/11/20 - Titouan Guillon <titouan@connect-io.fr> - Implémentation dans la classe
01/12/21 - Jonathan Fernandez <jonathan@connect-io.fr> - Maj param dans la fonction
------------------------------------------------------------------------------*/
	
	var $reponse_o : Object
	var $data_o : Object
	var $filePath_t : Text
	var $reponse_p : Picture
	var $etat_l : Integer
	
	//Ajout d'un header
	ARRAY TEXT:C222(HeaderNames_at; 0)
	ARRAY TEXT:C222(HeaderValues_at; 0)
	
	APPEND TO ARRAY:C911(HeaderNames_at; "Content-Type")
	APPEND TO ARRAY:C911(HeaderValues_at; "application/json")
	
	//$t_data:=""
	$data_o:=New object:C1471
	
	$reponse_o:=New object:C1471
	$reponse_o.isValide:=True:C214
	
	// Vérification des inputs
	
	If ($reponse_o.isValide)
		If (Count parameters:C259>1)
			If (Type:C295($cheminDownload_t)=Is text:K8:3)
				// Facile on utilise le chemin reçu.
				$filePath_t:=$cheminDownload_t
			Else 
				$reponse_o.isValide:=False:C215
				$reponse_o.error:="Le param $methodResize_t n'est pas un text."
			End if 
			
		Else 
			// On fabrique un chemin.
			// Dans le dossier data de l'application avec comme nom un UUID et l'extension du fichier renvoyé.
			$filePath_t:=Get 4D folder:C485(Data folder:K5:33)+Generate UUID:C1066+Choose:C955(This:C1470.lastExportInfo.type="image/jpeg"; ".jpg"; ".png")
		End if 
	End if 
	
	
	If ($reponse_o.isValide)
		If (Count parameters:C259>2)
			
			If (String:C10($methodResize_t)="scale") | (String:C10($methodResize_t)="fit") | (String:C10($methodResize_t)="cover")  // On choisit la méthode de resize. Voir la DOC pour plus d'informations
				$data_o.resize:=New object:C1471
				$data_o.resize.method:=String:C10($methodResize_t)
				
				If (Num:C11($largeur_i)#0)
					$data_o.resize.width:=Num:C11($largeur_i)
				End if 
				
				If (Count parameters:C259>3)
					If (Num:C11($hauteur_i)#0)
						$data_o.resize.height:=Num:C11($hauteur_i)
					End if 
				End if 
				
			Else 
				$reponse_o.isValide:=False:C215
				$reponse_o.error:="Le type de retaillage est invalide."
			End if 
			
		End if 
	End if 
	
	// On commence les choses sérieuses
	
	If ($reponse_o.isValide)
		HTTP AUTHENTICATE:C1161("api"; This:C1470.keys; HTTP basic:K71:8)
		$etat_l:=HTTP Request:C1158(HTTP GET method:K71:1; This:C1470.lastExportInfo.url; $data_o; $reponse_p; HeaderNames_at; HeaderValues_at)
		If ($etat_l=200)  // Succès
			// On récupére le nombre de compression que l'on a fait ce mois-ci.
			OB SET:C1220($reponse_o; "Compression-Count"; HeaderValues_at{Find in array:C230(HeaderNames_at; "Compression-Count")})
		Else 
			$reponse_o.isValide:=False:C215
			$reponse_o.error:="Impossible de récupérer le fichier sur le tinipgn."
		End if 
	End if 
	
	If ($reponse_o.isValide)
		WRITE PICTURE FILE:C680($filePath_t; $reponse_p; This:C1470.lastExportInfo.type)
		
		If (ok#1)
			$reponse_o.isValide:=False:C215
			$reponse_o.error:="Impossible d'ecrire le fichier sur le disque."
		End if 
	End if 
	
	$reponse_o.codeHttp:=$etat_l
	$reponse_o.filePath:=$filePath_t
	
	$fichierCollect_o:=$reponse_o
	
	
	
Function lastExportInfo()->$info_o : Object
/*------------------------------------------------------------------------------
Fonction : TinyPng.lastExportInfo
	
Renvoie les informations de la derniere importation.
	
Paramètre
$info_o  <- Informations importation
	
Historiques
09/11/20 - Titouan Guillon <titouan@connect-io.fr> - Création de la fonction
30/11/21 - Grégory Fromain <gregory@connect-io.fr> - Maj appel param dans la fonction
------------------------------------------------------------------------------*/
	
	$info_o:=This:C1470.lastExportInfo
	
	
	
Function uploadFromFile($filePath_t : Text)->$isValid_b : Boolean
/*------------------------------------------------------------------------------
Fonction : TinyPng.uploadFromFile
	
Importation du fichier et envoi vers l'API
Doc : https://tinypng.com/developers/reference
	
Paramètres
$filePath_t -> Forcer le chemin par defaut.
$isValid_b  <- Renvoie true si la requete a bien été envoyée
	
Historiques
01/09/17 - Grégory Fromain <gregory@connect-io.fr> - Création de la fonction
05/11/20 - Titouan Guillon <titouan@connect-io.fr> - Implémentation dans la classe
30/11/21 - Grégory Fromain <gregory@connect-io.fr> - Maj appel param dans la fonction
------------------------------------------------------------------------------*/
	
	// Déclarations
	var $filePath_t : Text  // chemin du fichier
	var $data_p : Picture  // Image à envoyer
	var $etat_i : Integer
	var $reponse_o : Object  // réponse temporaire
	ARRAY TEXT:C222(HeaderNames_at; 0)  //Ajout d'un header 
	ARRAY TEXT:C222(HeaderValues_at; 0)
	
	//Initialisation
	$reponse_o:=New object:C1471
	
	// On vérifie que le fichier existe bien sur le disque.
	If (Test path name:C476($filePath_t)=Is a document:K24:1)
		$reponse_o.isValide:=True:C214
	Else 
		$reponse_o.isValide:=False:C215
		$reponse_o.error:="Le chemin du fichier est invalide."
	End if 
	
	If ($reponse_o.isValide)
		READ PICTURE FILE:C678($filePath_t; $data_p)
		If (ok#1)
			$reponse_o.isValide:=False:C215
			$reponse_o.error:="Impossible de récupérer l'image du fichier."
		End if 
	End if 
	
	// On effectue la requête
	If ($reponse_o.isValide)
		HTTP AUTHENTICATE:C1161("api"; This:C1470.keys; HTTP basic:K71:8)
		$etat_i:=HTTP Request:C1158(HTTP POST method:K71:2; This:C1470.host+"shrink"; $data_p; $reponse_o; HeaderNames_at; HeaderValues_at)
		
		If ($etat_i=201)  // Succès)
			$reponse_o.isValide:=True:C214  // éffacé par la réponse du serveur.
			// On récupére le nombre de compression que l'on a fait ce mois-ci.
			This:C1470.CompressionCount:=Num:C11(HeaderValues_at{Find in array:C230(HeaderNames_at; "Compression-Count")})
		Else 
			$reponse_o.isValide:=False:C215
			// Le détail de l'erreur est dans la réponse du serveur.
		End if 
		
	End if 
	
	
	This:C1470.lastExportInfo:=$reponse_o.output
	
	$isValid_b:=$reponse_o.isValide
	
	
	
Function uploadFromUrl
/*------------------------------------------------------------------------------
Fonction : TinyPng.uploadFromUrl
	
Importation du fichier depuis une URL et envoi vers l'API
Doc : https://tinypng.com/developers/reference
	
 Historique
	
01/09/17 - Grégory Fromain<gregory@connect-io.fr> - Création de la fonction
05/11/20 - Titouan Guillon <titouan@connect-io.fr> - Implémentation dans la classe
	
------------------------------------------------------------------------------*/
	
	var $1 : Text  // L'URL depuis laquelle on veut upload
	var $0 : Boolean
	
	var $data_o : Object
	var $reponse_o : Object
	var $etat_l : Integer
	ARRAY TEXT:C222(HeaderNames_at; 0)  //Ajout d'un header
	ARRAY TEXT:C222(HeaderValues_at; 0)
	
	// Idée pour plus tard... Tester que l'url fonctionne bien...
	
	$data_o:=New object:C1471
	$data_o.source:=New object:C1471
	$data_o.source.url:=$1
	
	
	APPEND TO ARRAY:C911(HeaderNames_at; "Content-Type")
	APPEND TO ARRAY:C911(HeaderValues_at; "application/json")
	
	HTTP AUTHENTICATE:C1161("api"; This:C1470.keys; HTTP basic:K71:8)
	$etat_l:=HTTP Request:C1158(HTTP POST method:K71:2; This:C1470.host+"shrink"; $data_o; $reponse_o; HeaderNames_at; HeaderValues_at)
	
	If ($etat_l=201)  // Succès)
		// On récupére le nombre de compression que l'on a fait ce mois-ci.
		This:C1470.CompressionCount:=Num:C11(HeaderValues_at{Find in array:C230(HeaderNames_at; "Compression-Count")})
	End if 
	
	This:C1470.lastExportInfo:=$reponse_o.output
	$0:=$reponse_o.isValide
	