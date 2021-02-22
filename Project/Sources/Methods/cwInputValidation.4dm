//%attributes = {"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwInputValidation

Valide la valeur d'une variable web via son fichier de configuration

Historique
03/10/15 - Grégory Fromain <gregory@connect-io.fr> - Création
18/03/20 - Grégory Fromain <gregory@connect-io.fr> - Les inputs sont traités depuis une collection au lieu d'un objet.
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
27/01/21 - Grégory Fromain <gregory@connect-io.fr> - Fixe bug sur les input type file non envoyé.
----------------------------------------------------------------------------- */

// Déclarations
var $1 : Text  // Nom du formulaire
var $2 : Text  // Nom de la variable
var $0 : Text  // Retour : "ok" ou message d'erreur

var $valeurInput : Text
var $retour : Text
var $varNomPublic_t : Text
var $configInput : Object


$retour:="ok"

/*
If (OB Is defined(visiteur;String($2)))
$valeurInput:=String(OB Get(visiteur;$2))
Else
$valeurInput:=""
End if
*/

$valeurInput:=String:C10(visiteur[String:C10($2)])

// Il n'est pas utile de vérifier que la query renvoie bien un résultat car la même query est executé dans la méthode parent.
$configInput:=OB Copy:C1225(Storage:C1525.sites[visiteur.sousDomaine].form.query("lib IS :1";$1)[0].input.query("lib IS :1";$2)[0])

If (String:C10($configInput.label)#"")
	$varNomPublic_t:=$configInput.label
Else 
	$varNomPublic_t:=$configInput.lib
End if 

// ----- Gestion required -----
Case of 
	: (Not:C34(OB Is defined:C1231($configInput;"required")))
		//La cle required n'est pas initialisé, on ne fait rien
		
	: (Not:C34(OB Get:C1224($configInput;"required")))
		//La cle required est initialisé à false, on ne fait rien
		
	: ($configInput.type="file")
		//En cas d'import de fichier, le navigateur renvoi un variable vide ici, on ne fait rien
		
	: ($valeurInput#"")
		//La valeur est differente de vide, donc tout va bien, on ne fait rien.
		
	Else 
		//Erreur, la valeur est vide !
		$retour:=$varNomPublic_t+", la variable est vide."
End case 


// ----- Gestion format -----
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
			$valeurInput:=cwDateClean($valeurInput)
		End if 
		
		// On vérifie la validité du format.
		$retour:=cwFormatValide(OB Get:C1224($configInput;"format");$valeurInput)
		
		If ($retour#"ok")
			$retour:=$varNomPublic_t+", "+$retour
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


// ----- Gestion des differents cas en cas d'input de type : file -----
If (($retour="ok") & ($configInput.type="file"))
	
	// On le recherche dans le body part...
	var $vPartName : Text
	var $vPartMimeType : Text
	var $vPartFileName : Text
	var $vPartContentBlob : Blob
	var $i : Integer
	var $trouve_b : Boolean
	
	$trouve_b:=False:C215
	For ($i;1;WEB Get body part count:C1211)  //pour chaque partie
		WEB GET BODY PART:C1212($i;$vPartContentBlob;$vPartName;$vPartMimeType;$vPartFileName)
		
		If ($vPartName=$configInput.lib)
			//la variable ne figure pas dans le formulaire."
			$trouve_b:=True:C214
			$i:=WEB Get body part count:C1211  //On sort de la boucle.
		End if 
	End for 
	
	If ($trouve_b)
		If ($vPartFileName="") & (BLOB size:C605($vPartContentBlob)=0)
			// L'input n'est pas renseigné dans le formulaire
			$trouve_b:=False:C215
		End if 
	End if 
	
	// ----- Gestion size -----
	If ($trouve_b)
		Case of 
			: (Not:C34(OB Is defined:C1231($configInput;"blobSize")))
				//La cle blobSize n'est pas initialisé, on ne fait rien
				
			: (BLOB size:C605($vPartContentBlob)>$configInput.blobSize)
				$retour:=$varNomPublic_t+", le fichier est trop gros."
		End case 
		
		// ----- Gestion du type -----
		// On vérifie que le type de fichier soit le type attendu.
		Case of 
			: ($retour#"ok")
				// une erreur est deja remonté, on ne fait rien
				
			: (Not:C34(OB Is defined:C1231($configInput;"contentType")))
				//La cle contentType n'est pas initialisé, on ne fait rien
				
			: ($configInput.contentType.join()#("@"+$vPartMimeType+"@"))
				$retour:=$varNomPublic_t+", le type de fichier n'est pas valide."
				
		End case 
	End if 
End if 


// ----- Gestion insertion html -----
Case of 
	: ($retour#"ok")
		// une erreur est deja remonté, on ne fait rien
		
	: (Not:C34(cwInputInjection4DHtmlIsValide($valeurInput)))
		$retour:="injection de balise html 4D détécté sur le champ : "+String:C10($configInput.lib)
End case 


// ----- Gestion token -----
Case of 
	: ($retour#"ok")
		// une erreur est deja remonté, on ne fait rien
		
	: ($configInput.lib#"token")
		// Il ne s'agit pas d'un token, on ne fait rien.
		
	: (visiteur.tokenCheck())
		// Le token est valide, tout va bien.
		
	Else 
		// Le token est périmé, il n'est pas possible de valider le formulaire.
		//$retour:="Token périmé, merci de re-valider la page."
		$retour:="Le formulaire n'a pas été validé, car la page de validation n'est pas la dernière générée pour votre session. Merci de le valider de nouveau."
End case 

$0:=$retour