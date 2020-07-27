//%attributes = {"invisible":true}
/* ----------------------------------------------------
Méthode : cwWebAppFormPreload

Precharge tout les formulaires de l'application web.

Historique
16/10/15 - Grégory Fromain <gregory@connect-io.fr> - Création
09/12/19 - Grégory Fromain <gregory@connect-io.fr> - Gestion des collaps dans le chargement des formulaires.
21/12/19 - Grégory Fromain <gregory@connect-io.fr> - Transfert du controle des dossiers de base dans la méthode cwServerWebInit
21/12/19 - Grégory Fromain <gregory@connect-io.fr> - On stock les formulaires dans une collection au lieu d'un objet.
21/12/19 - Grégory Fromain <gregory@connect-io.fr> - Les formulaires sont rechargés uniquement si ils ont été modifié.
18/03/20 - Grégory Fromain <gregory@connect-io.fr> - Les inputs sont traités depuis une collection au lieu d'un objet.
15/08/20 - Grégory Fromain <gregory@connect-io.fr> - Mise en veille de l'internalisation
----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_LONGINT:C283($numForm;$i)
	C_BOOLEAN:C305($analyseForm_b)
	C_COLLECTION:C1488($formCharge_c;$indicesQuery_c)
	C_OBJECT:C1216(formInput_o)  // La variable est declaré en variable process car l'on l'utilise dans le fichier input.html
	C_TEXT:C284($subDomain_t)  // Nom du sous domaine
End if 


  // Récupération des formulaires
For each ($subDomain_t;This:C1470.config.subDomain_c)
	  //For ($i;1;Size of array($sites))
	
	  // On récupére les modéles d'input
	$htmlInput_t:=Document to text:C1236(This:C1470.sourceSubdomainPath($subDomain_t)+"_cioWeb"+Folder separator:K24:12+"view"+Folder separator:K24:12+"input.html";"UTF-8")
	
	
	$htmlInputReadOnly_t:=Document to text:C1236(This:C1470.sourceSubdomainPath($subDomain_t)+"_cioWeb"+Folder separator:K24:12+"view"+Folder separator:K24:12+"inputReadOnly.html";"UTF-8")
	
	
	  // On récupére la collection de form du sousDomaine
	If (This:C1470.sites[$subDomain_t].form=Null:C1517)
		This:C1470.sites[$subDomain_t].form:=New collection:C1472()
	End if 
	
	
	ARRAY TEXT:C222($fichiersForm;0)
	DOCUMENT LIST:C474(This:C1470.sourceSubdomainPath($subDomain_t);$fichiersForm;Recursive parsing:K24:13+Absolute path:K24:14)
	For ($numForm;1;Size of array:C274($fichiersForm))
		$analyseForm_b:=True:C214
		C_OBJECT:C1216($form)
		
		If ($fichiersForm{$numForm}#"@form.json")
			$analyseForm_b:=False:C215
		End if 
		
		If ($analyseForm_b)
			  // On regarde si le formulaire est déjà chargé en mémoire...
			$formCharge_c:=This:C1470.sites[$subDomain_t].form.query("source IS :1";$fichiersForm{$numForm})
			If ($formCharge_c.length=0)
				  // Il n'est pas chargé, on doit donc faire le job...
				
			Else 
				  // Il est déjà chargé... mais est-ce que la source est plus récente ?
				GET DOCUMENT PROPERTIES:C477($fichiersForm{$numForm};$verrouille;$invisible;$creeLe;$creeA;$modifie_d;$modifie_h)
				If (Num:C11($formCharge_c[0].maj_ts)>cwTimestamp ($modifie_d;$modifie_h))
					  // La source est plus ancienne... Donc pas besoin d'intégrer le fichier du formulaire
					$analyseForm_b:=False:C215
				End if 
			End if 
		End if 
		
		If ($analyseForm_b)
			$form:=JSON Parse:C1218(Document to text:C1236($fichiersForm{$numForm};"UTF-8"))
			If (Not:C34(OB Is defined:C1231($form)))
				ALERT:C41("Impossible de parse "+$fichiersForm{$numForm})
				$analyseForm_b:=False:C215
			End if 
		End if 
		
		If ($analyseForm_b)
			  //chargement de l'objet form
			
			  // On commence par ajouter un timestamp de MAJ du formulaire.
			$form.maj_ts:=cwTimestamp 
			
			  // On indique également la source du formulaire.
			$form.source:=$fichiersForm{$numForm}
			
			If ($form.readOnly=Null:C1517)
				$form.readOnly:=False:C215
			End if 
			
			$formId:=" id=\""+String:C10($form.lib)+"\""
			$formEnctype:=""
			$formClass:=""
			$formMethod:=" method=\"GET\""
			
			If (OB Is defined:C1231($form;"enctype"))
				$formEnctype:=" enctype=\""+OB Get:C1224($form;"enctype")+"\""
			End if 
			
			If (OB Is defined:C1231($form;"class"))
				$formClass:=" class=\""+OB Get:C1224($form;"class")+"\""
			End if 
			
			If (OB Is defined:C1231($form;"method"))
				$formMethod:=" method=\""+OB Get:C1224($form;"method")+"\""
			End if 
			
			  // On vérifie que dans notre formulaire il y a pas un input type "file"
			  // Si c'est le cas on force la method à POST et on force un enctype
			
			
			For each (formInput_o;$form.input)
				If (formInput_o.type=Null:C1517)
					formInput_o.type:=""
				End if 
				If (String:C10(formInput_o.type)="file")
					$formMethod:=" method=\"POST\""
					$formEnctype:=" enctype=\"multipart/form-data\""
				End if 
			End for each 
			
			$form.html:=$formEnctype+$formId+$formClass+$formMethod+" action=\"$action\""
			
			  //Configuration des inputs.
			For each (formInput_o;$form.input)
				
				If (String:C10(formInput_o.type)="submit")
					$form.submit:=formInput_o.lib
					
					  // On retrouve le préfixe des inputs
					$form.inputPrefixe:=Replace string:C233(formInput_o.lib;"submit";"")
				End if 
				
				If (formInput_o.required=Null:C1517)
					formInput_o.required:=False:C215
				End if 
				
				If (formInput_o.clientDisabled=Null:C1517)
					formInput_o.clientDisabled:=False:C215
				End if 
				
				If (formInput_o.class=Null:C1517)
					formInput_o.class:=""
				End if 
				
				If (String:C10(formInput_o.format)#"")
					formInput_o.class:=formInput_o.class+" "+formInput_o.format
				End if 
				
				If (formInput_o.placeholder=Null:C1517)
					formInput_o.placeholder:=""
				End if 
				
				  // On determine la largeur d'un label
				Case of 
					: (formInput_o.label=Null:C1517)
						  // Il n'y a pas de label dans la l'input
						formInput_o.colLabel:=0
						
					: (formInput_o.colLabel=Null:C1517)
						formInput_o.colLabel:=3
						
					: (formInput_o.colLabel>=0) & (formInput_o.colLabel<=12)
						  // On garde la valeur inscrite
						
					Else 
						  // Si <0 ou >12
						formInput_o.colInput:=12
				End case 
				
				If (Not:C34(OB Is defined:C1231(formInput_o;"colLabel")))
					formInput_o.colLabel:=3
				End if 
				
				  // Ondetermine la largueur de l'input
				Case of 
					: (OB Is defined:C1231(formInput_o;"colInput"))
						If (formInput_o.colInput>=0) & (formInput_o.colInput<=12)
							  // On garde la valeur inscrite
						Else 
							formInput_o.colInput:=12
						End if 
						
					: (formInput_o.colLabel>=0) & (formInput_o.colLabel<12)
						formInput_o.colInput:=12-formInput_o.colLabel
						
					Else 
						  // Label en pleine largueur, donc input en pleine largueur
						formInput_o.colInput:=12
				End case 
				
				If (Not:C34(OB Is defined:C1231(formInput_o;"colInput")))
					formInput_o.colInput:=12-formInput_o.colLabel
				End if 
				
				  // Gestion des collapse
				If (Bool:C1537(formInput_o.collapse)=False:C215)
					formInput_o.collapse:=False:C215
				End if 
				
				
				If (OB Is defined:C1231(formInput_o;"contentType"))
					ARRAY TEXT:C222($tabContentType;0)
					OB GET ARRAY:C1229(formInput_o;"contentType";$tabContentType)
					$type:=JSON Stringify array:C1228($tabContentType)
					$type:=Replace string:C233($type;"[";"")
					$type:=Replace string:C233($type;"]";"")
					$type:=Replace string:C233($type;"\"";"")
					OB SET:C1220(formInput_o;"accept";$type)
					
				Else 
					OB SET:C1220(formInput_o;"accept";"")
				End if 
				
				If (Not:C34(OB Is defined:C1231(formInput_o;"divClassSubmit")))
					OB SET:C1220(formInput_o;"divClassSubmit";"")
				End if 
				
				If (formInput_o.type="radio")
					ARRAY OBJECT:C1221(selection_ao;0)
					If (OB Is defined:C1231(formInput_o;"selection"))
						OB GET ARRAY:C1229(formInput_o;"selection";selection_ao)
					End if 
				End if 
				
				
				For each ($viewHtml;New collection:C1472("html";"htmlReadOnly"))
					
					  // Traitement des balises HTML
					If ($viewHtml="html")
						PROCESS 4D TAGS:C816($htmlInput_t;$htmlInputTags_t)
					Else 
						PROCESS 4D TAGS:C816($htmlInputReadOnly_t;$htmlInputTags_t)
					End if 
					
					  // Traitement apres 4D tags
					$htmlInputTags_t:=Replace string:C233($htmlInputTags_t;"<!--# 4 D";"<!--#4D")
					Case of 
							  // Value input default,Petite verru pour les tokens.
						: (formInput_o.type=Null:C1517)
							formInput_o.type:="hidden"
							
						: (formInput_o.type="select")
							If (OB Is defined:C1231(formInput_o;"selection"))
								C_COLLECTION:C1488($selection_c)
								C_OBJECT:C1216($option_o)
								$selectOption_t:=""
								
								  // On récupére le tableau avec la config à utiliser
								$selection_c:=formInput_o.selection
								
								For each ($option_o;$selection_c)
									$selected:="<!--#4DIF string("+varVisiteurName_t+"."+formInput_o.lib+")=\""+String:C10($option_o.value)+"\"--> selected <!--#4DELSEIF ("+Choose:C955(Bool:C1537($option_o.selected);"True";"False")+"&("+varVisiteurName_t+"."+formInput_o.lib+"=Null))--> selected<!--#4DENDIF-->"
									
									$selectOption_t:=$selectOption_t+\
										"<option value=\""+String:C10($option_o.value)+"\""+$selected+Choose:C955(Bool:C1537($option_o.disabled);" disabled";"")+">"+\
										String:C10($option_o.lib)+"</option>"
								End for each 
								
								$htmlInputTags_t:=Replace string:C233($htmlInputTags_t;"$valueInput";$selectOption_t)
								
							Else 
								$selectOption:="<!--#4DIF OB Is defined ("+varVisiteurName_t+";\"selectOption"+OB Get:C1224(formInput_o;"lib")+"\")-->"
								$selectOption:=$selectOption+"<!--#4DHTML OB Get("+varVisiteurName_t+";\"selectOption"+OB Get:C1224(formInput_o;"lib")+"\")-->"
								$selectOption:=$selectOption+"<!--#4DELSE-->Impossible de trouver : OB Get("+varVisiteurName_t+";\"selectOption"+OB Get:C1224(formInput_o;"lib")+"\")<!--#4DENDIF-->"
								$htmlInputTags_t:=Replace string:C233($htmlInputTags_t;"$valueInput";$selectOption)
							End if 
							
						: (formInput_o.type="toggle")
							$htmlInputTags_t:=Replace string:C233($htmlInputTags_t;"$valueInput";"<!--#4DIF (OB Is defined("+varVisiteurName_t+";\""+OB Get:C1224(formInput_o;"lib")+"\"))--><!--#4DTEXT OB Get("+varVisiteurName_t+";\""+OB Get:C1224(formInput_o;"lib")+"\")--><!--#4DENDIF-->")
							
						Else 
							$htmlInputTags_t:=Replace string:C233($htmlInputTags_t;"$valueInput";"<!--#4DIF (OB Is defined("+varVisiteurName_t+";\""+OB Get:C1224(formInput_o;"lib")+"\"))--><!--#4DTEXT OB Get("+varVisiteurName_t+";\""+OB Get:C1224(formInput_o;"lib")+"\")--><!--#4DENDIF-->")
					End case 
					
					$htmlInputTags_t:=Replace string:C233($htmlInputTags_t;"$disabled";"<!--#4DIF (OB Get("+varVisiteurName_t+";\"loginLevel\")#\"admin\")-->disabled<!--#4DENDIF-->")
					
					  //$htmlInputTags_t:=cwI18nConvertJson ($htmlInputTags_t)
					OB SET:C1220(formInput_o;$viewHtml;$htmlInputTags_t)
					
				End for each 
			End for each 
			
			If ($formCharge_c.length=0)
				
				  // Si c'est le 1er chargement du formulaire, on l'ajoute à la collection.
				This:C1470.sites[$subDomain_t].form.push($form)
			Else 
				
				  // Si le formulaire à déjà été chargé, il faut le mettre à jour.
				$indicesQuery_c:=This:C1470.sites[$subDomain_t].form.indices("source IS :1";$fichiersForm{$numForm})
				This:C1470.sites[$subDomain_t].form[$indicesQuery_c[0]]:=$form
			End if 
		End if 
	End for 
	
End for each 