## Description
Retrouver le timestamp depuis le 01/01/1970 (en fonction de l'heure de votre machine)

```4d
cwTimestamp ( $startDate_d ; $startTime_t ) -> $result_i
```

| Paramètres     | Type    | entrée/sortie | Description |
| -------------- | ------- | ------------- | ----------- |
| $startDate_d   | Date    | entrée        | Date (optionnel)  |
| $startTime_t   | Time    | entrée        | Heure (optionnel) |
| $result_i      | Integer | sortie        | Timestamp |
