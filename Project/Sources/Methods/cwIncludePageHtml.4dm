//%attributes = {"shared":true,"publishedWeb":true}
/* ----------------------------------------------------
Méthode : cwIncludeHtml

Renvoie le code html contenue dans le dossier Resources/sites/$site/pages

Historique

----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_TEXT:C284($1;$0;$T_chFichier;$T_nomFichier)  // $1 = chemin relatif depuis le dossier pages, $0 = contenu du fichier.
End if 

$T_nomFichier:=Choose:C955($1="/@";Substring:C12($1;2);$1)
$T_nomFichier:=$T_nomFichier+Choose:C955($1#"@.html";".html";"")
$T_nomFichier:=Replace string:C233($T_nomFichier;"/";Folder separator:K24:12)

$T_chFichier:=<>webApp_o.config.viewCache.folder_f()


$0:=Char:C90(1)+Document to text:C1236($T_chFichier+$T_nomFichier;"UTF-8")