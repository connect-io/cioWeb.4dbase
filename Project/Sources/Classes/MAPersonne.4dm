/* -----------------------------------------------------------------------------
Class : cs.MAPersonne

Class de gestion du marketing automation pour les personnes.

-----------------------------------------------------------------------------*/

Class constructor
/*-----------------------------------------------------------------------------
Fonction : MAPersonne.constructor
	
Instenciation de la class MAPersonne pour le marketing automotion
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - Clean code
-----------------------------------------------------------------------------*/
	This:C1470.personne:=Null:C1517
	
	// Nom de la table personne dans la base hote.
	This:C1470.passerelle:=OB Copy:C1225(Storage:C1525.automation.config.passerelle.query("tableComposant = :1"; "Personne")[0])
	
	This:C1470.UID:=""
	This:C1470.sexe:=""
	This:C1470.nom:=""
	This:C1470.prenom:=""
	This:C1470.eMail:=""
	This:C1470.codePostal:=""
	This:C1470.ville:=""
	This:C1470.dateNaissance:=""
	This:C1470.dateCreation:=""
	
	
	
Function getInfo
/*-----------------------------------------------------------------------------
Fonction : MAPersonne.getInfo
	
Remonte les informations de mailjet.
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
	
	C_OBJECT:C1216($mailjet_cs; $mailjet_o)
	
	$mailjet_cs:=cwToolGetClass("Mailjet")  // Initialisation de la class
	
	$mailjet_o:=$mailjet_cs.new()  // Instanciation de la class
	
	This:C1470.statMailjet:=$mailjet_o.getStatistic(This:C1470.email)
	
	
	
Function load($field_c : Collection)
/*-----------------------------------------------------------------------------
Fonction : MAPersonne.load
	
Charge le profil de la personne depuis la base hôte.
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	
	var $formule_t : Text
	var $field_t : Text  // Lib du champ
	
	// On récupére la liste des champs que l'on souhaite intégrer à la personne.
	If ($field_c=Null:C1517)
		$field_c:=This:C1470.passerelle.champ.extract("lib")
	End if 
	
	ASSERT:C1129(This:C1470.personne#Null:C1517; "Impossible d'utiliser cette fonction sans une personne de définie.")
	ASSERT:C1129($field_c#Null:C1517; "Impossible de determiner les champs d'une personne.")
	
	For each ($field_t; $field_c)
		
		// On récupére la config du champs.
		$field_c:=This:C1470.passerelle.champ.query("lib is :1"; $field_t)
		ASSERT:C1129($field_c.length#0; "getData : Impossible de trouver la configuration du champ : "+$field_t)
		
		// Reset de la formule.
		$formule_t:="This.personne"
		
		For each ($element_t; Split string:C1554($field_c[0].personnAccess; ".")) Until (This:C1470[$field_t]=Null:C1517)
			
			// On concaténe la formule.
			$formule_t:=$formule_t+"."+$element_t
			
			// On applique la formule et l'on fixe le résultat dans this.
			This:C1470[$field_t]:=Formula from string:C1601($formule_t).call(This:C1470)
			
			// Si This[$field_t] =. null, on sort de la boucle.
		End for each 
	End for each 
	
	
	
Function loadByChild($field_t : Text)->$isOk_b : Boolean
/*-----------------------------------------------------------------------------
Fonction : MAPersonne.loadByChild
	
Retrouve le profil d'une personne depuis une recherche d'une table enfant.
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - Début de création
-----------------------------------------------------------------------------*/
	
	var $entityChild_o : Object
	var $formule_t : Text
	
	// 1/ Il faut faire un accès direct à l'entité. ("directAccess")
	$formule_t:=This:C1470.passerelle.champ.query("lib is :1"; $field_t)[0].directAccess
	$entityChild_o:=Formula from string:C1601($formule_t).call(This:C1470)
	
	// 2/ Puis il faut remonter vers la personne.
	$contentQuery_t:=This:C1470.passerelle.champ.query("lib is :1"; $field_t)[0].personnAccess
	This:C1470.personne:=$entityChild_o.query($contentQuery_t)
	
	If (This:C1470.personne#Null:C1517)
		This:C1470.load()
		$isOk_b:=True:C214
	End if 
	
	
	
Function loadByEmail($eMail_t : Text)->$isOk_b : Boolean
/* -----------------------------------------------------------------------------
Fonction : MAPersonne.loadByEmail
	
Certainement voué à disparaitre... 
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - Ajout entête.
-----------------------------------------------------------------------------*/
	
	C_TEXT:C284($field_t; $nomLien_t)
	C_OBJECT:C1216($table_o)
	
	$field_t:=This:C1470.passerelle.champ.query("lib is 'eMail'")[0].personnAccess
	$table_o:=ds:C1482[This:C1470.passerelle.tableHote].query($field_t+" is :1"; $eMail_t)
	
	
	If ($table_o.length=1)
		$nomLien_t:=Storage:C1525.automation.formule.getFieldName(This:C1470.passerelle.lienAvecPersonne; "nomLien")
		
		This:C1470.personne:=$table_o[$nomLien_t]
		
		If (This:C1470.personne#Null:C1517)
			This:C1470.load()
			$isOk_b:=True:C214
		End if 
		
	End if 
	
	
	
Function loadByPrimaryKey($PersonneID_v : Variant)->$isOk_b : Boolean
/* -----------------------------------------------------------------------------
Fonction : MAPersonne.loadByPrimaryKey
	
Retrouve et charge le profil d'une personne via, sa clé primaire.
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - Ré-écriture.
-----------------------------------------------------------------------------*/
	
	This:C1470.personne:=ds:C1482[This:C1470.passerelle.tableHote].get($PersonneID_v)
	
	If (This:C1470.personne#Null:C1517)
		This:C1470.load()
		$isOk_b:=True:C214
	End if 
	
	
	
Function loadCaMarketing
/* -----------------------------------------------------------------------------
Fonction : MAPersonne.loadCaMarketing
	
!! Je ne sais pas à quoi sert cet méthode.
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - Ajout entête
-----------------------------------------------------------------------------*/
	
	C_OBJECT:C1216($0)  // Entity CaMarketing
	C_OBJECT:C1216($caPersonneMarketing_o; $retour_o)
	
	If (This:C1470.personne.length=1)
		$caPersonneMarketing_o:=This:C1470.personne.AllCaPersonneMarketing
		
		If ($caPersonneMarketing_o.length=0)
			$caPersonneMarketing_o:=ds:C1482.CaPersonneMarketing.new()
			
			$caPersonneMarketing_o.personneID:=This:C1470.UID
			$caPersonneMarketing_o.rang:=1  // 1 pour Suspect
			
			$retour_o:=$caPersonneMarketing_o.save()
			
			$0:=$caPersonneMarketing_o
		Else 
			$0:=$caPersonneMarketing_o.first()
		End if 
		
	End if 
	
	
	
Function updateCaMarketingEventAutomatic()->$return_b : Boolean
/*------------------------------------------------------------------------------
Fonction : MAPersonne.updateCaMarketingEventAutomatic
	
!! Je ne sais pas à quoi sert cet méthode.
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - Ajout entête
------------------------------------------------------------------------------*/
	
	C_TEXT:C284($1)  // Event qu'on souhaite mettre à jour
	C_LONGINT:C283($2)  // TS de l'event
	C_OBJECT:C1216($caPersonneMarketing_o)
	
	// On pensera à mettre à jour les informations marketing.
	$caPersonneMarketing_o:=This:C1470.personne.AllCaPersonneMarketing
	
	If ($caPersonneMarketing_o.length=0)
		$caPersonneMarketing_o:=ds:C1482.CaPersonneMarketing.new()
		
		$caPersonneMarketing_o.personneID:=This:C1470.UID
		$caPersonneMarketing_o.rang:=1  // 1 pour Suspect
	Else 
		$caPersonneMarketing_o:=$caPersonneMarketing_o.first()
	End if 
	
	Case of 
		: ($1="3")
			$caPersonneMarketing_o.lastOpened:=$2
		: ($1="4")
			$caPersonneMarketing_o.lastClicked:=$2
		: ($1="10")
			$caPersonneMarketing_o.lastBounce:=$2
	End case 
	
	$retour_o:=$caPersonneMarketing_o.save()
	
	$return_b:=$retour_o.success
	
	
	
Function updateCaMarketingStatisticAutomatic
/*------------------------------------------------------------------------------
Fonction : MAPersonne.updateCaMarketingStatisticAutomatic
	
!! Je ne sais pas à quoi sert cet méthode.
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - Ajout entête
------------------------------------------------------------------------------*/
	
	C_OBJECT:C1216($caPersonneMarketing_o)
	
	// On pensera à mettre à jour les informations marketing.
	$caPersonneMarketing_o:=This:C1470.personne.AllCaPersonneMarketing
	
	If ($caPersonneMarketing_o.length=0)
		$caPersonneMarketing_o:=ds:C1482.CaPersonneMarketing.new()
		
		$caPersonneMarketing_o.personneID:=This:C1470.UID
		$caPersonneMarketing_o.mailjetInfo:=This:C1470.statMailjet
		$caPersonneMarketing_o.rang:=1  // 1 pour Suspect
	Else 
		$caPersonneMarketing_o:=$caPersonneMarketing_o.first()
		
		$caPersonneMarketing_o.mailjetInfo:=This:C1470.statMailjet
	End if 
	
	
	
Function updateCaMarketingStatisticManual()->$return_b : Boolean
/*------------------------------------------------------------------------------
Fonction : MAPersonne.updateCaMarketingStatisticManual
	
!! Je ne sais pas à quoi sert cet méthode.
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - Ajout entête
------------------------------------------------------------------------------*/
	
	var $caPersonneMarketing_o : Object
	
	// On pensera à mettre à jour les informations marketing.
	$caPersonneMarketing_o:=This:C1470.personne.AllCaPersonneMarketing
	
	If ($caPersonneMarketing_o.length=0)
		$caPersonneMarketing_o:=ds:C1482.CaPersonneMarketing.new()
		
		$caPersonneMarketing_o.personneID:=This:C1470.UID
		$caPersonneMarketing_o.mailjetInfo:=This:C1470.statMailjet
		$caPersonneMarketing_o.rang:=1  // 1 pour Suspect
	Else 
		$caPersonneMarketing_o:=$caPersonneMarketing_o.first()
		
		$caPersonneMarketing_o.mailjetInfo:=This:C1470.statMailjet
	End if 
	
	$retour_o:=$caPersonneMarketing_o.save()
	
	If ($retour_o.success=True:C214)
		ALERT:C41("Les dernières stats de mailjet on bien été mis à jour dans la fiche de "+This:C1470.nom+" "+This:C1470.prenom)
	Else 
		ALERT:C41("Impossible de mettre à jour la table marketing dans la fiche de "+This:C1470.nom+" "+This:C1470.prenom+" !")
	End if 
	
	$retour_o:=$caPersonneMarketing_o.save()
	return_b:=$retour_o.success
	