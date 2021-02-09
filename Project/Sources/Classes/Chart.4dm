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
	
	var $0 : Text  // Le text à insérer dans le code HTML
	
	$0:="<canvas id=\""+This:C1470.lib+"\"></canvas>"
	
	
	
Function dataColor
/* -----------------------------------------------------------------------------
Fonction : Chart.dataColor
	
Permet d'appliquer une couleur prédefinie à une courbe. Si la couleur n'existe pas ,renvoie du noir
	
Historique
04/02/21 - Alban Catoire <alban@connect-io.fr> - Creation
-----------------------------------------------------------------------------*/
	
	var $color_c : Collection  // liste des couleurs prédéfinis.
	var $1;$2;$color_t : Text
	var $color_o : Object  // Couleur sélectionné.
	
	ASSERT:C1129($1#"";"Chart.dataColor : Le param $1 (Nom du label) ne doit pas être vide.")
	ASSERT:C1129($2#"";"Chart.dataColor : Le param $2 (Nom de la couleur) ne doit pas être vide.")
	ASSERT:C1129(This:C1470.data.datasets.indices("label IS :1";$1).length#0;"Chart.dataColor : Le param $1 (Nom du label) ne correspond à aucune courbe.")
	
	$color_t:=$2
	
	$color_c:=New collection:C1472()
	$color_c.push(New object:C1471("r";"255";"g";"255";"b";"255";"name";"white"))
	$color_c.push(New object:C1471("r";"27";"g";"203";"b";"27";"name";"green"))
	$color_c.push(New object:C1471("r";"194";"g";"16";"b";"16";"name";"red"))
	$color_c.push(New object:C1471("r";"246";"g";"242";"b";"6";"name";"yellow"))
	$color_c.push(New object:C1471("r";"16";"g";"141";"b";"222";"name";"blue"))
	$color_c.push(New object:C1471("r";"33";"g";"91";"b";"153";"name";"indigo"))
	$color_c.push(New object:C1471("r";"191";"g";"63";"b";"200";"name";"purple"))
	$color_c.push(New object:C1471("r";"252";"g";"63";"b";"155";"name";"pink"))
	$color_c.push(New object:C1471("r";"213";"g";"70";"b";"24";"name";"orange"))
	$color_c.push(New object:C1471("r";"0";"g";"0";"b";"0";"name";"black"))
	$color_c.push(New object:C1471("r";"115";"g";"38";"b";"13";"name";"brown"))
	$color_c.push(New object:C1471("r";"100";"g";"91";"b";"89";"name";"grey"))
	//...
	// Bonus :  Couleur aléatoire
	$color_c.push(New object:C1471("r";String:C10(Random:C100%256);"g";String:C10(Random:C100%256);"b";String:C10(Random:C100%256);"name";"random"))
	
	If ($color_c.query("name IS :1";$2).length=0)
		$color_t:="black"
	End if 
	
	$color_o:=$color_c.query("name IS :1";$color_t)[0]
	
	$indiceLabel_i:=This:C1470.data.datasets.indices("label IS :1";$1)[0]
	
	This:C1470.data.datasets[$indiceLabel_i].backgroundColor:="rgba("+$color_o.r+", "+$color_o.g+", "+$color_o.b+", 0.2)"
	This:C1470.data.datasets[$indiceLabel_i].borderColor:="rgba("+$color_o.r+", "+$color_o.g+", "+$color_o.b+", 1)"
	
	
	
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
	
	ASSERT:C1129($1#"";"Chart.dataOption : Le param $1 ne doit pas être vide.")
	ASSERT:C1129($2#Null:C1517;"Chart.dataOption : Le param $2 ne doit pas être null.")
	
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
	
Charge les valeurs des données d'une courbe dans le graphique.
	
Historique
03/02/21 - Grégory Fromain <gregory@connect-io.fr> - Creation
-----------------------------------------------------------------------------*/
	
	var $1 : Text
	var $2 : Collection
	var $indice_i : Integer
	var $data_o : Object
	
	ASSERT:C1129($1#Null:C1517;"Chart.dataSet : La param $1 ne doit pas être null. Vous n'avez pas indiqué le label")
	ASSERT:C1129($1#Null:C1517;"Chart.dataSet : La param $2 ne doit pas être null. Vous n'avez pas rentré de données")
	
	If (This:C1470.data.datasets.indices("label IS :1";$1).length=1)
		$indice_i:=This:C1470.data.datasets.indices("label IS :1";$1)[0]
		This:C1470.data.datasets[$indice_i].data:=$2.copy()
	Else 
		$data_o:=New object:C1471()
		$data_o.label:=$1
		$data_o.data:=$2.copy()
		This:C1470.data.datasets.push($data_o)
	End if 
	
	
	
Function labelSet
/* -----------------------------------------------------------------------------
Fonction : Chart.labelSet
	
Charger les labels dans le graphique.
	
Historique
03/02/21 - Grégory Fromain <gregory@connect-io.fr> - Creation
-----------------------------------------------------------------------------*/
	
	var $1 : Collection
	
	This:C1470.data.labels:=$1.copy()
	
	
	
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
	
	
	
Function titleSet
/* -----------------------------------------------------------------------------
Fonction : Chart.titleSet
	
Permet de definir le titre du graph 
	
Historique
05/02/21 - Alban Catoire <alban@connect-io.fr> - Creation
-----------------------------------------------------------------------------*/
	var $1 : Text  // Le titre du graph
	var $title_o : Object
	
	ASSERT:C1129($1#Null:C1517;"Chart.titleSet : Le param $1 ne doit pas être null.")
	
	$title_o:=New object:C1471("title";New object:C1471("display";True:C214;"text";$1))
	If (This:C1470.options.title#Null:C1517)
		This:C1470.options.title.display:=True:C214
		This:C1470.options.title.text:=$1
	Else 
		This:C1470.optionsMerge($title_o)
	End if 
	
	
	
Function typeSet
/* -----------------------------------------------------------------------------
Fonction : Chart.typeSet
	
Permet de changer le type du graph (bar, line, camembert...). Si le parametre est inconnu, on initialise avec un graph line.
	
Historique
04/02/21 - Alban Catoire <alban@connect-io.fr> - Creation
-----------------------------------------------------------------------------*/
	
	var $1 : Text  // Le type de graph à utiliser 
	var $typePossible_c : Collection
	
	ASSERT:C1129($1#"";"Chart.typeSet : La param $1 ne doit pas être vide.")
	$typePossible_c:=New collection:C1472("bar";"line";"pie";"radar";"polarArea";"bubble";"scatter")
	ASSERT:C1129($typePossible_c.indexOf($1)#-1;"Chart.typeSet : Le param $1 ne correspond à aucun type de courbe.")
	If $typePossible_c.indexOf($1)#-1
		This:C1470.type:=$1
	Else 
		This:C1470.type:="line"
	End if 
	