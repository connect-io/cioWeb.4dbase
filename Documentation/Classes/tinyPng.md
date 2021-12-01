<!-- Type your summary here -->
# Class : TinyPng

### Description
Cette class permet d'utiliser l'API du site tinyPNG.com afin de retailler des images à la dimension souhaitée

### Accès aux fonctions
* [Fonction : constructor](#fonction--constructor)
* [Fonction : uploadFromFile](#fonction--uploadFromFile)
* [Fonction : uploadfromUrl](#fonction--uploadfromUrl)
* [Fonction : downloadRequest](#fonction--downloadRequest)
* [Fonction : lastExportInfo](#fonction--lastExportInfo)

--------------------------------------------------------------------------------

## Fonction : constructor
Initialisation de la clé de l'API. Par défaut, elle est initialisée avec une clé de "démonstration". Sinon, elle peut être renseignée sous la forme d'un String.

| Paramètre | Type       | entrée/sortie | Description |
| --------- | ---------- | ------------- | ----------- |
| $ApiKey   | Texte      | Entrée        | Clé de l'API |

### Example
```4d
  // ===== Initialisation de l'instance de tinypng avec la clé "Kzioor4VCZXDlMTnAB093q46JJRFr03Q" =====
var tinyPng_o : cs.TinyPng
tinyPng_o:=cs.TinyPng.new("Kzioor4VCZXDlMTnAB093q46JJRFr03Q")
```

--------------------------------------------------------------------------------

## Fonction : downloadRequest
Place le contenue du fichier javascript dans le HTML.

### Fonctionnement
```4d
TinyPng.downloadRequest($cheminDownload_t;$methodResize_t;$largeur_i;$hauteur_i) -> $fichierCollect_o
```

| Paramètre         | Type      | entrée/sortie | Description |
| ----------------- | ----------| ------------- | ----------- |
| $cheminDownload_t | Texte     | Entrée        | Chemin vers l'endroit ou on veut insérer l'image au format system  |
| $methodResize_t   | Texte     | Entrée        | Optionnel - Permet de choisir la méthode de resize. Voir la doc de l'api pour plus d'infos (scale, cover, ...)  |
| $largeur_i        | Integer   | Entrée        | Optionnel ou pas en fonction de la méthode de resize choisie - largeur désirée  |
| $hauteur_i        | Integer   | Entrée        | Optionnel ou pas en fonction de la méthode de resize choisie - hauteur désirée  |
| $fichierCollect_o | Objet     | Sortie        | Renvoie le résultat de la requête de download de l'api et permet de donner des informations sur le code d'erreur en cas d'erreur, ... cf doc  |

### Example

```4d
$chemin_download:=Convert path POSIX to system("/Users/titouanguillon/Desktop/figurine-kangourou_resize.jpg")
If(tinyPng_o.uploadFromFile($chemin_upload))
tinyPng_o.downloadRequest($chemin_download;"scale";15;)
End if
```

--------------------------------------------------------------------------------

## Fonction : lastExportInfo
Renvoie les informations de la dernière importation dans un objet.

### Fonctionnement
```4d
TinyPng.lastExportInfo() -> $infoFicherExport_o
```

| Paramètre           | Type      | entrée/sortie | Description |
| ------------------- | ----------| ------------- | ----------- |
| $infoFicherExport_o | Objet     | Sortie        | taille et extension du fichier exporté. |

### Example
```4d
$chemin_download:=Convert path POSIX to system("/Users/titouanguillon/Desktop/figurine-kangourou_resize.jpg")
$isValide:=tinyPng_o.uploadFromFile($chemin_upload)
$resultat:=tinyPng_o.lastExportInfo()
```

--------------------------------------------------------------------------------

## Fonction : uploadFromUrl
Importation du fichier et envoi vers l'API depuis le chemin d'un fichier écrit en dur sur le serveur. En construction...

### Fonctionnement
```4d
TinyPng.uploadFromuRL($chemin_upload_t) -> $isValide_b
```

| Paramètre        | Type       | entrée/sortie | Description |
| ---------------- | ---------- | ------------- | ----------- |
| $chemin_upload_t | Texte      | Entrée        | URL de l'image que l'on veut modifier |
| $isValide_b      | Bool       | Sortie        | Renvoie true si la requete a bien été envoyée |


### Example
```4d
  // ===== upload depuis l'URL $urlImage_t ====
$chemin_upload:=$urlImage_t
$isValide:=tinyPng_o.uploadFromFile($chemin_upload)
```

--------------------------------------------------------------------------------

## Fonction : uploadFromFile
Importation du fichier et envoi vers l'API depuis le chemin d'un fichier écrit en dur sur le serveur.

### Fonctionnement
```4d
TinyPng.uploadFromFile($filePath_t) -> $isValide_b
```

| Paramètre        | Type       | entrée/sortie | Description |
| ---------------- | ---------- | ------------- | ----------- |
| $filePath_t      | Texte      | Entrée        | Chemin vers l'image qu'on veut modifier au format system |
| $isValide_b      | Bool       | Sortie        | Renvoie true si la requete a bien été envoyée |

### Example
```4d
  // ===== upload depuis le chemin POSIX $stringToPath_t ====
$chemin_upload:=Convert path POSIX to system($stringToPath_t)
$isValide:=tinyPng_o.uploadFromFile($chemin_upload)
```
