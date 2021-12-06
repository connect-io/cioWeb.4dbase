## Description
Détail des entreprises ajax.

```4d
cw4dWriteProGeneratePDF ( $pathImport_v ; $pathExport_v ; $optionPdf_o ) -> $result_t
```

| Paramètres     | Type    | entrée/sortie | Description |
| -------------- | ------- | ------------- | ----------- |
| $pathImport_v  | Variant | entrée        | Si type "text" : c'est un chemin, dans ce cas on va importer le document 4D write pro. Sinon, si c'est un objet, dans ce cas on va importer le document 4D write pro à l'aide de la propriété .path de type "document 4D write pro" : Dans ce cas on l'utilise directement. |
| $pathExport_v  | Variant | entrée        | Si type "text" : c'est le chemin direct dans lequel on va exporter le PDF. Sinon si
type "4d.File" : C'est un objet, dans ce cas on va exporter le PDF à l'aide de la propriété .path |
| $optionPdf_o   | Objet   | entrée        | ( Optionnel ) permet de modifier les options de génération du PDF |
| $result_t      | Texte   | sortie        | Information sur le résultat de la génération du PDF |
  