//%attributes = {"shared":true,"preemptive":"capable"}
/*------------------------------------------------------------------------------
Méthode : cwFormControl

Permet de controler les informations d'un formulaire saisie par l'internaute

Historique
07/10/15 - Grégory Fromain <gregory@connect-io.fr> - Création
26/10/19 - Grégory Fromain <gregory@connect-io.fr> - Normalisation de la méthode.
21/12/19 - Grégory Fromain <gregory@connect-io.fr> - On utilise les formulaires depuis une collection au lieux d'un objet.
18/03/20 - Grégory Fromain <gregory@connect-io.fr> - Ajout de précision en cas d'inpossibilité de charger un formulaire.
18/03/20 - Grégory Fromain <gregory@connect-io.fr> - Les inputs sont traités depuis une collection au lieu d'un objet.
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
------------------------------------------------------------------------------*/

// Déclarations
var $0 : Text  // Etat du formulaire
var $1 : Text  // Nom du formulaire

var $T_nomForm; $T_prefixe; $resultat_t; $inputValide_t; $key_t : Text
var $infoForm_o; $formInput_o; $dataForm_o; $dataFormTyping_o : Object
var $resultForm_c; $key_c; $splitKey_c : Collection

$T_nomForm:=$1

If (Session:C1714.storage.user=Null:C1517)
	$resultat_t:="cwFormControl ("+$T_nomForm+"): Variable Session.storage.user non indiqué."
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
			$resultat_t:="Impossible de charger le formulaire "+$T_nomForm+", plusieurs formulaires portent le même libellé."
			ALERT:C41($resultat_t)
	End case 
End if 

If ($resultat_t="")
	
	If (Not:C34(OB Is defined:C1231(Session:C1714.storage.user; String:C10($infoForm_o.submit))))
		$resultat_t:="non soumis"
	End if 
	
End if 

If ($resultat_t="")
	// Il y a bien un formulaire de soumis, on supprime la validation de celui-ci.
	OB REMOVE:C1226(Session:C1714.storage.user; $infoForm_o.submit)
	
	// On supprime les précédentes dataForm
	If (Session:C1714.storage.user.dataForm#Null:C1517)
		OB REMOVE:C1226(Session:C1714.storage.user; "dataForm")
		OB REMOVE:C1226(Session:C1714.storage.user; "dataFormTyping")
	End if 
	
	// On vérifie que la méthod HTTP soit conforme.
	Case of 
		: (String:C10($infoForm_o.method)="")  // Il n'y a pas de méthode préconisé, donc on avance.
		: ($infoForm_o.method=String:C10(Session:C1714.storage.user["X-METHOD"]))  // La methode http du visiteur est identique à celle attendu par le formulaire.
		Else 
			$resultat_t:="La méthode http du visiteur (Session.storage.user) n'est pas identique à celle attendu par le formulaire."
	End case 
	
End if 

If ($resultat_t="")
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
	For each ($formInput_o; $infoForm_o.input) Until ($inputValide_t#"ok")
		// On vérfie que la data de l'input soit valide.
		$inputValide_t:=cwInputValidation($T_nomForm; $formInput_o.lib)
		
		If ($inputValide_t="ok")
			
			// Si la data est valide, on stock la valeur dans dataForm.
			Use ($dataForm_o)
				OB SET:C1220($dataForm_o; $formInput_o.lib; Session:C1714.storage.user[$formInput_o.lib])
			End use 
			
			Use ($dataFormTyping_o)
				
				Case of 
					: (String:C10($formInput_o.format)="bool") & ($formInput_o.type="checkbox")  // Si la valeur est on, on la transforme en bool.
						$dataFormTyping_o[$formInput_o.lib]:=$dataForm_o[$formInput_o.lib]="on"
					: (String:C10($formInput_o.format)="bool")
						$dataFormTyping_o[$formInput_o.lib]:=Bool:C1537(Num:C11($dataForm_o[$formInput_o.lib]))
					: ($formInput_o.type="checkbox")  // Si la valeur est on, on la transforme en numérique.
						$dataFormTyping_o[$formInput_o.lib]:=Num:C11($dataForm_o[$formInput_o.lib]="on")
					: ($formInput_o.type="number") | (String:C10($formInput_o.format)="int") | (String:C10($formInput_o.format)="real")
						$dataFormTyping_o[$formInput_o.lib]:=Num:C11($dataForm_o[$formInput_o.lib])
					: (String:C10($formInput_o.format)="date")
						$dataFormTyping_o[$formInput_o.lib]:=Date:C102(cwDateClean($dataForm_o[$formInput_o.lib]))
					: ($formInput_o.type="textarea") & (String:C10($formInput_o.class)="@4dStyledText@")  // Dans le cas d'un text multistyle, on modifie les fins de ligne et paragraphe.
						$dataFormTyping_o[$formInput_o.lib]:=cwToolHtmlToText($dataForm_o[$formInput_o.lib])
						
						// On supprime completement la balise </p> si elle est a la fin du text.
						If ($dataFormTyping_o[$formInput_o.lib]="@</p>")
							$dataFormTyping_o[$formInput_o.lib]:=Substring:C12($dataFormTyping_o[$formInput_o.lib]; 1; Length:C16($dataFormTyping_o[$formInput_o.lib])-4)
						End if 
						
						// Dans les autres cas on remplace </p> par 2 fins de ligne.
						$dataFormTyping_o[$formInput_o.lib]:=Replace string:C233($dataFormTyping_o[$formInput_o.lib]; "</p>"; "\r\r")
					Else 
						$dataFormTyping_o[$formInput_o.lib]:=$dataForm_o[$formInput_o.lib]
				End case 
				
			End use 
			
		End if 
		
	End for each 
	
	Use (Session:C1714.storage.user)
		Session:C1714.storage.user.dataForm:=OB Copy:C1225($dataForm_o; ck shared:K85:29)
		Session:C1714.storage.user.dataFormTyping:=OB Copy:C1225($dataFormTyping_o; ck shared:K85:29)
	End use 
	
	// On retourne l'etat de la vérification du dernier input controlé.
	$resultat_t:=$inputValide_t
End if 

If ($inputValide_t="ok")
	$T_prefixe:=Replace string:C233($infoForm_o.submit; "submit"; "")
	
	// On supprime le prefixe des clés.
	cwToolObjectDeletePrefixKey(Session:C1714.storage.user.dataForm; $T_prefixe)
	cwToolObjectDeletePrefixKey(Session:C1714.storage.user.dataFormTyping; $T_prefixe)
End if 

// Décomposition des propriété objet . ex :  {"toto.tata":"titi"} -> {"toto":{"tata":"titi"}}
If ($resultat_t#"non soumis")
	cwToolObjectSplitStringKey(Session:C1714.storage.user.dataFormTyping)
End if 

// Notification du message d'erreur au visiteur.
If (Not:C34($inputValide_t="ok")) & (Not:C34($resultat_t="non soumis"))
	
	Use (Session:C1714.storage.user)
		Session:C1714.storage.user.notificationError:=$resultat_t
	End use 
	
End if 

$0:=$resultat_t