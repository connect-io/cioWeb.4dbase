<!-- Type your summary here -->
# Class : tinyPng

### Description
Cette class permet d'utiliser l'API du site tinyPNG.com afin de retailler des images à la dimension souhaitée

### Accès aux fonctions
* [Fonction : constructor](#fonction--constructor)
* [Fonction : uploadFromFile](#fonction--uploadFromFile)
* [Fonction : uploadfromUrl](#fonction--uploadfromUrl)
* [Fonction : downloadRequest](#fonction--downloadRequest)


------------------------------------------------------

## Fonction : constructor
Initialisation de la clé de l'API. Par défaut, elle est initialisée avec une clé de "démonstration". Sinon, elle peut être renseignée sous la forme d'un String.


### Example
```4d
  // ===== Initialisation de l'instance de tinypng avec la clé "Kzioor4VCZXDlMTnAB093q46JJRFr03Q" =====
var tinyPng_o : cs.tinyPng
tinyPng_o:=cs.tinyPng.new("Kzioor4VCZXDlMTnAB093q46JJRFr03Q")
```


------------------------------------------------------

## Fonction : uploadFromFile
Importation du fichier et envoi vers l'API depuis le chemin d'un fichier écrit en dur sur le serveur.

### Fonctionnement
```4d
tinyPng_o.uploadFromFile($chemin_upload) -> $dataTransfert
```

| Paramêtre      | Type       | entrée/sortie | Description |
| -------------- | ---------- | ------------- | ----------- |
| $chemin_upload| Texte      | Entrée        | Chemin vers l'image qu'on veut modifier au format system |
| $dataTransfert | Objet     | Sortie        | Resultat de la requete HTTP de l'upload |


### Example
```4d
  // ===== upload depuis le chemin POSIX $stringToPath_t ====
$chemin_upload:=Convert path POSIX to system($stringToPath_t)
$dataTransfert:=tinyPng_o.uploadFromFile($chemin_upload)
```


------------------------------------------------------

## Fonction : uploadFromUrl
Importation du fichier et envoi vers l'API depuis le chemin d'un fichier écrit en dur sur le serveur. En construction...

### Fonctionnement
```4d
tinyPng_o.uploadFromuRL($chemin_upload) -> $dataTransfert
```

| Paramêtre      | Type       | entrée/sortie | Description |
| -------------- | ---------- | ------------- | ----------- |
| $chemin_upload| Texte      | Entrée        | URL de l'image que l'on veut modifier |
| $dataTransfert | Objet     | Sortie        | Resultat de la requete HTTP de l'upload |


### Example
```4d
  // ===== upload depuis l'URL $urlImage_t ====
$chemin_upload:=$urlImage_t
$dataTransfert:=tinyPng_o.uploadFromFile($chemin_upload)
```


------------------------------------------------------

## Fonction : downloadRequest
Place le contenue du fichier javascript dans le HTML.

### Fonctionnement
```4d
tinyPng_o.downloadRequest($dataTransfert;$chemin_download;$method_resize;$largeur;$hauteur;) -> $fichier_collect
```

| Paramêtre      | Type       | entrée/sortie | Description |
| -------------- | ---------- | ------------- | ----------- |
| $dataTransfert| Objet     | Entrée        | résultat de la méthode Upload |
| $chemin_download | Texte     | Entrée       | Chemin vers l'endroit ou on veut insérer l'image au format system  |
| $method_resize | Texte     | Entrée       | Optionnel - Permet de choisir la méthode de resize. Voir la doc de l'api pour plus d'infos (scale, cover, ...)  |
| $largeur | Texte     | Entrée       | Optionnel ou pas en fonctoin de la méthode de resize choisie - largeur désirée  |
| $hauteur | Texte     | Entrée       | Optionnel ou pas en fonction de la méthode de resize choisie - hauteur désirée  |
| $fichier_collect | Texte     | Sortie       | Renvoie le resultat de la requete de download de l'api et permet de donner des informations sur le code d'erreur en cas d'erreur, ... cf doc  |




### Example

```4d
$chemin_download:=Convert path POSIX to system("/Users/titouanguillon/Desktop/figurine-kangourou_resize.jpg")

$dataTransfert:=tinyPng_o.uploadFromFile($chemin_upload)

tinyPng_o.downloadRequest($dataTransfert;$chemin_download;"scale";15;)
```
