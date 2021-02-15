Case of 
	: (Form event code:C388=Sur clic:K2:4)
		var $texte_t : Text
		var $version_o : Object
		
		Case of 
			: (Form:C1466.entree=2)  // Edition action scène
				$texte_t:=WP Get text:C1575(WParea; wk expressions as source:K81:256)
				
				If ($texte_t#"")
					CONFIRM:C162("Voulez-vous sauvegarder le document en cours ?"; "Oui"; "Non")
					
					If (OK=1)
						//Form.donnee.saveFileActionScene(Form.donnee.scenarioDetail.ID; Form.donnee.sceneDetail.ID; WParea; "4wp"; Faux)
						
						//Form.donnee.sceneDetail.paramAction.modelePerso:=Vrai
						//Form.sceneDetail.paramAction.modele4WP:=WParea
						$version_o:=Form:C1466.donnee.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.donnee.sceneTypeSelected)].version.query("titre = :1"; Form:C1466.donnee.sceneVersionSelected)[0]
						
						$version_o.contenu4WP:=WParea
						
						$version_o.modifierLe:=cwTimestamp
						$version_o.modifierPar:=Current user:C182
						
						Form:C1466.donnee.sceneDetail.save()
					End if 
					
				End if 
				
		End case 
		
		ACCEPT:C269
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 