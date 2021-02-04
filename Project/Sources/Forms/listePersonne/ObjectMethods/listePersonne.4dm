If (Form event code:C388=Sur double clic:K2:5)
	var $class_o : Object
	
	$class_o:=cwToolGetClass("MAPersonne").new()
	$class_o.loadByPrimaryKey(Form:C1466.PersonneCurrentElement.UID)
	
	If ($class_o.personne#Null:C1517)
		$class_o.loadPersonDetailForm()  // Affichage du détail de la table [Personne] de la base hôte
		
		Form:C1466.personneSelectionDisplayClass.reloadPerson(Form:C1466.PersonneCurrentElement.UID)
	End if 
	
End if 