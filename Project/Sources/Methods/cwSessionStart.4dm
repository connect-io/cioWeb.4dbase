//%attributes = {"shared":true}
  // ----------------------------------------------------
  // Méthode : cwSessionStart
  // Description
  // 
  //
  // Paramètres
  // $1 : [objet] option, option du serveur web
  //     Format : "key";Web session cookie name;"value";"CIOSID"
  //
  // $2 : [text] Dossier racine des sessions
  //
  // ----------------------------------------------------

  // Exemple d'activation :
  //$optionsSession_c:=New collection
  //$optionsSession_c.push(New object("key";Web session cookie name;"value";"LYOSID"))

  //cwSessionStart($optionsSession_c;<>T_Racine_Site_Local+Folder separator+"sessionWeb"+Folder separator)

If (False:C215)  // Historique
	  // 30/07/19 - Grégory Fromain <gregory@connect-io.fr> - Création
End if 

If (True:C214)  // Déclarations
	C_COLLECTION:C1488($1;$options_c)
	C_TEXT:C284($2)
	C_OBJECT:C1216($0;<>sessionWeb;$option_o)
	C_LONGINT:C283($valideMinute_l;$refProcess_l)
End if 

$configs_o:=$2
<>sessionWeb:=New object:C1471

  // On applique quelques valeurs par defaut, pour que cela fonctionne même sans param.
$options_c:=New collection:C1472
$options_c.push(New object:C1471("key";Web session cookie name:K73:4;"value";"CIOSID"))  // nom du cookies de la session
$options_c.push(New object:C1471("key";Web inactive session timeout:K73:3;"value";30*24*60))  // 30 jours, en minute
$options_c.push(New object:C1471("key";Web inactive process timeout:K73:13;"value";60))
$options_c.push(New object:C1471("key";Web max sessions:K73:2;"value";200))
$options_c.push(New object:C1471("key";Web Session IP address validation enabled:K73:17;"value";0))
$options_c.push(New object:C1471("key";Web keep session:K73:1;"value";1))

  // Puis l'on vient combiner avec les informations 
If (Count parameters:C259>=1)
	If (Type:C295($1)=Is collection:K8:32)
		
		$options_c:=$options_c.query("NOT (key IN :1)";$1.extract("key"))
		$options_c.combine($1)
	End if 
End if 

  // Pour les options il suffit de faire une boucle
For each ($option_o;$options_c)
	WEB SET OPTION:C1210($option_o.key;$option_o.value)
End for each 


  //Dossier de gestion des sessions
Case of 
	: (Count parameters:C259#2)
		<>sessionWeb.folder:=Get 4D folder:C485(Data folder:K5:33;*)+"sessionWeb"+Folder separator:K24:12
		
	: (String:C10($2)="")
		<>sessionWeb.folder:=Get 4D folder:C485(Data folder:K5:33;*)+"sessionWeb"+Folder separator:K24:12
		
	Else 
		<>sessionWeb.folder:=String:C10($2)
End case 


If (Test path name:C476(<>sessionWeb.folder)#Is a folder:K24:2)
	CREATE FOLDER:C475(<>sessionWeb.folder;*)
	If (ok=0)
		ALERT:C41("Impossible de créer le dossier des sessions Web : "+<>sessionWeb.folder)
		<>sessionWeb.folder:=Get 4D folder:C485(Database folder:K5:14;*)
	End if 
End if 


  // On va conserver des informations importantes a porté de main...
<>sessionWeb.name:=$options_c.query("key IS :1";Web session cookie name:K73:4)[0].value

$valideMinute_l:=$options_c.query("key IS :1";Web inactive session timeout:K73:3)[0].value
<>sessionWeb.valideDay:=Int:C8($valideMinute_l/60/24)

  // On en profite pour nettoyer les sessions périmées dans un nouveau process...
$refProcess_l:=New process:C317("cwSessionClean";1024*1000;"Nettoyage session")

  // Et on retourne les infos pour l'application
$0:=<>sessionWeb