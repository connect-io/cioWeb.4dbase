//%attributes = {"shared":true,"preemptive":"capable"}
/*------------------------------------------------------------------------------
Méthode : cwToolHtmlToText

Converti les balises <br /> et <p> vers du texte brut (\r)

Historique
09/03/2022 - Grégory Fromain <gregory@connect-io.fr> - Création
------------------------------------------------------------------------------*/

var $1 : Text
var $0 : Text

var $textModify_t : Text


$textModify_t:=$1
$textModify_t:=Replace string:C233($textModify_t; "<br>"; "\r")
$textModify_t:=Replace string:C233($textModify_t; "<br>\r"; "\r")
$textModify_t:=Replace string:C233($textModify_t; "<br/>\r"; "\r")
$textModify_t:=Replace string:C233($textModify_t; "<br/>\r"; "\r")
$textModify_t:=Replace string:C233($textModify_t; "<br />"; "\r")
$textModify_t:=Replace string:C233($textModify_t; "<br />\r"; "\r")
$textModify_t:=Replace string:C233($textModify_t; "<p>"; "")
$0:=Replace string:C233($textModify_t; "</p>"; "")