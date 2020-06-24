//%attributes = {"shared":true}

$parents_t:="Macintosh HD:Users:gregoryfromain:Desktop:parents:"

$enfants_t:="Macintosh HD:Users:gregoryfromain:Desktop:enfants:"

FOLDER LIST:C473($enfants_t;dossiers)

For ($i;1;Size of array:C274(dossiers))
	COPY DOCUMENT:C541($enfants_t+dossiers{$i}+Folder separator:K24:12;$parents_t;*)
	
End for 

C_LONGINT:C283($numRoute;$i)
ARRAY TEXT:C222($sites;0)
C_BOOLEAN:C305($analyseForm_b)
C_COLLECTION:C1488($formCharge_c;$indicesQuery_c)
C_TEXT:C284($routeLib)

FOLDER LIST:C473(<>webApp_o.config.webApp.folder_f();$sites)

FOLDER LIST:C473(System folder:C487(Desktop:K41:16)+"sites";$sites)

  // Récupération des formulaires
For ($i;1;Size of array:C274($sites))
	
	ARRAY TEXT:C222($fichiersRoute;0)
	DOCUMENT LIST:C474(<>webApp_o.config.route.folder_f($sites{$i});$fichiersRoute;Recursive parsing:K24:13+Absolute path:K24:14)
	
	For ($numRoute;1;Size of array:C274($fichiersRoute))
		$analyseForm_b:=True:C214
		C_OBJECT:C1216($route)
		
		If ($fichiersRoute{$numRoute}#"@.route.json")
			$analyseForm_b:=False:C215
		End if 
		
		
		If ($analyseForm_b)
			$routes:=JSON Parse:C1218(Document to text:C1236($fichiersRoute{$numRoute};"UTF-8"))
			If (Not:C34(OB Is defined:C1231($routes)))
				ALERT:C41("Impossible de parse "+$fichiersRoute{$numRoute})
				$analyseForm_b:=False:C215
			End if 
		End if 
		
		If ($analyseForm_b)
			
			  // On boucle sur chaque route
			For each ($routeLib;$routes)
				
				If (String:C10($routes[$routeLib].methode)#"")
					$routes[$routeLib].methode:=New collection:C1472($routes[$routeLib].methode)
				End if 
				
				If (String:C10($routes[$routeLib].fichier)#"")
					$routes[$routeLib].fichier:=New collection:C1472($routes[$routeLib].fichier)
				End if 
				
			End for each 
			
			TEXT TO DOCUMENT:C1237($fichiersRoute{$numRoute};JSON Stringify:C1217($routes;*);"UTF-8")
			
		End if 
	End for 
	
End for 



  //----- Permet de convertir les objets des inputs des formulaires en collection. -----

  //C_LONGINT($numForm;$i)
  //ARRAY TEXT($sites;0)
  //C_BOOLEAN($analyseForm_b)
  //C_COLLECTION($formCharge_c;$indicesQuery_c)


  //FOLDER LIST(<>webApp_o.config.webApp.folder_f();$sites)

  //  // Récupération des formulaires
  //For ($i;1;Size of array($sites))

  //  // On récupére la collection de form du sousDomaine
  //If (<>webApp_o.sites[$sites{$i}].form=Null)
  //<>webApp_o.sites[$sites{$i}].form:=New collection()
  //End if 

  //ARRAY TEXT($fichiersForm;0)
  //DOCUMENT LIST(<>webApp_o.config.form.folder_f($sites{$i});$fichiersForm;Recursive parsing+Absolute path)
  //For ($numForm;1;Size of array($fichiersForm))
  //$analyseForm_b:=True
  //C_OBJECT($form)

  //If ($fichiersForm{$numForm}#"@.form.json")
  //$analyseForm_b:=False
  //End if 


  //If ($analyseForm_b)
  //$form:=JSON Parse(Document to text($fichiersForm{$numForm};"UTF-8"))
  //If (Not(OB Is defined($form)))
  //ALERT("Impossible de parse "+$fichiersForm{$numForm})
  //$analyseForm_b:=False
  //End if 
  //End if 

  //If ($analyseForm_b)

  //$inputsForm:=OB Get($form;"input";Is object)
  //ARRAY TEXT($listeInput;0)
  //OB GET PROPERTY NAMES($inputsForm;$listeInput)

  //inputs_c:=New collection

  //  //Configuration des inputs.
  //For ($numInput;1;Size of array($listeInput))



  //inputForm:=New object

  //inputForm:=cwToolObjectMerge (New object("lib";$listeInput{$numInput});OB Get($inputsForm;$listeInput{$numInput};Is object))

  //inputs_c.push(inputForm)

  //End for 

  //$form.input:=inputs_c

  //TEXT TO DOCUMENT($fichiersForm{$numForm};JSON Stringify($form;*);"UTF-8")

  //End if 
  //End for 

  //End for 















  //  //Configuration des inputs.
  //For ($numInput;1;Size of array($listeInput))
  //inputForm:=New object
  //inputForm:=OB Get($inputsForm;$listeInput{$numInput};Is object)

  //  // On rajoute un lib qui est la valeur de la cles parent.
  //inputForm.lib:=$listeInput{$numInput}

  //If (String(inputForm.type)="submit")
  //OB SET($form;"submit";$listeInput{$numInput})

  //  // On retrouve le préfixe des inputs
  //$form.inputPrefixe:=Replace string($listeInput{$numInput};"submit";"")
  //End if 



  //If (Not(OB Is defined(inputForm;"required")))
  //OB SET(inputForm;"required";False)
  //End if 

  //If (Not(OB Is defined(inputForm;"clientDisabled")))
  //OB SET(inputForm;"clientDisabled";False)
  //End if 

  //If (Not(OB Is defined(inputForm;"class")))
  //OB SET(inputForm;"class";"")
  //End if 

  //If (OB Is defined(inputForm;"format"))
  //  // on l'ajoute dans la class
  //OB SET(inputForm;"class";OB Get(inputForm;"class")+" "+OB Get(inputForm;"format"))
  //End if 

  //If (Not(OB Is defined(inputForm;"placeholder")))
  //OB SET(inputForm;"placeholder";"")
  //End if 

  //  // On determine la largeur d'un label
  //Case of 
  //: (Not(OB Is defined(inputForm;"label")))
  //  // Il n'y a pas de label dans la l'input
  //inputForm.colLabel:=0

  //: (Not(OB Is defined(inputForm;"colLabel")))
  //inputForm.colLabel:=3

  //: (inputForm.colLabel>=0) & (inputForm.colLabel<=12)
  //  // On garde la valeur inscrite

  //Else 
  //  // Si <0 ou >12
  //inputForm.colInput:=12
  //End case 

  //If (Not(OB Is defined(inputForm;"colLabel")))
  //inputForm.colLabel:=3
  //End if 

  //  // Ondetermine la largueur de l'input
  //Case of 
  //: (OB Is defined(inputForm;"colInput"))
  //If (inputForm.colInput>=0) & (inputForm.colInput<=12)
  //  // On garde la valeur inscrite
  //Else 
  //inputForm.colInput:=12
  //End if 

  //: (inputForm.colLabel>=0) & (inputForm.colLabel<12)
  //inputForm.colInput:=12-inputForm.colLabel

  //Else 
  //  // Label en pleine largueur, donc input en pleine largueur
  //inputForm.colInput:=12
  //End case 

  //If (Not(OB Is defined(inputForm;"colInput")))
  //inputForm.colInput:=12-inputForm.colLabel
  //End if 

  //  // Gestion des collapse
  //If (Bool(inputForm.collapse)=False)
  //inputForm.collapse:=False
  //End if 


  //If (OB Is defined(inputForm;"contentType"))
  //ARRAY TEXT($tabContentType;0)
  //OB GET ARRAY(inputForm;"contentType";$tabContentType)
  //$type:=JSON Stringify array($tabContentType)
  //$type:=Replace string($type;"[";"")
  //$type:=Replace string($type;"]";"")
  //$type:=Replace string($type;"\"";"")
  //OB SET(inputForm;"accept";$type)

  //Else 
  //OB SET(inputForm;"accept";"")
  //End if 

  //If (Not(OB Is defined(inputForm;"divClassSubmit")))
  //OB SET(inputForm;"divClassSubmit";"")
  //End if 

  //If (inputForm.type="radio")
  //ARRAY OBJECT(selection_ao;0)
  //If (OB Is defined(inputForm;"selection"))
  //OB GET ARRAY(inputForm;"selection";selection_ao)
  //End if 
  //End if 

  //  // Traitement des balises HTML
  //PROCESS 4D TAGS($htmlInput_t;$htmlInputTags_t)

  //  // Traitement apres 4D tags
  //$htmlInputTags_t:=Replace string($htmlInputTags_t;"<!--# 4 D";"<!--#4D")
  //Case of 
  //  // Value input default,Petite verru pour les tokens.
  //: (inputForm.type=Null)
  //inputForm.type:="hidden"

  //: (inputForm.type="select")
  //If (OB Is defined(inputForm;"selection"))
  //C_COLLECTION($selection_c)
  //C_OBJECT($option_o)
  //$selectOption_t:=""

  //  // On récupére le tableau avec la config à utiliser
  //$selection_c:=inputForm.selection

  //For each ($option_o;$selection_c)
  //$selected:="<!--#4DIF string("+varVisiteurName_t+"."+inputForm.lib+")=\""+String($option_o.value)+"\"--> selected <!--#4DELSEIF ("+Choose(Bool($option_o.selected);"True";"False")+"&("+varVisiteurName_t+"."+inputForm.lib+"=Null))--> selected<!--#4DENDIF-->"

  //$selectOption_t:=$selectOption_t+\
"<option value=\""+String($option_o.value)+"\""+$selected+Choose(Bool($option_o.disabled);" disabled";"")+">"+\
String($option_o.lib)+"</option>"
  //End for each 

  //$htmlInputTags_t:=Replace string($htmlInputTags_t;"$valueInput";$selectOption_t)

  //Else 
  //$selectOption:="<!--#4DIF OB Is defined ("+varVisiteurName_t+";\"selectOption"+OB Get(inputForm;"lib")+"\")-->"
  //$selectOption:=$selectOption+"<!--#4DHTML OB Get("+varVisiteurName_t+";\"selectOption"+OB Get(inputForm;"lib")+"\")-->"
  //$selectOption:=$selectOption+"<!--#4DELSE-->Impossible de trouver : OB Get("+varVisiteurName_t+";\"selectOption"+OB Get(inputForm;"lib")+"\")<!--#4DENDIF-->"
  //$htmlInputTags_t:=Replace string($htmlInputTags_t;"$valueInput";$selectOption)
  //End if 

  //: (inputForm.type="toggle")
  //$htmlInputTags_t:=Replace string($htmlInputTags_t;"$valueInput";"<!--#4DIF (OB Is defined("+varVisiteurName_t+";\""+OB Get(inputForm;"lib")+"\"))--><!--#4DTEXT OB Get("+varVisiteurName_t+";\""+OB Get(inputForm;"lib")+"\")--><!--#4DENDIF-->")

  //Else 
  //$htmlInputTags_t:=Replace string($htmlInputTags_t;"$valueInput";"<!--#4DIF (OB Is defined("+varVisiteurName_t+";\""+OB Get(inputForm;"lib")+"\"))--><!--#4DTEXT OB Get("+varVisiteurName_t+";\""+OB Get(inputForm;"lib")+"\")--><!--#4DENDIF-->")
  //End case 

  //$htmlInputTags_t:=Replace string($htmlInputTags_t;"$disabled";"<!--#4DIF (OB Get("+varVisiteurName_t+";\"loginLevel\")#\"admin\")-->disabled<!--#4DENDIF-->")

  //$htmlInputTags_t:=cwI18nConvertJson ($htmlInputTags_t)
  //OB SET(inputForm;"html";$htmlInputTags_t)

  //End for 