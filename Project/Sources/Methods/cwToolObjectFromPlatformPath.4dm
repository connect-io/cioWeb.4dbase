//%attributes = {}
/* -----------------------------------------------------------------------------
Méthode : cwToolObjectFromPlatformPath

Charge un objet depuis le chemin d'un fichier. (Compatible JSON et JSONC)
Cette methode n'est pas partagé avec la base hote car il est préférable d'utiliser : cwToolObjectFromFile

Historique
01/10/2020 - Grégory Fromain <gregory@connect-io.fr> - Création
-----------------------------------------------------------------------------*/

C_TEXT:C284($1)  // Chemin du fichier à charger. (format plateforme)
C_OBJECT:C1216($0)  // Objet contenu dans le fichier.

C_OBJECT:C1216($file_o)

$file_o:=File:C1566($1;fk platform path:K87:2)

$0:=cwToolObjectFromFile ($file_o)