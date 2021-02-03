var $class_o : Object

$class_o:=cwToolGetClass("MAPersonne").new()
$class_o.loadByPrimaryKey(Form:C1466.PersonneCurrentElement.UID)

If ($class_o.personne#Null:C1517)
	$class_o.loadPersonDetailForm()  // Affichage du détail de la table [Personne] de la base hôte
End if 