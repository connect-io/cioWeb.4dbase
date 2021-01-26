//%attributes = {"shared":true}
// ======================================================================
// Methode projet : webHttpRequest
// 
// Méthode qui permet de faire des requêtes http
//
// ----------------------------------------------------------------------

If (False:C215)  // Historique
	// 02/07/20 remy@connect-io.fr - Création
End if 

If (True:C214)  // Déclarations
	C_VARIANT:C1683($0)  // Réponse du serveur distant
	C_TEXT:C284($1)  // Type de requête demandé
	C_TEXT:C284($2)  // Url demandée
	C_VARIANT:C1683($3)  // Body de la requête peut varié d'une requête à l'autre
	C_POINTER:C301($4)  // Pointeur de la réponse attendue de l'url $2
	
	C_VARIANT:C1683($reponse_v)
	C_LONGINT:C283($etat_el)
	C_BLOB:C604($blobVide_b)
	
	ARRAY TEXT:C222($headerNames_at;0)
	ARRAY TEXT:C222($headerValues_at;0)
End if 

Case of 
	: (Value type:C1509($4->)=Est un texte:K8:3)
		$reponse_v:=""
	: (Value type:C1509($4->)=Est un objet:K8:27)
		$reponse_v:=New object:C1471
	: (Value type:C1509($4->)=Est un BLOB:K8:12)
		$reponse_v:=$blobVide_b
End case 

ON ERR CALL:C155("cwGestionErreur")
$etat_el:=HTTP Request:C1158($1;$2;$3;$reponse_v;$headerNames_at;$headerValues_at)
ON ERR CALL:C155("")

If ($etat_el#200)
	$reponse_v:="Error HTTP "+String:C10($etat_el)
End if 

$4->:=$reponse_v