Case of 
	: (Form event code:C388=Sur clic:K2:4)
		var $continue_b : Boolean
		var $config_o : Object
		
		If (Form:C1466.sceneDetail.paramAction.modele#Null:C1517)  // Un modèle du composant OU stocké sur l'ordi a été sélectionné
			CONFIRM:C162("Un modèle a été sélectionné auparavant, voulez-vous le supprimer pour faire une version personnel du mailing ?"; "Oui"; "Non")
			
			If (OK=1)
				OB REMOVE:C1226(Form:C1466.sceneDetail.paramAction; "modele")
				
				If (Form:C1466.sceneDetail.paramAction.modelePerso#Null:C1517)
					OB REMOVE:C1226(Form:C1466.sceneDetail.paramAction; "modelePerso")
				End if 
				
				If (Form:C1466.sceneDetail.paramAction.modele4WP#Null:C1517)
					OB REMOVE:C1226(Form:C1466.sceneDetail.paramAction; "modele4WP")
				End if 
				
				$continue_b:=True:C214
			End if 
			
		Else   // Aucun modèle n'a été sélectionné auparavant on continue
			$continue_b:=True:C214
		End if 
		
		If ($continue_b=True:C214)
			$config_o:=New object:C1471("entree"; 1; "donnee"; Form:C1466)  // Form est la class scénario
			
			cwToolWindowsForm("gestionDocument"; New object:C1471("ecartHautEcran"; 90; "ecartBasEcran"; 70); $config_o)
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 