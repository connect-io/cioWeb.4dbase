Case of 
	: (Form event code:C388=Sur clic:K2:4)
		C_TEXT:C284($texte_t)
		C_TIME:C306($refDoc_h)
		C_OBJECT:C1216($fichier_o)
		
		CONFIRM:C162("Voulez-vous insérer le contenue par défaut d'une page HTML5 ?";"Oui";"Non")
		
		If (OK=1)
			$fichier_o:=File:C1566(Get 4D folder:C485(Dossier Resources courant:K5:16;*)+"cioMarketingAutomation"+Séparateur dossier:K24:12+"html"+Séparateur dossier:K24:12+"structure.html";fk chemin plateforme:K87:2)
			
			If ($fichier_o.exists=True:C214)
				$texte_t:=$fichier_o.getText("UTF-8";Document avec format natif:K24:19)
			Else 
				ALERT:C41("Impossible de récupérer le fichier de structure HTML")
			End if 
			
		Else 
			$refDoc_h:=Open document:C264("";"HTML")
			
			If (OK=1)
				$texte_t:=Document to text:C1236(Document;"UTF-8";Document avec format natif:K24:19)
				
				CLOSE DOCUMENT:C267($refDoc_h)
			End if 
			
		End if 
		
		If ($texte_t#"")
			WP SET TEXT:C1574(WParea;$texte_t;wk append:K81:179)
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 