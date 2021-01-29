/* -----------------------------------------------------------------------------
Class : cs.MAPersonneSelectionDisplay

Class de gestion du marketing automation pour le formulaire liste [Personne]

-----------------------------------------------------------------------------*/

Class constructor
/*-----------------------------------------------------------------------------
Fonction : MAPersonneSelection.constructor
	
Instenciation de la class MAPersonneSelectionDisplay pour le marketing automotion
	
Historique
27/01/21 - RémyScanu <gregory@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	
Function manageFilter($collectionToFilter_c : Collection; $filtreNom_t : Text; $filtrePrenom_t : Text; $filtreEmail_t : Text; $filtreTelFixe_t : Text; $filtreTelMobile_t : Text; \
$filtreCodePostal_t : Text; $filtreVille_t : Text; $filtreDateNaissance_t : Text)->$collectionFiltered_b : Collection
	
	If ($filtreNom_t#"")
		$collectionToFilter_c:=$collectionToFilter_c.query("nom = :1"; "@"+$filtreNom_t+"@")
	End if 
	
	If ($filtrePrenom_t#"")
		$collectionToFilter_c:=$collectionToFilter_c.query("prenom = :1"; "@"+$filtrePrenom_t+"@")
	End if 
	
	If ($filtreEmail_t#"")
		$collectionToFilter_c:=$collectionToFilter_c.query("eMail = :1"; "@"+$filtreEmail_t+"@")
	End if 
	
	If ($filtreTelFixe_t#"")
		$collectionToFilter_c:=$collectionToFilter_c.query("telFixe = :1"; "@"+$filtreTelFixe_t+"@")
	End if 
	
	If ($filtreTelMobile_t#"")
		$collectionToFilter_c:=$collectionToFilter_c.query("telMobile = :1"; "@"+$filtreTelMobile_t+"@")
	End if 
	
	If ($filtreCodePostal_t#"")
		$collectionToFilter_c:=$collectionToFilter_c.query("codePostal = :1"; "@"+$filtreCodePostal_t+"@")
	End if 
	
	If ($filtreVille_t#"")
		$collectionToFilter_c:=$collectionToFilter_c.query("ville = :1"; "@"+$filtreVille_t+"@")
	End if 
	
	If ($filtreDateNaissance_t#"")
		$collectionToFilter_c:=$collectionToFilter_c.query("dateNaissance = :1"; Date:C102($filtreDateNaissance_t))
	End if 
	
	$collectionFiltered_b:=$collectionToFilter_c.copy()