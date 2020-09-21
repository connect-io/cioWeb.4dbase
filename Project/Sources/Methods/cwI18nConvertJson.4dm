//%attributes = {"shared":true,"publishedWeb":true}
/* -----------------------------------------------------------------------------
Méthode : cwI18nConvertJson (Composant CioRegex)

Remplace une chaine de caractère depuis une regex par un contenu fixe.

Historique
15/08/20 - Grégory Fromain <gregory@connect-io.fr> - Mise en veille de l'internalisation
----------------------------------------------------------------------------- */

/*
If (True)  // Déclarations
C_TEXT($source;$1;$0;$obsolete;$T_nouveau;$T_regex)  // $1 = Source [texte], $0 : [texte] le texte corrigé

C_LONGINT($position;$L_pos_trouvee;$L_long_trouvée)
C_BOOLEAN($regexValid)
End if 

$source:=$1
$position:=1

$T_regex:="i18n\\([\\w.-]+?\\)"

Repeat 
$regexValid:=Match regex($T_regex;$source;$position;$L_pos_trouvee;$L_long_trouvée)
If ($regexValid)
$obsolete:=Substring($source;$L_pos_trouvee;$L_long_trouvée)

$T_nouveau:=Replace string($obsolete;"i18n";"")
$T_nouveau:=Replace string($T_nouveau;"(";"(\"")
$T_nouveau:=Replace string($T_nouveau;")";"\")")

$T_nouveau:="<!--#4DHTML cwI18nGet"+$T_nouveau+"-->"

$source:=Replace string($source;$obsolete;$T_nouveau)
$position:=$L_pos_trouvee+Length($T_nouveau)
End if 
Until (Not($regexValid))

$0:=$source

*/