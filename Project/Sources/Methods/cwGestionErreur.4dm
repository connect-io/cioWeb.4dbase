//%attributes = {"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwGestionErreur

Methode de gestion appel sur erreur du serveur web.
ATTENTION : Cette gestion des erreurs ne s'applique que sur le composant.
Pensez à la copier dans une methode de votre projet pour en profiter...

Historique
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
24/11/20 - Grégory Fromain <gregory@connect-io.fr> - Clean code
----------------------------------------------------------------------------- */

// Déclarations
var $erreur : Object
ARRAY LONGINT:C221($code;0)
ARRAY TEXT:C222($composantInterne;0)
ARRAY TEXT:C222($lib;0)

GET LAST ERROR STACK:C1015($code;$composantInterne;$lib)

$erreur:=New object:C1471(\
"libelle";$lib{1};\
"methode";Error Method;\
"ligne";Error Line;\
"code";Error)

If (visiteur#Null:C1517)
	$erreur.visiteur:=visiteur
End if 

cwLogErreurAjout("Serveur Web";$erreur)

If (Get assert enabled:C1130)
	WEB SEND TEXT:C677(JSON Stringify:C1217($erreur))
End if 