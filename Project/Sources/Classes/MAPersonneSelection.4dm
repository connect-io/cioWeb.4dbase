/* -----------------------------------------------------------------------------
Class : cs.MAPersonneSelection

Class de gestion du marketing automation pour une entité Sélection [Personne]

-----------------------------------------------------------------------------*/

Class constructor
/*-----------------------------------------------------------------------------
Fonction : MAPersonneSelection.constructor
	
Instanciation de la class MAPersonneSelection pour le marketing automotion
	
Historique
27/01/21 - RémyScanu <gregory@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	This:C1470.personneSelection:=Null:C1517
	
	// Chargement des éléments nécessaires au bon fonctionnement de la classe par rapport à la table [Personne] de la base hote.
	This:C1470.passerelle:=OB Copy:C1225(Storage:C1525.automation.config.passerelle.query("tableComposant = :1"; "Personne")[0])
	
Function loadAll
/*------------------------------------------------------------------------------
Fonction : MAPersonneSelection.loadAll
	
Permet de sélectionner tous les enregistrements de la table [Personne]
	
Historique
04/01/21 - Rémy Scanu <remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	This:C1470.personneSelection:=ds:C1482[This:C1470.passerelle.tableHote].all()
	
Function loadByField
	var $1 : Text  // Nom du champ
	var $2 : Text  // Signe de la recherche
	var $3 : Variant  // Valeur à rechercher
	
	var $field_c : Collection
	
	$field_c:=This:C1470.passerelle.champ.query("lib = :1"; $1)
	
	If ($field_c.length=1)
		
		If ($field_c[0].directAccess=Null:C1517)  // Il faut faire la recherche sur la table [Personne]
			This:C1470.fieldName:=$field_c[0].personAccess
			This:C1470.fieldSignComparaison:=$2
			This:C1470.fieldValue:=$3
			
			This:C1470.personneSelection:=Formula from string:C1601("ds[\""+This:C1470.passerelle.tableHote+"\"].query(\""+This:C1470.fieldName+" "+This:C1470.fieldSignComparaison+" :1\";This.fieldValue)").call(This:C1470)
			
			OB REMOVE:C1226(This:C1470; "fieldName")
			OB REMOVE:C1226(This:C1470; "fieldSignComparaison")
			OB REMOVE:C1226(This:C1470; "fieldValue")
		Else   // Il faut faire la recherche sur une table [Enfant]
			// ToDo
		End if 
		
	Else 
		This:C1470.newSelection()
	End if 
	
Function loadPersonListForm
	cwToolWindowsForm("listePersonne"; New object:C1471("ecartHautEcran"; 30; "ecartBasEcran"; 70); This:C1470)
	
Function fromEntitySelection($table_o : Object)
	This:C1470.personneSelection:=$table_o
	
Function fromListPersonCollection($collection_c : Collection)
	var $personne_o; $element_o : Object
	
	This:C1470.newSelection()
	
	For each ($element_o; $collection_c)
		$personne_o:=ds:C1482[This:C1470.passerelle.tableHote].get($element_o.UID)
		
		If ($personne_o#Null:C1517)
			This:C1470.personneSelection.add($personne_o)
		End if 
		
	End for each 
	
Function newSelection
/*------------------------------------------------------------------------------
Fonction : MAPersonneSelection.newSelection
	
Permet de ré-initialiser l'entitySelection
	
Historique
04/01/21 - Rémy Scanu <remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	This:C1470.personneSelection:=ds:C1482[This:C1470.passerelle.tableHote].newSelection()
	
Function sendMailing
/*------------------------------------------------------------------------------
Fonction : MAPersonneSelection.sendMailing
	
Permet d'envoyer un mailing à une entitySelection
	
Historique
04/01/21 - Rémy Scanu <remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	var $canalEnvoi_t; $corps_t; $mime_t; $propriete_t; $contenu_t : Text
	var $statut_b : Boolean
	var $class_o; $config_o; $mime_o; $statut_o; $enregistrement_o; $personne_o; $compteur_o : Object
	
	ASSERT:C1129(This:C1470.personneSelection#Null:C1517; "Impossible d'utiliser la fonction sendMailing sans une sélection de personne de définie.")
	
	// Instanciation de la class
	$class_o:=cwToolGetClass("MAMailing").new()
	
	// On détermine le canal d'envoi du mailing
	$canalEnvoi_t:=$class_o.sendGetType()
	
	If ($canalEnvoi_t#"")
		// On configure correctement le mailing
		$config_o:=$class_o.sendGetConfig($canalEnvoi_t)
		
		If ($config_o.success=True:C214)
			// On récupère le contenu
			cwToolWindowsForm("gestionDocument"; New object:C1471("ecartHautEcran"; 30; "ecartBasEcran"; 70); New object:C1471("entree"; 1))
			
			$compteur_o:=New object:C1471("success"; 0; "fail"; 0)
			
			For each ($enregistrement_o; This:C1470.personneSelection)
				$personne_o:=cwToolGetClass("MAPersonne").new()
				$personne_o.loadByPrimaryKey($enregistrement_o.getKey())
				
				If ($personne_o.personne#Null:C1517)
					$statut_b:=True:C214
					
					Case of 
						: ($canalEnvoi_t="Email")
							$corps_t:=WP Get text:C1575(WParea; wk expressions as value:K81:255)
							
							If ($corps_t#"")
								// toDo charger enregistrement pour table [Personne] de la base hôte
								
								If ($corps_t#"@<body@")  // Nouvelle façon d'envoyer des emails
									WP EXPORT VARIABLE:C1319(WParea; $mime_t; wk mime html:K81:1)  // Mime export of Write Pro document
									$mime_o:=MAIL Convert from MIME:C1681($mime_t)
									
									For each ($propriete_t; $mime_o)
										$config_o.eMailConfig[$propriete_t]:=$mime_o[$propriete_t]
									End for each 
									
								Else 
									$config_o.eMailConfig.htmlBody:=$corps_t
								End if 
								
								$config_o.eMailConfig.to:=$personne_o.eMail
								$statut_o:=$config_o.eMailConfig.send()
								
								$contenu_t:=$config_o.eMailConfig.subject
								$statut_b:=(String:C10($statut_o.statusText)="ok@")
								
								If ($statut_b=True:C214)  // Statut de l'envoie du mail
									$compteur_o.success:=$compteur_o.success+1
								Else 
									$compteur_o.fail:=$compteur_o.fail+1
								End if 
								
							End if 
							
						: ($canalEnvoi_t="Courrier")
							WP PRINT:C1343(WParea; wk 4D Write Pro layout:K81:176)
							
							$compteur_o.success:=$compteur_o.success+1
						: ($canalEnvoi_t="SMS")
					End case 
					
					// S'il s'agit d'un Courrier ou SMS ou un mail qui possède un corps non vide, on rajoute l'historique de l'envoi
					If ($canalEnvoi_t#"Email") | (($canalEnvoi_t="Email") & ($corps_t#""))
						$personne_o.updateCaMarketingStatistic(3; New object:C1471("type"; $canalEnvoi_t; "contenu"; $contenu_t; "statut"; $statut_b))
					End if 
					
				End if 
				
				CLEAR VARIABLE:C89($contenu_t)
				CLEAR VARIABLE:C89($statut_b)
			End for each 
			
			If ($compteur_o.success>0)
				ALERT:C41("Le mailing a bien été envoyé à "+String:C10($compteur_o.success)+" personne(s)")
			End if 
			
			If ($compteur_o.fail>0)
				ALERT:C41("Le mailing n'a pas pu être envoyé à "+String:C10($compteur_o.fail)+" personne(s)")
			End if 
			
			If ($compteur_o.success=0) & ($compteur_o.fail=0)
				ALERT:C41("Le mailing a été annulé !")
			End if 
			
		End if 
		
	End if 
	
Function toCollectionAndExtractField($field_c : Collection)
/*------------------------------------------------------------------------------
Fonction : MAPersonneSelection.toCollectionAndExtractField
	
Permet de transformer l'entitySelection This.personneSelection à This.personneCollection suivant les propriétés voulues
	
Historique
04/01/21 - Rémy Scanu <remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
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
	
Function updateCaMarketingStatistic
/*------------------------------------------------------------------------------
Fonction : MAPersonneSelection.updateCaMarketingStatistic
	
Permet de mettre à jour la table marketing
	
Historique
04/01/21 - Rémy Scanu <remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	var $progressBar_i : Integer
	var $class_o; $enregistrement_o : Object
	
	ASSERT:C1129(This:C1470.personneSelection#Null:C1517; "Impossible d'utiliser la fonction updateCaMarketingStatistic sans une sélection de personne de définie.")
	
	// Instanciation de la class
	$class_o:=cwToolGetClass("MAPersonne").new()
	
	$progressBar_i:=Progress New
	
	For each ($enregistrement_o; This:C1470.personneSelection)
		$class_o.loadByPrimaryKey($enregistrement_o.getKey())
		
		If ($class_o.personne#Null:C1517)
			$class_o.updateCaMarketingStatistic(4)  // Je génère à la volée l'enregistrement dans la table [CaMarketing], s'il n'y a pas eu d'enregistrement
		End if 
		
		Progress SET PROGRESS($progressBar_i; ($enregistrement_o.indexOf(This:C1470.personneSelection)/This:C1470.personneSelection.length); "Mise à jour de la table CaMarketing en cours..."; True:C214)
	End for each 
	
	Progress QUIT($progressBar_i)