//%attributes = {"shared":true,"preemptive":"capable"}
/*------------------------------------------------------------------------------
Méthode : cwFormGetData

La méthode reprend le principe de fonctionnement de la methode cwFormControle mais sans les contrôles.

Historique
07/05/20 - Grégory Fromain <gregory@connect-io.fr> - Création
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
------------------------------------------------------------------------------*/

// Déclarations
var $0 : Object  // etat du formulaire
var $1 : Text  // nom du formulaire

var $T_nomForm; $T_prefixe; $resultat_t : Text
var $formInput_o; $infoForm_o; $dataForm_o; $dataFormTyping_o : Object
var $resultForm_c : Collection

$T_nomForm:=$1

If (Session:C1714.storage.user=Null:C1517)
	$resultat_t:="cwFormGetData ("+$T_nomForm+"): Variable Session.storage.user non indiqué."
	ALERT:C41($resultat_t)
End if 

If ($resultat_t="")
	$resultForm_c:=Storage:C1525.sites[Session:C1714.storage.user.sousDomaine].form.query("lib IS :1"; $T_nomForm)
	
	Case of 
		: ($resultForm_c.length=1)
			$infoForm_o:=$resultForm_c[0]
		: ($resultForm_c.length=0)
			$resultat_t:="Impossible de charger le formulaire "+$T_nomForm+",il n'existe pas."
			ALERT:C41($resultat_t)
		Else 
			$resultat_t:="Impossible de charger le formulaire "+$T_nomForm+", plusieurs formulaire portent le même libellé."
			ALERT:C41($resultat_t)
	End case 
	
End if 

If ($resultat_t="")
	// On supprime les précédentes dataForm
	OB REMOVE:C1226(Session:C1714.storage.user; "dataForm")
	OB REMOVE:C1226(Session:C1714.storage.user; "dataFormTyping")
	
	$dataForm_o:=New object:C1471
	$dataFormTyping_o:=New object:C1471
	
	// On crée un objet pour les nouvelles data du formulaire
	If (Session:C1714.storage.user.dataForm=Null:C1517)
		
		Use (Session:C1714.storage.user)
			Session:C1714.storage.user.dataForm:=OB Copy:C1225($dataForm_o; ck shared:K85:29)
			Session:C1714.storage.user.dataFormTyping:=OB Copy:C1225($dataFormTyping_o; ck shared:K85:29)
		End use 
		
	End if 
	
	$dataForm_o:=OB Copy:C1225(Session:C1714.storage.user.dataForm; ck shared:K85:29)
	$dataFormTyping_o:=OB Copy:C1225(Session:C1714.storage.user.dataFormTyping; ck shared:K85:29)
	
	// On boucle sur chaque input du formulaire HTML, si une des data n'est pas valide, on sort de la boucle.
	For each ($formInput_o; $infoForm_o.input)
		
		// Si la data est valide, on stock la valeur dans dataForm.
		Use ($dataForm_o)
			OB SET:C1220($dataForm_o; $formInput_o.lib; Session:C1714.storage.user[$formInput_o.lib])
		End use 
		
		Use ($dataFormTyping_o)
			
			Case of 
				: ($formInput_o.lib=$infoForm_o.submit)  // Ne rien faire, on ne veut pas récupérer le submit.
				: ($formInput_o.type="checkbox")  // Si la valeur est on, on la transforme en boolean.
					$dataFormTyping_o[$formInput_o.lib]:=Num:C11($dataForm_o[$formInput_o.lib]="on")
				: ($formInput_o.type="number") | (String:C10($formInput_o.format)="int") | (String:C10($formInput_o.format)="real")
					$dataFormTyping_o[$formInput_o.lib]:=Num:C11($dataForm_o[$formInput_o.lib])
				: (String:C10($formInput_o.format)="bool")
					$dataFormTyping_o[$formInput_o.lib]:=Num:C11($dataForm_o[$formInput_o.lib])
				: (String:C10($formInput_o.format)="date")
					$dataFormTyping_o[$formInput_o.lib]:=Date:C102(cwDateClean($dataForm_o[$formInput_o.lib]))
				: ($formInput_o.type="textarea") & (String:C10($formInput_o.class)="@4dStyledText@")  // Dans le cas d'un text multistyle, on modifie les fins de ligne et paragraphe.
					$dataFormTyping_o[$formInput_o.lib]:=cwToolHtmlToText($dataForm_o[$formInput_o.lib])
				Else 
					$dataFormTyping_o[$formInput_o.lib]:=$dataForm_o[$formInput_o.lib]
			End case 
			
		End use 
		
	End for each 
	
	$T_prefixe:=Replace string:C233($infoForm_o.submit; "submit"; "")
	
	// On supprime le prefixe des clés.
	cwToolObjectDeletePrefixKey($dataForm_o; $T_prefixe)
	cwToolObjectDeletePrefixKey($dataFormTyping_o; $T_prefixe)
	
	Use (Session:C1714.storage.user)
		Session:C1714.storage.user.dataForm:=OB Copy:C1225($dataForm_o; ck shared:K85:29)
		Session:C1714.storage.user.dataFormTyping:=OB Copy:C1225($dataFormTyping_o; ck shared:K85:29)
	End use 
	
End if 

// DataFromTyping est renvoyé dans la méthode et dans visiteur... C'est Kdo.
$0:=$dataFormTyping_o