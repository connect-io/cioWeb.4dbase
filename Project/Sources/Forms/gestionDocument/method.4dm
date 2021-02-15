Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		var $image_i : Picture
		var $fichier_o; $version_o : Object
		
		var WParea : Object
		
		WParea:=WP New:C1317()
		
		Case of 
			: (Form:C1466.entree=1)  // Envoi d'un mailing à la table [Personne]
				Form:C1466.imageSave:=Storage:C1525.automation.image["logout"]
			: (Form:C1466.entree=2)  // Edition action scène
				Form:C1466.imageSave:=Storage:C1525.automation.image["save"]
				
				OBJECT SET COORDINATES:C1248(*; "sauvegarderDocument"; 739; 15; 779; 55)
				
				OBJECT SET TITLE:C194(*; "Texte6"; "Sauvegarder et fermer")
				OBJECT SET COORDINATES:C1248(*; "Texte6"; 694; 57; 825; 71)
				
				OBJECT SET COORDINATES:C1248(*; "Rectangle"; 86; 9; 835; 73)
				
				$version_o:=Form:C1466.donnee.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.donnee.sceneTypeSelected)].version.query("titre = :1"; Form:C1466.donnee.sceneVersionSelected)[0]
				
				WParea:=WP New:C1317($version_o.contenu4WP)
		End case 
		
	: (Form event code:C388=Sur case de fermeture:K2:21)
		var $texte_t : Text
		var $version_o : Object
		
		Case of 
			: (Form:C1466.entree=2)  // Edition action scène
				$texte_t:=WP Get text:C1575(WParea; wk expressions as source:K81:256)
				
				If ($texte_t#"")
					CONFIRM:C162("Voulez-vous sauvegarder le document en cours ?"; "Oui"; "Non")
					
					If (OK=1)
						$version_o:=Form:C1466.donnee.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.donnee.sceneTypeSelected)].version.query("titre = :1"; Form:C1466.donnee.sceneVersionSelected)[0]
						
						$version_o.contenu4WP:=WParea
						
						$version_o.modifierLe:=cwTimestamp
						$version_o.modifierPar:=Current user:C182
						
						Form:C1466.donnee.sceneDetail.save()
						//Form.donnee.saveFileActionScene(Form.donnee.scenarioDetail.ID; Form.donnee.sceneDetail.ID; WParea; "4wp"; Faux)
					End if 
					
				End if 
				
		End case 
		
End case 