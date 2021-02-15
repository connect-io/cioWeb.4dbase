If (Form event code:C388=Sur données modifiées:K2:15)
	//var $destinataire_t; $to_t : Text
	//var $modele_o : Object
	var $titre_t : Text
	var $titreUnique_b : Boolean
	var $elementSelected_o; $version_o : Object
	
	If (versionList_at{versionList_at}="Créer une nouvelle version...")
		
		Repeat 
			$titre_t:=Request:C163("Merci d'indiquer le nom de la nouvelle version"; "Version "+String:C10(Size of array:C274(versionList_at)); "Créer"; "Annuler")
			
			If ($titre_t#"")
				
				If (Num:C11(Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version.query("titre = :1"; $titre_t).length)=0)
					$titreUnique_b:=True:C214
				End if 
				
				If ($titreUnique_b=True:C214)
					// Mise à jour du select
					DELETE FROM ARRAY:C228(versionList_at; versionList_at)
					
					APPEND TO ARRAY:C911(versionList_at; $titre_t)
					SORT ARRAY:C229(versionList_at; >)
					
					APPEND TO ARRAY:C911(versionList_at; "Créer une nouvelle version...")
					
					versionList_at:=Find in array:C230(versionList_at; $titre_t)
					
					REDRAW:C174(versionList_at)
					
					If (Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version.length>0)
						CONFIRM:C162("Voulez-vous en faire devenir la version active ?"; "Oui"; "Non")
						
						If (OK=1)
							
							For each ($version_o; Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version)
								$version_o.actif:=False:C215
							End for each 
							
						End if 
						
					Else 
						OK:=1
					End if 
					
					Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version.push(New object:C1471("titre"; $titre_t; "actif"; (OK=1); "contenu4WP"; WP New:C1317; "creerPar"; Current user:C182; "creerLe"; cwTimestamp; "modifierPar"; Current user:C182; "modifierLe"; cwTimestamp))
					Form:C1466.sceneDetail.save()
				Else 
					ALERT:C41("Une version porte déjà ce nom, merci d'en choisir un différent")
				End if 
				
			End if 
			
		Until ((OK=1) & ($titreUnique_b=True:C214)) | (OK=0)
		
	Else 
		$titre_t:=versionList_at{versionList_at}
	End if 
	
	If ($titre_t#"")
		$elementSelected_o:=Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version.query("titre = :1"; $titre_t)[0]
		
		Form:C1466.modeleDetail:="• Titre : "+$elementSelected_o.titre+Char:C90(Retour à la ligne:K15:40)
		Form:C1466.modeleDetail:=Form:C1466.modeleDetail+"• Créer le "+cwTimestampLire("date"; $elementSelected_o.creerLe)+" par "+$elementSelected_o.creerPar+Char:C90(Retour à la ligne:K15:40)
		Form:C1466.modeleDetail:=Form:C1466.modeleDetail+"• Dernière modification fait le "+cwTimestampLire("date"; $elementSelected_o.modifierLe)+" par "+$elementSelected_o.modifierPar
		
		If ($elementSelected_o.actif=True:C214)
			Form:C1466.imageModeleActif:=Storage:C1525.automation.image["toggle-on"]
		Else 
			Form:C1466.imageModeleActif:=Storage:C1525.automation.image["toggle-off"]
		End if 
		
	Else 
		versionList_at:=0
		
		Form:C1466.modeleDetail:=""
	End if 
	
	Form:C1466.sceneVersionSelected:=$titre_t
	//Si (modeleListe_at{modeleListe_at}#"")
	
	//Si (modeleListe_at{modeleListe_at}#"@.4WP") & (modeleListe_at{modeleListe_at}#"@.4W7")  // Modèle du composant cioWeb
	//$modele_o:=Storage.eMail.model.query("name IS :1"; modeleListe_at{modeleListe_at})[0]
	
	//Form.modeleDetail:="• Objet de l'email : "+$modele_o.subject
	
	//Si ($modele_o.to#Null)
	
	//Pour chaque ($destinataire_t; $modele_o.to)
	
	//Si ($modele_o.to.indexOf($destinataire_t)#$modele_o.to.length)
	//$to_t:=$to_t+$destinataire_t+", "
	//Sinon 
	//$to_t:=$to_t+$destinataire_t
	//Fin de si 
	
	//Fin de chaque 
	
	//Form.modeleDetail:=Form.modeleDetail+"• Destinataire de l'email : "+$to_t
	//Fin de si 
	
	//Sinon   // Modèle perso
	//Form.modeleDetail:="• Modèle sélectionné sur votre ordinateur (Chemin d'accès : "+Form.modele[0].path+")"
	//Fin de si 
	
	//Sinon 
	//OB SUPPRIMER(Form; "modeleDetail")
	//Fin de si 
	
End if 