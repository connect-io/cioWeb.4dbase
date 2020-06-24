//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Méthode : cwToolObjectMerge (composant CioWeb)
  // Description
  // Fusionne 2 objets
  //
  // Paramètres
  // $1 = [objet] Parent
  // $2 = [objet] Fils
  // $0 = [objet] Fusionné
  // ----------------------------------------------------

If (False:C215)  // Historique
	  // 27/10/15 gregory@connect-io.fr - Création
	  // 27/10/19 gregory@connect-io.fr - Récupération de la méthode depuis le composant cioObjet
End if 

If (True:C214)  // Déclarations
	C_OBJECT:C1216($0;$1;$2;$oParent;$oFils;$oFusion)
	ARRAY TEXT:C222($cles;0)
	
End if 

$oParent:=$1
$oFils:=$2

  //On fusionne toutes les cles de 1er niveau.
OB GET PROPERTY NAMES:C1232($oParent;$cles)
OB GET PROPERTY NAMES:C1232($oFils;$cleFils)
For ($i;1;Size of array:C274($cleFils))
	If (Find in array:C230($cles;$cleFils{$i})=-1)
		APPEND TO ARRAY:C911($cles;$cleFils{$i})
	End if 
End for 


  //On compare les valeurs.
For ($i;1;Size of array:C274($cles))
	ARRAY OBJECT:C1221($tFils;0)
	ARRAY OBJECT:C1221($tParents;0)
	Case of 
		: (Not:C34(OB Is defined:C1231($oFils;$cles{$i})))
			  //Ob fil n'existe pas, donc on rajoute celui du parent.
			If (OB Get type:C1230($oParent;$cles{$i})=Object array:K8:28)
				OB GET ARRAY:C1229($oParent;$cles{$i};$tParents)
				OB SET ARRAY:C1227($oFusion;$cles{$i};$tParents)
			Else 
				OB SET:C1220($oFusion;$cles{$i};OB Get:C1224($oParent;$cles{$i}))
			End if 
			
		: (Not:C34(OB Is defined:C1231($oParent;$cles{$i})))
			  //Ob parent n'existe pas, donc on rajoute celui du fils.
			OB SET:C1220($oFusion;$cles{$i};OB Get:C1224($oFils;$cles{$i}))
			
		: (OB Get type:C1230($oFils;$cles{$i})=Is object:K8:27) & (OB Get type:C1230($oParent;$cles{$i})=Is object:K8:27)
			If (OB Is empty:C1297(OB Get:C1224($oFils;$cles{$i}))) & (OB Is empty:C1297(OB Get:C1224($oParent;$cles{$i})))
				  // Si les 2 objets sont vide, on crée un objet vide.
				OB SET:C1220($oFusion;$cles{$i};New object:C1471)
			Else 
				  //Du moment qu'ils ont le même type, on prend la valeur du fils
				OB SET:C1220($oFusion;$cles{$i};cwToolObjectMerge (OB Get:C1224($oParent;$cles{$i});OB Get:C1224($oFils;$cles{$i})))
			End if 
			
		: (OB Get type:C1230($oFils;$cles{$i})=Object array:K8:28) & (OB Get type:C1230($oParent;$cles{$i})=Object array:K8:28)
			OB GET ARRAY:C1229($oFils;$cles{$i};$tFils)
			OB GET ARRAY:C1229($oParent;$cles{$i};$tParents)
			
			For ($t;1;Size of array:C274($tParents))
				  // Pour le moment on rassemble les 2 tableaux
				APPEND TO ARRAY:C911($tFils;$tParents{$t})
			End for 
			
			OB SET ARRAY:C1227($oFusion;$cles{$i};$tFils)
			
		: (OB Get type:C1230($oFils;$cles{$i})=Is collection:K8:32) & (OB Get type:C1230($oParent;$cles{$i})=Is collection:K8:32)
			
			If ($oFusion=Null:C1517)
				$oFusion:=New object:C1471()
			End if 
			$oFusion[$cles{$i}]:=$oParent[$cles{$i}].concat($oFils[$cles{$i}])
			
		Else 
			  // Si objet existe dans les 2 parties, peut importe le type (different de type objet)
			  // On prend l'objet fils.
			OB SET:C1220($oFusion;$cles{$i};OB Get:C1224($oFils;$cles{$i}))
	End case 
End for 

$0:=$oFusion


  //*** Test de la méthode ***//
  //C_OBJECT(oParent;oFils;oFusion)
  //C_OBJECT($a;$b)

  //OB SET($a;"toto";"tutu";"momo";"mumuPere")
  //OB SET($b;"toto1";"tutu";"momo";"mumuFils")

  //OB SET(oParent;"cle1";"val1")
  //OB SET(oParent;"cle2";"val2")
  //OB SET(oParent;"cle3";"val3")
  //OB SET(oParent;"cle4";"val4")
  //OB SET(oParent;"cle5";$a)

  //OB SET(oFils;"cle1";"val1bis")
  //OB SET(oFils;"cle2";"val2")
  //OB SET(oFils;"cle3";"val3bis")
  //OB SET(oFils;"cle5";$b)
  //OB SET(oFils;"cle6";1)

  //oFusion:=cwToolObjectMerge (oParent;oFils)

  // Résultat attendu sur oFusion
  //{
  // "cle1" : "val1bis",
  // "cle2" : "val2",
  // "cle3" : "val3bis",
  // "cle4" : "val4",
  // "cle5" : {
  //   "toto1" : "tutu",
  //   "momo" : "mumuFils",
  //   "toto" : ""
  // },
  // "cle6" : 1
  // }