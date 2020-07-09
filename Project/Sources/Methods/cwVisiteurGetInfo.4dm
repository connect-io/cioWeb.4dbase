//%attributes = {"shared":true}
/* ----------------------------------------------------
Méthode : cwWebVisiteurGetInfo

Renvoi un objet avec les informations du visiteur :
entête, formulaire, cookies

Historique
19/02/15 gregory@connect-io.fr - Recopie de la methode depuis le composant CioGénérique
26/10/19 gregory@connect-io.fr - Passage notation objet
----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_OBJECT:C1216(visiteur;$1)  // Information précédente du visiteur
	C_OBJECT:C1216($0)  // Retourne toutes les informations du visiteur issu du navigateur.
	
	C_LONGINT:C283($i_l)
	ARRAY TEXT:C222($nom_at;0)
	ARRAY TEXT:C222($valeur_at;0)
End if 

visiteur:=New object:C1471

If (Count parameters:C259=1)
	  //Si un objet visiteur existe déjà, on le recopie avant de travailler dessus...
	visiteur:=OB Copy:C1225($1)
End if 

  //On retire la propriété "formSubmit" si elle existe... Elle est périmé.
If (visiteur.formSubmit#Null:C1517)
	OB REMOVE:C1226(visiteur;"formSubmit")
End if 

  //---------- Entete HTTP ----------
  //récupération des informations dans l'entete HTTP
WEB GET HTTP HEADER:C697($nom_at;$valeur_at)
For ($i_l;1;Size of array:C274($nom_at))
	OB SET:C1220(visiteur;$nom_at{$i_l};$valeur_at{$i_l})
End for 

  //---------- Gestion des cookies ----------
$cookies:=OB Get:C1224(visiteur;"Cookie";Is text:K8:3)
If ($cookies#"")
	While ($cookies#"")
		$pos_egal:=Position:C15("=";$cookies)+1
		$pos_point:=Position:C15("; ";$cookies)
		If ($pos_point=0)
			$pos_point:=99999
		End if 
		
		OB SET:C1220(visiteur;\
			Substring:C12($cookies;1;$pos_egal-2);\
			Substring:C12($cookies;$pos_egal;$pos_point-$pos_egal))
		
		$cookies:=Substring:C12($cookies;$pos_point+2)
	End while 
End if 

  //---------- Récuperation des variables du formulaire ----------
  // On reset le tableau
ARRAY TEXT:C222($nom_at;0)
ARRAY TEXT:C222($valeur_at;0)
WEB GET VARIABLES:C683($nom_at;$valeur_at)

For ($i_l;1;Size of array:C274($nom_at))
	OB SET:C1220(visiteur;$nom_at{$i_l};$valeur_at{$i_l})
End for 

  //---------- Calcul de variable ----------
visiteur.sousDomaine:=Substring:C12(visiteur.Host;1;Position:C15(".";visiteur.Host)-1)
visiteur.domaine:=Substring:C12(visiteur.Host;Position:C15(".";visiteur.Host)+1)

  // On retire les parametres de l'url.
$url_t:=visiteur["X-URL"]
visiteur.url:=Choose:C955(Position:C15("?";$url_t)#0;Substring:C12($url_t;1;Position:C15("?";$url_t)-1);$url_t)

  //On efface les messages d'erreur eventuel
  // Sauf si on vient d'une redirection
If (OB Is defined:C1231(visiteur;"envoiHttpRedirection"))
	  // Pour ce chargement on efface pas les message d'information.
	OB REMOVE:C1226(visiteur;"envoiHttpRedirection")
Else 
	  // Nouveau format
	visiteur.notificationError:=""
	visiteur.notificationSuccess:=""
	visiteur.notificationWarning:=""
	visiteur.notificationInfo:=""
End if 

$0:=visiteur