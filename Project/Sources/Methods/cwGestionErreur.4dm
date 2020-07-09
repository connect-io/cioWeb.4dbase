//%attributes = {"shared":true}
/* ----------------------------------------------------
Méthode : ogWebGestionErreur

Methode de gestion appel sur erreur du serveur web.
ATTENTION : Cette gestion des erreurs ne s'applique que sur le composant.
Pensez à la copier dans une methode de votre projet pour en profiter...

Historique

----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_OBJECT:C1216($erreur)
	ARRAY LONGINT:C221($code;0)
	ARRAY TEXT:C222($composantInterne;0)
	ARRAY TEXT:C222($lib;0)
End if 

GET LAST ERROR STACK:C1015($code;$composantInterne;$lib)

OB SET:C1220($erreur;\
"libelle";$lib{1};\
"methode";Error Method;\
"ligne";Error Line;\
"code";Error)

If (OB Is defined:C1231(visiteur))
	OB SET:C1220($erreur;"visiteur";visiteur)
End if 

cwLogErreurAjout ("Serveur Web";$erreur)

If (Get assert enabled:C1130)
	WEB SEND TEXT:C677(JSON Stringify:C1217($erreur))
End if 