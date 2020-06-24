//%attributes = {}
  // ----------------------------------------------------
  // Nom utilisateur (OS) : Grégory Fromain <gregory@connect-io.fr>
  // Date et heure : 02/05/19, 19:03:33
  // ----------------------------------------------------
  // Méthode : cwMotDePasseHash
  // Description
  // Génére un hash avec uniquement les valeurs a-Z0-9 et $
  // (Car cela peut poser des problèmes en cas de passage dans une url ou mot de passe.
  //
  // Paramètres
  // $1 : [text] mot de passe clair
  // $0 : [text] mot de passe hash
  // ----------------------------------------------------


If (False:C215)  // Historique
	  // 02/05/19 Gregory@connect-io.fr - GF190502001 - Création
End if 

If (True:C214)  // Déclarations
	C_TEXT:C284($1;$motDePasseClair_t;$motDePasseHash_t;$0)
End if 

$motDePasseClair_t:=$1

Repeat 
	$motDePasseHash_t:=Generate password hash:C1533($motDePasseClair_t)
Until (Match regex:C1019("[\\w$]+";$motDePasseHash_t))

$0:=$motDePasseHash_t