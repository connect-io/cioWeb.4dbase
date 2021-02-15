Case of 
	: (Form event code:C388=Sur clic:K2:4)
		var $doc4WP : Object
		
		If (WP Get text:C1575(WParea; wk expressions as value:K81:255)="@<p@") | (WP Get text:C1575(WParea; wk expressions as value:K81:255)="@<html@")
			$doc4WP:=WParea
			
			cwToolWindowsForm("apercuDocument"; New object:C1471("ecartHautEcran"; 90; "ecartBasEcran"; 70); New object:C1471("entree"; 2; "donnee"; Form:C1466.donnee))
			WParea:=WP New:C1317($doc4WP)
		Else 
			ALERT:C41("Le document 4D WPro ne contient pas de code html")
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 