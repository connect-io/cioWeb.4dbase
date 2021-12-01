## Description
Charge un objet JSON depuis un objet de type file. (Compatible JSON et JSONC).

```4d
cwToolObjectFromFile ( $fileToload_t ; $sharedObject_i ) -> $fileObject_o
```

| Paramètres      | Type    | entrée/sortie | Description |
| --------------- | ------- | ------------- | ----------- |
| $fileToload_t   | Texte   | entrée        | Objet du fichier à charger    |
| $sharedObject_i | Integer | entrée        | renvoi un objet partagé, on utilisera la constante "ck shared" (entier 16) |
| $fileObject_o   | Objet   | sortie        | Objet contenu dans le fichier |
