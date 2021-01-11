//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cwToolPathFolderOrAlias

Renvoie le chemin d'un dossier ou son chemin depuis un alias.

Historique
26/09/19 - Grégory Fromain <gregory@connect-io.fr> - Recopie de la methode depuis le composant CioGénérique
27/11/19 - Grégory Fromain <gregory@connect-io.fr> - En cas de non résolutionde l'alias... on retourne la valeur d'entrée.
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */

// Déclarations
var $1 : Text  // chemin du dossier
var $0 : Text  // chemin du dossier alias réél

var $chemin_t : Text

$chemin_t:=$1

If (Test path name:C476($chemin_t)=Is a folder:K24:2)
	$0:=$chemin_t
	
Else 
	// Il s'agit peut-être d'un alias
	RESOLVE ALIAS:C695($chemin_t;$chemin_t)
	
	If (ok=1)
		
		$0:=Substring:C12($chemin_t;1;Length:C16($chemin_t)-1)
		
	Else 
		//$0:=""
		$O:=$1
	End if 
	
End if 