//%attributes = {"shared":true,"publishedWeb":true}
  // ----------------------------------------------------
  // Nom utilisateur (OS) : Grégory Fromain <gregory@connect-io.fr>
  // Date et heure : 25/09/15, 20:18:18
  // ----------------------------------------------------
  // Méthode : cwIncludeHtml
  // Description
  // Renvoit le code html contenue dans le dossier Resources/sites/$site/pages
  //
  // Paramètres
  // $1 = chemin relatif depuis le dossier pages
  // $0 = contenu du fichier.

  // ----------------------------------------------------
  //C_BLOB($b_fichier)
C_TEXT:C284($1;$0;$T_chFichier;$T_nomFichier)

$T_nomFichier:=Choose:C955($1="/@";Substring:C12($1;2);$1)
$T_nomFichier:=$T_nomFichier+Choose:C955($1#"@.html";".html";"")
$T_nomFichier:=Replace string:C233($T_nomFichier;"/";Folder separator:K24:12)

  //$T_chFichier:=<>webApp_o.config.webApp.folder_f()+OB Get(visiteur;"sousDomaine")+Folder separator+"pages"+Folder separator
$T_chFichier:=<>webApp_o.config.page.folder_f()


  //DOCUMENT VERS BLOB($chFichier;$b_fichier)
  //$0:=Caractere(1)+BLOB vers texte($b_fichier;UTF8 texte sans longueur)

$0:=Char:C90(1)+Document to text:C1236($T_chFichier+$T_nomFichier;"UTF-8")