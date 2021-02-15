If (Form event code:C388=Sur chargement:K2:1)
	var $webCode_t : Text
	var $model_o; $fichier_o; $doc4WP_o : Object
	var WParea : Object
	
	WParea:=WP New:C1317()
	
	If (Form:C1466.entree=1) | (Form:C1466.entree=2)  // Prévisualisation du modèle actif (Edition paramètres de scène)
		$doc4WP_o:=Form:C1466.donnee.sceneDetail.paramAction.modele[Lowercase:C14(Form:C1466.donnee.sceneTypeSelected)].version.query("actif = :1"; True:C214)[0].contenu4WP
		
		If (WP Get text:C1575($doc4WP_o; wk expressions as value:K81:255)="@<p@") | (WP Get text:C1575($doc4WP_o; wk expressions as value:K81:255)="@<html@")  // Il s'agit d'un email
			$webCode_t:=WP Get text:C1575($doc4WP_o; wk expressions as value:K81:255)
			
			WA OPEN URL:C1020(*; "Zone Web"; "about:blank")
			WA SET PAGE CONTENT:C1037(*; "Zone Web"; $webCode_t; "about:blank")
			
			OBJECT SET VISIBLE:C603(*; "WPtoolbar"; False:C215)
			OBJECT SET VISIBLE:C603(*; "WParea"; False:C215)
		Else 
			WParea:=$doc4WP_o
			
			OBJECT SET VISIBLE:C603(*; "Zone Web"; False:C215)
		End if 
		
	End if 
	
End if 