//%attributes = {}
  // ----------------------------------------------------
  // Méthode : cwVisiteurLoginIS
  // Description
  // à utiliser après la vérification des utilisateurs.
  // permet de garder l'information durant la  session.
  //
  // ----------------------------------------------------

If (False:C215)  // Historique
	  // 29/09/15 Grégory Fromain <gregory@connect-io.fr> - Création
End if 

If (True:C214)  // Déclarations
	C_BOOLEAN:C305($1)  // objet "visiteur"
	
	  //C_OBJECT($visiteur_o)
End if 


If (This:C1470._info=Null:C1517)
	This:C1470._info:=New object:C1471()
End if 

If (Count parameters:C259=1)
	
	This:C1470._info.isLogin:=$1
	
Else 
	$0:=Bool:C1537(This:C1470._info.isLogin)
	
End if 

