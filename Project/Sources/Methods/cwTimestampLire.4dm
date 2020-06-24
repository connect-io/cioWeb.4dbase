//%attributes = {"shared":true,"publishedWeb":true}
  // ----------------------------------------------------
  // Nom utilisateur (OS) : Grégory Fromain <gregoryfromain@gmail.com>
  // Date et heure : 28/11/2014, 18:21:21
  // ----------------------------------------------------
  // Méthode : cwTimestampLire
  // Description
  // Renvoi la date ou l'heure du timestamp en $1
  //
  // Paramètres
  // $1 = [texte] info de sortie ("date" ou "heure")
  // $2 = [entier long] le timestamp
  // $0 = [texte]
  // ----------------------------------------------------
C_TEXT:C284($0;$1)
C_LONGINT:C283($2;$tsAvecDecallage)

ASSERT:C1129(Count parameters:C259=2;"Il manque un paramêtre à cette méthode.")
ASSERT:C1129(Type:C295($2)=Is longint:K8:6;"Le param $1 doit être de type 'entier'.")
ASSERT:C1129(($1="date") | ($1="heure");"La valeur de $1 est incorrect.")

$tsAvecDecallage:=$2+cwDecallageHoraire 
If ($1="date")
	$0:=String:C10(Int:C8($tsAvecDecallage/86400)+!1970-01-01!;Internal date short:K1:7)
Else 
	$0:=String:C10(Time:C179(Mod:C98($tsAvecDecallage;86400));HH MM SS:K7:1)
End if 
