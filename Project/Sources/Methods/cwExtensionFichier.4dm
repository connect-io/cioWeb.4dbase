//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Nom utilisateur (OS) : Grégory Fromain <gregory@connect-io.fr>
  // Date et heure : 20/10/15, 00:32:31
  // ----------------------------------------------------
  // Méthode : cwExtensionFichier (composant Cioweb)
  // Description
  // Trouve l'extension d'un fichier depuis une chaine de caractere
  //
  // Paramètres
  // $1 = chemin du fichier
  // $0 = extension
  // ----------------------------------------------------
C_TEXT:C284($0;$1;$extension)
C_LONGINT:C283($i)
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