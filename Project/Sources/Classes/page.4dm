/* 
Cette class permet de génerer le contenue d'une page.

Historique
16/07/20 - gregory@connect-io.fr - Création

*/

  // ----- Initialisation de la page web -----
Class constructor
	C_COLLECTION:C1488($1)  // Information sur les routes du site provenants directement de la class webApp.
	C_OBJECT:C1216($2)  // Les informations sur le visiteur.
	
	C_OBJECT:C1216($page_o)
	C_TEXT:C284($propriete_t)
	
	This:C1470.siteRoute_c:=$1
	
	This:C1470.user:=$2
	
	$page_o:=cwPageGetInfo 
	
	For each ($propriete_t;$page_o)
		This:C1470[$propriete_t]:=$page_o[$propriete_t]
	End for each 
	
	
	  // Adfaut de faire mieux pour le moment... (Comptatibilité avec du vieux code)
	C_OBJECT:C1216(pageWeb)
	pageWeb:=$page_o