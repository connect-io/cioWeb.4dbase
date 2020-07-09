//%attributes = {"invisible":true}
/* ----------------------------------------------------
Méthode : ogMaxMindGetVilleTest

Test de la methode ogMaxMindGetVille

Historique

----------------------------------------------------*/

If (True:C214)  // Déclarations
	C_BOOLEAN:C305($0)  // $0  = [bool] VRAI, si le test bon !
	
	C_TEXT:C284($resultat)
End if 

MESSAGE:C88("Test en cours : "+Current method name:C684)

  //On test avec l'ip du bureau !
$resultat:=cwMaxMindGetVille ("81.65.24.128")
$0:=Asserted:C1132($resultat="@Grasse@";"La methode 'ogMaxMindGetVille' présente un bug.")
