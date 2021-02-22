//%attributes = {"publishedWeb":true,"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwGetVersion

Permet de recuperer la version de 4D

Historique
13/11/2020 - Titouan Guillon titouan@connect-io.fr> - Création
-----------------------------------------------------------------------------*/

// Déclarations
var $0 : Text

var $version_t : Text
var $major_t : Text
var $release_t : Text
var $info_t : Text
var $minor_t : Text

$version_t:=Application version:C493()
$major_t:=$version_t[[1]]+$version_t[[2]]  //numéro de version, p.e. 14
$release_t:=$version_t[[3]]  //Rx
$minor_t:=$version_t[[4]]  //.x

$info_t:="4D v"+$major_t
If ($release_t="0")  //4D v14.x
	$info_t:=$info_t+Choose:C955($minor_t#"0";"."+$minor_t;"")
	
Else   //4D v14 Rx
	$info_t:=$info_t+" R"+$release_t
End if 


$0:=$info_t