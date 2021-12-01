## Description
Charge un objet depuis le chemin d'un fichier. (Compatible JSON et JSONC)
Cette methode n'est pas partagé avec la base hote car il est préférable d'utiliser : cwToolObjectFromFile.

```4d
cwToolObjectFromPlatformPath ( $filePath_t ) -> $result_o
```

| Paramètres     | Type  | entrée/sortie | Description |
| -------------- | ----- | ------------- | ----------- |
| $filePath_t    | Texte | entrée        | Chemin du fichier à charger (format plateforme)     |
| $result_o      | objet | sortie        | Objet contenu dans le fichier |
