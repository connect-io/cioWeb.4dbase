/* 
Class : cs.Chart

Gestion des tableaux de données en HTML.

*/



Class constructor($libChart_t : Text; $modele_t : Text)
/*------------------------------------------------------------------------------
Fonction : Chart.constructor
	
Initialisation d'un graphique

Paramètres
	$libChart_t -> Nom du graphique
	$modele_t   -> (optionnel) le modele que l'on souhaite utiliser.
	
Historiques
03/02/21 - Grégory Fromain <gregory@connect-io.fr> - Création
01/12/21 - Jonathan Fernandez <jonathan@connect-io.fr> - Maj param dans la Class constructor
------------------------------------------------------------------------------*/
	
	var $propriete_t : Text
	
	ASSERT:C1129($libChart_t#""; "Chart.constructor : Le param $libChart_t est manquante.")
	ASSERT:C1129(visiteur.sousDomaine#""; "Chart.constructor : Le param visiteur n'est pas initialisé.")
	
	If (Count parameters:C259=1)
		
		$chartConfig_o:=Storage:C1525.sites[visiteur.sousDomaine].chart.query("lib IS :1"; $libChart_t).copy()
	Else 
		
		$chartConfig_o:=Storage:C1525.sites[visiteur.sousDomaine].chart.query("lib IS :1"; $modele_t).copy()
	End if 
	
	ASSERT:C1129($chartConfig_o.length#0; "WebApp.chartNew : Impossible de retrouver le graphique : "+$libChart_t)
	
	For each ($propriete_t; $chartConfig_o[0])
		This:C1470[$propriete_t]:=$chartConfig_o[0][$propriete_t]
	End for each 
	
	If (Count parameters:C259=2)
		This:C1470.lib:=$libChart_t
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
	
	
	
Function getHtml()->$codeHtml_t : Text
/*------------------------------------------------------------------------------
Fonction : Chart.getHtml
	
Génére le code HTML pour le graphique.

Paramètre
$codeHtml_t <- Le text à insérer dans le code HTML
	
Historiques
03/02/21 - Grégory Fromain <gregory@connect-io.fr> - Creation
30/11/21 - Jonathan Fernandez <jonathan@connect-io.fr> - Maj param dans la fonction
------------------------------------------------------------------------------*/
	
	$codeHtml_t:="<canvas id=\""+This:C1470.lib+"\"></canvas>"
	
	
	
Function dataColor($labelName_t : Text; $colorName_t : Text)
/*------------------------------------------------------------------------------
Fonction : Chart.dataColor
	
Permet d'appliquer une couleur prédefinie à une courbe. Si la couleur n'existe pas, renvoie du noir
	
Historiques
04/02/21 - Alban Catoire <alban@connect-io.fr> - Creation
30/11/21 - Jonathan Fernandez <jonathan@connect-io.fr> - Maj param dans la fonction
------------------------------------------------------------------------------*/
	
	var $color_c : Collection  // liste des couleurs prédéfinis.
	var $color_t : Text
	var $color_o : Object  // Couleur sélectionné.
	
	ASSERT:C1129($labelName_t#""; "Chart.dataColor : Le param $labelName_t ne doit pas être vide.")
	ASSERT:C1129($colorName_t#""; "Chart.dataColor : Le param $colorName_t ne doit pas être vide.")
	ASSERT:C1129(This:C1470.data.datasets.indices("label IS :1"; $labelName_t).length#0; "Chart.dataColor : Le param $labelName_t ne correspond à aucune courbe.")
	
	$color_t:=$colorName_t
	
	$color_c:=New collection:C1472()
	$color_c.push(New object:C1471("r"; "255"; "g"; "255"; "b"; "255"; "name"; "white"))
	$color_c.push(New object:C1471("r"; "27"; "g"; "203"; "b"; "27"; "name"; "green"))
	$color_c.push(New object:C1471("r"; "194"; "g"; "16"; "b"; "16"; "name"; "red"))
	$color_c.push(New object:C1471("r"; "246"; "g"; "242"; "b"; "6"; "name"; "yellow"))
	$color_c.push(New object:C1471("r"; "16"; "g"; "141"; "b"; "222"; "name"; "blue"))
	$color_c.push(New object:C1471("r"; "33"; "g"; "91"; "b"; "153"; "name"; "indigo"))
	$color_c.push(New object:C1471("r"; "191"; "g"; "63"; "b"; "200"; "name"; "purple"))
	$color_c.push(New object:C1471("r"; "252"; "g"; "63"; "b"; "155"; "name"; "pink"))
	$color_c.push(New object:C1471("r"; "213"; "g"; "70"; "b"; "24"; "name"; "orange"))
	$color_c.push(New object:C1471("r"; "0"; "g"; "0"; "b"; "0"; "name"; "black"))
	$color_c.push(New object:C1471("r"; "115"; "g"; "38"; "b"; "13"; "name"; "brown"))
	$color_c.push(New object:C1471("r"; "100"; "g"; "91"; "b"; "89"; "name"; "grey"))
	//...
	// Bonus :  Couleur aléatoire
	$color_c.push(New object:C1471("r"; String:C10(Random:C100%256); "g"; String:C10(Random:C100%256); "b"; String:C10(Random:C100%256); "name"; "random"))
	
	If ($color_c.query("name IS :1"; $colorName_t).length=0)
		$color_t:="black"
	End if 
	
	$color_o:=$color_c.query("name IS :1"; $color_t)[0]
	
	$indiceLabel_i:=This:C1470.data.datasets.indices("label IS :1"; $labelName_t)[0]
	
	This:C1470.data.datasets[$indiceLabel_i].backgroundColor:="rgba("+$color_o.r+", "+$color_o.g+", "+$color_o.b+", 0.2)"
	This:C1470.data.datasets[$indiceLabel_i].borderColor:="rgba("+$color_o.r+", "+$color_o.g+", "+$color_o.b+", 1)"
	
	
	
Function dataOption($labelName_t : Text; $option_o : Object)
/*------------------------------------------------------------------------------
Fonction : Chart.dataOption
	
Charger les options des data dans le graphique.
	
Historiques
03/02/21 - Grégory Fromain <gregory@connect-io.fr> - Creation
30/11/21 - Jonathan Fernandez <jonathan@connect-io.fr> - Maj param dans la fonction
------------------------------------------------------------------------------*/

	var $indice_i : Integer
	var $data_o : Object
	
	ASSERT:C1129($labelName_t#""; "Chart.dataOption : Le param $labelName_t ne doit pas être vide.")
	ASSERT:C1129($option_o#Null:C1517; "Chart.dataOption : Le param $option_o ne doit pas être null.")
	
	If (This:C1470.data.datasets.indices("label IS :1"; $labelName_t).length=1)
		$indice_i:=This:C1470.data.datasets.indices("label IS :1"; $labelName_t)[0]
		This:C1470.data.datasets[$indice_i]:=cwToolObjectMerge(This:C1470.data.datasets[$indice_i]; $option_o)
	Else 
		$data_o:=New object:C1471()
		$data_o:=$option_o.copy()
		$data_o.label:=$labelName_t
		This:C1470.data.datasets.push($data_o)
	End if 
	
	
	
Function dataSet($labelName_t : Text; $data_c : Collection)
/*------------------------------------------------------------------------------
Fonction : Chart.dataSet
	
Charge les valeurs des données d'une courbe dans le graphique.
	
Historiques
03/02/21 - Grégory Fromain <gregory@connect-io.fr> - Creation
30/11/21 - Jonathan Fernandez <jonathan@connect-io.fr> - Maj param dans la fonction
------------------------------------------------------------------------------*/
	
	var $indice_i : Integer
	var $data_o : Object
	
	ASSERT:C1129($labelName_t#Null:C1517; "Chart.dataSet : La param $labelName_t ne doit pas être null. Vous n'avez pas indiqué le label")
	ASSERT:C1129($data_c #Null:C1517; "Chart.dataSet : La param $data_c ne doit pas être null. Vous n'avez pas rentré de données")
	
	If (This:C1470.data.datasets.indices("label IS :1"; $labelName_t).length=1)
		$indice_i:=This:C1470.data.datasets.indices("label IS :1"; $labelName_t)[0]
		This:C1470.data.datasets[$indice_i].data:=$data_c .copy()
	Else 
		$data_o:=New object:C1471()
		$data_o.label:=$labelName_t
		$data_o.data:=$data_c .copy()
		This:C1470.data.datasets.push($data_o)
	End if 
	
	
	
Function labelSet($label_c : Collection)
/*------------------------------------------------------------------------------
Fonction : Chart.labelSet
	
Charger les labels dans le graphique.
	
Historiques
03/02/21 - Grégory Fromain <gregory@connect-io.fr> - Creation
30/11/21 - Jonathan Fernandez <jonathan@connect-io.fr> - Maj param dans la fonction
------------------------------------------------------------------------------*/
	
	This:C1470.data.labels:=$label_c.copy()
	
	
	
Function optionsMerge($options_o : Object)
/*------------------------------------------------------------------------------
Fonction : Chart.optionsMerge
	
Charger les options du graphique.
	
Historiques
03/02/21 - Grégory Fromain <gregory@connect-io.fr> - Creation
30/11/21 - Jonathan Fernandez <jonathan@connect-io.fr> - Maj param dans la fonction
------------------------------------------------------------------------------*/
	
	ASSERT:C1129($options_o#Null:C1517; "Chart.optionsMerge : La param $options_o ne doit pas être null.")
	
	This:C1470.options:=cwToolObjectMerge(This:C1470.options; $1)
	
	
	
Function titleSet($title_t : Text)
/*------------------------------------------------------------------------------
Fonction : Chart.titleSet
	
Permet de definir le titre du graph 

Paramètre
$title_t -> Titre du graphique
	
Historiques
05/02/21 - Alban Catoire <alban@connect-io.fr> - Creation
30/11/21 - Jonathan Fernandez <jonathan@connect-io.fr> - Maj param dans la fonction
------------------------------------------------------------------------------*/

	var $title_o : Object
	
	ASSERT:C1129($title_t#Null:C1517; "Chart.titleSet : Le param $title_t ne doit pas être null.")
	
	$title_o:=New object:C1471("title"; New object:C1471("display"; True:C214; "text"; $title_t))
	If (This:C1470.options.title#Null:C1517)
		This:C1470.options.title.display:=True:C214
		This:C1470.options.title.text:=$title_t
	Else 
		This:C1470.optionsMerge($title_o)
	End if 
	
	
	
Function typeSet($type_t : Text)
/*------------------------------------------------------------------------------
Fonction : Chart.typeSet
	
Permet de changer le type du graph (bar, line, camembert...). Si le parametre est inconnu, on initialise avec un graph line.

Paramètre
$type_t -> Le type de graph à utiliser 

Historiques
04/02/21 - Alban Catoire <alban@connect-io.fr> - Creation
30/11/21 - Jonathan Fernandez <jonathan@connect-io.fr> - Maj param dans la fonction
------------------------------------------------------------------------------*/
	
	var $typePossible_c : Collection
	
	ASSERT:C1129($type_t#""; "Chart.typeSet : La param $type_t ne doit pas être vide.")
	$typePossible_c:=New collection:C1472("bar"; "line"; "pie"; "radar"; "polarArea"; "bubble"; "scatter")
	ASSERT:C1129($typePossible_c.indexOf($type_t)#-1; "Chart.typeSet : Le param $type_t ne correspond à aucun type de courbe.")
	If $typePossible_c.indexOf($type_t)#-1
		This:C1470.type:=$type_t
	Else 
		This:C1470.type:="line"
	End if 
	