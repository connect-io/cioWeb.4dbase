//%attributes = {"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwToolPathSeparator

Modifier les séparateurs dans le chemin d'un fichier.

Historique
10/11/20 - Grégory Fromain <gregory@connect-io.fr> - Création
----------------------------------------------------------------------------- */

// Déclarations
var $1 : Text  // Chemin à controler
var $2 : Text  // Séparateur à appliquer... Si non utilisé, on utilise la constante "Folder separator"
var $0 : Text  // Chemin controlé

var $cheminTemporaire_t : Text
var $separateur_t : Text

$cheminTemporaire_t:=$1

If (Count parameters:C259=2)
	$separateur_t:=$2
Else 
	$separateur_t:=Folder separator:K24:12
End if 

If ($separateur_t="/")
	$cheminTemporaire_t:=Replace string:C233($cheminTemporaire_t;":\\";$separateur_t)
	
	// Exemple : C:\dossier -> C/dossier
End if 

If ($separateur_t#"\\")
	$cheminTemporaire_t:=Replace string:C233($cheminTemporaire_t;"\\";$separateur_t)  // Séparateur windows
End if 

If ($separateur_t#":")
	$cheminTemporaire_t:=Replace string:C233($cheminTemporaire_t;":";$separateur_t)  // Séparateur mac
End if 

If ($separateur_t#"/")
	$cheminTemporaire_t:=Replace string:C233($cheminTemporaire_t;"/";$separateur_t)  // Séparateur unix
End if 

$0:=$cheminTemporaire_t
