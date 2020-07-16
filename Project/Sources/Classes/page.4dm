/* 
Cette class permet de génerer le contenue d'une page.

Historique
16/07/20 - gregory@connect-io.fr - Création

*/

  // ----- Initialisation de la page web -----
Class constructor
	C_OBJECT:C1216($1)  // Les informations sur les sites provenants directement de la class webApp.
	C_OBJECT:C1216($2)  // Les informations sur le visiteur.
	
	This:C1470.webAppSites:=$1
	This:C1470.user:=$2
	TRACE:C157
	This:C1470.route:=cwPageGetInfo 
	
	