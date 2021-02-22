//%attributes = {"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : c(io)w(eb)ToolExtractFileNameToPath

Extrait le nom d'un document à partir d'un chemin

Historique
03/02/21 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/

//https://doc.4d.com/4Dv18R6/4D/18-R6/fichierfullName.303-5197796.fe.html
// Cette fonction n'est pas utile,  il suffit d'utiliser la propriété : fichier.fullName

ASSERT:C1129(False:C215; "Cette fonction n'est pas utile,  il suffit d'utiliser la propriété : fichier.fullName")

/*
var $1 : Text  // Chemin du fichier
var $2 : Boolean  // Permet de savoir si on souhaite l'extension ou pas
var $0 : Text

var $fichier_o : Object

$fichier_o:=File($1; fk platform path)

If ($fichier_o.exists=True)
$0:=$fichier_o.name

If ($2=True)
$0:=$0+$fichier_o.extension
End if 

End if 
*/