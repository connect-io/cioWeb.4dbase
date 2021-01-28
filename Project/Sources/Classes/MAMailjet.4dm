Class constructor
	C_TEXT:C284($1)
	C_OBJECT:C1216($fichierConfig_o)
	
	If (Count parameters:C259=0)
		This:C1470.configChemin:=Get 4D folder:C485(Dossier Resources courant:K5:16; *)+"cioMailjet"+Séparateur dossier:K24:12+"config.json"
	Else 
		This:C1470.configChemin:=$1
	End if 
	
	$fichierConfig_o:=File:C1566(This:C1470.configChemin; fk chemin plateforme:K87:2)
	
	If ($fichierConfig_o.exists=True:C214)
		This:C1470.config:=JSON Parse:C1218($fichierConfig_o.getText())
		
		This:C1470.config.domainRequest:="https://"+This:C1470.config.smtpKeyPublic+":"+This:C1470.config.smtpKeySecret+"@api.mailjet.com/"+This:C1470.config.smtpVersion
	Else 
		ALERT:C41("Impossible d'intialiser le composant cioMailjet")
	End if 
	
Function getLabelSearch
	C_TEXT:C284($1)  // Numéro du label qu'on souhaite
	C_COLLECTION:C1488($typeSearch_c)
	
	$typeSearch_c:=This:C1470.config.typeSearch.query("number = :1"; $1)
	
	If ($typeSearch_c.length=1)
		This:C1470.numberTypeSearch:=$typeSearch_c[0].number
		This:C1470.labelTypeSearch:=$typeSearch_c[0].label
	Else 
		This:C1470.numberTypeSearch:=""
		This:C1470.labelTypeSearch:=""
	End if 
	
Function getHistoryRequestFile
	C_TEXT:C284($cheminFichier_t)
	C_OBJECT:C1216($fichier_o; $config_o)
	
	$config_o:=New object:C1471()
	
	$cheminFichier_t:=Get 4D folder:C485(Dossier Resources courant:K5:16; *)+"cioMailjet"+Séparateur dossier:K24:12+"historyRequest.json"
	
	$fichier_o:=File:C1566($cheminFichier_t; fk chemin plateforme:K87:2)
	
	If ($fichier_o.exists=False:C215)
		
		If ($fichier_o.create()=True:C214)
			$config_o.lastRequest:=cwTimestamp(Current date:C33; Current time:C178)-604800  // Par défaut on met que la dernière requête a eu lieu il y a 7 jours
			
			$fichier_o.setText(JSON Stringify:C1217($config_o; *); 2)
		End if 
		
	End if 
	
	This:C1470.historyRequest:=$fichier_o
	
