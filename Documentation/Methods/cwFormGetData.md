## Description
La méthode reprend le principe de fonctionnement de la methode cwFormControle mais sans les contrôles.

```4d
cwFormGetData ( $visitorPointer_p ; $formName_t ) -> $formStatus_o
```

| Paramètres        | Type    | entrée/sortie | Description |
| ----------------- | ----- --| ------------- | ----------- |
| $visitorPointer_p | Pointer | entrée        | Visiteur      |
| $formName_t       | Texte   | entrée        | Nom du formulaire |
| $formStatus_o     | Objet   | sortie        | Etat du formulaire |