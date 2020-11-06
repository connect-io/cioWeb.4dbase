/* 
Classe : tinyPng
Permet l'utilisation de l'api du site tinypng.com

*/


Class constructor
/* -----------------------------------------------------------------------------
Fonction : tinyPng.constructor
	
Initialisation de la clé de l'API
Si aucune clé n'est renseignée, on utilisera une clé de "démonstration"
	
Historique
01/09/17 Grégory gregory@connect-io.fr - Création de la méthode
05/11/20 titouan titouan@connect-io.fr - Clean méthode + adaptation aux nouvelles formulations
06/11/20 titouan titouan@connect-io.fr - Création du constructeur
------------------------------------------------------------------------------*/
	
	If (True:C214)  // Déclarations
		var $1 : Text  // Clé API
	End if 
	
	
	If (Count parameters:C259=1)
		This:C1470.keys:=$1
	Else 
		This:C1470.keys:="Kzioor4VCZXDlMTnAB093q46JJRFr03Q"
	End if 
	This:C1470.host:="https://api.tinify.com/"
	
	
	
Function uploadFromFile
/* ----------------------------------------------------------------------
Fonction : tinyPng.uploadFromFile
	
Importation du fichier et envoi vers l'API
Doc : https://tinypng.com/developers/reference
	
 Historique
	
01/09/17 Grégory gregory@connect-io.fr - Création de la fonction
05/11/20 titouan titouan@connect-io.fr - Implémentation dans la classe
	
-------------------------------------------------------------------------*/
	
	If (True:C214)  // Déclarations
		var $1 : Text  // chemin du fichier
		var $filePath_t : Text  // chemin du fichier
		var $data_p : Picture  // Image à envoyer
		var $etat_i : Integer
		var $reponse_o : Object  // réponse temporaire
		var $0 : Object  // réponse
	End if 
	
	//Ajout d'un header 
	ARRAY TEXT:C222(HeaderNames_at;0)
	ARRAY TEXT:C222(HeaderValues_at;0)
	
	//Initialisation
	$filePath_t:=$1
	$reponse_o:=New object:C1471
	
	// On vérifie que le fichier existe bien sur le disque.
	If (Test path name:C476($filePath_t)=Is a document:K24:1)
		$reponse_o.isValide:=True:C214
	Else 
		$reponse_o.isValide:=False:C215
		$reponse_o.error:="Le chemin du fichier est invalide."
	End if 
	
	If ($reponse_o.isValide)
		READ PICTURE FILE:C678($filePath_t;$data_p)
		If (ok#1)
			$reponse_o.isValide:=False:C215
			$reponse_o.error:="Impossible de récupérer l'image du fichier."
		End if 
	End if 
	
	// On effectue la requête
	If ($reponse_o.isValide)
		HTTP AUTHENTICATE:C1161("api";This:C1470.keys;HTTP basic:K71:8)
		$etat_i:=HTTP Request:C1158(HTTP POST method:K71:2;This:C1470.host+"shrink";$data_p;$reponse_o;HeaderNames_at;HeaderValues_at)
		
		If ($etat_i=201)  // Succès)
			$reponse_o.isValide:=True:C214  // éffacé par la réponse du serveur.
			// On récupére le nombre de compression que l'on a fait ce mois-ci.
			OB SET:C1220($reponse_o;"Compression-Count";HeaderValues_at{Find in array:C230(HeaderNames_at;"Compression-Count")})
		Else 
			$reponse_o.isValide:=False:C215
			// Le détail de l'erreur est dans la réponse du serveur.
		End if 
		
	End if 
	
	$reponse_o.codeHttp:=$etat_i
	
	$0:=$reponse_o
	
Function uploadFromUrl
/* ----------------------------------------------------------------------
Fonction : tinyPng.uploadFromUrl
	
Importation du fichier depuis une URL et envoi vers l'API
Doc : https://tinypng.com/developers/reference
	
 Historique
	
01/09/17 Grégory gregory@connect-io.fr - Création de la fonction
05/11/20 titouan titouan@connect-io.fr - Implémentation dans la classe
	
-------------------------------------------------------------------------*/
	
	If (True:C214)  // Déclarations
		var $1 : Text  // L'URL depuis laquelle on veut upload
		var $data_o : Object
		var $reponse_o : Object
		var $etat_l : Integer
		var $0 : Object
	End if 
	
	// Idée pour plus tard... Tester que l'url fonctionne bien...
	
	$data_o:=New object:C1471
	$data_o.source.url:=$1
	
	
	//Ajout d'un header
	ARRAY TEXT:C222(HeaderNames_at;0)
	ARRAY TEXT:C222(HeaderValues_at;0)
	APPEND TO ARRAY:C911(HeaderNames_at;"Content-Type")
	APPEND TO ARRAY:C911(HeaderValues_at;"application/json")
	
	HTTP AUTHENTICATE:C1161("api";This:C1470.keys;HTTP basic:K71:8)
	$etat_l:=HTTP Request:C1158(HTTP POST method:K71:2;This:C1470.host+"shrink";$data_o;$reponse_o;HeaderNames_at;HeaderValues_at)
	
	If ($etat_l=201)  // Succès)
		// On récupére le nombre de compression que l'on a fait ce mois-ci.
		OB SET:C1220($reponse_o;"Compression-Count";HeaderValues_at{Find in array:C230(HeaderNames_at;"Compression-Count")})
	End if 
	
	$reponse_o.codeHttp:=$etat_l
	
	$0:=$reponse_o
	
Function downloadRequest
/* -----------------------------------------------------------------------------
Fonction : tinyPng.downloadRequest
	
Récupération du fichier depuis l'API
Doc : https://tinypng.com/developers/reference
	
Historique
	
01/09/17 Grégory gregory@connect-io.fr - Création de la méthode
05/11/20 titouan titouan@connect-io.fr - Implémentation dans la classe
------------------------------------------------------------------------------*/
	
	
	If (True:C214)  // Déclarations
		
		var $1 : Object  // resultat de l'upload du fichier
		var $dataUpload_o : Object
		var $reponse_o : Object
		var $data_o : Object
		var $filePath_t : Text
		var $reponse_p : Picture
		var $etat_l : Integer
		var $2 : Text  // (optionnel) Destination du fichier sur le disque.
		var $3 : Text  // (optionnel) type de retaillage (scale, fit, cover)
		var $4 : Integer  // (optionnel) largueur en px
		var $5 : Integer  // (optionnel) hauteur en px
		var $0 : Object
		
		//Ajout d'un header
		ARRAY TEXT:C222(HeaderNames_at;0)
		ARRAY TEXT:C222(HeaderValues_at;0)
		APPEND TO ARRAY:C911(HeaderNames_at;"Content-Type")
		APPEND TO ARRAY:C911(HeaderValues_at;"application/json")
	End if 
	
	//$t_data:=""
	$data_o:=New object:C1471
	
	$reponse_o:=New object:C1471
	$reponse_o.isValide:=True:C214
	
	// Vérification des inputs
	
	If (Type:C295($1)=Is object:K8:27)
		$dataUpload_o:=$1
	Else 
		$reponse_o.isValide:=False:C215
		$reponse_o.error:="Le param $1 n'est pas un objet."
	End if 
	
	If ($reponse_o.isValide)
		If (Count parameters:C259>1)
			If (Type:C295($2)=Is text:K8:3)
				// Facile on utilise le chemin reçu.
				$filePath_t:=$2
			Else 
				$reponse_o.isValide:=False:C215
				$reponse_o.error:="Le param $2 n'est pas un text."
			End if 
			
		Else 
			//On fabrique un chemin.
			// Dans le dossier data de l'application avec comme nom un UUID et l'extension du fichier renvoyé.
			$filePath_t:=Get 4D folder:C485(Data folder:K5:33)+Generate UUID:C1066+Choose:C955($dataUpload_o.output.type="image/jpeg";".jpg";".png")
		End if 
	End if 
	
	
	If ($reponse_o.isValide)
		If (Count parameters:C259>2)
			
			If (Type:C295($3)#Is text:K8:3)
				$reponse_o.isValide:=False:C215
				$reponse_o.error:="Le param $3 n'est pas un text."
			End if 
			
			If (Type:C295($4)#Is longint:K8:6)
				$reponse_o.isValide:=False:C215
				$reponse_o.error:="Le param $4 n'est pas un entier."
			End if 
			
			If (Type:C295($5)#Is longint:K8:6)
				$reponse_o.isValide:=False:C215
				$reponse_o.error:="Le param $5 n'est pas un entier."
			End if 
			
			
			If ($3="scale") | ($3="fit") | ($3="cover")  // On choisit la méthode de resize. Voir la DOC pour plus d'informations
				$data_o.resize:=New object:C1471
				$data_o.resize.method:=$3
				
				If ($4#0)
					$data_o.resize.width:=$4
				End if 
				If ($5#0)
					$data_o.resize.height:=$5
				End if 
			Else 
				$reponse_o.isValide:=False:C215
				$reponse_o.error:="Le type de retaillage est invalide."
			End if 
			
			
		End if 
	End if 
	
	// On commence les choses sérieuses
	
	If ($reponse_o.isValide)
		HTTP AUTHENTICATE:C1161("api";This:C1470.keys;HTTP basic:K71:8)
		$etat_l:=HTTP Request:C1158(HTTP GET method:K71:1;$dataUpload_o.output.url;$data_o;$reponse_p;HeaderNames_at;HeaderValues_at)
		If ($etat_l=200)  // Succès
			// On récupére le nombre de compression que l'on a fait ce mois-ci.
			OB SET:C1220($reponse_o;"Compression-Count";HeaderValues_at{Find in array:C230(HeaderNames_at;"Compression-Count")})
		Else 
			$reponse_o.isValide:=False:C215
			$reponse_o.error:="Impossible de récupérer le fichier sur le tinipgn."
		End if 
	End if 
	
	If ($reponse_o.isValide)
		WRITE PICTURE FILE:C680($filePath_t;$reponse_p;$dataUpload_o.output.type)
		
		If (ok#1)
			$reponse_o.isValide:=False:C215
			$reponse_o.error:="Impossible d'ecrire le fichier sur le disque."
		End if 
	End if 
	
	$reponse_o.codeHttp:=$etat_l
	$reponse_o.filePath:=$filePath_t
	
	$0:=$reponse_o