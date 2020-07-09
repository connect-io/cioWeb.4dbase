//%attributes = {"shared":true}
/* ----------------------------------------------------
Méthode : cwi18nDataPage

Historique

----------------------------------------------------*/


If (True:C214)  // Déclarations
	C_OBJECT:C1216($0;$O_dataPage;$O_langueDomaine;$langueFichier)  // $0 : [objet] data i18n de la page
	C_TEXT:C284($1)
End if 

$O_dataPage:=New object:C1471

  // On récupére les data du sous dommaine du site et de la langue qui nous intérresse.
If (OB Is defined:C1231(<>webApp_o.i18n;OB Get:C1224(visiteur;"sousDomaine")))
	$O_langueDomaine:=OB Get:C1224(<>webApp_o.i18n;OB Get:C1224(visiteur;"sousDomaine"))
	If (OB Is defined:C1231($O_langueDomaine;String:C10(pageWeb.route.data.langue)))
		$langueFichier:=OB Get:C1224($O_langueDomaine;String:C10(pageWeb.route.data.langue))
		
		  // On récupére les data du layout
		  // On regarde si un layout existe dans la config du site.
		If (OB Is defined:C1231(pageWeb;"layout"))
			
			  // On regarde si il y a des infos sur le layout dans l'i18n
			If (OB Is defined:C1231($langueFichier;OB Get:C1224(pageWeb;"layout")))
				
				$O_dataPage:=OB Get:C1224($langueFichier;OB Get:C1224(pageWeb;"layout"))
			End if 
		End if 
		
		  // On récupére des data de la page html.
		
		  // On regarde si il y a des infos sur le layout dans l'i18n
		If (OB Is defined:C1231($langueFichier;OB Get:C1224(pageWeb;"lib")))
			
			$O_dataPage:=cwToolObjectMerge ($O_dataPage;OB Get:C1224($langueFichier;OB Get:C1224(pageWeb;"lib")))
		End if 
		
		
		  // On récupére les data additionnelles.
		If (OB Is defined:C1231(pageWeb;"i18nAddOn"))
			
			ARRAY TEXT:C222($T_i18nAddOn;0)
			OB GET ARRAY:C1229(pageWeb;"i18nAddOn";$T_i18nAddOn)
			
			For ($i;1;Size of array:C274($T_i18nAddOn))
				If (OB Is defined:C1231($langueFichier;$T_i18nAddOn{$i}))
					$O_dataPage:=cwToolObjectMerge ($O_dataPage;OB Get:C1224($langueFichier;$T_i18nAddOn{$i}))
				End if 
			End for 
		End if 
		
	End if 
End if 

  // On renvoie le tout.
$0:=$O_dataPage