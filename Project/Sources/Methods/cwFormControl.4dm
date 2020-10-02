//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : cwFormControl

Permet de controler les informations d'un formulaire saisie par l'internaute

Historique
07/10/15 - Grégory Fromain <gregory@connect-io.fr> - Création
26/10/19 - Grégory Fromain <gregory@connect-io.fr> - Normalisation de la méthode.
21/12/19 - Grégory Fromain <gregory@connect-io.fr> - On utilise les formulaires depuis une collection au lieux d'un objet.
18/03/20 - Grégory Fromain <gregory@connect-io.fr> - Ajout de précision en cas d'inpossibilité de charger un formulaire.
18/03/20 - Grégory Fromain <gregory@connect-io.fr> - Les inputs sont traités depuis une collection au lieu d'un objet.
----------------------------------------------------------------------------- */

If (True:C214)  // Déclarations
	C_POINTER:C301($1)  // visiteur
	C_TEXT:C284($2)  // nom du formulaire
	C_TEXT:C284($0)  // etat du formulaire
	
	C_TEXT:C284($T_nomForm;$T_prefixe;$resultat_t;$inputValide_t)
	C_OBJECT:C1216($infoForm_o;$formInput_o)
	C_COLLECTION:C1488($resultForm_c)
End if 

visiteur:=$1->
$T_nomForm:=$2
$resultat_t:=""
$inputValide_t:=""

If (visiteur=Null:C1517)
	$resultat_t:="cwFormControl ("+$T_nomForm+"): Variable visiteur non indiqué."
	ALERT:C41($resultat_t)
End if 

If ($resultat_t="")
	
	$resultForm_c:=siteForm_c.query("lib IS :1";$T_nomForm)
	
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
	If (Not:C34(OB Is defined:C1231(visiteur;String:C10($infoForm_o.submit))))
		$resultat_t:="non soumis"
	End if 
End if 

If ($resultat_t="")
	  // Il y a bien un formulaire de soumis.
	  // On supprime la validation de celui-ci.
	OB REMOVE:C1226(visiteur;$infoForm_o.submit)
	
	  //On supprime les précédentes dataForm
	If (visiteur.dataForm#Null:C1517)
		OB REMOVE:C1226(visiteur;"dataForm")
		OB REMOVE:C1226(visiteur;"dataFormTyping")
	End if 
	
	
	  // On vérifie que la méthod HTTP soit conforme.
	If (String:C10($infoForm_o.method)="")
		  // Il n'y a pas de méthode préconisé, donc on avance.
	Else 
		If ($infoForm_o.method=String:C10(visiteur["X-METHOD"]))
			  // La methode http du visiteur est identique à celle attendu par le formulaire.
		Else 
			$resultat_t:="La méthode http du visiteur n'est pas identique à celle attendu par le formulaire."
		End if 
	End if 
End if 

If ($resultat_t="")
	
	  // On crée un objet pour les nouvelles data du formulaire
	If (visiteur.dataForm=Null:C1517)
		visiteur.dataForm:=New object:C1471
		visiteur.dataFormTyping:=New object:C1471
	End if 
	
	  // On boucle sur chaque input du formulaire HTML, si une des data n'est pas valide, on sort de la boucle.
	For each ($formInput_o;$infoForm_o.input) Until ($inputValide_t#"ok")
		
		  // On vérfie que la data de l'input soit valide.
		$inputValide_t:=cwInputValidation ($T_nomForm;$formInput_o.lib)
		If ($inputValide_t="ok")
			
			  // Si la data est valide, on stock la valeur dans dataForm.
			OB SET:C1220(visiteur.dataForm;$formInput_o.lib;visiteur[$formInput_o.lib])
			
			Case of 
				: ($formInput_o.type="checkbox")
					  // Si la valeur est on, on la transforme en boolean.
					visiteur.dataFormTyping[$formInput_o.lib]:=Num:C11(visiteur.dataForm[$formInput_o.lib]="on")
					
				: ($formInput_o.type="number") | (String:C10($formInput_o.format)="int") | (String:C10($formInput_o.format)="real")
					visiteur.dataFormTyping[$formInput_o.lib]:=Num:C11(visiteur.dataForm[$formInput_o.lib])
					
				: (String:C10($formInput_o.format)="bool")
					  // visiteur.dataFormTyping[$formInput_o.lib]:=Num(visiteur.dataForm[$formInput_o.lib])
					visiteur.dataFormTyping[$formInput_o.lib]:=Bool:C1537(Num:C11(visiteur.dataForm[$formInput_o.lib]))
					
				: (String:C10($formInput_o.format)="date")
					visiteur.dataFormTyping[$formInput_o.lib]:=Date:C102(cwDateClean (visiteur.dataForm[$formInput_o.lib]))
					
				: ($formInput_o.type="textarea") & (String:C10($formInput_o.class)="@4dStyledText@")
					  // Dans le cas d'un text multistyle, on modifie les fins de ligne et paragraphe.
					visiteur.dataFormTyping[$formInput_o.lib]:=Replace string:C233(visiteur.dataForm[$formInput_o.lib];"<br>";"\r")
					visiteur.dataFormTyping[$formInput_o.lib]:=Replace string:C233(visiteur.dataFormTyping[$formInput_o.lib];"<br />";"\r")
					visiteur.dataFormTyping[$formInput_o.lib]:=Replace string:C233(visiteur.dataFormTyping[$formInput_o.lib];"<p>";"")
					
					  // On supprime completement la balise </p> si elle est a la fin du text.
					If (visiteur.dataFormTyping[$formInput_o.lib]="@</p>")
						visiteur.dataFormTyping[$formInput_o.lib]:=Substring:C12(visiteur.dataFormTyping[$formInput_o.lib];1;Length:C16(visiteur.dataFormTyping[$formInput_o.lib])-4)
					End if 
					
					  // Dans les autres cas on remplace </p> par 2 fins de ligne.
					visiteur.dataFormTyping[$formInput_o.lib]:=Replace string:C233(visiteur.dataFormTyping[$formInput_o.lib];"</p>";"\r\r")
					
				Else 
					visiteur.dataFormTyping[$formInput_o.lib]:=visiteur.dataForm[$formInput_o.lib]
			End case 
		End if 
		
	End for each 
	
	  // On retourne l'etat de la vérification du dernier input controlé.
	$resultat_t:=$inputValide_t
	
End if 


If ($inputValide_t="ok")
	$T_prefixe:=Replace string:C233($infoForm_o.submit;"submit";"")
	  // On supprime le prefixe des clés.
	cwToolDeletePrefixKey (visiteur.dataForm;$T_prefixe)
	cwToolDeletePrefixKey (visiteur.dataFormTyping;$T_prefixe)
End if 

  // Notification du message d'erreur au visiteur.
If (Not:C34($inputValide_t="ok")) & (Not:C34($resultat_t="non soumis"))
	visiteur.notificationError:=$resultat_t
End if 



$0:=$resultat_t
$1->:=visiteur