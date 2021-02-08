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
	
	
	
Function dataColor
/* -----------------------------------------------------------------------------
Fonction : Chart.dataColor
	
Permet d'appliquer une couleur prédefinie à une courbe. Si la couleur n'existe pas ,renvoie du noir
	
Historique
04/02/21 - Alban Catoire <alban@connect-io.fr> - Creation
-----------------------------------------------------------------------------*/
	
	var $1 : Text  // Le label de la courbe 
	var $2 : Text  // La couleur à utiliser, du type "green", "yellow", "red" ...
	var $couleur_s : Collection
	var $couleur_rgb : Collection
	var $indiceCouleur_i : Integer
	var $indiceLabel_i : Integer
	
	ASSERT:C1129($1#"";"Chart.dataOption : La param $1 ne doit pas être vide.")
	ASSERT:C1129($2#"";"Chart.dataOption : La param $2 ne doit pas être vide.")
	
	$couleur_s:=New collection:C1472("green";"red";"yellow";"blue";"indigo";"purple";"pink";"orange";"black";"brown";"grey")
	$couleur_rgb:=New collection:C1472(\
		"rgba(27, 203, 27,";\
		"rgba(194, 16, 16,";\
		"rgba(246, 242, 6,";\
		"rgba(16, 141, 222,";\
		"rgba(33, 91, 153,";\
		"rgba(191, 63, 200,";\
		"rgba(213, 70, 24,";\
		"rgba(0, 0, 0,";\
		"rgba(115, 38, 13,";\
		"rgba(100, 91, 89,")
	$indiceCouleur_i:=$Couleur_s.indexOf($2)
	
	
	If (This:C1470.data.datasets.indices("label IS :1";$1).length=1)
		$indiceLabel_i:=This:C1470.data.datasets.indices("label IS :1";$1)[0]
		If $indiceCouleur_i#-1
			This:C1470.data.datasets[$indiceLabel_i].backgroundColor:=$couleur_rgb[$indiceCouleur_i]+"0.2)"
			This:C1470.data.datasets[$indiceLabel_i].borderColor:=$Couleur_rgb[$indiceCouleur_i]+"1)"
		Else 
			This:C1470.data.datasets[$indiceLabel_i].backgroundColor:="rgba(0, 0, 0, 0.2)"
			This:C1470.data.datasets[$indiceLabel_i].borderColor:="rgba(0, 0, 0, 1)"
		End if 
	End if 
	
/*
var $color_c : Collection  // liste des couleurs prédéfinis.
var $2;$color_t :Text
var $color_o : Object // Couleur sélectionné.
	
ASSERT($1#"";"Chart.dataColor : Le param $1 (Nom du label) ne doit pas être vide.")
ASSERT($2#"";"Chart.dataColor : Le param $2 (Nom de la couleur) ne doit pas être vide.")
ASSERT(This.data.datasets.indices("label IS :1";$1).length#0;"Chart.dataColor : Le param $1 (Nom du label) ne correspond à aucune courbe.")
	
$color_t:=$2
	
$color_c:=New collection()
$color_c.push(New object("r";255;"g";255;"b";255;"name";"white"))
$color_c.push(New object("r";027;"g";203;"b";027;"name";"green"))
$color_c.push(New object("r";194;"g";016;"b";016;"name";"red"))
$color_c.push(New object("r";246;"g";242;"b";006;"name";"yellow"))
$color_c.push(New object("r";016;"g";141;"b";222;"name";"blue"))
$color_c.push(New object("r";033;"g";091;"b";153;"name";"indigo"))
$color_c.push(New object("r";191;"g";063;"b";200;"name";"purple"))
$color_c.push(New object("r";191;"g";063;"b";200;"name";"pink"))
$color_c.push(New object("r";213;"g";070;"b";024;"name";"orange"))
$color_c.push(New object("r";000;"g";000;"b";000;"name";"black"))
$color_c.push(New object("r";115;"g";038;"b";013;"name";"brown"))
$color_c.push(New object("r";100;"g";091;"b";089;"name";"grey"))
//...
// Bonus :  Couleur aléatoire
$color_c.push(New object("r";Random%257;"g";Random%257;"b";Random%257;"name";"random"))
	
If ($color_c.query("name IS :1";$2).length=0)
$color_t:="black"
End if 
	
$color_o:=$color_c.query("name IS :1";$color_t)[0]
	
$indiceLabel_i:=This.data.datasets.indices("label IS :1";$1)[0]
	
This.data.datasets[$indiceLabel_i].backgroundColor:="rgba("+$color_o.r+", "+$color_o.g+", "+$color_o.b+", 0.2)"
This.data.datasets[$indiceLabel_i].borderColor:="rgba("+$color_o.r+", "+$color_o.g+", "+$color_o.b+", 1)"
*/
	
	
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
	
Permet de changer le type du graph (bar, line, camembert...)
	
Historique
04/02/21 - Alban Catoire <alban@connect-io.fr> - Creation
-----------------------------------------------------------------------------*/
	
	var $1 : Text  // Le type de graph à utiliser 
	
	ASSERT:C1129($1#"";"Chart.dataOption : La param $1 ne doit pas être vide.")
	This:C1470.type:=$1
	
	