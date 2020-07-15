//%attributes = {"shared":true}
/* ----------------------------------------------------
Méthode : cwi18nDataPage

Historique
15/08/20 - Grégory Fromain <gregory@connect-io.fr> - Mise en veille de l'internalisation
----------------------------------------------------*/

/*
If (True)  // Déclarations
C_OBJECT($0;$O_dataPage;$O_langueDomaine;$langueFichier)  // $0 : [objet] data i18n de la page
C_TEXT($1)
End if 

$O_dataPage:=New object

  // On récupére les data du sous dommaine du site et de la langue qui nous intérresse.
If (OB Is defined(<>webApp_o.i18n;OB Get(visiteur;"sousDomaine")))
$O_langueDomaine:=OB Get(<>webApp_o.i18n;OB Get(visiteur;"sousDomaine"))
If (OB Is defined($O_langueDomaine;String(pageWeb.route.data.langue)))
$langueFichier:=OB Get($O_langueDomaine;String(pageWeb.route.data.langue))

  // On récupére les data du layout
  // On regarde si un layout existe dans la config du site.
If (OB Is defined(pageWeb;"layout"))

  // On regarde si il y a des infos sur le layout dans l'i18n
If (OB Is defined($langueFichier;OB Get(pageWeb;"layout")))

$O_dataPage:=OB Get($langueFichier;OB Get(pageWeb;"layout"))
End if 
End if 

  // On récupére des data de la page html.

  // On regarde si il y a des infos sur le layout dans l'i18n
If (OB Is defined($langueFichier;OB Get(pageWeb;"lib")))

$O_dataPage:=cwToolObjectMerge ($O_dataPage;OB Get($langueFichier;OB Get(pageWeb;"lib")))
End if 


  // On récupére les data additionnelles.
If (OB Is defined(pageWeb;"i18nAddOn"))

ARRAY TEXT($T_i18nAddOn;0)
OB GET ARRAY(pageWeb;"i18nAddOn";$T_i18nAddOn)

For ($i;1;Size of array($T_i18nAddOn))
If (OB Is defined($langueFichier;$T_i18nAddOn{$i}))
$O_dataPage:=cwToolObjectMerge ($O_dataPage;OB Get($langueFichier;$T_i18nAddOn{$i}))
End if 
End for 
End if 

End if 
End if 

  // On renvoie le tout.
$0:=$O_dataPage
*/