Class constructor
	C_OBJECT:C1216($1)  // Class MarketingAutomation
	
	This:C1470.formule:=OB Copy:C1225($1.formule)  // Copie de la formule de la class MarketingAutomation pour pouvoir l'utiliser dans les fonctions
	This:C1470.passerelle:=OB Copy:C1225($1.passerelle)  // Copie de la passerelle de la class MarketingAutomation pour pouvoir l'utiliser dans les fonctions
	
	This:C1470.personne:=ds:C1482[$1.passerelle.tableHote].newSelection()
	This:C1470.UID:=""
	
	This:C1470.sexe:=""
	This:C1470.nom:=""
	This:C1470.prenom:=""
	
	This:C1470.email:=""
	
	This:C1470.codePostal:=""
	This:C1470.ville:=""
	
	This:C1470.dateNaissance:=""
	This:C1470.dateCreation:=""
	
Function load
	C_TEXT:C284(${1})  // Nom de la propriété à charger dans la class This.personne
	C_LONGINT:C283($i_el)
	
	For ($i_el;1;Count parameters:C259)
		This:C1470[${$i_el}]:=This:C1470.getData(${$i_el})
	End for 
	
Function loadAll
	This:C1470.personne:=ds:C1482[This:C1470.passerelle.tableHote].all()
	
Function loadByUID
	C_TEXT:C284($1)  // UID de la personne
	C_BOOLEAN:C305($0)  // Booléen qui indique si on a trouvé ou pas la personne
	C_TEXT:C284($field_t)
	
	$field_t:=This:C1470.formule.getFieldName(This:C1470.passerelle.champ;"UID")
	
	This:C1470.personne:=ds:C1482[This:C1470.passerelle.tableHote].query($field_t+" is :1";$1)
	
	If (This:C1470.personne.length=1)
		This:C1470.load("UID";"nom";"prenom";"sexe";"email";"dateNaissance";"dateCreation";"codePostal";"ville")
		
		$0:=True:C214
	End if 
	
Function loadByEmail
	C_TEXT:C284($1)  // Email de la personne
	C_BOOLEAN:C305($0)  // Booléen qui indique si on a trouvé ou pas la personne
	C_TEXT:C284($field_t;$nomLien_t)
	C_OBJECT:C1216($table_o)
	
	$field_t:=This:C1470.formule.getFieldName(This:C1470.passerelle.champ;"value")
	
	$table_o:=ds:C1482[This:C1470.passerelle.tableHote].query($field_t+" is :1";$1)
	
	If ($table_o.length=1)
		This:C1470.email:=$table_o.first()[$field_t]
		
		$nomLien_t:=This:C1470.formule.getFieldName(This:C1470.passerelle.lienAvecPersonne;"nomLien")
		
		This:C1470.personne:=$table_o[$nomLien_t]
		
		If (This:C1470.personne.length=1)
			This:C1470.UID:=This:C1470.personne.first().getKey(dk key as string:K85:16)
			
			$0:=True:C214
		End if 
		
	End if 
	
Function loadCaMarketing
	C_OBJECT:C1216($0)  // Entity CaMarketing
	C_OBJECT:C1216($caPersonneMarketing_o;$retour_o)
	
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
	
Function getData
	C_TEXT:C284($1)  // Champ à retourner
	C_TEXT:C284($0)  // Valeur du champ
	
	C_TEXT:C284($field_t;$element_t)
	C_OBJECT:C1216($recherche_o)
	C_BOOLEAN:C305($error_b)
	C_COLLECTION:C1488($recherche_c)
	C_VARIANT:C1683(data_v)
	
	If ($1#"email")
		$field_t:=This:C1470.formule.getFieldName(This:C1470.passerelle.champ;$1)
	Else 
		$field_t:=This:C1470.formule.getFieldName(This:C1470.passerelle.lienAvecTelecom;$1)
	End if 
	
	$recherche_c:=Split string:C1554($field_t;".")
	
	data_v:=This:C1470.personne.first()
	
	$recherche_o:=New object:C1471()
	
	For each ($element_t;$recherche_c) Until ($error_b=True:C214)
		$recherche_o.execute:=Formula from string:C1601("data_v."+$element_t)
		
		If ($element_t="first()") | ($element_t="[0]")  // Il faut vérifier qu'il y a bien au moins une entité dans data_v
			
			If (data_v.length=0)
				data_v:=""
				
				$error_b:=True:C214
			End if 
			
		End if 
		
		If ($error_b=False:C215)
			data_v:=$recherche_o.execute()
		End if 
		
	End for each 
	
	$0:=String:C10(data_v)
	
Function getInfo
	C_OBJECT:C1216($mailjet_cs;$mailjet_o)
	
	$mailjet_cs:=cwToolGetClass("Mailjet")  // Initialisation de la class
	
	$mailjet_o:=$mailjet_cs.new()  // Instanciation de la class
	
	This:C1470.statMailjet:=$mailjet_o.getStatistic(This:C1470.email)
	
Function sendMail
	C_TEXT:C284($1)  // objet
	C_TEXT:C284($2)  // Corps
	C_OBJECT:C1216($0)  // Statut de l'email
	
	C_OBJECT:C1216($mail_cs;$mail_o)
	
	$mail_cs:=cwToolGetClass("EMail")  // Initialisation de la class
	$mail_o:=$mail_cs.new()  // Instanciation de class
	
Function sendMailModel
	C_TEXT:C284($1)  // Nom du model
	C_OBJECT:C1216($2)  // Variable dans l'email
	C_OBJECT:C1216($0)  // Statut de l'email
	
	C_OBJECT:C1216($mail_cs;$mail_o)
	
	$mail_cs:=cwToolGetClass("EMail")  // Initialisation de la class
	$mail_o:=$mail_cs.new()  // Instanciation de class
	
Function updateCaMarketingStatisticManual
	C_BOOLEAN:C305($0)
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
	
	$retour_o:=$caPersonneMarketing_o.save()
	
	If ($retour_o.success=True:C214)
		ALERT:C41("Les dernières stats de mailjet on bien été mis à jour dans la fiche de "+This:C1470.nom+" "+This:C1470.prenom)
	Else 
		ALERT:C41("Impossible de mettre à jour la table marketing dans la fiche de "+This:C1470.nom+" "+This:C1470.prenom+" !")
	End if 
	
Function updateCaMarketingStatisticAutomatic
	C_BOOLEAN:C305($0)
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
	
	$retour_o:=$caPersonneMarketing_o.save()
	
	If ($retour_o.success=True:C214)
		$0:=True:C214
	End if 
	
Function updateCaMarketingEventAutomatic
	C_TEXT:C284($1)  // Event qu'on souhaite mettre à jour
	C_LONGINT:C283($2)  // TS de l'event
	C_BOOLEAN:C305($0)
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
	
	$0:=$retour_o.success