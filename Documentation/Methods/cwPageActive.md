## Description
Active le menu html en fonction de l'url.

```4d
cwPageActive ( $textSource_t ) -> $result_t
```

| Paramètres     | Type  | entrée/sortie | Description |
| -------------- | ----- | ------------- | ----------- |
| $textSource_t  | Texte | entrée        | recup via la page web. (<!--#4DSCRIPT/cwPageActive/accueil-->)     |
| $result_t      | Texte | sortie        | "" ou "active" |