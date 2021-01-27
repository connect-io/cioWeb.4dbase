Class constructor
	C_OBJECT:C1216($marketingAutomation_cs; $marketingAutomation_o)
	
	$marketingAutomation_cs:=cwToolGetClass("MarketingAutomation")  // Initialisation de la class
	$marketingAutomation_o:=$marketingAutomation_cs.new()  // Instanciation de la class
	
	This:C1470.marketingAutomation:=$marketingAutomation_o
	
	This:C1470.marketingAutomation.loadPasserelle("Personne")
	
	This:C1470.champUID:=This:C1470.marketingAutomation.formule.getFieldName(This:C1470.marketingAutomation.passerelle.champ; "UID")
	This:C1470.champSexe:=This:C1470.marketingAutomation.formule.getFieldName(This:C1470.marketingAutomation.passerelle.champ; "sexe")
	This:C1470.champNom:=This:C1470.marketingAutomation.formule.getFieldName(This:C1470.marketingAutomation.passerelle.champ; "nom")
	This:C1470.champPrenom:=This:C1470.marketingAutomation.formule.getFieldName(This:C1470.marketingAutomation.passerelle.champ; "prenom")
	This:C1470.champCodePostal:=This:C1470.marketingAutomation.formule.getFieldName(This:C1470.marketingAutomation.passerelle.champ; "codePostal")
	This:C1470.champVille:=This:C1470.marketingAutomation.formule.getFieldName(This:C1470.marketingAutomation.passerelle.champ; "ville")
	
