//%attributes = {"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwMotDePasseHash

Génére un hash avec uniquement les valeurs a-Z0-9 et $
Car cela peut poser des problèmes en cas de passage dans une url ou mot de passe.

Historique
02/05/19 - Grégory Fromain <gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */

// Déclarations
var $1;$motDePasseClair_t : Text  // $1 : [text] mot de passe clair
var $0 : Text  // $0 : [text] mot de passe hash

var $motDePasseHash_t : Text


$motDePasseClair_t:=$1

Repeat 
	$motDePasseHash_t:=Generate password hash:C1533($motDePasseClair_t)
Until (Match regex:C1019("[\\w$]+";$motDePasseHash_t))

$0:=$motDePasseHash_t