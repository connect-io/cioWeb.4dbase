<!-- cwToolGetClass ( Texte ) -> Objet -->

## Description
Renvoie une classe vers la base hôte.

```4d
cwToolGetClass ( class_t ) -> class_o
```

| Paramètre | Type  | entrée/sortie | Description |
| --------- | ----- | ------------- | ----------- |
| class_t   | Texte | entrée        | Nom de la classe à renvoyer |
| class_o   | Objet | sortie        | Objet de la classe |

## Exemple

```4d
var $webApp_cs;$myWebApp_o : Object

// Récupération de la class depuis le composant
$webApp_cs:=cwToolGetClass ("webApp")

// Instanciation de la class
$myWebApp_o:=$webApp_cs.new()
```
