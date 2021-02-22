//%attributes = {"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwWebAppFuncChartPreload

Precharge tous les graphiques HTML de l'application web.

Historique
03/02/21 - Grégory Fromain <gregory@connect-io.fr> - Création
-----------------------------------------------------------------------------*/

// Déclarations
var $analyseChart_b : Boolean
var $chartCharge_c : Collection
var $indicesQuery_c : Collection
var formInput_o : Object
var $subDomain_t : Text
var $fileSubDomain_c : Collection
var $file_o : Object


// Récupération des graphiques
For each ($subDomain_t; Storage:C1525.param.subDomain_c)
	
	// On récupére la collection des graphiques du sousDomaine
	Use (Storage:C1525.sites[$subDomain_t])
		Storage:C1525.sites[$subDomain_t].chart:=New shared collection:C1527()
	End use 
	
	// On récupére la liste de tout les fichiers sources du sous domaine.
	$fileSubDomain_c:=Folder:C1567(This:C1470.sourceSubdomainPath($subDomain_t); fk platform path:K87:2).files(fk recursive:K87:7+fk ignore invisible:K87:22)
	$fileSubDomain_c:=$fileSubDomain_c.query("fullName = :1"; "@chart.json@")
	
	
	For each ($file_o; $fileSubDomain_c)
		
		$analyseChart_b:=True:C214
		var $chart_o : Object
		// On regarde si le formulaire est déjà chargé en mémoire...
		$chartCharge_c:=Storage:C1525.sites[$subDomain_t].chart.query("source IS :1"; $file_o.platformPath)
		If ($chartCharge_c.length=0)
			// Il n'est pas chargé, on doit donc faire le job...
			
		Else 
			// Il est déjà chargé... mais est-ce que la source est plus récente ?
			If (Num:C11($chartCharge_c[0].maj_ts)>cwTimestamp($file_o.modificationDate; $file_o.modificationTime))
				// La source est plus ancienne... Donc pas besoin d'intégrer le fichier du formulaire
				$analyseChart_b:=False:C215
			End if 
		End if 
		
		If ($analyseChart_b)
			$chart_o:=cwToolObjectFromFile($file_o)
			If (Not:C34(OB Is defined:C1231($chart_o)))
				ALERT:C41("Impossible de parse "+$file_o.platformPath)
				$analyseChart_b:=False:C215
			End if 
		End if 
		
		If ($analyseChart_b)
			//chargement de l'objet form
			
			// On commence par ajouter un timestamp de MAJ du formulaire.
			$chart_o.maj_ts:=cwTimestamp
			
			// On indique également la source du formulaire.
			$chart_o.file:=$file_o.platformPath
			
			
			If ($chartCharge_c.length=0)
				
				// Si c'est le 1er chargement du graphique, on l'ajoute à la collection.
				Use (Storage:C1525.sites[$subDomain_t].chart)
					Storage:C1525.sites[$subDomain_t].chart.push(OB Copy:C1225($chart_o; ck shared:K85:29; Storage:C1525.sites[$subDomain_t].chart))
				End use 
			Else 
				
				// Si le graphique à déjà été chargé, il faut la mettre à jour.
				$indicesQuery_c:=Storage:C1525.sites[$subDomain_t].chart.indices("file IS :1"; $file_o.platformPath)
				Use (Storage:C1525.sites[$subDomain_t].chart)
					Storage:C1525.sites[$subDomain_t].chart[$indicesQuery_c[0]]:=OB Copy:C1225($chart_o; ck shared:K85:29; Storage:C1525.sites[$subDomain_t].chart)
				End use 
			End if 
		End if 
	End for each 
	
End for each 