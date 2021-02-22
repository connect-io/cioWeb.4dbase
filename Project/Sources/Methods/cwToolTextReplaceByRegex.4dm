//%attributes = {"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwToolTextReplaceByRegex

Remplace une chaine de caractère depuis une regex par un contenu fixe.

Historique
19/09/16 - Grégory Fromain <gregory@connect-io.fr> - Création
26/10/19 - Grégory Fromain <gregory@connect-io.fr> - Récupération méthode depuis composant cioRegex et ré-écriture
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */

// Déclarations
var $1;$source_t : Text  // Source
var $2 : Text  // Expression recherché [regex]
var $3 : Text  // texte à remplacer
var $0 : Text  // le texte corrigé

var $obsolete_t : Text
var $position_l : Integer
var $pos_trouvee_l : Integer
var $long_trouvée_l : Integer
var $regexValid_b : Boolean


$source_t:=$1
$position_l:=1

// On remplace les sauts de lignes par un espace. (Créer des erreurs sur le regex)
$source_t:=Replace string:C233($source_t;"\r";"##r")
$source_t:=Replace string:C233($source_t;"\n";"##n")

If ($2#"")
	Repeat 
		$regexValid_b:=Match regex:C1019($2;$source_t;$position_l;$pos_trouvee_l;$long_trouvée_l)
		If ($regexValid_b)
			$obsolete_t:=Substring:C12($source_t;$pos_trouvee_l;$long_trouvée_l)
			$source_t:=Replace string:C233($source_t;$obsolete_t;$3)
			$position_l:=$pos_trouvee_l+Length:C16($3)
		End if 
	Until (Not:C34($regexValid_b))
End if 

$source_t:=Replace string:C233($source_t;"##r";"\r")
$source_t:=Replace string:C233($source_t;"##n";"\n")

$0:=$source_t