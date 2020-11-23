//%attributes = {}
// ----------------------------------------------------
// Nom utilisateur (OS) : Grégory Fromain <gregory@connect-io.fr>
// Date et heure : 18/08/17, 20:55:03
// ----------------------------------------------------
// Méthode : cwEntityToForm
// Description
// Permet de charger un enregistrement dans les inputs d'un formulaire.
//
// Paramètres
// $1 : [pointeur] de la table
// $2 : [text] Nom du formulaire
// $3 : [objet] visiteur : ajoute la liste des inputs du formulaire
// $0 = [text] etat de la methode
// ----------------------------------------------------


// A Réécrire...



C_OBJECT:C1216($3;$o_DataRecord;$o_visiteur;$o_infoForm;$o_input)
C_POINTER:C301($1;$p_table)
C_TEXT:C284($0;$2;$t_nomForm;$t_prefixe)
C_BOOLEAN:C305($b_methodeIsValid)

$o_visiteur:=$3
$p_table:=$1
$t_nomForm:=$2
$b_methodeIsValid:=True:C214
$0:="ok"

If (Not:C34(OB Is defined:C1231($o_visiteur)))
	ALERT:C41(Current method name:C684+" ("+$t_nomForm+"): Variable visiteur non indiqué.")
	$0:=Current method name:C684+" ("+$t_nomForm+"): Variable visiteur non indiqué."
	$b_methodeIsValid:=False:C215
End if 

If ($b_methodeIsValid)
	$o_infoForm:=<>webApp_o.sites[visiteur.sousDomaine].form[$t_nomForm]
	
	If (Not:C34(OB Is defined:C1231($o_infoForm)))
		ALERT:C41(Current method name:C684+" : Impossible de charger le formulaire "+$t_nomForm)
		$0:=Current method name:C684+" : Impossible de charger le formulaire "+$t_nomForm
		$b_methodeIsValid:=False:C215
	End if 
End if 

If ($b_methodeIsValid)
	
	// On va déjà charger toutes les data de l'enregistrement dans un objet.
	$o_DataRecord:=coRecordToObject($p_table)
	
	// On recherche le prefixe du formulaire.
	$t_prefixe:=Replace string:C233(OB Get:C1224($o_infoForm;"submit");"submit";"")
	
	// On l'applique à toutes les cles de l'enregistrement.
	coAjoutPrefixeCle(->$o_DataRecord;$t_prefixe)
	coCleFilsVersPoint(->$o_DataRecord)
	
	
	// Il faut adapter chaque type d'input en texte.
	ARRAY TEXT:C222($at_nomCle;0)
	ARRAY LONGINT:C221($al_typeCle;0)
	OB GET PROPERTY NAMES:C1232($o_DataRecord;$at_nomCle;$al_typeCle)
	For ($i;1;Size of array:C274($at_nomCle))
		Case of 
			: ($al_typeCle{$i}=Is boolean:K8:9)
				OB SET:C1220($o_DataRecord;$at_nomCle{$i};Choose:C955(OB Get:C1224($o_DataRecord;$at_nomCle{$i});"1";"0"))
			: ($al_typeCle{$i}=Is real:K8:4)
				OB SET:C1220($o_DataRecord;$at_nomCle{$i};Replace string:C233(String:C10(OB Get:C1224($o_DataRecord;$at_nomCle{$i});"&xml");".";","))
			: ($al_typeCle{$i}=Is object:K8:27)
				OB SET:C1220($o_DataRecord;$at_nomCle{$i};JSON Stringify:C1217($o_DataRecord[$at_nomCle{$i}];*))
		End case 
	End for 
	
	// On récupére tout les inputs du formulaire.
	ARRAY TEXT:C222($at_listeChamp;0)
	$o_input:=OB Get:C1224($o_infoForm;"input")
	OB GET PROPERTY NAMES:C1232($o_input;$at_listeChamp)
	For ($i;1;Size of array:C274($at_listeChamp))
		If (OB Is defined:C1231($o_DataRecord;$at_listeChamp{$i}))
			OB SET:C1220($o_visiteur;$at_listeChamp{$i};OB Get:C1224($o_DataRecord;$at_listeChamp{$i}))
			
		Else 
			// Problème... Il manque un champs pour le formulaire.
			// En faite c'est peu être un image... Qui sera rajouté plus tard.
			
			
			// C'est peut etre aussi un sous objet qui n'a pas initialisé...
			// Du coup on le supprime dans l'objet visiteur car il a peut etre été initialisé précédement.
			If (OB Is defined:C1231($o_visiteur;$at_listeChamp{$i}))
				OB REMOVE:C1226($o_visiteur;$at_listeChamp{$i})
			End if 
		End if 
	End for 
End if 

$1->:=$o_visiteur