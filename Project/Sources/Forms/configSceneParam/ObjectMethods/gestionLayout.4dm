Case of 
	: (Form event code:C388=Sur clic:K2:4)
		C_OBJECT:C1216($config)
		
		$config:=New object:C1471
		
		CONFIRM:C162("Voulez-vous utiliser un modèle interne ?"; "Oui"; "Non")
		TRACE:C157
		If (OK=1)
			
		Else   // Modèle du composant cioWeb (sousDomaine/email)
			$config.modele:=Storage:C1525.eMail.model
		End if 
		
		$config.sceneDetail:=Form:C1466.sceneDetail
		
		cwToolWindowsForm("configSceneModele"; "center"; $config)  // Form est la class scénario
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 