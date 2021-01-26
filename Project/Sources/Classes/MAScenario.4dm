Class constructor
	C_OBJECT:C1216($1)  // Class MarketingAutomation
	
	This:C1470.marketingAutomation:=$1
	This:C1470.scenario:=ds:C1482.CaScenario.newSelection()
	This:C1470.scenarioDetail:=New object:C1471()
	
Function newScenario
	C_BOOLEAN:C305($0)
	C_OBJECT:C1216($caScenario_o;$retour_o)
	
	$caScenario_o:=ds:C1482.CaScenario.new()
	
	$caScenario_o.nom:="Nouveau scénario"
	$caScenario_o.actif:=True:C214
	$caScenario_o.condition:=New object:C1471("ageMinimum";18;"ageMaximum";99;"rang";0;"dateDebutMailClique";!00-00-00!;"dateFinMailClique";!00-00-00!;"dateDebutMailOuvert";!00-00-00!;"dateFinMailOuvert";!00-00-00!)
	
	$retour_o:=$caScenario_o.save()
	
	$0:=$retour_o.success
	
Function loadAllScenario
	This:C1470.scenario:=ds:C1482.CaScenario.all().orderBy("nom asc")
	
Function loadScenarioDisplay
	This:C1470.loadAllScenario()
	
	cwToolWindowsFormCenter("gestionScenario";"center";This:C1470)
	
