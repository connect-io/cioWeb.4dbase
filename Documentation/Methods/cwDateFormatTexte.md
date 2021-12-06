## Description
Formate une date en fonction d'un modele.

```4d
cwDateFormatTexte ( $formatModel_t ; $dateToFormat_d ) -> $result_t
```

| Paramètres      | Type  | entrée/sortie | Description |
| --------------- | ----- | ------------- | ----------- |
| $formatModel_t  | Texte | entrée        | Modele du format (ex : JJMMAA, AA-MM-JJ, AA.JJ.MM,...) |
| $dateToFormat_d | Date  | entrée        | Date à formater, si inexistant la date sera la date du jour. |
| $result_t       | Texte | sortie        | Date formaté |
