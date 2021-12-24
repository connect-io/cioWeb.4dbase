//%attributes = {"publishedWeb":true,"shared":true,"preemptive":"incapable"}
/*------------------------------------------------------------------------------
Méthode : cwToolUrlDecode

Décodage d'une URL.
https://mozilla.org/?x=%D1%88%D0%B5%D0%BB%20%D0%BB%D1%8B -> https://mozilla.org/?x=шел лы

ATTENTION : Cette méthode n'est pas préemptif.
(Cause : WA Evaluate JavaScript)

Historique
24/12/21 - Grégory Fromain <gregory@connect-io.fr> - Création
------------------------------------------------------------------------------*/

// Déclarations
var $1; $url_t : Text  // URL encodé
var $0 : Text  // URL simple

var $config_o : Object

ASSERT:C1129(Length:C16($1)#0; "Le contenue du param $1 est vide.")

$url_t:=$1
$config_o:=New object:C1471
$config_o.url:="about:blank"
$config_o.onEvent:=Formula:C1597(This:C1470.result:=WA Evaluate JavaScript:C1029(*; This:C1470.area; "decodeURI('"+$url_t+"');"; Is text:K8:3))
$0:=WA Run offscreen area:C1727($config_o)