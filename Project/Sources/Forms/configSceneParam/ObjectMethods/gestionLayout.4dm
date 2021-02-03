Case of 
	: (Form event code:C388=Sur clic:K2:4)
		var $docFichier_t : Text
		var $config_o : Object
		
		$config_o:=New object:C1471
		
		CONFIRM:C162("Voulez-vous utiliser un modèle du composant cioWeb ?"; "Oui"; "Non")
		
		If (OK=1)  // Modèle du composant cioWeb (sousDomaine/email)
			$config_o.modele:=Storage:C1525.eMail.model
		Else 
			$docFichier_t:=Select document:C905(""; ".4WP"; "Sélection du modèle pour la scène"; Utiliser fenêtre feuille:K24:11)
			
			If (OK=1)
				$config_o.modele:=New collection:C1472(New object:C1471("name"; cwToolExtractFileNameToPath(Document; True:C214)))
			End if 
			
		End if 
		
		If ($config_o.modele#Null:C1517)
			$config_o.sceneDetail:=Form:C1466.sceneDetail
			
			cwToolWindowsForm("configSceneModele"; "center"; $config_o)
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 