Function searchPersonToScenario
	C_LONGINT:C283($1)  // Entier long qui indique l'endroit d'où est exécuté la fonction
	C_TEXT:C284($lib_t;$nomLien_t;$libEmail_t)
	C_LONGINT:C283($ts_el)
	C_OBJECT:C1216($condition_o;$cleValeur_o;$personne_o;$table_o;$personneAEnlever_o;$statut_o)
	C_COLLECTION:C1488($cleValeur_c)
	
	This:C1470.marketingAutomation.loadPasserelle("Personne")  // Chargement de la passerelle Personne
	
	//$personne_o:=ds[This.marketingAutomation.passerelle.tableHote].newSelection()
	$personne_o:=This:C1470.marketingAutomation.loadCurrentPeople()
	$personneAEnlever_o:=ds:C1482[This:C1470.marketingAutomation.passerelle.tableHote].newSelection()
	
	Case of 
		: ($1=1) | ($1=2)  // Gestion du scénario OU Après application d'un scénario à des personnes
			
			If (This:C1470.scenarioDetail#Null:C1517)
				$condition_o:=This:C1470.scenarioDetail.condition
				
				If ($1=2)
					$statut_o:=This:C1470.scenarioDetail.reload()
				End if 
				
				$table_o:=This:C1470.scenarioDetail.AllCaPersonneScenario
				
				If ($table_o.length>0)
					$personneAEnlever_o:=$table_o.OnePersonne
				End if 
				
			End if 
			
	End case 
	
	If ($condition_o#Null:C1517)
		$cleValeur_c:=OB Entries:C1720($condition_o)
		
		For each ($cleValeur_o;$cleValeur_c)
			
			Case of 
				: ($cleValeur_o.key="ageMinimum")
					$lib_t:=This:C1470.marketingAutomation.formule.getFieldName(This:C1470.marketingAutomation.passerelle.champ;"dateNaissance")
					
					$table_o:=ds:C1482[This:C1470.marketingAutomation.passerelle.tableHote].query($lib_t+" <= :1";cwToolNumToDate($cleValeur_o.value;"year";"less"))
					
					$personne_o:=$personne_o.and($table_o)  // Première propriété de ma collection d'objet $cleValeur_c
				: ($cleValeur_o.key="ageMaximum")
					$lib_t:=This:C1470.marketingAutomation.formule.getFieldName(This:C1470.marketingAutomation.passerelle.champ;"dateNaissance")
					
					$table_o:=ds:C1482[This:C1470.marketingAutomation.passerelle.tableHote].query($lib_t+" >= :1";cwToolNumToDate($cleValeur_o.value;"year";"less"))
					
					$personne_o:=$personne_o.and($table_o)
				: ($cleValeur_o.key="dateDebutMailClique")
					
					If ($cleValeur_o.value#!00-00-00!)
						$ts_el:=cwTimestamp($cleValeur_o.value;?00:00:00?)
						
						$table_o:=ds:C1482.CaPersonneMarketing.query("lastClicked # :1 AND lastClicked >= :2";0;$ts_el).OnePersonne
						
						$personne_o:=$personne_o.and($table_o)
					End if 
					
				: ($cleValeur_o.key="dateFinMailClique")
					
					If ($cleValeur_o.value#!00-00-00!)
						$ts_el:=cwTimestamp($cleValeur_o.value;?23:59:59?)
						
						$table_o:=ds:C1482.CaPersonneMarketing.query("lastClicked # :1 AND lastClicked <= :2";0;$ts_el).OnePersonne
						
						$personne_o:=$personne_o.and($table_o)
					End if 
					
				: ($cleValeur_o.key="dateDebutMailOuvert")
					
					If ($cleValeur_o.value#!00-00-00!)
						$ts_el:=cwTimestamp($cleValeur_o.value;?00:00:00?)
						
						$table_o:=ds:C1482.CaPersonneMarketing.query("lastOpened # :1 AND lastOpened >= :2";0;$ts_el).OnePersonne
						
						$personne_o:=$personne_o.and($table_o)
					End if 
					
				: ($cleValeur_o.key="dateFinMailOuvert")
					
					If ($cleValeur_o.value#!00-00-00!)
						$ts_el:=cwTimestamp($cleValeur_o.value;?23:59:59?)
						
						$table_o:=ds:C1482.CaPersonneMarketing.query("lastOpened # :1 AND lastOpened <= :2";0;$ts_el).OnePersonne
						
						$personne_o:=$personne_o.and($table_o)
					End if 
					
				: ($cleValeur_o.key="email")
					$nomLien_t:=This:C1470.marketingAutomation.formule.getFieldName(This:C1470.marketingAutomation.passerelle.lienAvecTelecom;"nomLien")
					
					$table_o:=$personne_o[$nomLien_t]
					
					If (Num:C11($table_o.length)>0)
						This:C1470.marketingAutomation.loadPasserelle("Telecom")  // Chargement de la passerelle Telecom
						
						$lib_t:=This:C1470.marketingAutomation.formule.getFieldName(This:C1470.marketingAutomation.passerelle.champ;"type")
						$libEmail_t:=This:C1470.marketingAutomation.formule.getFieldName(This:C1470.marketingAutomation.passerelle.libelleType;"email")
						
						$table_o:=$table_o.query($lib_t+" = :1";$libEmail_t)
						
						If (Num:C11($table_o.length)>0)
							$nomLien_t:=This:C1470.marketingAutomation.formule.getFieldName(This:C1470.marketingAutomation.passerelle.lienAvecPersonne;"nomLien")
							
							$table_o:=$table_o[$nomLien_t]
							
							If ($cleValeur_o.value=True:C214)  // Si dans les conditions, l'utisateur souhaite uniquement les personnes avec un email
								$personne_o:=$personne_o.and($table_o)
							Else 
								$personne_o:=$personne_o.minus($table_o)
							End if 
							
						Else   // Aucun enregistrement de type "email" dans la table [Telecom] de la base client
							
							If ($cleValeur_o.value=True:C214)  // Si dans les conditions, l'utisateur souhaite uniquement les personnes avec un email
								$personne_o:=ds:C1482[This:C1470.marketingAutomation.passerelle.tableHote].newSelection()
							End if 
							
						End if 
						
						This:C1470.marketingAutomation.loadPasserelle("Personne")  // Chargement de la passerelle Personne
					Else   // Aucun enregistrement dans la table [Telecom] de la base client
						
						If ($cleValeur_o.value=True:C214)  // Si dans les conditions, l'utisateur souhaite uniquement les personnes avec un email
							$personne_o:=ds:C1482[This:C1470.marketingAutomation.passerelle.tableHote].newSelection()
						End if 
						
					End if 
					
				: ($cleValeur_o.key="rang")
					
					If ($cleValeur_o.value#0)
						$table_o:=ds:C1482.CaPersonneMarketing.query("rang = :1";$cleValeur_o.value).OnePersonne
						
						$personne_o:=$personne_o.and($table_o)
					End if 
					
				: ($cleValeur_o.key="sexe")
					$lib_t:=This:C1470.marketingAutomation.formule.getFieldName(This:C1470.marketingAutomation.passerelle.champ;"sexe")
					
					$table_o:=ds:C1482[This:C1470.marketingAutomation.passerelle.tableHote].query($lib_t+" = :1";$cleValeur_o.value)
					
					$personne_o:=$personne_o.and($table_o)
			End case 
			
		End for each 
		
	End if 
	
	If ($personne_o.length>0)  // On va extraire celles et ceux qui ont déjà ce scénario affecté
		$personne_o:=$personne_o.minus($personneAEnlever_o)
	End if 
	
	This:C1470.scenarioPersonnePossibleEntity:=$personne_o
	This:C1470.scenarioPersonneEnCoursEntity:=$personneAEnlever_o
	
Function applyScenarioToPerson
	C_OBJECT:C1216($enregistrement_o;$caPersonneScenario_o;$retour_o)
	
	If (This:C1470.scenarioSelectionPossiblePersonne#Null:C1517)
		
		For each ($enregistrement_o;This:C1470.scenarioSelectionPossiblePersonne)
			$caPersonneScenario_o:=ds:C1482.CaPersonneScenario.new()
			
			$caPersonneScenario_o.personneID:=$enregistrement_o.getKey()
			$caPersonneScenario_o.scenarioID:=This:C1470.scenarioDetail.getKey()
			
			$caPersonneScenario_o.actif:=This:C1470.scenarioDetail.actif
			
			$retour_o:=$caPersonneScenario_o.save()
		End for each 
		
		This:C1470.updateStringScenarioForm(2)  // On met à jour les deux variables qui indiquent les différentes applications possibles et en cours pour le scénario X
	End if 
	
Function deleteScenarioToPerson
	C_VARIANT:C1683($1)  // UID Personne
	C_TEXT:C284($2)  // UID Scenario
	C_BOOLEAN:C305($0)
	C_OBJECT:C1216($table_o;$statut_o)
	
	$table_o:=ds:C1482.CaPersonneScenario.query("personneID is :1 AND scenarioID is :2";$1;$2)
	
	If (Num:C11($table_o.length)=1)
		$statut_o:=$table_o.first().drop()
		
		$0:=$statut_o.success
	End if 
	
Function loadImageScenarioCondition
	C_TEXT:C284($lib_t)
	
	$lib_t:=This:C1470.marketingAutomation.formule.getFieldName(This:C1470.marketingAutomation.passerelle.libelleSexe;"femme")
	
	This:C1470.imageMale:=This:C1470.marketingAutomation.image["male"]
	This:C1470.imageFemale:=This:C1470.marketingAutomation.image["female"]
	This:C1470.imageMaleFemale:=This:C1470.marketingAutomation.image["male-female-clicked"]
	
	This:C1470.imageEmail:=This:C1470.marketingAutomation.image["toggle"]
	This:C1470.imageDesabonnement:=This:C1470.marketingAutomation.image["toggle"]
	
	If (This:C1470.scenarioDetail.condition.sexe#Null:C1517)
		
		If (This:C1470.scenarioDetail.condition.sexe=$lib_t)  // Il s'agit d'une condition sexe = femme
			This:C1470.imageFemale:=This:C1470.marketingAutomation.image["female-clicked"]
		Else 
			This:C1470.imageMale:=This:C1470.marketingAutomation.image["male-clicked"]
		End if 
		
		This:C1470.imageMaleFemale:=This:C1470.marketingAutomation.image["male-female"]
	End if 
	
	If (This:C1470.scenarioDetail.condition.email#Null:C1517)
		
		If (This:C1470.scenarioDetail.condition.email=True:C214)
			This:C1470.imageEmail:=This:C1470.marketingAutomation.image["toggle-on"]
		Else 
			This:C1470.imageEmail:=This:C1470.marketingAutomation.image["toggle-off"]
		End if 
		
	End if 
	
	If (This:C1470.scenarioDetail.condition.desabonnement#Null:C1517)
		
		If (This:C1470.scenarioDetail.condition.desabonnement=True:C214)
			This:C1470.imageDesabonnement:=This:C1470.marketingAutomation.image["toggle-on"]
		Else 
			This:C1470.imageDesabonnement:=This:C1470.marketingAutomation.image["toggle-off"]
		End if 
		
	End if 
	
Function updateStringScenarioForm
	C_LONGINT:C283($1)  // Entier long qui indique l'endroit d'où est exécuté la fonction
	
	Case of 
		: ($1=1)  // Gestion du scénario
			This:C1470.searchPersonToScenario(1)
		: ($1=2)  // Application scénario à une sélection de personne
			This:C1470.searchPersonToScenario(2)
	End case 
	
	If ($1=1) | ($1=2)
		This:C1470.scenarioPersonnePossible:="Applicable à "+String:C10(This:C1470.scenarioPersonnePossibleEntity.length)+" personne(s)."
		
		If (This:C1470.scenarioSelectionPossiblePersonne#Null:C1517) & ($1=1)
			This:C1470.scenarioPersonnePossible:=This:C1470.scenarioPersonnePossible+Char:C90(Retour chariot:K15:38)+String:C10(This:C1470.scenarioSelectionPossiblePersonne.length)+" personne(s) sélectionnée(s)."
		Else 
			This:C1470.scenarioPersonnePossible:=This:C1470.scenarioPersonnePossible+Char:C90(Retour chariot:K15:38)+"0 personne sélectionnée."
			
			If (This:C1470.scenarioSelectionPossiblePersonne#Null:C1517)
				OB REMOVE:C1226(This:C1470;"scenarioSelectionPossiblePersonne")
			End if 
			
		End if 
		
		This:C1470.scenarioPersonneEnCours:="Appliqué à "+String:C10(This:C1470.scenarioPersonneEnCoursEntity.length)+" personne(s)."
	End if 
	
Function newScene
	C_BOOLEAN:C305($0)
	C_OBJECT:C1216($caScene_o;$retour_o)
	
	$caScene_o:=ds:C1482.CaScene.new()
	
	$caScene_o.nom:="Nouvelle scène"
	$caScene_o.scenarioID:=This:C1470.scenarioDetail.getKey()
	$caScene_o.action:="Définir une nouvelle action..."
	$caScene_o.paramAction:=New object:C1471()
	$caScene_o.conditionAction:=New object:C1471()
	$caScene_o.conditionSaut:=New object:C1471()
	
	$retour_o:=$caScene_o.save()
	
	$0:=$retour_o.success
	
Function updateStringSceneForm
	C_LONGINT:C283($1)  // Entier long qui indique l'endroit d'où est exécuté la fonction
	
	This:C1470.scenePersonneEnCoursEntity:=ds:C1482[This:C1470.marketingAutomation.passerelle.tableHote].newSelection()
	
	Case of 
		: ($1=1)  // Gestion du scénario (et donc de la scène)
			
			If (Num:C11(This:C1470.sceneDetail.AllCaScenarioEvent.length)>0)  // Il y a eu des logs pour cette scène
				This:C1470.scenePersonneEnCoursEntity:=This:C1470.sceneDetail.AllCaScenarioEvent.OneCaPersonneScenario.OnePersonne
			Else 
				This:C1470.scenePersonneEnCoursEntity:=This:C1470.sceneDetail.OneCaScenario.AllCaPersonneScenario.OnePersonne
			End if 
			
			If (This:C1470.sceneDetail.tsAttente=0)
				This:C1470.sceneSuivanteDelai:="0"
				
				If (String:C10(This:C1470.sceneDetail.paramAction.echelleDelai)="")
					This:C1470.sceneDetail.paramAction.echelleDelai:="jour(s)"
				End if 
				
			Else 
				
				Case of 
					: (String:C10(This:C1470.sceneDetail.paramAction.echelleDelai)="jour(s)") | (String:C10(This:C1470.sceneDetail.paramAction.echelleDelai)="jour(s)")
						This:C1470.sceneSuivanteDelai:=String:C10(Round:C94(This:C1470.sceneDetail.tsAttente/5184000;0))
					: (String:C10(This:C1470.sceneDetail.paramAction.echelleDelai)="semaine(s)")
						This:C1470.sceneSuivanteDelai:=String:C10(Round:C94(This:C1470.sceneDetail.tsAttente/(5184000*7);0))
					: (String:C10(This:C1470.sceneDetail.paramAction.echelleDelai)="mois(s)")
						This:C1470.sceneSuivanteDelai:=String:C10(Round:C94(This:C1470.sceneDetail.tsAttente/(5184000*30);0))
					: (String:C10(This:C1470.sceneDetail.paramAction.echelleDelai)="année(s)")
						This:C1470.sceneSuivanteDelai:=String:C10(Round:C94(This:C1470.sceneDetail.tsAttente/(5184000*365);0))
				End case 
				
			End if 
			
	End case 
	
	This:C1470.scenePersonneEnCours:="Appliqué à "+String:C10(This:C1470.scenePersonneEnCoursEntity.length)+" personne(s)."
	
Function loadImageSceneActionCondition
	This:C1470.imageEmail:=This:C1470.marketingAutomation.image["toggle"]
	
Function saveFileActionScene
	C_TEXT:C284($1)  // ID scenario
	C_LONGINT:C283($2)  // ID scene
	C_OBJECT:C1216($3)  // Objet Write Pro
	C_TEXT:C284($4)  // Extension du fichier
	C_BOOLEAN:C305($5)  // Booléen qui indique si l'utilisateur choisi l'endroit du fichier de sauvegarde du fichier
	C_TEXT:C284($texte_t;$chemin_t)
	C_BOOLEAN:C305($continue_b)
	
	$texte_t:=WP Get text:C1575($3;wk expressions as source:K81:256)
	
	$chemin_t:=Get 4D folder:C485(Dossier Resources courant:K5:16;*)+"cioMarketingAutomation"+Séparateur dossier:K24:12+"scenario"+Séparateur dossier:K24:12+$1+Séparateur dossier:K24:12
	
	$continue_b:=This:C1470.marketingAutomation.createFolder($chemin_t)  // Création ou check du dossier scénario
	
	If ($continue_b=True:C214)  // Le dossier du scénario scenarioDetail.ID existe
		$chemin_t:=$chemin_t+String:C10($2)+Séparateur dossier:K24:12
		
		$continue_b:=This:C1470.marketingAutomation.createFolder($chemin_t)  // Création ou check du dossier de la scène
	End if 
	
	If ($continue_b=True:C214)  // Le dossier de la scène sceneDetail.ID du scénario scenarioDetail.ID existe
		
		If ($5=False:C215)
			
			Case of 
				: ($4="word")
					
				: ($4="html")
					
				: ($4="4wp")
					
					If ($texte_t="@<mj-body@") | ($texte_t="@<body@")  // Il s'agit d'un email
						WP EXPORT DOCUMENT:C1337($3;$chemin_t+"actionParMail.4WP";wk 4wp:K81:4)
					Else 
						WP EXPORT DOCUMENT:C1337($3;$chemin_t+"actionParCourrier.4WP";wk 4wp:K81:4)
					End if 
					
			End case 
			
		Else 
			$chemin_t:=Select document:C905(System folder:C487(Bureau:K41:16);".4wp";" title";Saisie nom de fichier:K24:17)
			
			// ToDo
			If ($chemin_t#"")
				WP EXPORT DOCUMENT:C1337($3;document;wk 4wp:K81:4;wk normal:K81:7)
			End if 
			
		End if 
		
		ALERT:C41("L'action de la scène a été sauvegardé avec succès")
	Else 
		ALERT:C41("L'action de la scène n'a pas pu être sauvegardé")
	End if 