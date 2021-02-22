//%attributes = {"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Methode projet : cw4dWriteProGeneratePDF

Detail des entreprises ajax

Historique
03/11/20 - Grégory Fromain <gregory@connect-io.fr> - Création
-----------------------------------------------------------------------------*/

/*
Il est possible que $1 soit :
de type "text" : C'est un chemin, dans ce cas on va importer le document 4D write pro.
de type "4d.File" : C'est un objet, dans ce cas on va importer le document 4D write pro à l'aide de la propriété .path
de type "document 4D write pro" : Dans ce cas on l'utilise directement.
*/
var $1 : Variant

/*
Il est possible que $2 soit :
de type "text" : C'est le chemin direct dans lequel on va exporter le PDF.
de type "4d.File" : C'est un objet, dans ce cas on va exporter le PDF à l'aide de la propriété .path
*/
var $2 : Variant

// Le param $3 est optionnel. Il permet de modifier les options de génération du PDF.
var $3 : Object

// $0 : Information sur le résultat de la génération du PDF.
var $0 : Text

var $documentWrPro_o : Object
var $option_o : Object
var $erreur_t : Text


Case of 
	: (Value type:C1509($1)=Is text:K8:3)
		$documentWrPro_o:=WP Import document:C1318($1)
		
	: (Value type:C1509($1)=Is object:K8:27)
		If (String:C10($1.platformPath)#"")
			$documentWrPro_o:=WP Import document:C1318($1.platformPath)
			
		Else 
			// Le param envoi directement le contenu.
			$documentWrPro_o:=$1
		End if 
		
	Else 
		$erreur_t:="Impossible de charger le document 4D write Pro."
End case 


Case of 
	: (Value type:C1509($2)=Is text:K8:3)
		$cheminPdf_t:=$2
		
	: (Value type:C1509($2)=Is object:K8:27)
		If (String:C10($2.platformPath)#"")
			$cheminPdf_t:=$2.platformPath
			
		Else 
			$erreur_t:="Impossible de determiner l'emplacement de destination."
		End if 
		
End case 


Case of 
	: ($erreur_t#"")
		// Ne rien faire.
		
	: (Test path name:C476($cheminPdf_t)=Is a document:K24:1)
		// On supprime au préalable l'ancien PDF.
		DELETE DOCUMENT:C159($cheminPdf_t)
		
	: (Test path name:C476($cheminPdf_t)#Is a folder:K24:2)
		// Si besoin, on génére l'arborescence.
		CREATE FOLDER:C475($cheminPdf_t;*)
End case 

// Configuration de base du PDF.
$option_o:=New object:C1471
$option_o[wk optimized for:K81:317]:=wk print:K81:318
$option_o[wk recompute formulas:K81:320]:=True:C214

// si besoin, sur-configuration du PDF.
If (Count parameters:C259=3)
	If (Type:C295($3)=Is object:K8:27)
		$option_o:=cwToolObjectMerge($option_o;$3)
	Else 
		$erreur_t:="Le param $3 doit être de nature objet."
	End if 
End if 


If ($erreur_t="")
	WP EXPORT DOCUMENT:C1337($documentWrPro_o;$cheminPdf_t;wk pdf:K81:315;$option_o)
	If (Test path name:C476($cheminPdf_t)#Is a document:K24:1)
		$erreur_t:="La génération du PDF n'a pas fonctionné."
	End if 
	
End if 


$0:=Choose:C955($erreur_t#"";Current method name:C684+" : "+$erreur_t;"Ok")