If (Type:C295(entitySelection_o)#Est une variable indéfinie:K8:13) & (Form:C1466.PersonneCurrentElement#Null:C1517)
	entitySelection_o:=ds:C1482[Form:C1466.donnee.marketingAutomation.passerelle.tableHote].query(Form:C1466.champUID+" in :1";Form:C1466.PersonneSelectedElement.extract("UID"))  // Je le mets en dur car c'est moi qui le défini sur chargement du formulaire
End if 

ACCEPT:C269