<!-- cwDataTableJsInformation ( Texte ) -> Objet -->

## Description
Renvoie au navigateur les informations sur la dataTable.

```4d
cwDataTableJsInformation ( class_t ) -> class_o
```

| Paramêtre | Type | entrée/sortie | Description |
| --------- | ---- | ------------- | ----------- |
| class_t | Texte | entrée | Nom de la classe à renvoyer |
| class_o | Objet | sortie | Objet de la classe |

## Example

```html
C_OBJECT($classClMarketingAutomation_o)

$classClMarketingAutomation_o:=caToolGetClass ("clMarketingAutomation")
$classClMarketingAutomation_o.new("Tonton")
```