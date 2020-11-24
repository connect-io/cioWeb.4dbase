//%attributes = {"shared":true,"publishedWeb":true}
/* -----------------------------------------------------------------------------
Méthode : cwI18nGet

Historique
15/08/20 - Grégory Fromain <gregory@connect-io.fr> - Mise en veille de l'internalisation
----------------------------------------------------------------------------- */

/*
If (True)  // Déclarations
C_TEXT($0;$1)  // $0 :[text] le text en retour, $1 : [text] nom de la ressource que l'on souhaite utiliser.
C_OBJECT($2;$O_ressource)  // $2 : [objet] (optionnel) objet de référence que l'on souhaite utiliser.
End if 

  // Si il y a un 2eme param, on utilise celui la.
If (Count parameters=2)
$O_ressource:=$2
Else 
$O_ressource:=OB Get(pageWeb_o;"i18n")
End if 

  // Si la ressource existe on l'utilise sinon on renvoie la cle.
If (OB Is defined($O_ressource;$1))
$0:=OB Get($O_ressource;$1)
Else 
$0:=$1
End if 
*/