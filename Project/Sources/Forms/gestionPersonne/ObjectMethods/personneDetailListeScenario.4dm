If (Form event code:C388=Sur clic:K2:4) & (Form:C1466.ScenarioPersonneCurrentElement#Null:C1517)
	C_OBJECT:C1216($table_o)
	
	$table_o:=Form:C1466.ScenarioPersonneCurrentElement  // Gestion du scènario sélectionné
	
	Form:C1466.scene:=$table_o.AllCaScene  // Gestion des scènes du scénario sélectionné
	
	OBJECT SET ENABLED:C1123(*;"personneDetailListeScene";True:C214)
Else 
	
	If (Form:C1466.scene#Null:C1517)
		Form:C1466.scene:=Null:C1517
	End if 
	
	OBJECT SET ENABLED:C1123(*;"personneDetailListeScene";False:C215)
End if 