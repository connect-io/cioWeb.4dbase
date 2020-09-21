//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cwToolPathFolderOrAlias

Renvoie le chemin d'un dossier ou son chemin depuis un alias.

Historique
26/09/19 gregory@connect-io.fr - Recopie de la methode depuis le composant CioGénérique
27/11/19 gregory@connect-io.fr - En cas de non résolutionde l'alias... on retourne la valeur d'entrée.
----------------------------------------------------------------------------- */


If (True:C214)  // Déclarations
	C_TEXT:C284($0;$1;$chemin_t)  // $1 : [text] chemin du dossier, $0 : [text] chemin du dossier alias réél
End if 

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