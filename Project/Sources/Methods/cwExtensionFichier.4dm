//%attributes = {"invisible":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwExtensionFichier (composant Cioweb)

Trouve l'extension d'un fichier depuis une chaine de caractere

Historique
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */

// Déclarations
var $1 : Text  // chemin du fichier
var $0 : Text  // extension

var $extension : Text
var $i : Integer


For ($i;Length:C16($1);1;-1)
	$extension:=Substring:C12($1;$i)
	
	If ($extension=".@")
		$i:=0
	End if 
	
	//Cas d'un fichier qui n'a pas d'extension
	If ($i=1)
		$extension:=""
	End if 
	
End for 

$0:=Lowercase:C14($extension)