//%attributes = {"shared":true,"publishedWeb":true}
  // ----------------------------------------------------
  // Nom utilisateur (OS) : Grégory Fromain <gregory@connect-io.fr>
  // Date et heure : 27/03/18, 19:53:47
  // ----------------------------------------------------
  // Méthode : cwI18nGet
  // Description
  // 
  //
  // Paramètres
  // $1 : [text] nom de la ressource que l'on souhaite utiliser.
  // $2 : [objet] (optionnel) objet de référence que l'on souhaite utiliser.
  // $0 :[text] le text en retour

  // ----------------------------------------------------

C_TEXT:C284($0;$1)
C_OBJECT:C1216($2;$O_ressource)


  // Si il y a un 2eme param, on utilise celui la.
If (Count parameters:C259=2)
	$O_ressource:=$2
Else 
	$O_ressource:=OB Get:C1224(pageWeb;"i18n")
End if 

  // Si la ressource existe on l'utilise sinon on renvoit la cle.
If (OB Is defined:C1231($O_ressource;$1))
	$0:=OB Get:C1224($O_ressource;$1)
Else 
	$0:=$1
End if 