//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : c(io)w(eb)ToolExtractFileNameToPath

Extrait le nom d'un document à partir d'un chemin

Historique
03/02/21 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
var $1 : Text  // Chemin du fichier
var $2 : Boolean  // Permet de savoir si on souhaite l'extension ou pas
var $0 : Text

var $fichier_o : Object

$fichier_o:=File:C1566($1; fk chemin plateforme:K87:2)

If ($fichier_o.exists=True:C214)
	$0:=$fichier_o.name
	
	If ($2=True:C214)
		$0:=$0+$fichier_o.extension
	End if 
	
End if 