/* -----------------------------------------------------------------------------
Class : cs.MAPersonneSelection

Class de gestion du marketing automation pour une entité Sélection [Personne]

-----------------------------------------------------------------------------*/

Class constructor
/*-----------------------------------------------------------------------------
Fonction : MAPersonneSelection.constructor
	
Instenciation de la class MAPersonneSelection pour le marketing automotion
	
Historique
27/01/21 - RémyScanu <gregory@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	This:C1470.personneSelection:=Null:C1517
	
	// Chargement des éléments nécessaires au bon fonctionnement de la classe par rapport à la table [Personne] de la base hote.
	This:C1470.passerelle:=OB Copy:C1225(Storage:C1525.automation.config.passerelle.query("tableComposant = :1"; "Personne")[0])
	
Function loadAll
	This:C1470.personneSelection:=ds:C1482[This:C1470.passerelle.tableHote].all()
	
Function toCollectionAndExtractField($field_c : Collection)
	var $field_t; $fieldExtract_t : Text
	var $formule_o : Object
	
	If ($field_c=Null:C1517)
		$field_c:=This:C1470.passerelle.champ.extract("lib")
	End if 
	
	For each ($field_t; $field_c)
		$fieldExtract_t:=$fieldExtract_t+Char:C90(Guillemets:K15:41)+String:C10(This:C1470.passerelle.champ[This:C1470.passerelle.champ.indices("lib = :1"; $field_t)[0]].personAccess)+Char:C90(Guillemets:K15:41)+"; "+Char:C90(Guillemets:K15:41)+$field_t+Char:C90(Guillemets:K15:41)
		
		If ($field_c.indexOf($field_t)#($field_c.length-1))
			$fieldExtract_t:=$fieldExtract_t+";"
		End if 
		
	End for each 
	
	This:C1470.personneCollection:=Formula from string:C1601("This.personneSelection.toCollection().extract("+$fieldExtract_t+")").call(This:C1470)
	
Function loadPersonForm
	cwToolWindowsForm("listePersonne"; "center"; This:C1470)
	
Function newSelection
	This:C1470.personneSelection:=ds:C1482[This:C1470.passerelle.tableHote].newSelection()