Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		var $sexe_t : Text
		
		$sexe_t:=Storage:C1525.automation.passerelle.libelleSexe.query("value = :1"; Form:C1466.sexe)[0].lib
		
		If ($sexe_t="femme")
			Form:C1466.imageSexe:=Storage:C1525.automation.image["female"]
		Else 
			Form:C1466.imageSexe:=Storage:C1525.automation.image["male"]
		End if 
		
End case 