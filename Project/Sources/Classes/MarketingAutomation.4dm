/* -----------------------------------------------------------------------------
Class : cs.MarketingAutomation

Class de gestion du marketing automation

-----------------------------------------------------------------------------*/


Class constructor($configChemin_t : Text)
/* -----------------------------------------------------------------------------
Fonction : MarketingAutomation.constructor
	
Initialisation du marketing automation
	
Historique
25/01/21 - Grégory Fromain <gregory@connect-io.fr> - clean code
-----------------------------------------------------------------------------*/
	
	var $chemin_t : Text
	var $fichierConfig_o : cs:C1710.File
	
	Use (Storage:C1525)
		Storage:C1525.automation:=New shared object:C1526()
	End use 
	
	If (Count parameters:C259=0)
		This:C1470.configChemin:=Get 4D folder:C485(Current resources folder:K5:16; *)+"cioMarketingAutomation"+Folder separator:K24:12+"config.json"
	Else 
		This:C1470.configChemin:=$configChemin_t
	End if 
	
	$fichierConfig_o:=File:C1566(This:C1470.configChemin; fk platform path:K87:2)
	
	If ($fichierConfig_o.exists=True:C214)
		Use (Storage:C1525.automation)
			Storage:C1525.automation.config:=OB Copy:C1225(JSON Parse:C1218($fichierConfig_o.getText()); ck shared:K85:29; Storage:C1525.automation)
		End use 
		
	Else 
		ALERT:C41("Impossible d'intialiser le composant caMarketingAutomation")
	End if 
	
	$chemin_t:=Get 4D folder:C485(Current resources folder:K5:16; *)+"cioMarketingAutomation"+Folder separator:K24:12
	
	If (Test path name:C476($chemin_t+"scenario"+Folder separator:K24:12)#Is a folder:K24:2)
		CREATE FOLDER:C475($chemin_t+"scenario"+Folder separator:K24:12)
	End if 
	
	
	
Function createFolder
	C_TEXT:C284($1)  // Chemin du dossier à créer
	C_BOOLEAN:C305($0)
	C_OBJECT:C1216($dossier_o)
	
	$dossier_o:=Folder:C1567($1; fk platform path:K87:2)
	
	If ($dossier_o.exists=False:C215)  // Création du dossier du scénario
		$0:=$dossier_o.create()
	Else 
		$0:=True:C214
	End if 
	
	If ($0=False:C215)
		ALERT:C41("Le dossier dont le chemin est « "+$1+" » n'a pas pu être créer !")
	End if 
	
	
	
Function cronosAction($action_t : Text)
/* -----------------------------------------------------------------------------
Fonction : MarketingAutomation.cronosAction
	
Lancement d'une action dans cronos.
	
Historique
26/01/21 - Grégory Fromain <gregory@connect-io.fr> - clean code
-----------------------------------------------------------------------------*/
	
	Case of 
		: ($action_t="verifTache") | ($action_t="mailjetRecup")
			
			If ($action_t="verifTache")
				This:C1470.cronosMessage:=""
			End if 
			
			This:C1470.cronosVerifTache:=False:C215
			
			DELAY PROCESS:C323(Current process:C322; 100)
		: ($action_t="RAS")
			This:C1470.cronosMessage:=""
			This:C1470.cronosVerifTache:=True:C214
			
			DELAY PROCESS:C323(Current process:C322; 600)
	End case 
	
	
	
Function cronosMessageDisplay
	var $ts_el : Integer
	
	$ts_el:=cwTimestamp(Current date:C33; Current time:C178)
	
	Case of 
		: (This:C1470.cronosMessage="Vérification si une tâche doit être effectuée...")
			This:C1470.cronosAction("verifTache")
		: (This:C1470.cronosMessage="Récupération des données de mailjet en cours...")
			This:C1470.cronosAction("mailjetRecup")
		: (This:C1470.cronosMessage="RAS, prochaine vérification dans 10 secondes.")
			This:C1470.cronosAction("RAS")
		: (This:C1470.cronosMessage="") & ($ts_el>This:C1470.cronosVerifMailjet)
			This:C1470.cronosImage:=This:C1470.image["cronosWork"]
			
			This:C1470.cronosMessage:="Récupération des données de mailjet en cours..."
		: (This:C1470.cronosVerifTache=True:C214)
			This:C1470.cronosImage:=This:C1470.image["cronosWork"]
			
			This:C1470.cronosMessage:="Vérification si une tâche doit être effectuée..."
		Else 
			This:C1470.cronosImage:=This:C1470.image["cronosSleep"]
			
			This:C1470.cronosMessage:="RAS, prochaine vérification dans 10 secondes."
	End case 
	
	
	
Function cronosUpdateCaMarketing
	C_LONGINT:C283($1)  // TS de début
	C_LONGINT:C283($2)  // TS de fin
	C_TEXT:C284(${3})  // Numéro chez mailjet de l'eventMessage à mettre à jour exemple : 3 -> Opened, 4 -> Clicked etc.
	C_LONGINT:C283($i_el)
	C_OBJECT:C1216($mailjet_o; $mailjetDetail_o; $table_o)
	C_COLLECTION:C1488($mailjetDetail_c)
	
	This:C1470.loadPasserelle("Telecom")  // On change de passerelle de recherche
	
	If (This:C1470.cronosMailjetClass#Null:C1517)
		
		For ($i_el; 3; Count parameters:C259)
			
			This:C1470.cronosMailjetClass.getMessageEvent(${$i_el}; $1; $2; ->$mailjet_o)
			
			If ($mailjet_o.errorHttp=Null:C1517)
				This:C1470.cronosMailjetClass.AnalysisMessageEvent($mailjet_o; ${$i_el}; $1; $2; ->$mailjetDetail_c)
			End if 
			
			For each ($mailjetDetail_o; $mailjetDetail_c)
				// On vérifie que l'email trouvé est bien dans la base du client
				$table_o:=This:C1470.loadPeopleByEmail($mailjetDetail_o.email)  // Initialisation de l'entité sélection de la table [Personne] du client
				
				If (Num:C11($table_o.personne.length)#0)
					
					If ($table_o.updateCaMarketingEventAutomatic(${$i_el}; Num:C11($mailjetDetail_o.tsEvent))=False:C215)
						// ToDo Prevenir utilisateur
					End if 
					
				End if 
				
			End for each 
			
		End for 
		
	End if 
	
	
	
Function loadAllPeople
	C_OBJECT:C1216($0)  // Toutes les entités de la table [personne] du client
	
	$0:=cs:C1710.Personne.new(This:C1470)  // Instanciation de la class
	$0.loadAll()
	
	
	
Function loadCronos
	C_LONGINT:C283($process_el)
	
	If (This:C1470.loadImage("cronosSleep.png")=True:C214) & (This:C1470.loadImage("cronosWork.png")=True:C214)
		This:C1470.cronosImage:=This:C1470.image["cronosSleep"]
		This:C1470.cronosMessage:="Démarrage en cours de Cronos"
		This:C1470.cronosStop:=False:C215
		This:C1470.cronosVerifTache:=True:C214
		This:C1470.cronosVerifMailjet:=0
		This:C1470.cronosMailjetClass:=This:C1470.loadMailjetClass()
		
		$process_el:=New process:C317("caCronosDisplay"; 0; "cronos"; This:C1470; *)
	End if 
	
	
	
Function loadCurrentPeople
	C_OBJECT:C1216($0)  // Toutes les entités en cours de la table [personne] du client
	var $formule_o : Object
	
	This:C1470.loadPasserelle("Personne")  // On change de passerelle de recherche
	
	$formule_o:=New object:C1471("loadPeople"; Formula from string:C1601("Create entity selection:C1512(["+This:C1470.passerelle.tableHote+"])"))
	$0:=$formule_o.loadPeople()
	
	
	
Function loadImage()->$return_b : Boolean
	
	var ${1} : Text  // Nom de l'image
	var $i_el : Integer
	var $fichier_o : 4D:C1709.File
	var $blob_b : Blob
	var $image_i : Picture
	
	For ($i_el; 1; Count parameters:C259)
		
		$fichier_o:=File:C1566(Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12+${$i_el}; fk platform path:K87:2)
		
		If ($fichier_o.exists=True:C214)
			$blob_b:=$fichier_o.getContent()
			
			BLOB TO PICTURE:C682($blob_b; $image_i)
			
			If (This:C1470.image=Null:C1517)
				This:C1470.image:=New object:C1471()
			End if 
			
			This:C1470.image[$fichier_o.name]:=$image_i
			
			$return_b:=True:C214
		End if 
	End for 
	
	
	
Function loadMailjetClass
	C_OBJECT:C1216($0)
	C_OBJECT:C1216($mailjet_cs)
	
	$mailjet_cs:=cwToolGetClass("Mailjet")  // Initialisation de la class
	
	$0:=$mailjet_cs.new()  // Instanciation de la class
	
	
	
Function loadNewPeople
	C_OBJECT:C1216($0)  // Entité vide de la table [Personne] du client
	
	$0:=cs:C1710.Personne.new()  // Instanciation de la class
	
	
	
Function loadPasserelle
	C_TEXT:C284($1)  // Personne OU Telecom
	C_OBJECT:C1216($0)
	
	Use (Storage:C1525.automation)
		Storage:C1525.automation.passerelle:=Storage:C1525.automation.config.passerelle.query("tableComposant = :1"; $1)[0]
		Storage:C1525.automation.formule:=New shared object:C1526("getFieldName"; Formula:C1597($1.query("lib = :1"; $2)[0].value))  // $1 contient le nom de la collection dans le fichier config où la recherche doit s'effectuer et $2 doit être la valeur du champ recherché
	End use 
	
	$0:=New object:C1471()
	$0.passerelle:=Storage:C1525.automation.passerelle
	$0.formule:=Storage:C1525.automation.formule
	
	
Function loadPeopleByEmail
	C_TEXT:C284($1)  // Email de la personne
	C_OBJECT:C1216($0)  // Entité de la personne trouvée avec $1
	
	$0:=cs:C1710.Personne.new(This:C1470)  // Instanciation de la class
	
	If ($0.loadByEmail($1)=False:C215)
		ALERT:C41("La personne avec l'email "+$1+" n'a pas été trouvé")
	End if 
	
	
	
Function loadPeopleByUID
	C_TEXT:C284($1)  // UID de la personne
	C_OBJECT:C1216($0)  // Entité de la personne trouvée avec $1
	
	$0:=cs:C1710.Personne.new(This:C1470)  // Instanciation de la class
	
	If ($0.loadByUID($1)=False:C215)
		ALERT:C41("La personne avec l'UID "+$1+" n'a pas été trouvé")
	End if 