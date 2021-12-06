## Description
Générer des nouvelles entrée dans un input de type select.

Struture de la collection
[
  "value": "1",
  "lib": "est un admin",
  "selected": true (optionnel),
  "disabled": true (optionnel)
,...
]

```4d
cwFormInputSelectNewValue ( $visitorPointer_p ; $rinputName_t ; $libValeur_c ; $defaultResult_t )
```

| Paramètres        | Type       | entrée/sortie | Description |
| ----------------- | ---------- | ------------- | ----------- |
| $visitorPointer_p | Pointer    | entrée        | ->visiteur     |
| $rinputName_t     | Texte      | entrée        | Nom de l'input html |
| $libValeur_c      | Collection | entrée        | {"lib" : "valeur"} |
| $defaultResult_t  | Texte      | entrée        | (optionnel)résultat par defaut |