Function getHistoryRequestContent
	
	If (This:C1470.historyRequest#Null:C1517)
		This:C1470.historyRequestContent:=JSON Parse:C1218(This:C1470.historyRequest.getText())
	End if 
	
Function setHistoryRequestContent
	C_TEXT:C284($1)
	
	If (This:C1470.historyRequest#Null:C1517)
		This:C1470.historyRequest.setText($1; "UTF-8")
	End if 
	
Function getStatistic
	C_TEXT:C284($1)  // Email OU Contact ID de la personne dont on souhaite avoir les stats
	C_OBJECT:C1216($0)  // Retour de mailjet
	C_TEXT:C284($resultatHttp_t)
	
	cwToolWebHttpRequest("GET"; This:C1470.config.domainRequest+"/REST/contactstatistics/"+String:C10($1); ""; ->$resultatHttp_t)
	
	If ($resultatHttp_t="{@}")
		$0:=JSON Parse:C1218($resultatHttp_t)
	Else 
		$0:=New object:C1471("errorHttp"; $resultatHttp_t)
	End if 
	
Function getMessageEvent
	C_TEXT:C284($1)  // Statut des emails qu'on souhaite avoir
	C_LONGINT:C283($2)  // TS début
	C_LONGINT:C283($3)  // TS fin
	C_POINTER:C301($4)  // Retour de mailjet
	C_TEXT:C284($resultatHttp_t; $tsFrom_t; $tsTo_t)
	
	$tsFrom_t:="&FromTS="+String:C10($2)
	$tsTo_t:="&ToTS="+String:C10($3)
	
	cwToolWebHttpRequest("GET"; This:C1470.config.domainRequest+"/REST/message?MessageStatus="+$1+"&countOnly=1"+$tsFrom_t+$tsTo_t; ""; ->$resultatHttp_t)
	
	If ($resultatHttp_t="{@}")
		$4->:=JSON Parse:C1218($resultatHttp_t)
	Else 
		$4->:=New object:C1471("errorHttp"; $resultatHttp_t)
	End if 
	
Function AnalysisMessageEvent
	C_OBJECT:C1216($1)  // Réponse mailjet de la function getMessageEvent
	C_TEXT:C284($2)  // Statut des emails qu'on souhaite avoir
	C_LONGINT:C283($3)  // TS début
	C_LONGINT:C283($4)  // TS fin
	C_POINTER:C301($5)  // Collection à retourner qui contient mail et idContact
	
	C_TEXT:C284($resultatHttp_t; $tsFrom_t; $tsTo_t; $email_t; $arrivedAt_t)
	C_LONGINT:C283($countMessage_el; $nbBoucle_el; $i_el; $j_el; $offset_el; $tsEvent_el)
	C_DATE:C307($dateArrivedAt_d)
	C_TIME:C306($heureArrivedAt_h)
	C_OBJECT:C1216($mailStatut_o; $statut_o; $contactDetail_o)
	
	ARRAY TEXT:C222($email_at; 0)
	ARRAY OBJECT:C1221($dataStat_ao; 0)
	
	$5->:=New collection:C1472()
	
	$tsFrom_t:="&FromTS="+String:C10($3)
	$tsTo_t:="&ToTS="+String:C10($4)
	
	If ($1.Count#Null:C1517)
		$countMessage_el:=Num:C11($1.Count)
		
		$nbBoucle_el:=Int:C8($countMessage_el/1000)+1
		
		For ($i_el; 1; $nbBoucle_el)
			
			If ($i_el>1)  // Il y a plus de 1000 résultats
				$offset_el:=(1000*$i_el)+1
			Else 
				$offset_el:=0
			End if 
			
			// Je demande dans un second temps les 1000 premiers mails de mon laps de temps recherché (entre $1 et $2) -> un jour à la fois normalement
			cwToolWebHttpRequest("GET"; This:C1470.config.domainRequest+"/REST/message?MessageStatus="+$2+"&limit=1000"+$tsFrom_t+$tsTo_t+"&offset="+String:C10($offset_el)+"&ShowContactAlt=true&sort=ArrivedAt+desc"; ""; ->$resultatHttp_t)
			
			$mailStatut_o:=JSON Parse:C1218($resultatHttp_t)
			
			OB GET ARRAY:C1229($mailStatut_o; "Data"; $dataStat_ao)
			
			If (Size of array:C274($dataStat_ao)>0)
				
				For ($j_el; 1; Size of array:C274($dataStat_ao))
					$statut_o:=$dataStat_ao{$j_el}
					
					$contactID_el:=Num:C11($statut_o.ContactID)  // Contact ID chez mailjet du contact
					$email_t:=$statut_o.ContactAlt  // Email du contact
					
					If (Find in array:C230($email_at; $email_t)=-1)  // Si le contact n'a pas déjà été traité on ne recherche que le statut du mail le plus récent, inutile de boucler sur les plus anciens
						APPEND TO ARRAY:C911($email_at; $email_t)
						
						$arrivedAt_t:=$statut_o.ArrivedAt
						
						$dateArrivedAt_d:=Date:C102($arrivedAt_t)
						$heureArrivedAt_h:=Time:C179($arrivedAt_t)
						
						$tsEvent_el:=cwTimestamp($dateArrivedAt_d; $heureArrivedAt_h)
						
						$5->push(New object:C1471("email"; $email_t; "idContact"; $contactID_el; "tsEvent"; $tsEvent_el))
					End if 
					
				End for 
				
			End if 
			
		End for 
		
	End if 
	
Function getMessageID
	C_TEXT:C284($1)  // Chaine à analyser
	C_POINTER:C301($2)  // Pointeur tabeau texte qui contient les id des messages
	C_TEXT:C284($demonteChaine_t; $chaineObjet_t; $messageID_t)
	C_LONGINT:C283($positionCrochet_el; $positionAccolade_el; $positionID_el; $positionVirgule_el)
	
	// Petite galère qui fait bien chier, je vais devoir passer en revu ma chaine $resultatHTTP car l'ID du message est supérieur à la valeur autorisée par la commande JSON PARSE ±10.421e±10...
	$demonteChaine_t:=$1
	
	$positionCrochet_el:=Position:C15("["; $demonteChaine_t)
	If ($positionCrochet_el>0)
		$demonteChaine_t:=Delete string:C232($demonteChaine_t; 1; $positionCrochet_el+1)
		
		$positionCrochet_el:=Position:C15("]"; $demonteChaine_t)
		If ($positionCrochet_el>0)
			$demonteChaine_t:=Substring:C12($demonteChaine_t; 1; $positionCrochet_el-1)
			
			// On devrait se retrouver avec une chaine comme ça : {...},{...},{...}
			$positionAccolade_el:=Position:C15("}"; $demonteChaine_t)
			If ($positionAccolade_el>0)
				
				While ($positionAccolade_el>0)
					$chaineObjet_t:=Substring:C12($demonteChaine_t; 1; $positionAccolade_el)
					
					// $chaineObjet_t devrait ressembler à une chaine comme ça : {...}
					$positionID_el:=Position:C15("\"ID\" :"; $chaineObjet_t)
					If ($positionID_el>0)
						$chaineObjet_t:=Substring:C12($chaineObjet_t; $positionID_el+7)
						
						$positionVirgule_el:=Position:C15(","; $chaineObjet_t)
						If ($positionVirgule_el>0)
							$messageID_t:=Substring:C12($chaineObjet_t; 1; $positionVirgule_el-1)
							
							// Enfin on est arrivé au bout !
							APPEND TO ARRAY:C911($2->; $messageID_t)
						End if 
						
					End if 
					
					$demonteChaine_t:=Delete string:C232($demonteChaine_t; 1; $positionAccolade_el+1)
					$positionAccolade_el:=Position:C15("}"; $demonteChaine_t)
				End while 
				
			End if 
			
		End if 
		
	End if 