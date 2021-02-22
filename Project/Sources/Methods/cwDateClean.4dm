//%attributes = {"publishedWeb":true,"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwDateClean

Reconstruire une date depuis une saisie client

Historique
19/06/17 - Grégory Fromain <gregory@connect-io.fr> - Création
25/02/20 - Grégory Fromain <gregory@connect-io.fr> - Récupération depuis le projet livrerunballon et amélioration
13/06/20 - Grégory Fromain <gregory@connect-io.fr> - Gestion du cas : ($1="00/00/00")|($1="00-00-00")
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */

// Déclarations
var $0 : Text  // $0 = [texte] date formatté
var $1 : Text  // $1= [texte] saisie client

var $stop_b : Boolean


$stop_b:=False:C215

// Si le champ est vide, on ne va pas plus loin...
If ($1="") | ($1="00/00/00") | ($1="00-00-00")
	$0:=$1
	$stop_b:=True:C214
End if 


// La date est déjà propre.
If (Not:C34($stop_b))
	If (Date:C102($1)#!00-00-00!)
		$0:=$1
		$stop_b:=True:C214
	End if 
End if 

If (Not:C34($stop_b))
	If ($1="@lundi@")
		$1:=Replace string:C233($1;"lundi";"")
	End if 
	If ($1="@mardi@")
		$1:=Replace string:C233($1;"mardi";"")
	End if 
	If ($1="@mercredi@")
		$1:=Replace string:C233($1;"mercredi";"")
	End if 
	If ($1="@jeudi@")
		$1:=Replace string:C233($1;"jeudi";"")
	End if 
	If ($1="@vendredi@")
		$1:=Replace string:C233($1;"vendredi";"")
	End if 
	If ($1="@samedi@")
		$1:=Replace string:C233($1;"samedi";"")
	End if 
	If ($1="@dimanche@")
		$1:=Replace string:C233($1;"dimanche";"")
	End if 
	
	Case of 
		: ($1="@janvier@")
			$1:=Replace string:C233($1;"janvier";"/01/")
		: ($1="@février@")
			$1:=Replace string:C233($1;"février";"/02/")
		: ($1="@mars@")
			$1:=Replace string:C233($1;"mars";"/03/")
		: ($1="@avril@")
			$1:=Replace string:C233($1;"avril";"/04/")
		: ($1="@mai@")
			$1:=Replace string:C233($1;"mai";"/05/")
		: ($1="@juin@")
			$1:=Replace string:C233($1;"juin";"/06/")
		: ($1="@juillet@")
			$1:=Replace string:C233($1;"juillet";"/07/")
		: ($1="@aout@")
			$1:=Replace string:C233($1;"aout";"/08/")
		: ($1="@septembre@")
			$1:=Replace string:C233($1;"septembre";"/09/")
		: ($1="@octobre@")
			$1:=Replace string:C233($1;"octobre";"/10/")
		: ($1="@novembre@")
			$1:=Replace string:C233($1;"novembre";"/11/")
		: ($1="@decembre@")
			$1:=Replace string:C233($1;"decembre";"/12/")
	End case 
	
	$posParenthese:=Position:C15("(";$1)
	If ($posParenthese#0)
		// il y surement un commentaire du client genre : 01/01/01 (avant 10h)
		$posParentheseFin:=Position:C15(")";$1)
		$commentaire:=Substring:C12($1;$posParenthese;$posParentheseFin-$posParenthese+1)
		$1:=Replace string:C233($1;$commentaire;"")
	End if 
	
	$annéeMoinsUn:=String:C10((Year of:C25(Current date:C33)-1)%100)
	$année:=String:C10(Year of:C25(Current date:C33)%100)
	If ($1=("@"+$annéeMoinsUn))
		$1:=Substring:C12($1;1;Length:C16($1)-2)+$année
	End if 
	
	
	If ($1#("@"+$année))
		$1:=$1+" "+$année
	End if 
	
	If ($1#"@/@") & ($1#"@ @") & ($1#"@,@") & ($1#"@.@") & ($1#"@-@")
		$1:=Insert string:C231($1;"/";5)
		$1:=Insert string:C231($1;"/";3)
	End if 
	
	If (Date:C102($1)#!00-00-00!)
		$0:=String:C10(Date:C102($1))
		$stop_b:=True:C214
	Else 
		
	End if 
End if 