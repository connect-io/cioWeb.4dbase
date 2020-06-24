//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Méthode : cwToolTextReplaceByRegex
  // Description
  // Remplace une chaine de caractère depuis une regex par un contenu fixe.
  //
  // Paramètres
  // $1 = Source [texte]
  // $2 = Expression recherché [regex]
  // $3 = texte à remplacer. [texte]
  // $0 : [texte] le texte corrigé
  // ----------------------------------------------------

If (False:C215)  // Historique
	  // 19/09/16 gregory@connect-io.fr - Création
	  // 26/10/19 gregory@connect-io.fr - Récupération méthode depuis composant cioRegex et ré-écriture
End if 

If (True:C214)  // Déclarations
	C_LONGINT:C283($position_l;$pos_trouvee_l;$long_trouvée_l)
	C_BOOLEAN:C305($regexValid_b)
	C_TEXT:C284($source_t;$1;$2;$3;$0;$obsolete_t)
End if 

$source_t:=$1
$position_l:=1

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

$0:=$source_t