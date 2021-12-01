## Description
Modifier les séparateurs dans le chemin d'un fichier.

```4d
cwToolPathSeparator ( $pathToCheck_t ; $separator_t ) -> $result_t
```

| Paramètres     | Type  | entrée/sortie | Description |
| -------------- | ----- | ------------- | ----------- |
| $pathToCheck_t | Texte | entrée        | Chemin à controler      |
| $separator_t   | Texte | entrée        | Séparateur à appliquer... Si non utilisé, on utilise la constante "Folder separator" |
| $result_t      | Texte | sortie        | Chemin controlé |
