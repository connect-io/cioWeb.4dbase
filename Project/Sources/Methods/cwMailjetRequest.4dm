//%attributes = {"lang":"en"}
// ======================================================================
// Methode projet : mailjetRequest
//
// Méthode qui permet de traiter toutes les requêtes mailjet
//
// ----------------------------------------------------------------------

If (False:C215)  // Historique
	// 02/07/20 remy@connect-io.fr - Création
End if 

If (True:C214)  // Déclarations
	var $1 : Integer  // [timestamp] "avant" ou "depuis"
	var $2 : Integer  // [timestamp] "jusqu'à"
	var $3 : Text  // [texte] type recherche : "0" (Processed) "1" (Queued) "2" (Sent) "3" (Opened) "4" (Clicked) "5" (Bounce) "6" (Spam) "7" (Unsub) "8" (Blocked) "9" (SoftBounce) "10" (HardBounce) "11" (Deferred)
	
	var $tsFrom_t; $tsTo_t; $libelleRecherche_t; $resultatHttp_t; $email_t; $demonteChaine_t; $chaineObjet_t : Text
	var $countMessage_el; $nbBoucle_el; $i_el; $offset_el; $j_el; $contactID_el; $positionCrochet_el; $positionAccolade_el; $positionID_el; $positionVirgule_el; $tsEventAt_el : Integer
	var $marketingAutomation_cs; $marketingAutomation_o; $mailjet_cs; $mailjet_o; $nbResultat_o; $mailStatut_o; $statut_o; $entitySelection_o; $table_o; $message_o; $messageDetail_o : Object
	
	ARRAY TEXT:C222($messageID_at; 0)
	
	ARRAY OBJECT:C1221($dataStat_ao; 0)
	ARRAY OBJECT:C1221($dataMessage_ao; 0)
End if 

// Class Mailjet
$mailjet_cs:=cwToolGetClass("Mailjet")  // Initialisation de la class

$mailjet_o:=$mailjet_cs.new()  // Instanciation de la class

// Class MarketingAutomation + Initialisation à vide de l'objet $entitySelection_o
//$marketingAutomation_cs:=cwToolGetClass ("MarketingAutomation")  // Initialisation de la class

$marketingAutomation_o:=$marketingAutomation_cs.new()  // Instanciation de la class
$marketingAutomation_o.loadPasserelle("Personne")  // Création de la passerelle entre la class $marketingAutomation_o et la base hôte

$entitySelection_o:=$marketingAutomation_o.loadNewPeople()  // Initialisation de l'entité sélection de la table [Personne] du client

$tsFrom_t:="&FromTS="+String:C10($1)
$tsTo_t:="&ToTS="+String:C10($2)

$libelleRecherche_t:=$mailjet_o.getLabelSearch($3)

// Je demande dans un premier temps le nombre total de mails que j'ai eu pendant la période recherchée
cwToolWebHttpRequest("GET"; $mailjet_o.config.domainRequest+"/REST/message?MessageStatus="+$3+"&countOnly=1"+$tsFrom_t+$tsTo_t; ""; ->$resultatHttp_t)

