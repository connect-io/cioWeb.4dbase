/* 
Class : cs.Chart

Gestion des tableaux de données en HTML.

*/


Class constructor
/* -----------------------------------------------------------------------------
Fonction : Chart.constructor
	
Initialisation d'un graphique
	
Historique
03/02/21 - Grégory Fromain <gregory@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	
	var $1 : Text  // Le lib du graphique.
	var $2 : Text  // (optionnel) le modele que l'on souhaite utiliser.
	
	var $propriete_t : Text
	
	ASSERT:C1129($1#"";"Chart.constructor : Le param $1 est manquante.")
	ASSERT:C1129(visiteur.sousDomaine#"";"Chart.constructor : Le param visiteur n'est pas initialisé.")
	
	If (Count parameters:C259=1)
		
		$chartConfig_o:=Storage:C1525.sites[visiteur.sousDomaine].chart.query("lib IS :1";$1).copy()
	Else 
		
		$chartConfig_o:=Storage:C1525.sites[visiteur.sousDomaine].chart.query("lib IS :1";$2).copy()
	End if 
	
	ASSERT:C1129($chartConfig_o.length#0;"WebApp.chartNew : Impossible de retrouver le graphique : "+$1)
	
	For each ($propriete_t;$chartConfig_o[0])
		This:C1470[$propriete_t]:=$chartConfig_o[0][$propriete_t]
	End for each 
	
	If (Count parameters:C259=2)
		This:C1470.lib:=$1
	End if 
	
	If (This:C1470.data=Null:C1517)
		This:C1470.data:=New object:C1471()
	End if 
	
	If (This:C1470.data.labels=Null:C1517)
		This:C1470.data.labels:=New object:C1471()
	End if 
	
	If (This:C1470.data.datasets=Null:C1517)
		This:C1470.data.datasets:=New object:C1471()
	End if 
	
	If (This:C1470.options=Null:C1517)
		This:C1470.options:=New object:C1471()
	End if 
	
	
	
Function getHtml
/* -----------------------------------------------------------------------------
Fonction : Chart.getHtml
	
Génére le code HTML pour le graphique.
	
Historique
03/02/21 - Grégory Fromain <gregory@connect-io.fr> - Creation
-----------------------------------------------------------------------------*/
	
	var $0 : Text
	
	$0:="<canvas id=\""+This:C1470.lib+"\"></canvas>"
	
	
	
Function optionsMerge
/* -----------------------------------------------------------------------------
Fonction : Chart.optionsMerge
	
Charger les options du graphique.
	
Historique
03/02/21 - Grégory Fromain <gregory@connect-io.fr> - Creation
-----------------------------------------------------------------------------*/
	
	var $1 : Object
	
	ASSERT:C1129($1#Null:C1517;"Chart.optionsMerge : La param $1 ne doit pas être null.")
	
	This:C1470.options:=cwToolObjectMerge(This:C1470.options;$1)
	
	
	
Function dataOption
/* -----------------------------------------------------------------------------
Fonction : Chart.dataOption
	
Charger les options des data dans le graphique.
	
Historique
03/02/21 - Grégory Fromain <gregory@connect-io.fr> - Creation
-----------------------------------------------------------------------------*/
	
	var $1 : Text
	var $2 : Object
	var $indice_i : Integer
	var $data_o : Object
	
	ASSERT:C1129($1#"";"Chart.dataOption : La param $1 ne doit pas être vide.")
	ASSERT:C1129($2#Null:C1517;"Chart.dataOption : La param $2 ne doit pas être null.")
	
	If (This:C1470.data.datasets.indices("label IS :1";$1).length=1)
		$indice_i:=This:C1470.data.datasets.indices("label IS :1";$1)[0]
		This:C1470.data.datasets[$indice_i]:=cwToolObjectMerge(This:C1470.data.datasets[$indice_i];$2)
	Else 
		$data_o:=New object:C1471()
		$data_o:=$2.copy()
		$data_o.label:=$1
		This:C1470.data.datasets.push($data_o)
	End if 
	
	
	
Function dataSet
/* -----------------------------------------------------------------------------
Fonction : Chart.dataSet
	
Charger les value des data dans le graphique.
	
Historique
03/02/21 - Grégory Fromain <gregory@connect-io.fr> - Creation
-----------------------------------------------------------------------------*/
	
	var $1 : Text
	var $2 : Collection
	var $indice_i : Integer
	var $data_o : Object
	
	If (This:C1470.data.datasets.indices("label IS :1";$1).length=1)
		$indice_i:=This:C1470.data.datasets.indices("label IS :1";$1)[0]
		This:C1470.data.datasets[$indice_i].data:=$2.copy()
	Else 
		$data_o:=New object:C1471()
		$data_o.label:=$1
		$data_o.data:=$2.copy()
		This:C1470.data.datasets.push($data_o)
	End if 
	
	
	
Function label
/* -----------------------------------------------------------------------------
Fonction : Chart.label
	
Charger les labels dans le graphique.
	
Historique
03/02/21 - Grégory Fromain <gregory@connect-io.fr> - Creation
-----------------------------------------------------------------------------*/
	
	var $1 : Collection
	
	This:C1470.data.labels:=$1.copy()
	
	