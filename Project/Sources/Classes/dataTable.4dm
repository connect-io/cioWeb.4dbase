/* 
Class : dataTable

Gestion des tableaux de données en HTML.

*/


Class constructor
/* -----------------------------------------------------------------------------
Fonction : dataTable.constructor
	
Initialisation d'une dataTable
	
Historique
21/07/20 - Grégory Fromain <gregory@connect-io.fr> - Réflexion
----------------------------------------------------------------------------- */
	C_OBJECT:C1216($1)  // Le lib de la dataTable.
	C_TEXT:C284($propriete_t)
	
	ASSERT:C1129($1#Null:C1517;"dataTable.constructor : La configuration de la dataTable est manquante.")
	
	For each ($propriete_t;$1)
		This:C1470[$propriete_t]:=$1[$propriete_t]
	End for each 
	
	This:C1470.column_c:=This:C1470.column
	
	This:C1470.data_c:=New collection:C1472()
	
	  //----- Gestion du double click -----
	If (This:C1470.doubleClick#Null:C1517)
		
		  // On génére l'url du double click sur une ligne du dataTable.
		ASSERT:C1129(This:C1470.doubleClick.link#"";"dataTable.constructor : La propriété $dataTable_o.doubleClick.link n'est pas définit dans "+This:C1470.lib)
		
		If (This:C1470.doubleClick.linkVariable=Null:C1517)
			This:C1470.doubleClick.linkVariable:=New object:C1471
		End if 
		
		This:C1470.doubleClick.link:=cwLibToUrl (This:C1470.doubleClick.link;This:C1470.doubleClick.linkVariable)
		
		  // Securité navigateur
		This:C1470.doubleClick.linkVariable:=Null:C1517
	End if 
	
	
	  //----- Gestion du lien en ajax -----
	If (This:C1470.ajax#Null:C1517)
		
		  // On génére l'url du double click sur une ligne du dataTable.
		ASSERT:C1129(This:C1470.ajax.link#"";"dataTable.constructor : La propriété $dataTable_o.ajax.link n'est pas définit dans "+This:C1470.lib)
		
		If (This:C1470.ajax.linkVariable=Null:C1517)
			This:C1470.ajax.linkVariable:=New object:C1471
		End if 
		
		This:C1470.ajax.link:=cwLibToUrl (This:C1470.ajax.link;This:C1470.ajax.linkVariable)
		
		  // Securité navigateur
		This:C1470.ajax.linkVariable:=Null:C1517
	End if 
	
	
Function setData
/* -----------------------------------------------------------------------------
Fonction : dataTable.setData
	
Charger les data dans le tableau de donnée.
	
Historique
28/07/20 - Grégory Fromain <gregory@connect-io.fr> - Creation
----------------------------------------------------------------------------- */
	C_VARIANT:C1683($1;$source_v)  // Entité selection
	C_OBJECT:C1216(dataInBase_o;dataligne_o;dataColumn_o)
	
	If ($1=Null:C1517)
		ALERT:C41("dataTable.setData : Le paramêtre $1 n'est pas défini dans la datatable "+This:C1470.lib)
	End if 
	
	$source_v:=$1
	
	  // On purge les datas... Sinon cela concaténe les lignes.
	This:C1470.data_c:=New collection:C1472()
	
	  // On boucle sur chaque élément de la source...
	  // Attention de bien conserver les variables dataInBase_o et dataColumn_o pour pouvoir utiliser le Formula from string
	For each (dataInBase_o;$source_v)
		
		dataligne_o:=New object:C1471()
		
		  // On boucle sur chaque colonne des données.
		For each (dataColumn_o;This:C1470.data)
			dataligne_o[dataColumn_o.name]:=Formula from string:C1601(Replace string:C233(dataColumn_o.value;"this.";"dataInBase_o.")).call()
		End for each 
		
		This:C1470.data_c.push(dataligne_o)
		
	End for each 
	
	
	
	
Function getHtml
/* -----------------------------------------------------------------------------
Fonction : dataTable.html
	
Génére le code HTML pour le tableau.
	
Historique
28/07/20 - Grégory Fromain <gregory@connect-io.fr> - Creation
----------------------------------------------------------------------------- */
	C_TEXT:C284($0)
	
	$0:="<table id=\""+This:C1470.lib+"\" class=\"table table-striped table-bordered\" width=\"100%\"></table>"
	
	
	
Function ajaxReload
	
	
Function ajaxRowRemove
	
	
	
Function ajaxRowAdd