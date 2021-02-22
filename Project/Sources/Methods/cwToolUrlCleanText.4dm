//%attributes = {"invisible":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwToolUrlCleanText

Permet de nettoyer un texte que l'on souhaite utiliser dans une url.

Historique
13/03/18 - Grégory Fromain <gregory@connect-io.fr> - Création
26/10/19 - Grégory Fromain <gregory@connect-io.fr> - Récupération méthode depuis composant cioGénérique
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */

// Déclarations
var $1;$textTempo_t : Text  // $1 : [texte] (Ballon Coeur "Rouge")
var $0 : Text  // $0 : [texte] Ballon-coeur-Rouge


$textTempo_t:=$1
$textTempo_t:=Replace string:C233($textTempo_t;" ";"-")
$textTempo_t:=Replace string:C233($textTempo_t;"'";"-")
$textTempo_t:=Replace string:C233($textTempo_t;"\"";"")
$textTempo_t:=Replace string:C233($textTempo_t;"“";"")
$textTempo_t:=Replace string:C233($textTempo_t;"”";"")
$textTempo_t:=Replace string:C233($textTempo_t;"«";"")
$textTempo_t:=Replace string:C233($textTempo_t;"»";"")
$textTempo_t:=Replace string:C233($textTempo_t;"ç";"c")  // fr : Çç
$textTempo_t:=Replace string:C233($textTempo_t;"Æ";"ae")
$textTempo_t:=Replace string:C233($textTempo_t;"a";"a")  // fr : ÀÂàâ  es : Áá
$textTempo_t:=Replace string:C233($textTempo_t;"e";"e")  // fr : ÉÈÊËéèêë
$textTempo_t:=Replace string:C233($textTempo_t;"i";"i")  // fr : ÎÏîï es : Íí
$textTempo_t:=Replace string:C233($textTempo_t;"n";"n")  // es : Ññ
$textTempo_t:=Replace string:C233($textTempo_t;"œ";"oe")  // fr : Œœ
$textTempo_t:=Replace string:C233($textTempo_t;"o";"o")  // fr : Ôô es : Óó
$textTempo_t:=Replace string:C233($textTempo_t;"u";"u")  // fr : ÙÛÜùûü es : ÚÜúü
$textTempo_t:=Replace string:C233($textTempo_t;"y";"y")  // fr : Ÿÿ
$textTempo_t:=Replace string:C233($textTempo_t;",";"")
$textTempo_t:=Replace string:C233($textTempo_t;".";"")
$textTempo_t:=Replace string:C233($textTempo_t;"!";"")
$textTempo_t:=Replace string:C233($textTempo_t;"¡";"")
$textTempo_t:=Replace string:C233($textTempo_t;"?";"")
$textTempo_t:=Replace string:C233($textTempo_t;"¿";"")
$textTempo_t:=Replace string:C233($textTempo_t;"/";"")
$textTempo_t:=Replace string:C233($textTempo_t;"&";"et")

$0:=$textTempo_t