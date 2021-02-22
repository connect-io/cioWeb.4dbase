//%attributes = {"invisible":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : cwWebAppFuncDataTablePreload

Precharge toutes les datatables HTML de l'application web.

Historique
05/07/20 - Grégory Fromain <gregory@connect-io.fr> - Création
01/10/20 - Grégory Fromain <gregory@connect-io.fr> - Ajout des fichiers de config au format JSONC.
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
-----------------------------------------------------------------------------*/

// Déclarations
var $analyseDataTable_b : Boolean
var $dataTableCharge_c : Collection
var $indicesQuery_c : Collection
var formInput_o : Object
var $subDomain_t : Text
var $fileSubDomain_c : Collection
var $file_o : Object


// Récupération des dataTables
For each ($subDomain_t; Storage:C1525.param.subDomain_c)
	
	// On récupére la collection de dataTable du sousDomaine
	Use (Storage:C1525.sites[$subDomain_t])
		Storage:C1525.sites[$subDomain_t].dataTable:=New shared collection:C1527()
	End use 
	
	// On récupére la liste de tout les fichiers sources du sous domaine.
	$fileSubDomain_c:=Folder:C1567(This:C1470.sourceSubdomainPath($subDomain_t); fk platform path:K87:2).files(fk recursive:K87:7+fk ignore invisible:K87:22)
	$fileSubDomain_c:=$fileSubDomain_c.query("fullName = :1"; "@datatable.json@")
	
	
	For each ($file_o; $fileSubDomain_c)
		
		$analyseDataTable_b:=True:C214
		var $dataTable_o : Object
		// On regarde si le formulaire est déjà chargé en mémoire...
		$dataTableCharge_c:=Storage:C1525.sites[$subDomain_t].dataTable.query("source IS :1"; $file_o.platformPath)
		If ($dataTableCharge_c.length=0)
			// Il n'est pas chargé, on doit donc faire le job...
			
		Else 
			// Il est déjà chargé... mais est-ce que la source est plus récente ?
			If (Num:C11($dataTableCharge_c[0].maj_ts)>cwTimestamp($file_o.modificationDate; $file_o.modificationTime))
				// La source est plus ancienne... Donc pas besoin d'intégrer le fichier du formulaire
				$analyseDataTable_b:=False:C215
			End if 
		End if 
		
		If ($analyseDataTable_b)
			$dataTable_o:=cwToolObjectFromFile($file_o)
			If (Not:C34(OB Is defined:C1231($dataTable_o)))
				ALERT:C41("Impossible de parse "+$file_o.platformPath)
				$analyseDataTable_b:=False:C215
			End if 
		End if 
		
		If ($analyseDataTable_b)
			//chargement de l'objet form
			
			// On commence par ajouter un timestamp de MAJ du formulaire.
			$dataTable_o.maj_ts:=cwTimestamp
			
			// On indique également la source du formulaire.
			$dataTable_o.file:=$file_o.platformPath
			
			$dataTable_o.html:=""
			
			
			If ($dataTableCharge_c.length=0)
				
				// Si c'est le 1er chargement du formulaire, on l'ajoute à la collection.
				Use (Storage:C1525.sites[$subDomain_t].dataTable)
					Storage:C1525.sites[$subDomain_t].dataTable.push(OB Copy:C1225($dataTable_o; ck shared:K85:29; Storage:C1525.sites[$subDomain_t].dataTable))
				End use 
			Else 
				
				// Si la dataTable à déjà été chargé, il faut la mettre à jour.
				$indicesQuery_c:=Storage:C1525.sites[$subDomain_t].dataTable.indices("file IS :1"; $file_o.platformPath)
				Use (Storage:C1525.sites[$subDomain_t].dataTable)
					Storage:C1525.sites[$subDomain_t].dataTable[$indicesQuery_c[0]]:=OB Copy:C1225($dataTable_o; ck shared:K85:29; Storage:C1525.sites[$subDomain_t].dataTable)
				End use 
			End if 
		End if 
	End for each 
	
End for each 