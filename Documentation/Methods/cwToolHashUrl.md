## Description
Génére un hash avec uniquement les valeurs a-Z0-9 et $
(Car cela peut poser des problèmes en cas de passage dans une url ou mot de passe.)

```4d
cwToolHashUrl ( $clearPassword_t ) -> $hashPassword_t
```

| Paramètres       | Type  | entrée/sortie | Description |
| ---------------- | ----- | ------------- | ----------- |
| $clearPassword_t | Texte | entrée        | Mot de passe en clair |
| $hashPassword_t  | Texte | sortie        | Mot de passe hash |
