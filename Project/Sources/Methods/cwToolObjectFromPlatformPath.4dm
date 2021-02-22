//%attributes = {"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwToolObjectFromPlatformPath

Charge un objet depuis le chemin d'un fichier. (Compatible JSON et JSONC)
Cette methode n'est pas partagé avec la base hote car il est préférable d'utiliser : cwToolObjectFromFile

Historique
01/10/20 - Grégory Fromain <gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
-----------------------------------------------------------------------------*/

var $1 : Text  // Chemin du fichier à charger. (format plateforme)
var $0 : Object  // Objet contenu dans le fichier.

var $file_o : Object

$file_o:=File:C1566($1;fk platform path:K87:2)

$0:=cwToolObjectFromFile($file_o)