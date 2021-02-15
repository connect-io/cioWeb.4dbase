Case of 
	: (Form event code:C388=Sur clic:K2:4)
		var $version_o : Object
		
		If (versionList_at>0)
			
			Case of 
				: (Picture size:C356(Form:C1466.imageModeleActif)=Picture size:C356(Storage:C1525.automation.image["toggle-off"]))
					
					// On boucle sur toutes les version et on les rend inactives sauf celle qu'on souhaite mettre en actif
					For each ($version_o; Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version)
						
						If ($version_o.titre#Form:C1466.sceneVersionSelected)
							$version_o.actif:=False:C215
						Else 
							$version_o.actif:=True:C214
						End if 
						
					End for each 
					
					Form:C1466.sceneDetail.save()
					Form:C1466.imageModeleActif:=Storage:C1525.automation.image["toggle-on"]
				: (Picture size:C356(Form:C1466.imageModeleActif)=Picture size:C356(Storage:C1525.automation.image["toggle-on"]))
					
					If (Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version.length>1)  // S'il y a plus d'une version on doit demander laquelle on souhaite rendre actve
						cwToolWindowsForm("selectValue"; "center"; New object:C1471("collection"; Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version.query("titre # :1"; Form:C1466.sceneVersionSelected).extract("titre"; "type"); \
							"property"; "type"; "selectSubTitle"; "Merci de sélectionner une version active"; "title"; "Choix du modèle actif :"))
						
						If (selectValue_t#"")
							
							For each ($version_o; Form:C1466.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.sceneTypeSelected)].version)
								
								If ($version_o.titre#selectValue_t)
									$version_o.actif:=False:C215
								Else 
									$version_o.actif:=True:C214
								End if 
								
								Form:C1466.sceneDetail.save()
							End for each 
							
							Form:C1466.imageModeleActif:=Storage:C1525.automation.image["toggle-off"]
						End if 
						
					Else 
						ALERT:C41("Impossible de rendre inactive le modèle car il n'en existe qu'un")
					End if 
					
			End case 
			
		Else 
			ALERT:C41("Merci de sélectionner une version avant de pouvoir la rendre active")
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 