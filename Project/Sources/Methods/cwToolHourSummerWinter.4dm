//%attributes = {"shared":true,"preemptive":"capable"}
// ----------------------------------------------------
// Nom utilisateur (OS) : Programmeur
// Date et heure : 13/07/20, 16:31:05
// ----------------------------------------------------
// Méthode : cwToolHourSummerWinter
// Description
// 
//
// Paramètres
// ----------------------------------------------------
var $1 : Date
var $0 : Integer

var $date_machine; $date : Date
var $heure_hiver; $heure_hiver_bis; $heure_ete; $heure_ete_bis : Boolean

$date_machine:=Current date:C33
$date:=$1

// On se laisse 5 ans d'avance, en sachant que peut être le changement heure hiver/été sera supprimé en Europe en 2019
Case of 
	: ($date_machine>=!2018-10-28!) & ($date_machine<!2019-03-31!)
		$heure_hiver:=True:C214
		$heure_ete:=False:C215
	: ($date_machine>=!2019-03-31!) & ($date_machine<!2019-10-27!)
		$heure_hiver:=False:C215
		$heure_ete:=True:C214
	: ($date_machine>=!2019-10-27!) & ($date_machine<!2020-03-29!)
		$heure_hiver:=True:C214
		$heure_ete:=False:C215
	: ($date_machine>=!2020-03-29!) & ($date_machine<!2020-10-25!)
		$heure_hiver:=False:C215
		$heure_ete:=True:C214
	: ($date_machine>=!2020-10-25!) & ($date_machine<!2021-03-28!)
		$heure_hiver:=True:C214
		$heure_ete:=False:C215
	: ($date_machine>=!2021-03-28!) & ($date_machine<!2021-10-31!)
		$heure_hiver:=False:C215
		$heure_ete:=True:C214
	: ($date_machine>=!2021-10-31!) & ($date_machine<!2022-03-27!)
		$heure_hiver:=True:C214
		$heure_ete:=False:C215
	: ($date_machine>=!2022-03-27!) & ($date_machine<!2022-10-30!)
		$heure_hiver:=False:C215
		$heure_ete:=True:C214
	: ($date_machine>=!2022-10-30!) & ($date_machine<!2023-03-26!)
		$heure_hiver:=True:C214
		$heure_ete:=False:C215
	: ($date_machine>=!2023-03-26!) & ($date_machine<!2023-10-29!)
		$heure_hiver:=False:C215
		$heure_ete:=True:C214
End case 

