/* -----------------------------------------------------------------------------
Class : cs.MAPersonne

Class de gestion du marketing automation pour une entité [Personne]

-----------------------------------------------------------------------------*/

Class constructor
/*-----------------------------------------------------------------------------
Fonction : MAPersonne.constructor
	
Instanciation de la class MAPersonne pour le marketing automotion
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - Clean code
-----------------------------------------------------------------------------*/
	This:C1470.personne:=Null:C1517
	
	// Chargement des éléments nécessaires au bon fonctionnement de la classe par rapport à la table [Personne] de la base hote.
	This:C1470.passerelle:=OB Copy:C1225(Storage:C1525.automation.config.passerelle.query("tableComposant = :1"; "Personne")[0])
	
Function getFieldName($field_t : Text)->$fieldName_t : Text
	var $field_c : Collection
	
	$field_c:=This:C1470.passerelle.champ.query("lib = :1"; $field_t)
	
	If ($field_c.length=1)
		$fieldName_t:=String:C10($field_c[0].personAccess)
	End if 
	
Function load($field_c : Collection)
/*-----------------------------------------------------------------------------
Fonction : MAPersonne.load
	
Charge le profil de la personne depuis la base hôte.
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - Ré-écriture
-----------------------------------------------------------------------------*/
	var $formule_t : Text
	var $field_t : Text  // Lib du champ
	
	// On récupére la liste des champs que l'on souhaite intégrer à la personne.
	If ($field_c=Null:C1517)
		$field_c:=This:C1470.passerelle.champ.extract("lib")
	End if 
	
	ASSERT:C1129(This:C1470.personne#Null:C1517; "Impossible d'utiliser cette fonction sans une personne de définie.")
	ASSERT:C1129($field_c#Null:C1517; "Impossible de déterminer les champs d'une personne.")
	
	For each ($field_t; $field_c)
		// On récupére la config du champs.
		$field_c:=This:C1470.passerelle.champ.query("lib is :1"; $field_t)
		ASSERT:C1129($field_c.length#0; "Fonction load (Class MAPersonne) : Impossible de trouver la configuration du champ : "+$field_t)
		
		// Reset de la formule.
		$formule_t:="This.personne"
		
		For each ($element_t; Split string:C1554($field_c[0].personAccess; ".")) Until (This:C1470[$field_t]=Null:C1517)
			// On concaténe la formule.
			$formule_t:=$formule_t+"."+$element_t
			
			// On applique la formule et l'on fixe le résultat dans this.
			This:C1470[$field_t]:=Formula from string:C1601($formule_t).call(This:C1470)
			
			// Si This[$field_t] = null, on sort de la boucle.
		End for each 
		
	End for each 
	
Function loadByField
	var $1 : Text  // Nom du champ
	var $2 : Text  // Signe de la recherche
	var $3 : Variant  // Valeur à rechercher
	
	var $table_o : Object
	var $field_c : Collection
	
	$field_c:=This:C1470.passerelle.champ.query("lib = :1"; $1)
	
	This:C1470.personne:=Null:C1517  // Par défaut je ré-initialise la propriété
	
	If ($field_c.length=1)
		
		If ($field_c[0].directAccess=Null:C1517)  // La recherche doit se faire directement sur la table [Personne] de la base hôte
			This:C1470.fieldName:=$field_c[0].personAccess
			This:C1470.fieldSignComparaison:=$2
			This:C1470.fieldValue:=$3
			
			$table_o:=Formula from string:C1601("ds[\""+This:C1470.passerelle.tableHote+"\"].query(\""+This:C1470.fieldName+" "+This:C1470.fieldSignComparaison+" :1\";This.fieldValue)").call(This:C1470)
			
			If ($table_o.length>0)
				This:C1470.personne:=$table_o.first()
				
				This:C1470.load()
			End if 
			
			OB REMOVE:C1226(This:C1470; "fieldName")
			OB REMOVE:C1226(This:C1470; "fieldSignComparaison")
			OB REMOVE:C1226(This:C1470; "fieldValue")
		Else   // Il faut faire la recherche sur une table [Enfant]
			// ToDo
		End if 
		
	End if 
	
Function loadByChild($field_t : Text; $childField_t : Text; $childFieldValue_t : Text)->$isOk_b : Boolean
/*-----------------------------------------------------------------------------
Fonction : MAPersonne.loadByChild
	
Retrouve le profil d'une personne depuis une recherche d'une table enfant.
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - Début de création
-----------------------------------------------------------------------------*/
	var $entityChild_o : Object
	var $formule_t : Text
	
	// 1/ Il faut faire un accès direct à l'entité. ("directAccess")
	This:C1470.childField:=$childField_t
	This:C1470.childFieldValue:=$childFieldValue_t
	
	$formule_t:=This:C1470.passerelle.champ.query("lib is :1"; $field_t)[0].directAccess
	$entityChild_o:=Formula from string:C1601($formule_t).call(This:C1470)
	
	// 2/ Puis il faut remonter vers la personne.
	$contentQuery_t:=This:C1470.passerelle.champ.query("lib is :1"; $field_t)[0].personAccess
	This:C1470.personne:=$entityChild_o.query($contentQuery_t)
	
	If (This:C1470.personne#Null:C1517)
		This:C1470.load()
		
		$isOk_b:=True:C214
	End if 
	
	// On supprime les deux propriétés nécessaires pour la recherche
	OB REMOVE:C1226(This:C1470; "childField")
	OB REMOVE:C1226(This:C1470; "childFieldValue")
	
Function loadByPrimaryKey($PersonneID_v : Variant)->$isOk_b : Boolean
/* -----------------------------------------------------------------------------
Fonction : MAPersonne.loadByPrimaryKey
	
Retrouve et charge le profil d'une personne via, sa clé primaire.
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - Ré-écriture
-----------------------------------------------------------------------------*/
	This:C1470.personne:=ds:C1482[This:C1470.passerelle.tableHote].get($PersonneID_v)
	
	If (This:C1470.personne#Null:C1517)
		This:C1470.load()
		
		$isOk_b:=True:C214
	End if 
	
Function loadPersonDetailForm($primaryKey_v : Variant)
/* -----------------------------------------------------------------------------
Fonction : MAPersonne.loadPersonDetailForm
	
Permet de charger le formulaire détail dans la liste de la table [Personne]
	
Historique
01/02/21 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	cwToolWindowsForm("detailPersonne"; "center"; This:C1470)
	
Function mailjetGetStat
/*-----------------------------------------------------------------------------
Fonction : MAPersonne.mailjetGetStat
	
Remonte les informations de mailjet.
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
	var $class_o : Object
	
	ASSERT:C1129(This:C1470.personne#Null:C1517; "Impossible d'utiliser la fonction mailjetGetStat sans une personne de définie.")
	
	// Instanciation de la class
	$class_o:=cwToolGetClass("MAMailjet").new()
	
	This:C1470.statMailjet:=$class_o.getStatistic(This:C1470.eMail)
	
Function mailjetGetDetailStat
/*-----------------------------------------------------------------------------
Fonction : MAPersonne.mailjetGetDetailStat
	
Remonte les informations de mailjet.
	
Historique
03/02/21 - Rémy Scanu <remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $1 : Text
	var ${2} : Text
	
	var $i_el : Integer
	var $class_o; $mailjet_o; $mailjetDetail_o; $personne_o : Object
	var $mailjetDetail_c : Collection
	
	ASSERT:C1129(This:C1470.personne#Null:C1517; "Impossible d'utiliser la fonction mailjetGetDetailStat sans une personne de définie.")
	
	// Instanciation de la class
	$class_o:=cwToolGetClass("MAMailjet").new()
	
	// Instanciation de la class
	$personne_o:=cwToolGetClass("MAPersonne").new()
	
	For ($i_el; 2; Count parameters:C259)
		$class_o.getMessageEvent(${$i_el}; 0; cwTimestamp(Current date:C33; Current time:C178); ->$mailjet_o)
		
		If ($mailjet_o.errorHttp=Null:C1517)
			$class_o.AnalysisMessageEvent($mailjet_o; ${$i_el}; 0; cwTimestamp(Current date:C33; Current time:C178); ->$mailjetDetail_c)
		End if 
		
		If ($1#"")
			$mailjetDetail_c:=$mailjetDetail_c.query("email = :1"; $1)
		End if 
		
		For each ($mailjetDetail_o; $mailjetDetail_c)
			// On vérifie que l'email trouvé est bien dans la base du client
			$personne_o.loadByField("eMail"; "="; $mailjetDetail_o.email)  // Initialisation de l'entité sélection de la table [Personne] du client
			
			If ($personne_o.personne#Null:C1517)  // On met à jour la table marketing avec les infos de mailjet
				$personne_o.updateCaMarketingStatistic(2; New object:C1471("eventNumber"; ${$i_el}; "eventTs"; Num:C11($mailjetDetail_o.tsEvent)))
			End if 
			
		End for each 
		
	End for 
	
Function sendMailing
	var $canalEnvoi_t; $corps_t; $mime_t; $propriete_t; $contenu_t : Text
	var $statut_b : Boolean
	var $class_o; $config_o; $mime_o; $statut_o : Object
	
	ASSERT:C1129(This:C1470.personne#Null:C1517; "Impossible d'utiliser la fonction sendMailing sans une personne de définie.")
	
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
			
			Case of 
				: ($canalEnvoi_t="Email")
					$corps_t:=WP Get text:C1575(WParea; wk expressions as value:K81:255)
					
					If ($corps_t#"")
						
						If ($corps_t#"@<body@")  // Nouvelle façon d'envoyer des emails
							WP EXPORT VARIABLE:C1319(WParea; $mime_t; wk mime html:K81:1)  // Mime export of Write Pro document
							$mime_o:=MAIL Convert from MIME:C1681($mime_t)
							
							For each ($propriete_t; $mime_o)
								$config_o.eMailConfig[$propriete_t]:=$mime_o[$propriete_t]
							End for each 
							
						Else 
							$config_o.eMailConfig.htmlBody:=$corps_t
						End if 
						
						$config_o.eMailConfig.to:=This:C1470.eMail
						
						$statut_o:=$config_o.eMailConfig.send()
						
						$contenu_t:=$config_o.eMailConfig.subject
						$statut_b:=(String:C10($statut_o.statusText)="ok@")
						
						If ($statut_b=True:C214)  // Statut de l'envoie du mail
							ALERT:C41("Votre email a bien été envoyé")
						Else 
							ALERT:C41("Une erreur est survenue lors de l'envoi de l'e-mail : "+$statut_o.statusText)
						End if 
						
						This:C1470.updateCaMarketingStatistic(3; New object:C1471("type"; $canalEnvoi_t; "contenu"; $config_o.eMailConfig.subject; "statut"; (String:C10($statut_o.statusText)="ok@")))
					End if 
					
				: ($canalEnvoi_t="Courrier")
					WP PRINT:C1343(WParea; wk 4D Write Pro layout:K81:176)
				: ($canalEnvoi_t="SMS")
			End case 
			
			// S'il s'agit d'un Courrier ou SMS ou un mail qui possède un corps non vide, on rajoute l'historique de l'envoi
			If ($canalEnvoi_t#"Email") | (($canalEnvoi_t="Email") & ($corps_t#""))
				$personne_o.updateCaMarketingStatistic(3; New object:C1471("type"; $canalEnvoi_t; "contenu"; $contenu_t; "statut"; $statut_b))
			End if 
			
		End if 
		
	End if 
	
Function updateCaMarketingStatistic($provenance_el : Integer; $detail_o : Object)->$isOk_b : Boolean
/*------------------------------------------------------------------------------
Fonction : MAPersonne.updateCaMarketingStatistic
	
Permet de mettre à jour la table marketing
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - Ajout entête
------------------------------------------------------------------------------*/
	var $table_o; $enregistrement_o : Object
	
	ASSERT:C1129(This:C1470.personne#Null:C1517; "Impossible d'utiliser la fonction updateCaMarketingStatistic sans une personne de définie.")
	
	// On pensera à mettre à jour les informations marketing.
	$table_o:=This:C1470.personne.AllCaPersonneMarketing
	
	If ($table_o.length=0)
		$enregistrement_o:=ds:C1482.CaPersonneMarketing.new()
		
		$enregistrement_o.personneID:=This:C1470.UID
		$enregistrement_o.rang:=1  // 1 pour Suspect
		$enregistrement_o.historique:=New object:C1471("detail"; New collection:C1472)
	Else 
		$enregistrement_o:=$table_o.first()
	End if 
	
	Case of 
		: ($provenance_el=1)  // On souhaite mettre à jour les stats de mailjet
			// On va récupérer les informations utiles sur mailjet pour mettre à jour la stratégie de relance.
			This:C1470.mailjetGetStat()
			
			// Mise à jour des stats de mailjet (besoin d'éxécuter avant mailjetGetStat() pour fonctionner correctement)
			$enregistrement_o.mailjetInfo:=This:C1470.statMailjet
			$retour_o:=$enregistrement_o.save()
			
			// Il faut également mettre à jour les autres champs
			This:C1470.mailjetGetDetailStat(This:C1470.eMail; "3"; "4"; "7"; "8"; "10")
		: ($provenance_el=2)  // On souhaite mettre à jour un des event (opened, clicked, unsubscribe ou bounce)
			
			Case of 
				: (String:C10($detail_o.eventNumber)="3")
					$enregistrement_o.lastOpened:=$detail_o.eventTs
				: (String:C10($detail_o.eventNumber)="4")
					$enregistrement_o.lastClicked:=$detail_o.eventTs
				: (String:C10($detail_o.eventNumber)="7")
					$enregistrement_o.lastUnsubscribe:=$detail_o.eventTs
					
					$enregistrement_o.desabonementMail:=True:C214
					
					// Gestion du désabonnement qui peut avoir un traitement particulier suivant la base
					If (OB Is defined:C1231(This:C1470.personne; "manageUnsubscribe")=True:C214)
						This:C1470.personne.manageUnsubscribe()
					End if 
					
				: (String:C10($detail_o.eventNumber)="10")
					$enregistrement_o.lastBounce:=$detail_o.eventTs
			End case 
			
		: ($provenance_el=3)  // On souhaite mettre à jour l'historique des mailings envoyés à la personne
			
			$enregistrement_o.historique.detail.push(New object:C1471(\
				"eventTs"; cwTimestamp(Current date:C33; Current time:C178); \
				"eventUser"; Current user:C182; \
				"eventDetail"; New object:C1471("type"; String:C10($detail_o.type); "contenu"; String:C10($detail_o.contenu); "statut"; String:C10($detail_o.statut))))
			
	End case 
	
	If ($provenance_el#1)  // On sauvegarde juste avant inutile de refaire cela
		$retour_o:=$enregistrement_o.save()
	End if 
	
	Case of 
		: ($provenance_el=1)  // On souhaite mettre à jour manuellement les stats de mailjet
			
			If ($retour_o.success=True:C214)
				ALERT:C41("Les dernières stats de mailjet on bien été mis à jour dans la fiche de "+This:C1470.nom+" "+This:C1470.prenom)
			Else 
				ALERT:C41("Impossible de mettre à jour la table marketing dans la fiche de "+This:C1470.nom+" "+This:C1470.prenom)
			End if 
			
		: ($provenance_el=2)  // On souhaite mettre à jour un des event (opened, clicked ou bounce)
			
			If ($retour_o.success=False:C215)
				
				Case of 
					: (String:C10($detail_o.eventNumber)="3")
						$event_t:="Opened"
					: (String:C10($detail_o.eventNumber)="4")
						$event_t:="Clicked"
					: (String:C10($detail_o.eventNumber)="10")
						$event_t:="Bounce"
				End case 
				
				ALERT:C41("Impossible de mettre à jour la table marketing pour l'event "+$event_t+" dans la fiche de "+This:C1470.nom+" "+This:C1470.prenom)
			End if 
			
	End case 
	
	$isOk_b:=$retour_o.success