If ($resultatHttp_t#"Error HTTP@")
	$nbResultat_o:=JSON Parse:C1218($resultatHttp)
	
	If (OB Is defined:C1231($nbResultat_o; "Count")=True:C214)
		$countMessage_el:=Num:C11(OB Get:C1224($nbResultat_o; "Count"))
		
		$nbBoucle_el:=Int:C8($countMessage_el/1000)+1
		
		For ($i_el; 1; $nbBoucle_el)
			
			If ($i_el>1)  // Il y a plus de 1000 résultats
				$offset_el:=(1000*$i_el)+1
			Else 
				$offset_el:=0
			End if 
			
			// Je demande dans un second temps les 1000 premiers mails de mon laps de temps recherché (entre $1 et $2) -> un jour à la fois normalement
			cwToolWebHttpRequest("GET"; $mailjet_o.config.domainRequest+"/REST/message?MessageStatus="+$3+"&limit=1000"+$tsFrom_t+$tsTo_t+"&offset="+String:C10($offset_el)+"&ShowContactAlt=true"; ""; ->$resultatHttp_t)
			
			If ($resultatHttp_t#"Error HTTP@")
				
				If ($3="5") | ($3="9") | ($3="10")  // Si c'est un bounce (soft ou hard bounce)
					// Petite galère qui fait bien chier, je vais devoir passer en revu ma chaine $resultatHTTP car l'ID du message est supérieur à la valeur autorisée par la commande JSON PARSE ±10.421e±10...
					$demonteChaine_t:=$resultatHttp
					
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
											$message_id:=Substring:C12($chaineObjet_t; 1; $positionVirgule_el-1)
											
											// Enfin on est arrivé au bout !
											APPEND TO ARRAY:C911($messageID_at; $message_id)
										End if 
										
									End if 
									
									$demonteChaine_t:=Delete string:C232($demonteChaine_t; 1; $positionAccolade_el+1)
									$positionAccolade_el:=Position:C15("}"; $demonteChaine_t)
								End while 
								
							End if 
							
						End if 
						
					End if 
					
				End if 
				
				$mailStatut_o:=JSON Parse:C1218($resultatHttp_t)
				
				OB GET ARRAY:C1229($mailStatut_o; "Data"; $dataStat_ao)
				
				If (Size of array:C274($dataStat_ao)>0)
					
					For ($j_el; 1; Size of array:C274($dataStat_ao))
						$statut_o:=$dataStat_ao{$j_el}
						
						$email_t:=$statut_o.ContactAlt
						
						// On vérifie que l'email trouvé est bien dans la base du client
						$table_o:=$marketingAutomation_o.loadPeopleByEmail($email_t)  // Initialisation de l'entité sélection de la table [Personne] du client
						
						If (String:C10($table_o.ID)#"")
							$entitySelection_o:=$entitySelection_o.add($table_o.personne.getSelection())
							
							$contactID_el:=Num:C11($statut_o.ContactID)
							
							// CREATION FICHIER BOUNCE
							If ($3="5") | ($3="9") | ($3="10")  // Si c'est un bounce (soft ou hard bounce)
								
								Case of 
									: ($3="9")  // SoftBounce
										
									: ($3="10") | ($3="5")  // HardBounce
										
								End case 
								
								// Modifié par : Scanu Rémy (10/10/2018)
								// Que ce soit un soft ou un hard bounce, on va stocker la raison du pourquoi il se retrouve en bounce dans la commentaire de la fiche
								If ($j_el<=Size of array:C274($messageID_at))
									
									// Je vais demander le détail du pourquoi le mail en question se retrouve en bounce
									cwToolWebHttpRequest("GET"; $mailjet_o.config.domainRequest+"/REST/messagehistory/"+$messageID_at{$j_el}; ""; ->$resultatHttp_t)
									
									If ($resultatHttp_t#"Error HTTP@")
										$message_o:=JSON Parse:C1218($resultatHttp)
										
										OB GET ARRAY:C1229($message_o; "Data"; $dataMessage_ao)
										
										For ($l; 1; Size of array:C274($dataMessage_ao))
											$messageDetail_o:=$dataMessage_ao{$l}
											
											If ($messageDetail_o.Comment#"")
												$tsEventAt_el:=$messageDetail_o.EventAt
											End if 
											
										End for 
										
									End if 
									
								End if 
								
							End if 
							
						End if 
						
					End for 
					
				End if 
				
			Else 
				ALERT:C41("La requête api Mailjet des statuts des emails "+$libelleRecherche_t+" n'a pas abouti, erreur HTTP n° : "+String:C10(Num:C11($resultatHttp_t))+", vérifiez votre connexion internet")
			End if 
			
		End for 
		
	End if 
	
Else 
	ALERT:C41("La requête api Mailjet de récupération du nombre de nombre de mails "+$libelleRecherche_t+" n'a pas abouti, erreur HTTP n° : "+String:C10(Num:C11($resultatHttp_t))+", vérifiez votre connexion internet")
End if 