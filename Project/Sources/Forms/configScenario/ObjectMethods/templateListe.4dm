Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		ARRAY TEXT:C222(templateListe_at;0)
		
		templateListe_at{0}:="Merci de sélectionner un template"
	: (Form event code:C388=Sur données modifiées:K2:15)
		C_TEXT:C284($template_t)
		
		$template_t:=templateListe_at{templateListe_at}
End case 