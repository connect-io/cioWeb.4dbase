If (Form event code:C388=Sur données modifiées:K2:15)
	var $destinataire_t; $to_t : Text
	var $modele_o : Object
	
	If (modeleListe_at{modeleListe_at}#"")
		
		If (modeleListe_at{modeleListe_at}#"@.4WP") | (modeleListe_at{modeleListe_at}#"@.4W7")  // Modèle du composant cioWeb
			$modele_o:=Storage:C1525.eMail.model.query("name IS :1"; modeleListe_at{modeleListe_at})[0]
			
			Form:C1466.modeleDetail:="• Objet de l'email : "+$modele_o.object
			
			If ($modele_o.to#Null:C1517)
				
				For each ($destinataire_t; $modele_o.to)
					
					If ($modele_o.to.indexOf($destinataire_t)#$modele_o.to.length)
						$to_t:=$to_t+$destinataire_t+", "
					Else 
						$to_t:=$to_t+$destinataire_t
					End if 
					
				End for each 
				
				Form:C1466.modeleDetail:=Form:C1466.modeleDetail+"• Destinataire de l'email : "+$to_t
			End if 
			
		End if 
		
	Else 
		OB REMOVE:C1226(Form:C1466; "modeleDetail")
	End if 
	
End if 