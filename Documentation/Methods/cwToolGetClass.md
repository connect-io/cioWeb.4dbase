<!-- cwToolGetClass ( Texte ) -> Objet -->

## Description
Renvoie une classe ver la base hôte.

```4d
cwToolGetClass ( class_t ) -> class_o
```

| Paramêtre | Type | entrée/sortie | Description |
| --------- | ---- | ------------- | ----------- |
| class_t | Texte | entrée | Nom de la classe à renvoyer |
| class_o | Objet | sortie | Objet de la classe |

## Example

```4d
C_OBJECT($webApp_cs;$myWebApp_o)

// Récupération de la class depuis le composant
$webApp_cs:=cwToolGetClass ("webApp")

// Instanciation de la class
$myWebApp_o:=$webApp_cs.new()
```
