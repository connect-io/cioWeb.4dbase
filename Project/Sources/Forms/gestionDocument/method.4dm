Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		
	: (Form event code:C388=Sur case de fermeture:K2:21)
		C_TEXT:C284($texte_t)
		
		$texte_t:=WP Get text:C1575(WParea;wk expressions as source:K81:256)
		
		If ($texte_t#"")
			CONFIRM:C162("Voulez-vous sauvegarder le document en cours ?";"Oui";"Non")
			
			If (OK=1)
				
				Case of 
					: (Form:C1466.entree=1)  // Edition action scène
						Form:C1466.donnee.saveFileActionScene(Form:C1466.donnee.scenarioDetail.ID;Form:C1466.donnee.sceneDetail.ID;WParea;"4wp";False:C215)
				End case 
				
			End if 
			
		End if 
		
End case 