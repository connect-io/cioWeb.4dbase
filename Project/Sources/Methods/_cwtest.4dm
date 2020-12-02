//%attributes = {"shared":true}


$ablan:="Salut je suis i18n(peter) à la campagne."

$cleATraduire_t:=Substring:C12($ablan;Position:C15("i18n(";$ablan)+5)

$cleATraduire_t:=Substring:C12($cleATraduire_t;1;Position:C15(")";$cleATraduire_t)-1)

$ablan:=cwToolTextReplaceByRegex($ablan;"i18n(.*?)\\)";"Spiderman")