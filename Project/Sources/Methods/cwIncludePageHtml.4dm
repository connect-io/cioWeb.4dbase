//%attributes = {"shared":true,"publishedWeb":true}
/* -----------------------------------------------------------------------------
Méthode : cwIncludePageHtml

Renvoie le code html contenue dans le dossier Resources/sites/$site/pages

Historique
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */


If (True:C214)  // Déclarations
	var $1 : Text  // $1 = chemin relatif depuis le dossier pages
	var $0 : Text  // $0 = contenu du fichier.
	
	var $T_nomFichier : Text
End if 

$T_nomFichier:=Choose:C955($1="/@";Substring:C12($1;2);$1)
$T_nomFichier:=$T_nomFichier+Choose:C955($1#"@.html";".html";"")
$T_nomFichier:=Replace string:C233($T_nomFichier;"/";Folder separator:K24:12)


$0:=Char:C90(1)+Document to text:C1236(cachePath_t+$T_nomFichier;"UTF-8")