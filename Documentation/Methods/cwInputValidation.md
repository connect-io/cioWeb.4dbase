## Description
Valide la valeur d'une variable web via son fichier de configuration.

```4d
cwInputValidation ( $formName_t ; $variableName_t ) -> $result_t
```

| Paramètres      | Type  | entrée/sortie | Description |
| --------------- | ----- | ------------- | ----------- |
| $formName_t     | Texte | entrée        | Nom du formulaire  |
| $variableName_t | Texte | entrée        | Nom de la variable |
| $result_t       | Texte | sortie        | Retour : "ok" ou message d'erreur |