Function updateScenarioListToPerson
	C_TEXT:C284($1)  // UID personne OU vide
	C_OBJECT:C1216($0)
	C_OBJECT:C1216($table_o)
	
	$0:=ds:C1482.CaScenario.newSelection()
	
	If ($1#"")
		$table_o:=ds:C1482[This:C1470.marketingAutomation.passerelle.tableHote].query(This:C1470.champUID+" is :1"; $1).AllCaPersonneScenario
		
		If (Num:C11($table_o.length)>0)
			$0:=$table_o.OneCaScenario
		End if 
		
	End if 
	
Function updateStringPersonneForm
	C_OBJECT:C1216($1)  // Entity personne
	C_TEXT:C284($civilite_t; $libHomme_t; $libFemme_t)
	C_OBJECT:C1216($table_o)
	
	$libHomme_t:=This:C1470.marketingAutomation.formule.getFieldName(This:C1470.marketingAutomation.passerelle.libelleSexe; "homme")
	$libFemme_t:=This:C1470.marketingAutomation.formule.getFieldName(This:C1470.marketingAutomation.passerelle.libelleSexe; "femme")
	
	Case of 
		: (String:C10($1.sexe)=$libHomme_t)
			$civilite_t:="Mr."
		: (String:C10($1.sexe)=$libFemme_t)
			$civilite_t:="Mme."
	End case 
	
	Case of 
		: (Num:C11($1.modeSelection)=1) | (Num:C11($1.modeSelection)=2) & (Bool:C1537($1.multiSelection)=False:C215)  // Sélection unique OU Sélection multi-lignes mais qu'une seule ligne sélectionnée
			$1.resume:=Choose:C955($civilite_t#""; $civilite_t+" "; "")+$1.nom+" "+$1.prenom+", habite à "+$1.ville+" ("+$1.codePostal+")."
			
			$table_o:=ds:C1482[This:C1470.marketingAutomation.passerelle.tableHote].query(This:C1470.champUID+" is :1"; $1.UID)
			
			If (Num:C11($table_o.length)=1)
				$table_o:=$table_o.AllCaPersonneMarketing
				
				If (Num:C11($table_o.length)=1)
					$table_o:=$table_o.first()
					
					Case of 
						: ($table_o.rang=1)
							$1.resumeMarketing:="• Rang : suspect"
						: ($table_o.rang=2)
							$1.resumeMarketing:="• Rang : prospect"
						: ($table_o.rang=3)
							$1.resumeMarketing:="• Rang : client"
						: ($table_o.rang=4)
							$1.resumeMarketing:="• Rang : client fidèle"
						: ($table_o.rang=5)
							$1.resumeMarketing:="• Rang : ambassadeur"
					End case 
					
					$1.resumeMarketing:=$1.resumeMarketing+Char:C90(Retour à la ligne:K15:40)
					
					$1.resumeMarketing:=$1.resumeMarketing+"Dernière(s) activité(s) des mails envoyés :"+Char:C90(Retour à la ligne:K15:40)
					
					If ($table_o.lastOpened#0)
						$1.resumeMarketing:=$1.resumeMarketing+"• Dernier mail ouvert : "+cwTimestampLire("date"; $table_o.lastOpened)+Char:C90(Retour à la ligne:K15:40)
					Else 
						$1.resumeMarketing:=$1.resumeMarketing+"• Aucun email ouvert"+Char:C90(Retour à la ligne:K15:40)
					End if 
					
					If ($table_o.lastClicked#0)
						$1.resumeMarketing:=$1.resumeMarketing+"• Dernier mail cliqué : "+cwTimestampLire("date"; $table_o.lastClicked)+Char:C90(Retour à la ligne:K15:40)
					Else 
						$1.resumeMarketing:=$1.resumeMarketing+"• Aucun email cliqué"+Char:C90(Retour à la ligne:K15:40)
					End if 
					
					If ($table_o.lastBounce#0)
						$1.resumeMarketing:=$1.resumeMarketing+"• Email détecté en bounce le : "+cwTimestampLire("date"; $table_o.lastBounce)+Char:C90(Retour à la ligne:K15:40)
					Else 
						$1.resumeMarketing:=$1.resumeMarketing+"• Aucun bounce"+Char:C90(Retour à la ligne:K15:40)
					End if 
					
					If ($table_o.desabonementMail=True:C214)
						$1.resumeMarketing:=$1.resumeMarketing+"• Désabonnement souhaité"
					Else 
						$1.resumeMarketing:=$1.resumeMarketing+"• Aucune demande de désabonnement"
					End if 
					
				Else 
					$1.resumeMarketing:="Aucune donnée disponible"
				End if 
				
			Else 
				$1.resumeMarketing:="La personne n'a pas pu être retrouver dans votre base de donnée."
			End if 
			
		: (Num:C11($1.modeSelection)=2) & (Bool:C1537($1.multiSelection)=True:C214)  // Sélection multi-lignes
			$1.resume:="Aperçu indisponible plusieurs personnes sélectionnées"
			$1.resumeMarketing:="Aperçu indisponible plusieurs personnes sélectionnées"
	End case 
	
Function viewPersonList
	C_OBJECT:C1216($1)  // Objet Form scénario
	C_OBJECT:C1216(entitySelection_o)
	
	entitySelection_o:=ds:C1482[This:C1470.marketingAutomation.passerelle.tableHote].newSelection()
	
	Case of 
		: ($1.entree=1)  // Gestion du scénario (Personne possible)
			
			If ($1.donnee.scenarioPersonnePossibleEntity#Null:C1517)  // On souhait voir les personnes possiblement applicable à un scénario
				$1.personne:=$1.donnee.scenarioPersonnePossibleEntity.toCollection(This:C1470.champUID+", "+This:C1470.champSexe+", "+This:C1470.champNom+", "+This:C1470.champPrenom+", "+This:C1470.champCodePostal+", "+This:C1470.champVille)\
					.extract(This:C1470.champUID; "UID"; This:C1470.champSexe; "sexe"; This:C1470.champNom; "nom"; This:C1470.champPrenom; "prenom"; This:C1470.champCodePostal; "codePostal"; This:C1470.champVille; "ville")
			End if 
			
			OBJECT SET ENABLED:C1123(*; "supprimerScenarioEnCours"; False:C215)
			
			If ($1.donnee.scenarioSelectionPossiblePersonne#Null:C1517)
				
				For each ($enregistrement_o; $1.personne)
					$table_o:=$1.donnee.scenarioSelectionPossiblePersonne.query(This:C1470.champUID+" is :1"; $enregistrement_o.UID)
					
					If (Num:C11($table_o.length)=1)
						LISTBOX SELECT ROW:C912(*; "listePersonne"; $1.personne.indexOf($enregistrement_o)+1; lk ajouter à sélection:K53:2)
					End if 
					
				End for each 
				
			End if 
			
			LISTBOX SET PROPERTY:C1440(*; "listePersonne"; lk mode de sélection:K53:35; lk multilignes:K53:59)
		: ($1.entree=2)  // Gestion du scénario (Personne en cours)
			
			If ($1.donnee.scenarioPersonneEnCoursEntity#Null:C1517)  // On souhait voir les personnes où le scénario est déjà appliqué
				$1.personne:=$1.donnee.scenarioPersonneEnCoursEntity.toCollection(This:C1470.champUID+", "+This:C1470.champSexe+", "+This:C1470.champNom+", "+This:C1470.champPrenom+", "+This:C1470.champCodePostal+", "+This:C1470.champVille)\
					.extract(This:C1470.champUID; "UID"; This:C1470.champSexe; "sexe"; This:C1470.champNom; "nom"; This:C1470.champPrenom; "prenom"; This:C1470.champCodePostal; "codePostal"; This:C1470.champVille; "ville")
			End if 
			
		: ($1.entree=3)  // Gestion des personnes (Sans passer par Gestion du scénario)
			
			$1.personne:=ds:C1482[This:C1470.marketingAutomation.passerelle.tableHote].all().toCollection(This:C1470.champUID+", "+This:C1470.champSexe+", "+This:C1470.champNom+", "+This:C1470.champPrenom+", "+This:C1470.champCodePostal+", "+This:C1470.champVille)\
				.extract(This:C1470.champUID; "UID"; This:C1470.champSexe; "sexe"; This:C1470.champNom; "nom"; This:C1470.champPrenom; "prenom"; This:C1470.champCodePostal; "codePostal"; This:C1470.champVille; "ville")
			
		: ($1.entree=4)  // Gestion de la scène (Personne en cours)
			
			If ($1.donnee.scenePersonneEnCoursEntity#Null:C1517)  // On souhait voir les personnes où la scène est en cours d'éxécution
				$1.personne:=$1.donnee.scenePersonneEnCoursEntity.toCollection(This:C1470.champUID+", "+This:C1470.champSexe+", "+This:C1470.champNom+", "+This:C1470.champPrenom+", "+This:C1470.champCodePostal+", "+This:C1470.champVille)\
					.extract(This:C1470.champUID; "UID"; This:C1470.champSexe; "sexe"; This:C1470.champNom; "nom"; This:C1470.champPrenom; "prenom"; This:C1470.champCodePostal; "codePostal"; This:C1470.champVille; "ville")
			End if 
			
	End case 