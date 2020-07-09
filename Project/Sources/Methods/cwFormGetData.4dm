//%attributes = {"shared":true}
/* ----------------------------------------------------
Méthode : cwFormGetData

La méthode reprend le principe de fonctionnement de la methode cwFormControle mais sans les contrôles.

Historique
07/05/20 - Grégory Fromain <gregory@connect-io.fr> - Création
----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_POINTER:C301($1)  // visiteur
	C_TEXT:C284($2)  // nom du formulaire
	C_OBJECT:C1216($0)  // etat du formulaire
	
	C_TEXT:C284($T_nomForm;$T_prefixe;$resultat_t)
	C_OBJECT:C1216($infoForm_o;$formInput_o)
	C_COLLECTION:C1488($resultForm_c)
End if 

visiteur:=$1->
$T_nomForm:=$2
$resultat_t:=""

If (visiteur=Null:C1517)
	$resultat_t:="cwFormGetData ("+$T_nomForm+"): Variable visiteur non indiqué."
	ALERT:C41($resultat_t)
End if 

If ($resultat_t="")
	$resultForm_c:=<>webApp_o.sites[visiteur.sousDomaine].form.query("lib IS :1";$T_nomForm)
	
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
	  //On supprime les précédentes dataForm
	If (visiteur.dataForm#Null:C1517)
		OB REMOVE:C1226(visiteur;"dataForm")
		OB REMOVE:C1226(visiteur;"dataFormTyping")
	End if 
	
End if 

If ($resultat_t="")
	
	  // On crée un objet pour les nouvelles data du formulaire
	If (visiteur.dataForm=Null:C1517)
		visiteur.dataForm:=New object:C1471
		visiteur.dataFormTyping:=New object:C1471
	End if 
	
	  // On boucle sur chaque input du formulaire HTML, si une des data n'est pas valide, on sort de la boucle.
	For each ($formInput_o;$infoForm_o.input)
		
		  // Si la data est valide, on stock la valeur dans dataForm.
		OB SET:C1220(visiteur.dataForm;$formInput_o.lib;visiteur[$formInput_o.lib])
		
		Case of 
			: ($formInput_o.lib=$infoForm_o.submit)
				  // Ne rien faire, on ne veut pas récupérer le submit.
				
			: ($formInput_o.type="checkbox")
				  // Si la valeur est on, on la transforme en boolean.
				visiteur.dataFormTyping[$formInput_o.lib]:=Num:C11(visiteur.dataForm[$formInput_o.lib]="on")
				
			: ($formInput_o.type="number") | (String:C10($formInput_o.format)="int") | (String:C10($formInput_o.format)="real")
				visiteur.dataFormTyping[$formInput_o.lib]:=Num:C11(visiteur.dataForm[$formInput_o.lib])
				
			: (String:C10($formInput_o.format)="bool")
				visiteur.dataFormTyping[$formInput_o.lib]:=Num:C11(visiteur.dataForm[$formInput_o.lib])
				
			: (String:C10($formInput_o.format)="date")
				visiteur.dataFormTyping[$formInput_o.lib]:=cwDateClean (visiteur.dataForm[$formInput_o.lib])
				
			Else 
				visiteur.dataFormTyping[$formInput_o.lib]:=visiteur.dataForm[$formInput_o.lib]
		End case 
		
	End for each 
	
	
End if 

$T_prefixe:=Replace string:C233($infoForm_o.submit;"submit";"")
  // On supprime le prefixe des clés.
cwToolDeletePrefixKey (visiteur.dataForm;$T_prefixe)
cwToolDeletePrefixKey (visiteur.dataFormTyping;$T_prefixe)

  // DataFromTyping est renvoyé dans la méthode et dans visiteur... C'est Kdo.
$0:=visiteur.dataFormTyping
$1->:=visiteur