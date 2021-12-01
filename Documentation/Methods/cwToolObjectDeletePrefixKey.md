## Description
Supprime un suffixe à chaque clé d'un objet et passe le 1er caractère en minuscule.

La méthode accepte sur $1 soit un objet si l'on l'utilise dans le composant.
                          soit un pointeur si l'on utilise dans une base hote.

```4d
cwToolObjectDeletePrefixKey ( $source_v ; $sufixToDelete_t )
```

| Paramètres       | Type    | entrée/sortie | Description |
| ---------------- | ------- | ------------- | ----------- |
| $source_v        | Variant | entrée        | Source      |
| $sufixToDelete_t | Texte   | entrée        | Suffixe à supprimer |