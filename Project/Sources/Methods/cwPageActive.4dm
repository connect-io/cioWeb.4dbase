//%attributes = {"shared":true,"publishedWeb":true}
  // ----------------------------------------------------
  // Nom utilisateur (OS) : Grégory Fromain <grégory@connect-io.fr>
  // Date et heure : 07/11/15, 21:59:00
  // ----------------------------------------------------
  // Méthode : cwPageActive (Composant CioWeb)
  // Description
  // Active le menu html en fonction de l'url.
  //
  // Paramètres
  // page_lib : genéré dans la methode sur connexion web.
  // $1 : recup via la page web. (<!--#4DSCRIPT/cwPageActive/accueil-->)
  // $0 : [texte] "" ou "active"
  // ----------------------------------------------------

C_TEXT:C284($0;$1;$retour_t;$texteRetour_t)
C_LONGINT:C283($debutPosition_l;$debutFin_l)
C_BOOLEAN:C305($boucle_b)

$texteRetour_t:="active"

$debutFin_l:=1
$boucle_b:=True:C214


While ($boucle_b)
	$debutPosition_l:=Position:C15("/";$1;$debutFin_l)+1
	$debutFin_l:=Position:C15("/";$1;$debutPosition_l)
	
	If ($debutFin_l=0)
		$retour_t:=Choose:C955(pageWeb.lib=Substring:C12($1;$debutPosition_l);$texteRetour_t;"")
		$boucle_b:=False:C215
	Else 
		$retour_t:=Choose:C955(pageWeb.lib=Substring:C12($1;$debutPosition_l;$debutFin_l-$debutPosition_l);$texteRetour_t;"")
	End if 
	
	If ($debutFin_l=0) | ($retour_t#"")
		$boucle_b:=False:C215
	End if 
	
End while 

$0:=$retour_t