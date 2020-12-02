If (Form:C1466.entree=1)  // Si gestion du scénario (personne possible)
	
	If (Type:C295(entitySelection_o)#Est une variable indéfinie:K8:13) & (Form:C1466.PersonneCurrentElement#Null:C1517)
		entitySelection_o:=ds:C1482[Form:C1466.donnee.MarketingAutomation.passerelle.tableHote].query(Form:C1466.MAPersonneDisplay.champUID+" in :1";Form:C1466.PersonneSelectedElement.extract("UID"))  // Je le mets en dur car c'est moi qui le défini sur chargement du formulaire
	End if 
	
End if 

ACCEPT:C269