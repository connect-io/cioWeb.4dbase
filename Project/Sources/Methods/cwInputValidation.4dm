//%attributes = {"shared":true}
$toto:=Date:C102("dad")


  // ----------------------------------------------------
  // Méthode : cwInputValidation
  // Description
  // Valide la valeur d'une variable web via son fichier de configuration
  //
  // ----------------------------------------------------

If (False:C215)  // Historique
	  // 03/10/15 - Grégory Fromain <gregory@connect-io.fr> - Création
	  // 18/03/20 - Grégory Fromain <gregory@connect-io.fr> - Les inputs sont traités depuis une collection au lieu d'un objet.
End if 

If (True:C214)  // Déclarations
	C_TEXT:C284($1)  // Nom du formulaire
	C_TEXT:C284($2)  // Nom de la variable
	C_TEXT:C284($0)  // Retour : "ok" ou message d'erreur
	
	C_TEXT:C284($valeurInput;$retour)
	C_OBJECT:C1216($configInput)
End if 

$retour:="ok"
If (OB Is defined:C1231(visiteur;String:C10($2)))
	$valeurInput:=String:C10(OB Get:C1224(visiteur;$2))
Else 
	$valeurInput:=""
End if 

  // Il n'est pas utile de vérifier que la query renvoit bien un résultat car la même query est executé dans la méthode parent.
$configInput:=<>webApp_o.sites[visiteur.sousDomaine].form.query("lib IS :1";$1)[0].input.query("lib IS :1";$2)[0]

  // Gestion required
