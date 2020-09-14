//%attributes = {"shared":true}
/* ---------------------------------------------------
Méthode : c(io)w(eb)ToolHashUrl

Génére un hash avec uniquement les valeurs a-Z0-9 et $
(Car cela peut poser des problèmes en cas de passage dans une url ou mot de passe.)

Historique
02/05/19 - Grégory Fromain <gregory@connect-io.fr> - Création
14/09/20 - Grégory Fromain <gregory@connect-io.fr> - Import dans le composant
---------------------------------------------------- */


If (True:C214)  // Déclarations
	C_TEXT:C284($1;$motDePasseClair_t)
	C_TEXT:C284($0;$motDePasseHash_t)
	
End if 

$motDePasseClair_t:=$1

Repeat 
	$motDePasseHash_t:=Generate password hash:C1533($motDePasseClair_t)
Until (Match regex:C1019("[\\w$]+";$motDePasseHash_t))

$0:=$motDePasseHash_t
