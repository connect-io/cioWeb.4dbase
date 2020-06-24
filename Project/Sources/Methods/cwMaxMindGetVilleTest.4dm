//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Nom utilisateur (OS) : Grégory Fromain <gregoryfromain@gmail.com>
  // Date et heure : 10/02/15, 20:21:11
  // ----------------------------------------------------
  // Méthode : ogMaxMindGetVilleTest
  // Description
  // Test de la methode ogMaxMindGetVille
  //
  // Paramètres
  // $0  = [bool] VRAI, si le test bon !
  // ----------------------------------------------------

C_BOOLEAN:C305($0)
C_TEXT:C284($resultat)
MESSAGE:C88("Test en cours : "+Current method name:C684)

  //On test avec l'ip du bureau !
$resultat:=cwMaxMindGetVille ("81.65.24.128")
$0:=Asserted:C1132($resultat="@Grasse@";"La methode 'ogMaxMindGetVille' présente un bug.")
