Case of 
	: (Form event code:C388=Sur clic:K2:4)
		var $chemin_t : Text
		var $refDoc_h : Time
		var $fichier_o; $model_o : Object
		
		CONFIRM:C162("Voulez-vous ouvrir un modèle stocké dans le composant ?"; "Oui"; "Non")
		
		If (OK=1)
			cwToolWindowsForm("selectValue"; "center"; New object:C1471("collection"; cwStorage.eMail.model; "property"; "name"; "selectSubTitle"; "Merci de sélectionner un modèle"; "title"; "Choix du modèle :"))
			
			If (selectValue_t#"")
				$model_o:=cwStorage.eMail.model.query("name = :1"; selectValue_t)[0]
				
				$fichier_o:=File:C1566(cwStorage.eMail.modelPath+$model_o.source)
				
				If ($fichier_o.exists=True:C214)
					
					If (String:C10($model_o.layout)#"")
						$fichier_o:=File:C1566(cwStorage.eMail.modelPath+$model_o.layout)
						
						If ($fichier_o.exists=True:C214)
							WP SET TEXT:C1574(WParea; $fichier_o.getText(); wk append:K81:179)
						End if 
						
					Else 
						WP SET TEXT:C1574(WParea; $fichier_o.getText(); wk append:K81:179)
					End if 
					
				End if 
				
			End if 
			
		Else 
			$refDoc_h:=Open document:C264(""; "4W7;4WP")  // Le fichier est ouvert
			
			If (OK=1)
				WParea:=WP Import document:C1318(Document)
				
				CLOSE DOCUMENT:C267($refDoc_h)
			End if 
			
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 