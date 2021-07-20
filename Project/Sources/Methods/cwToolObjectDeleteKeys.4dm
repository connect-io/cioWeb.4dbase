//%attributes = {"shared":true,"preemptive":"capable"}
/*------------------------------------------------------------------------------
Méthode : cwToolObjectDeleteKeys

Suppression multiple de cle d'un objet.

Historique
23/11/15 - Grégory Fromain <gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Ré-*ecriture et import dans cioWeb
------------------------------------------------------------------------------*/

// Déclarations
var $1 : Object  // Objet source
var $2 : Text  // La recherche de la cle à supprimer

var $key_c : Collection
var $key_t : Text


$key_c:=OB Keys:C1719($1)

For each ($key_t; $key_c)
	If ($key_t=$2)
		OB REMOVE:C1226($1; $key_t)
	End if 
End for each 


/// *** Test de la Méthode ***
//var $toto : Object

//$toto:=New object("A";"titi";"BA";"toto";"BB";"tutu";"C";"tete")

//cwToolObjectDeleteKeys ($toto;"B@")

// Valeur de retour : {"A":"titi","C":"tete"}