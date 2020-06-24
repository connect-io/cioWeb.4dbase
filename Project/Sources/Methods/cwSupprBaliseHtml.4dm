//%attributes = {"shared":true}
  // ----------------------------------------------------
  // Nom utilisateur (OS) : Grégory Fromain <gregory@connect-io.fr>
  // Date et heure : 21/12/15, 00:48:09
  // ----------------------------------------------------
  // Méthode : cwSupprBaliseHtml (composant CioWeb)
  // Description
  // Supprimer les balises html d'un chaine de caractére.
  // (ex : on reutilise du code html pour placer dans une meta description)
  //
  // Paramètres
  // $1 = [texte] chaine avec balise
  // $0 = [texte] chaine sans balise
  // ----------------------------------------------------

C_TEXT:C284($0;$1;$in;$out)
C_BOOLEAN:C305($B)

$in:=$1
$B:=PHP Execute:C1058("";"strip_tags";$out;$in)
$0:=$out
