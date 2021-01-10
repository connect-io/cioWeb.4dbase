//%attributes = {"shared":true,"publishedWeb":true}
/* -----------------------------------------------------------------------------
Méthode : cwI18nConvertJson (Composant CioRegex)

Remplace une chaine de caractère depuis une regex par un contenu fixe.

Historique
15/08/20 - Grégory Fromain <gregory@connect-io.fr> - Mise en veille de l'internalisation
02/12/20 - Alban Catoire <alban@connect-io.fr> - Réveil avec storage
-----------------------------------------------------------------------------*/

// Déclarations
C_TEXT:C284($source;$1;$0;$obsolete;$T_nouveau;$T_regex)  // $1 = Source [texte], $0 : [texte] le texte corrigé

C_LONGINT:C283($position;$L_pos_trouvee;$L_long_trouvée)
C_BOOLEAN:C305($regexValid)


$source:=$1
$position:=1

$T_regex:="i18n\\([\\w.-]+?\\)"

If ($source="@i18n(@")
	
	Repeat 
		$regexValid:=Match regex:C1019($T_regex;$source;$position;$L_pos_trouvee;$L_long_trouvée)
		If ($regexValid)
			$obsolete:=Substring:C12($source;$L_pos_trouvee;$L_long_trouvée)
			
			$T_nouveau:=Replace string:C233($obsolete;"i18n(";"")
			$T_nouveau:=Replace string:C233($T_nouveau;")";"")
			
			$T_nouveau:=Storage:C1525.sites[pageWeb_o.info.subDomain_t].I18n.form[pageWeb_o.route.data.lang][formulaire_o.lib][$T_nouveau]
			
			$source:=Replace string:C233($source;$obsolete;$T_nouveau)
			$position:=$L_pos_trouvee+Length:C16($T_nouveau)
		End if 
	Until (Not:C34($regexValid))
	
End if 

$0:=$source