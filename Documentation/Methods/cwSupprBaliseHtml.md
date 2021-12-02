## Description
Supprimer les balises html d'un chaine de caractére.
(ex : on reutilise du code html pour placer dans une meta description)

```4d
cwSupprBaliseHtml ( $stringWithTags_t ) -> $stringWithoutTags_t
```

| Paramètres           | Type  | entrée/sortie | Description |
| -------------------- | ----- | ------------- | ----------- |
| $stringWithTags_t    | Texte | entrée        | Chaine avec balise |
| $stringWithoutTags_t | Texte | sortie        | Chaine sans balise |