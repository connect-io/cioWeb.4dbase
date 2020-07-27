# Commencer avec le composant cioWeb

## Présentation

## Configuration du localhost

## Méthode de base sur ouverture

```4d
/* ----------------------------------------------------------------------
	Méthode : Sur ouverture
	
	Charger tout les éléments propres à l'application Web
	
	Historique
	27/07/20 -  Grégory Fromain & Tifenn Fabry - création
---------------------------------------------------------------------- */

If (True)  // Déclarations
	C_OBJECT(<>webApp_o)
	C_VARIANT($classWebApp_v)
End if 


  // Récupération de la class webApp depuis le composant
$classWebApp_v:=cwToolGetClass ("webApp")

  // Instanciation de la class
<>webApp_o:=$classWebApp_v.new()


MESSAGE("Arret du serveur serveur web..."+Char(Carriage return))
WEB STOP SERVER

MESSAGE("Chargement de l'application web..."+Char(Carriage return))
<>webApp_o.serverStart()

MESSAGE("Redémarrage du serveur serveur web..."+Char(Carriage return))
WEB START SERVER
If (ok#1)
	ALERT("Le serveur web n'est pas correctement démarré.")
End if 
```