// Il faut se placer dans le référentiel de la machine pour ajouter ou enlever 1h exprimé en secondes
// Exemple si on souhaite un TS d'une date qui est situé dans une heure d'hiver et que la machine est sur une heure d'été et bien le TS de cette date là aura \
comme référentiel l'heure d'été et non l'heure d'hiver
Case of 
	: ($date>=!2007-03-25!) & ($date<!2007-10-28!)
		$heure_hiver_bis:=False:C215
		$heure_ete_bis:=True:C214
	: ($date>=!2007-10-28!) & ($date<!2008-03-30!)
		$heure_hiver_bis:=True:C214
		$heure_ete_bis:=False:C215
	: ($date>=!2008-03-30!) & ($date<!2008-10-26!)
		$heure_hiver_bis:=False:C215
		$heure_ete_bis:=True:C214
	: ($date>=!2008-10-26!) & ($date<!2009-03-29!)
		$heure_hiver_bis:=True:C214
		$heure_ete_bis:=False:C215
	: ($date>=!2009-03-29!) & ($date<!2009-10-25!)
		$heure_hiver_bis:=False:C215
		$heure_ete_bis:=True:C214
	: ($date>=!2009-10-25!) & ($date<!2010-03-28!)
		$heure_hiver_bis:=True:C214
		$heure_ete_bis:=False:C215
	: ($date>=!2010-03-28!) & ($date<!2010-10-31!)
		$heure_hiver_bis:=False:C215
		$heure_ete_bis:=True:C214
	: ($date>=!2010-10-31!) & ($date<!2011-03-27!)
		$heure_hiver_bis:=True:C214
		$heure_ete_bis:=False:C215
	: ($date>=!2011-03-27!) & ($date<!2011-10-30!)
		$heure_hiver_bis:=False:C215
		$heure_ete_bis:=True:C214
	: ($date>=!2011-10-30!) & ($date<!2012-03-25!)
		$heure_hiver_bis:=True:C214
		$heure_ete_bis:=False:C215
	: ($date>=!2012-03-25!) & ($date<!2012-10-28!)
		$heure_hiver_bis:=False:C215
		$heure_ete_bis:=True:C214
	: ($date>=!2012-10-28!) & ($date<!2013-03-31!)
		$heure_hiver_bis:=True:C214
		$heure_ete_bis:=False:C215
	: ($date>=!2013-03-31!) & ($date<!2013-10-27!)
		$heure_hiver_bis:=False:C215
		$heure_ete_bis:=True:C214
	: ($date>=!2013-10-27!) & ($date<!2014-03-30!)
		$heure_hiver_bis:=True:C214
		$heure_ete_bis:=False:C215
	: ($date>=!2014-03-30!) & ($date<!2014-10-26!)
		$heure_hiver_bis:=False:C215
		$heure_ete_bis:=True:C214
	: ($date>=!2014-10-26!) & ($date<!2015-03-29!)
		$heure_hiver_bis:=True:C214
		$heure_ete_bis:=False:C215
	: ($date>=!2015-03-29!) & ($date<!2015-10-25!)
		$heure_hiver_bis:=False:C215
		$heure_ete_bis:=True:C214
	: ($date>=!2015-10-25!) & ($date<!2016-03-27!)
		$heure_hiver_bis:=True:C214
		$heure_ete_bis:=False:C215
	: ($date>=!2016-03-27!) & ($date<!2016-10-30!)
		$heure_hiver_bis:=False:C215
		$heure_ete_bis:=True:C214
	: ($date>=!2016-10-30!) & ($date<!2017-03-26!)
		$heure_hiver_bis:=True:C214
		$heure_ete_bis:=False:C215
	: ($date>=!2017-03-26!) & ($date<!2017-10-29!)
		$heure_hiver_bis:=False:C215
		$heure_ete_bis:=True:C214
	: ($date>=!2017-10-29!) & ($date<!2018-03-25!)
		$heure_hiver_bis:=True:C214
		$heure_ete_bis:=False:C215
	: ($date>=!2018-03-25!) & ($date<!2018-10-28!)
		$heure_hiver_bis:=False:C215
		$heure_ete_bis:=True:C214
	: ($date>=!2018-10-28!) & ($date<!2019-03-31!)
		$heure_hiver_bis:=True:C214
		$heure_ete_bis:=False:C215
	: ($date>=!2019-03-31!) & ($date<!2019-10-27!)
		$heure_hiver_bis:=False:C215
		$heure_ete_bis:=True:C214
	: ($date>=!2019-10-27!) & ($date<!2020-03-29!)
		$heure_hiver_bis:=True:C214
		$heure_ete_bis:=False:C215
	: ($date>=!2020-03-29!) & ($date<!2020-10-25!)
		$heure_hiver_bis:=False:C215
		$heure_ete_bis:=True:C214
	: ($date>=!2020-10-25!) & ($date<!2021-03-28!)
		$heure_hiver_bis:=True:C214
		$heure_ete_bis:=False:C215
	: ($date>=!2021-03-28!) & ($date<!2021-10-31!)
		$heure_hiver_bis:=False:C215
		$heure_ete_bis:=True:C214
	: ($date>=!2021-10-31!) & ($date<!2022-03-27!)
		$heure_hiver_bis:=True:C214
		$heure_ete_bis:=False:C215
End case 

Case of 
	: ($heure_ete=True:C214) & ($heure_ete_bis=False:C215)  // Je rajoute une heure
		$0:=-3600
	: ($heure_ete=False:C215) & ($heure_ete_bis=True:C214)  // J'enlève une heure
		$0:=3600
	Else   // La machine et l'autre date se situe sur le même créneau horaire, on ne change donc rien
		$0:=0
End case 