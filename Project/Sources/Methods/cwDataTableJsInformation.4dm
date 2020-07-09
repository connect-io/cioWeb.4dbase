//%attributes = {"publishedWeb":true,"shared":true}
/* ----------------------------------------------------
Méthode : cwDataTableJsInformation

Renvoi les informations sur la dataTable

Historique
06/07/20 - Grégory Fromain <gregory@connect-io.fr> - Création
08/07/20 - Grégory Fromain <gregory@connect-io.fr> - Renvoi de toutes les informations sur la dataTable.
----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_POINTER:C301($1)  //Variable pageWeb de l'application
	C_TEXT:C284($2)  // Nom du dataTable HTML
	C_OBJECT:C1216($3)  // Entité selection
	
	C_OBJECT:C1216($pageWeb_o)
	C_COLLECTION:C1488($resultForm_c)
	C_OBJECT:C1216($dataTable_o)
	C_TEXT:C284($dataTableNom_t)
	C_OBJECT:C1216($information_o;$column_o;dataInBase_o;dataColumn_o)
End if 

$pageWeb_o:=$1->

  // Nettoyage du param
$dataTableNom_t:=$2
$dataTableNom_t:=Replace string:C233($dataTableNom_t;"/readOnly";"")

  // On retrouve la dataTable
$resultForm_c:=<>webApp_o.sites[visiteur.sousDomaine].dataTable.query("lib IS :1";$dataTableNom_t)

  // Pour vérifier que les data soit bien brut.
If ($resultForm_c.length=1)
	$dataTable_o:=OB Copy:C1225($resultForm_c[0])
	$dataTable_o.readOnly:=$2="@/readOnly@"
	
Else 
	$dataTable_o:=New object:C1471()
	ALERT:C41("Impossible de retrouver la dataTable : "+$dataTableNom_t)
End if 


  // On génére les éléments pour construire le tableau html
  // On récupére les tableaux de contact de Philippe pour en refaire une collection...
$dataTable_o.column_c:=New collection:C1472()

For each ($column_o;$dataTable_o.column)
	
	$dataTable_o.column_c.push(New object:C1471("title";$column_o.title;"data";$column_o.data))
	
End for each 

$dataTable_o.data_c:=New collection:C1472()

  // On boucle sur chaque élément de la source...
  // Attention de bien conserver les varaibles dataInBase_o et dataColumn_o pour pouvoir utiliser le Formula from string
For each (dataInBase_o;$3)
	
	dataligne_o:=New object:C1471()
	
	  // On boucle sur chaque colonne des données.
	For each (dataColumn_o;$dataTable_o.data)
		dataligne_o[dataColumn_o.name]:=Formula from string:C1601(Replace string:C233(dataColumn_o.value;"this.";"dataInBase_o.")).call()
	End for each 
	
	$dataTable_o.data_c.push(dataligne_o)
	
End for each 


  //----- Gestion du double click -----
If ($dataTable_o.doubleClick#Null:C1517)
	
	  // On génére l'url du double click sur une ligne du dataTable.
	ASSERT:C1129($dataTable_o.doubleClick.link#Null:C1517;"La propriété $dataTable_o.doubleClick.link n'est pas définit dans "+$dataTableNom_t)
	
	If ($dataTable_o.doubleClick.linkVariable=Null:C1517)
		$dataTable_o.doubleClick.linkVariable:=New object:C1471
	End if 
	
	$dataTable_o.doubleClick.link:=cwLibToUrl ($dataTable_o.doubleClick.link;$dataTable_o.doubleClick.linkVariable)
	
	  // Securité navigateur
	$dataTable_o.doubleClick.linkVariable:=Null:C1517
End if 



  // Pour des raisons de sécurité on efface certaine propriété de l'objet.

$dataTable_o.source:=Null:C1517

$dataTable_o.column:=Null:C1517
$dataTable_o.data:=Null:C1517

If ($pageWeb_o.dataTable_c=Null:C1517)
	$pageWeb_o.dataTable_c:=New collection:C1472()
End if 

$pageWeb_o.dataTable_c.push($dataTable_o)

$1->:=$pageWeb_o

$0:="id=\""+$dataTableNom_t+"\" class=\"table table-striped table-bordered\" width=\"100%\""