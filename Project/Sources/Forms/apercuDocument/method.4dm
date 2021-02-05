If (Form event code:C388=Sur chargement:K2:1)
	var $model_o; $fichier_o : Object
	
	WParea:=WP New:C1317()
	
	If (Form:C1466.entree=1)  // Choix du template pour une scène
		
		Case of 
			: (Form:C1466.donnee.sceneDetail.paramAction.modele#Null:C1517)  // Il s'agit d'un modèle du composant ou bien d'un modèle stocké sur l'ordinateur de l'utilisateur
				
				If (Form:C1466.donnee.sceneDetail.paramAction.modelePerso=Null:C1517)  // Il s'agit d'un modèle du composant
					$model_o:=cwStorage.eMail.model.query("name = :1"; Form:C1466.donnee.sceneDetail.paramAction.modele)[0]
					
					$fichier_o:=File:C1566(cwStorage.eMail.modelPath+$model_o.source)
					
					If ($fichier_o.exists=True:C214)
						
						If (String:C10($model_o.layout)#"")
							$fichier_o:=File:C1566(cwStorage.eMail.modelPath+$model_o.layout)
							
							If ($fichier_o.exists=True:C214)
								WP SET TEXT:C1574(WParea; $fichier_o.getText(); wk replace:K81:177)
							End if 
							
						Else 
							WP SET TEXT:C1574(WParea; $fichier_o.getText(); wk replace:K81:177)
						End if 
						
					End if 
					
				Else   // Il s'agit d'un modèle stocké sur l'ordinateur de l'utilisateur
					WParea:=Form:C1466.donnee.sceneDetail.paramAction.modele4WP
				End if 
				
			: (Form:C1466.donnee.sceneDetail.paramAction.modelePerso#Null:C1517)  // Il s'agit d'un modèle tapé directement par l'utilisateur
				
		End case 
		
	End if 
	
End if 