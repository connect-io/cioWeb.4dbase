//%attributes = {"shared":true}
  // ----------------------------------------------------
  // Méthode : cwDataTablePreload
  // Description
  // Precharge toutes les datatables HTML de l'application web.
  //
  // ----------------------------------------------------

If (False:C215)  // Historique
	  // 05/07/20 - Grégory Fromain <gregory@connect-io.fr> - Création
End if 


If (True:C214)  // Déclarations
	C_LONGINT:C283($i)
	C_BOOLEAN:C305($analyseDataTable_b)
	C_COLLECTION:C1488($dataTableCharge_c;$indicesQuery_c)
	C_OBJECT:C1216(formInput_o)  // La variable est declaré en variable process car l'on l'utilise dans le fichier input.html
	C_TEXT:C284($subDomain_t)  // Nom du sous domaine
	C_COLLECTION:C1488($fileSubDomain_c)
	C_OBJECT:C1216($file_o)
End if 


  // Récupération des formulaires
For each ($subDomain_t;<>webApp_o.config.subDomain_c)
	
	  // On récupére la collection de form du sousDomaine
	If (<>webApp_o.sites[$subDomain_t].dataTable=Null:C1517)
		<>webApp_o.sites[$subDomain_t].dataTable:=New collection:C1472()
	End if 
	
	
	  // On récupére la liste de tout les fichiers sources du sous domaine.
	$fileSubDomain_c:=Folder:C1567(<>webApp_o.config.source.folder_f($subDomain_t);fk platform path:K87:2).files(fk recursive:K87:7+fk ignore invisible:K87:22)
	$fileSubDomain_c:=$fileSubDomain_c.query("fullName = :1";"@datatable.json")
	
	
	For each ($file_o;$fileSubDomain_c)
		
		$analyseDataTable_b:=True:C214
		C_OBJECT:C1216($dataTable_o)
		  // On regarde si le formulaire est déjà chargé en mémoire...
		$dataTableCharge_c:=<>webApp_o.sites[$subDomain_t].dataTable.query("source IS :1";$file_o.platformPath)
		If ($dataTableCharge_c.length=0)
			  // Il n'est pas chargé, on doit donc faire le job...
			
		Else 
			  // Il est déjà chargé... mais est-ce que la source est plus récente ?
			If (Num:C11($dataTableCharge_c[0].maj_ts)>cwTimestamp ($file_o.modificationDate;$file_o.modificationTime))
				  // La source est plus ancienne... Donc pas besoin d'intégrer le fichier du formulaire
				$analyseDataTable_b:=False:C215
			End if 
		End if 
		
		If ($analyseDataTable_b)
			$dataTable_o:=JSON Parse:C1218($file_o.getText())
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
			$dataTable_o.source:=$file_o.platformPath
			
			
			$dataTable_o.html:=""
			
			
			
			
			If ($dataTableCharge_c.length=0)
				
				  // Si c'est le 1er chargement du formulaire, on l'ajoute à la collection.
				<>webApp_o.sites[$subDomain_t].dataTable.push($dataTable_o)
			Else 
				
				  // Si le formulaire à déjà été chargé, il faut le mettre à jour.
				$indicesQuery_c:=<>webApp_o.sites[$subDomain_t].dataTable.indices("source IS :1";$file_o.platformPath)
				<>webApp_o.sites[$subDomain_t].dataTable[$indicesQuery_c[0]]:=$dataTable_o
			End if 
		End if 
	End for each 
	
End for each 