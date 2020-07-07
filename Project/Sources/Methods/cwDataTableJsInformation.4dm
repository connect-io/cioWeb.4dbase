//%attributes = {"publishedWeb":true,"shared":true}
  // ----------------------------------------------------
  // Méthode : cwDataTableJsInformation
  //
  // Description
  // Renvoi les informations des col
  // ----------------------------------------------------

If (False:C215)  // Historique
	  // 06/07/20 - Grégory Fromain <gregory@connect-io.fr> - Création
End if 

If (True:C214)  // Déclarations
	C_TEXT:C284($1)  // Nom du dataTable HTML
	C_OBJECT:C1216($2)  // Entité selection
	
	C_COLLECTION:C1488($resultForm_c)
	C_OBJECT:C1216(dataTable_o)
	C_TEXT:C284($dataTableNom_t)
	C_OBJECT:C1216($information_o;$column_o;dataInBase_o;dataColumn_o)
End if 


  // Nettoyage du param
$dataTableNom_t:=$1
$dataTableNom_t:=Replace string:C233($dataTableNom_t;"/readOnly";"")

  // On retrouve la dataTable
$resultForm_c:=<>webApp_o.sites[visiteur.sousDomaine].dataTable.query("lib IS :1";$dataTableNom_t)

If ($resultForm_c.length=1)
	dataTable_o:=$resultForm_c[0]
	dataTable_o.readOnly:=$1="@/readOnly@"
	
Else 
	dataTable_o:=New object:C1471()
	ALERT:C41("Impossible de retrouver la dataTable : "+$dataTableNom_t)
End if 


$information_o:=New object:C1471()

  // On génére les éléments pour construire le tableau html
  // On récupére les tableaux de contact de Philippe pour en refaire une collection...
$information_o.column_c:=New collection:C1472()

For each ($column_o;dataTable_o.column)
	
	$information_o.column_c.push(New object:C1471("title";$column_o.title;"data";$column_o.data))
	
End for each 

$information_o.data_c:=New collection:C1472()

  // On boucle sur chaque élément de la source...
  // Attention de bien conserver les varaibles dataInBase_o et dataColumn_o pour pouvoir utiliser le Formula from string
For each (dataInBase_o;$2)
	
	dataligne_o:=New object:C1471()
	
	  // On boucle sur chaque colonne des données.
	For each (dataColumn_o;dataTable_o.data)
		dataligne_o[dataColumn_o.name]:=Formula from string:C1601(Replace string:C233(dataColumn_o.value;"this.";"dataInBase_o.")).call()
	End for each 
	
	$information_o.data_c.push(dataligne_o)
	
End for each 




$0:=JSON Stringify:C1217($information_o)