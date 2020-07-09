//%attributes = {"invisible":true}
/* ----------------------------------------------------
Méthode : cwExtensionFichier (composant Cioweb)

Trouve l'extension d'un fichier depuis une chaine de caractere

Historique

----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_TEXT:C284($0;$1;$extension)  // $1 = chemin du fichier. $0 = extension
	
	C_LONGINT:C283($i)
End if 

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