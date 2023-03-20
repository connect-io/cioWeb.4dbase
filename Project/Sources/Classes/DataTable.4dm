/* 
Class : cs.DataTable

Gestion des tableaux de données en HTML.

*/


Class constructor($dataTableLib_t : Text)
/*------------------------------------------------------------------------------
Fonction : DataTable.constructor
	
Initialisation d'une dataTable
	
Paramètre
$dataTableLib_t -> Le lib de la dataTable.
	
Historique
21/07/20 - Grégory Fromain <gregory@connect-io.fr> - Réflexion
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
24/02/21 - Grégory Fromain <gregory@connect-io.fr> - Maj appel param dans la fonction
------------------------------------------------------------------------------*/
	
	var $propriete_t : Text
	
	ASSERT:C1129($dataTableLib_t#""; "DataTable.constructor : Le param $dataTableLib_t est manquante.")
	ASSERT:C1129(visiteur.sousDomaine#""; "DataTable.constructor : Le param visiteur n'est pas initialisé.")
	
	$dataTableConfig_c:=Storage:C1525.sites[visiteur.sousDomaine].dataTable.query("lib IS :1"; $dataTableLib_t).copy()
	
	ASSERT:C1129($dataTableConfig_c.length#0; "DataTable.constructor : Impossible de retrouver la dataTable : "+$dataTableLib_t)
	
	For each ($propriete_t; $dataTableConfig_c[0])
		This:C1470[$propriete_t]:=$dataTableConfig_c[0][$propriete_t]
	End for each 
	
	This:C1470.column_c:=This:C1470.column
	This:C1470.data_c:=New collection:C1472()
	
	//----- Gestion du double click -----
	If (This:C1470.doubleClick#Null:C1517)
		
		// On génére l'url du double click sur une ligne du dataTable.
		ASSERT:C1129(This:C1470.doubleClick.link#""; "dataTable.constructor : La propriété $dataTable_o.doubleClick.link n'est pas définit dans "+This:C1470.lib)
		
		If (This:C1470.doubleClick.linkVariable=Null:C1517)
			This:C1470.doubleClick.linkVariable:=New object:C1471
		End if 
		
		This:C1470.doubleClick.link:=cwLibToUrl(This:C1470.doubleClick.link; This:C1470.doubleClick.linkVariable)
		
		// Securité navigateur
		This:C1470.doubleClick.linkVariable:=Null:C1517
	End if 
	
	
	//----- Gestion du lien en ajax -----
	If (This:C1470.ajax#Null:C1517)
		
		// On génére l'url du double click sur une ligne du dataTable.
		ASSERT:C1129(This:C1470.ajax.link#""; "dataTable.constructor : La propriété $dataTable_o.ajax.link n'est pas définit dans "+This:C1470.lib)
		
		If (This:C1470.ajax.linkVariable=Null:C1517)
			This:C1470.ajax.linkVariable:=New object:C1471
		End if 
		
		This:C1470.ajax.link:=cwLibToUrl(This:C1470.ajax.link; This:C1470.ajax.linkVariable)
		
		// Securité navigateur
		This:C1470.ajax.linkVariable:=Null:C1517
	End if 
	
	
Function addData($ligneData_c : Collection)
/*------------------------------------------------------------------------------
Fonction : DataTable.addData
	
Ajoute une ligne à votre tableau.
	
Paramètre
$ligneData_c <- Data de la ligne
	
Historique
16/10/20 - Grégory Fromain <gregory@connect-io.fr> - Creation
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
24/02/21 - Grégory Fromain <gregory@connect-io.fr> - Maj appel param dans la fonction
------------------------------------------------------------------------------*/
	
	This:C1470.data_c.push($ligneData_c)
	
	
	
Function getHtml()->$html_t : Text
/*------------------------------------------------------------------------------
Fonction : DataTable.getHtml
	
Génére le code HTML pour le tableau.
	
Paramètre
$html_t <- Code HTML renvoyé
	
Historique
28/07/20 - Grégory Fromain <gregory@connect-io.fr> - Creation
24/02/21 - Grégory Fromain <gregory@connect-io.fr> - Maj appel param dans la fonction
------------------------------------------------------------------------------*/
	
	$html_t:="<table id=\""+This:C1470.lib+"\" class=\"table table-striped table-bordered\" width=\"100%\"></table>"
	
	
	
Function sendDataAjax()->$dataJson_t : Text
/*------------------------------------------------------------------------------
Fonction : DataTable.sendDataAjax
	
Génére le JSON des données à renvoyer au navigateur.
	
Paramètre
$dataJson_t <- JSON renvoyé
	
Historique
16/10/20 - Grégory Fromain <gregory@connect-io.fr> - Creation
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
24/02/21 - Grégory Fromain <gregory@connect-io.fr> - Maj appel param dans la fonction
------------------------------------------------------------------------------*/
	
	$dataJson_t:=JSON Stringify:C1217(New object:C1471("data"; This:C1470.data_c))
	
	
	
Function setData($source_v : Variant)
/*------------------------------------------------------------------------------
Fonction : DataTable.setData
	
Charger les data dans le tableau de donnée.
	
Paramètre
$source_v -> Entité selection ou collection
	
Historique
28/07/20 - Grégory Fromain <gregory@connect-io.fr> - Creation
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
24/02/21 - Grégory Fromain <gregory@connect-io.fr> - Maj appel param dans la fonction
------------------------------------------------------------------------------*/
	
	var $dataligne_o; $dataColumn_o : Object
	var dataInBase_o : Object
	
	If ($source_v=Null:C1517)
		ALERT:C41("dataTable.setData : Le paramêtre $source_v ($1) n'est pas défini dans la datatable "+This:C1470.lib)
	End if 
	
	// On purge les datas... Sinon cela concaténe les lignes.
	Use (This:C1470)
		This:C1470.data_c:=New shared collection:C1527()
		
		// On boucle sur chaque élément de la source...
		// Attention de bien conserver les variables dataInBase_o et dataColumn_o pour pouvoir utiliser le Formula from string
		For each (dataInBase_o; $source_v)
			$dataligne_o:=New object:C1471()
			
			// On boucle sur chaque colonne des données.
			For each ($dataColumn_o; This:C1470.data)
				$dataligne_o[$dataColumn_o.name]:=Formula from string:C1601(Replace string:C233($dataColumn_o.value; "this."; "dataInBase_o.")).call()
			End for each 
			
			Use (This:C1470.data_c)
				This:C1470.data_c.push(OB Copy:C1225($dataligne_o; ck shared:K85:29))
			End use 
			
		End for each 
		
	End use 