Case of 
	: ($retour#"ok")
		  // une erreur est deja remonté, on ne fait rien
	: (Not:C34(OB Is defined:C1231($configInput;"required")))
		  //La cle required n'est pas initialisé, on ne fait rien
	: (Not:C34(OB Get:C1224($configInput;"required")))
		  //La cle required est initialisé à false, on ne fait rien
	: ($valeurInput#"")
		  //La valeur est differente de vide, donc tout va bien, on ne fait rien.
	Else 
		  //Erreur, la valeur est vide !
		$retour:=OB Get:C1224($configInput;"lib")+", la variable est vide."
End case 

  // Gestion format
Case of 
	: ($retour#"ok")
		  // une erreur est deja remonté, on ne fait rien
	: ($valeurInput="") | ($valeurInput="nonObligatoire")  // nonObligatoire : petit hack pour certain cas en javascript.
		  //La valeur est vide, donc il y a rien a controler, on ne fait rien.
	: (Not:C34(OB Is defined:C1231($configInput;"format")))
		  //La cle format n'est pas initialisé, on ne fait rien
	Else 
		
		  // Il y a bien une gestion des formats...
		  // Si le format est une date, on peut faire un petit traitement.
		If ($configInput.format="date")
			$valeurInput:=cwDateClean ($valeurInput)
		End if 
		
		  // On vérifie la validité du format.
		$retour:=cwFormatValide (OB Get:C1224($configInput;"format");$valeurInput)
		
		If ($retour#"ok")
			$retour:=OB Get:C1224($configInput;"lib")+", "+$retour
		End if 
		
		  // Puisque que l'on est dans le format de date... Autant vérifier si il n'y a pas de date min et date max à controler...
		If (String:C10($configInput.dateMin)#"") & ($retour="ok")
			If ($configInput.dateMin="*@")
				$configInput.dateMin_d:=Current date:C33(*)+Num:C11($configInput.dateMin)
			Else 
				$configInput.dateMin_d:=Date:C102(String:C10($configInput.dateMin))
			End if 
			
			If (Date:C102($valeurInput)<$configInput.dateMin_d)
				$retour:="La valeur de "+$configInput.lib+" est plus petite que "+String:C10($configInput.dateMin_d)+"."
			End if 
		End if 
		
		If (String:C10($configInput.dateMax)#"") & ($retour="ok")
			If ($configInput.dateMax="*@")
				$configInput.dateMax_d:=Current date:C33(*)+Num:C11($configInput.dateMax)
			Else 
				$configInput.dateMax_d:=Date:C102(String:C10($configInput.dateMax))
			End if 
			
			If (Date:C102($valeurInput)>$configInput.dateMax_d)
				$retour:="La valeur de "+$configInput.lib+" est plus grande que "+String:C10($configInput.dateMax_d)+"."
			End if 
		End if 
		
End case 

  // *** Gestion des differents cas en cas d'input de type : file ***

If (($retour="ok") & ($configInput.type="file"))
	
	  // On le recherche dans le body part...
	C_TEXT:C284($vPartName;$vPartMimeType;$vPartFileName)
	C_BLOB:C604($vPartContentBlob)
	C_LONGINT:C283($i)
	C_BOOLEAN:C305($trouve_b)
	
	$trouve_b:=False:C215
	For ($i;1;WEB Get body part count:C1211)  //pour chaque partie
		WEB GET BODY PART:C1212($i;$vPartContentBlob;$vPartName;$vPartMimeType;$vPartFileName)
		
		If ($vPartName=$configInput.lib)
			$trouve_b:=True:C214
			$i:=WEB Get body part count:C1211  //On sort de la boucle.
		End if 
	End for 
	
	If ($trouve_b)
		  // On a retrouver notre fichier...
		  // On va l'analyser un peu...
		  // On regarde la taille
		Case of 
			: (Not:C34(OB Is defined:C1231($configInput;"blobSize")))
				  //La cle blobSize n'est pas initialisé, on ne fait rien
				
			: (BLOB size:C605($vPartContentBlob)>$configInput.blobSize)
				$retour:=OB Get:C1224($configInput;"lib")+", le fichier est trop gros."
		End case 
		
		  // On vérifie que le type de fichier soit le type attendu.
		Case of 
			: ($retour#"ok")
				  // une erreur est deja remonté, on ne fait rien
				
			: (Not:C34(OB Is defined:C1231($configInput;"contentType")))
				  //La cle contentType n'est pas initialisé, on ne fait rien
				
			: ($configInput.contentType.join()#("@"+$vPartMimeType+"@"))
				$retour:=OB Get:C1224($configInput;"lib")+", le type de fichier n'est pas valide."
				
		End case 
	End if 
	
	
	
End if 


  // Gestion size
Case of 
	: ($retour#"ok")
		  // une erreur est deja remonté, on ne fait rien
	: (Not:C34(OB Is defined:C1231($configInput;"blobSize")))
		  //La cle blobSize n'est pas initialisé, on ne fait rien
	Else 
		C_TEXT:C284($vPartName;$vPartMimeType;$vPartFileName)
		C_BLOB:C604($vPartContentBlob)
		C_LONGINT:C283($i)
		For ($i;1;WEB Get body part count:C1211)  //pour chaque partie
			WEB GET BODY PART:C1212($i;$vPartContentBlob;$vPartName;$vPartMimeType;$vPartFileName)
			Case of 
				: ($vPartName#OB Get:C1224($configInput;"lib"))
					  //la variable ne figure pas dans le formulaire."
				: ($vPartFileName="") & (BLOB size:C605($vPartContentBlob)=0)
					  // L'input n'est pas renseigné dans le formulaire, ne rien faire.
				: ($vPartFileName="")
					$retour:=OB Get:C1224($configInput;"lib")+", le fichier ne semble pas avoir été importé."
					$i:=WEB Get body part count:C1211  //On sort de la boucle.
				: (BLOB size:C605($vPartContentBlob)>OB Get:C1224($configInput;"blobSize"))
					$retour:=OB Get:C1224($configInput;"lib")+", le fichier est trop gros."
					$i:=WEB Get body part count:C1211  //On sort de la boucle.
			End case 
			
		End for 
End case 

  // Gestion insertion html
Case of 
	: ($retour#"ok")
		  // une erreur est deja remonté, on ne fait rien
	: (Not:C34(cwInputInjection4DHtmlIsValide ($valeurInput)))
		$retour:="injection de balise html 4D détécté sur le champ : "+String:C10($configInput.lib)
End case 

  // Gestion token
Case of 
	: ($retour#"ok")
		  // une erreur est deja remonté, on ne fait rien
	: ($configInput.lib#"token")
		  // Il ne s'agit pas d'un token, on ne fait rien.
	: (cwVisiteurTokenVerifier (->visiteur))
		  // Le token est valide, tout va bien.
	Else 
		  // Le token est périmé, il n'est pas possible de valider le formulaire.
		  //$retour:="Token périmé, merci de re-valider la page."
		$retour:="Le formulaire n'a pas été validé, car la page de validation n'est pas la dernière générée pour votre session. Merci de le valider de nouveau."
End case 

$0:=$retour