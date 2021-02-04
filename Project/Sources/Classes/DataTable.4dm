/* 
Class : cs.DataTable

Gestion des tableaux de données en HTML.

*/


Class constructor
/* -----------------------------------------------------------------------------
Fonction : DataTable.constructor
	
Initialisation d'une dataTable
	
Historique
21/07/20 - Grégory Fromain <gregory@connect-io.fr> - Réflexion
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
-----------------------------------------------------------------------------*/
	
	var $1 : Text  // Le lib de la dataTable.
	
	var $propriete_t : Text
	
	ASSERT:C1129($1#"";"dataTable.constructor : Le param $1 est manquante.")
	ASSERT:C1129(visiteur.sousDomaine#"";"dataTable.constructor : Le param visiteur n'est pas initialisé.")
	
	$dataTableConfig_o:=Storage:C1525.sites[visiteur.sousDomaine].dataTable.query("lib IS :1";$1).copy()
	
	ASSERT:C1129($dataTableConfig_o.length#0;"WebApp.dataTableNew : Impossible de retrouver la dataTable : "+$1)
	
	For each ($propriete_t;$dataTableConfig_o[0])
		This:C1470[$propriete_t]:=$dataTableConfig_o[0][$propriete_t]
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
		
		This:C1470.doubleClick.link:=cwLibToUrl(This:C1470.doubleClick.link;This:C1470.doubleClick.linkVariable)
		
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
		
		This:C1470.ajax.link:=cwLibToUrl(This:C1470.ajax.link;This:C1470.ajax.linkVariable)
		
		// Securité navigateur
		This:C1470.ajax.linkVariable:=Null:C1517
	End if 
	
	
Function addData
/* -----------------------------------------------------------------------------
Fonction : DataTable.addData
	
Ajoute une ligne à votre tableau.
	
Historique
16/10/20 - Grégory Fromain <gregory@connect-io.fr> - Creation
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
-----------------------------------------------------------------------------*/
	
	var $1 : Collection
	
	This:C1470.data_c.push($1)
	
	
Function getHtml
/* -----------------------------------------------------------------------------
Fonction : DataTable.getHtml
	
Génére le code HTML pour le tableau.
	
Historique
28/07/20 - Grégory Fromain <gregory@connect-io.fr> - Creation
-----------------------------------------------------------------------------*/
	
	var $0 : Text
	
	$0:="<table id=\""+This:C1470.lib+"\" class=\"table table-striped table-bordered\" width=\"100%\"></table>"
	
	
	
Function sendDataAjax
/* -----------------------------------------------------------------------------
Fonction : DataTable.sendDataAjax
	
Génére le JSON des données à renvoyer au navigateur.
	
Historique
16/10/20 - Grégory Fromain <gregory@connect-io.fr> - Creation
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
-----------------------------------------------------------------------------*/
	
	var $0 : Text
	
	$0:=JSON Stringify:C1217(New object:C1471("data";This:C1470.data_c))
	
	
	
Function setData
/* -----------------------------------------------------------------------------
Fonction : DataTable.setData
	
Charger les data dans le tableau de donnée.
	
Historique
28/07/20 - Grégory Fromain <gregory@connect-io.fr> - Creation
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
-----------------------------------------------------------------------------*/
	
	var $1;$source_v : Variant  // Entité selection
	
	var dataInBase_o : Object
	var dataligne_o : Object
	var dataColumn_o : Object
	
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
	
	