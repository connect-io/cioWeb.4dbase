//%attributes = {"shared":true,"preemptive":"capable"}
/* -----------------------------------------------------------------------------
Méthode : ogWebMinifier

Permet de minimifier les fichiers javascript.

Historique
31/10/20 - Grégory Fromain <gregory@connect-io.fr> - Déclaration des variables via var
----------------------------------------------------------------------------- */

// Déclarations
var $1;texteIn : Text  // action (Utile seulement pour la methode.)
var $0;texteOut : Text

var car : Text
var $car1 : Text
var $car2 : Text
var $p : Integer
var $l : Integer
var posTexte : Integer
var $fin : Boolean
var $tjrsCommentaire : Boolean


If (Count parameters:C259=1)
	
	//On reset le texte out.
	texteOut:=""
	posTexte:=0
	texteIn:=$1
	//On minifi
	Repeat 
		car:=cwMinifier
		texteOut:=texteOut+car
	Until (car="")
	
	$0:=texteOut
	
Else 
	posTexte:=posTexte+1
	$car1:=Substring:C12(texteIn;posTexte;1)
	$car2:=Substring:C12(texteIn;posTexte+1;1)
	//On transforme les retours a la ligne en nouvelle ligne.
	
	If (Match regex:C1019("[:space:]";$car1;1;$p;$l))
		//On creer 2 conditions pour reduire le nombre de regex.
		If (Match regex:C1019("[:space:]";$car2;1;$p;$l))
			
			$fin:=False:C215
			Repeat 
				$car2:=Substring:C12(texteIn;posTexte+1;1)
				
				If (Match regex:C1019("[:space:]";$car2;1;$p;$l))
					posTexte:=posTexte+1
					$fin:=True:C214
					$car1:="\n"
				End if 
				
			Until ($fin)
		End if 
	End if 
	
	//On filtre de suite les commentaires.
	// C'est peux être le début d'un commentaire
	
	Case of 
		: ($car1="/") & ($car2="/") & (car#":") & (car#"\"")  //car est equivalent car - 1
			// http://... n'est pas un commentaire
			// "//.. (url dans meta) n'est pas un commentaire (href="//fonts.googleapis.com/css?family=Open+Sans:400)
			//c'est confirmé c'est un commentaire sur 1 ligne.
			//On va donc boucler pour sortir de la ligne.
			//On replace notre compteur
			
			posTexte:=posTexte+1
			While ($car1#"\n") & ($car1#"\r") & ($car1#"")
				posTexte:=posTexte+1
				$car1:=Substring:C12(texteIn;posTexte;1)
				
			End while 
			
			//Une fois sortie du comm on recherche le prochain caractere.
			$car1:=cwMinifier
			
		: ($car1="/") & ($car2="*")
			//C'est un commentaire multiligne... On va rechercher la fin du comm.
			posTexte:=posTexte+1
			$tjrsCommentaire:=True:C214
			
			While ($tjrsCommentaire)
				posTexte:=posTexte+1
				$car1:=Substring:C12(texteIn;posTexte;1)
				
				Case of 
					: ($car1="*")
						$car2:=Substring:C12(texteIn;posTexte+1;1)
						If ($car2="/")
							posTexte:=posTexte+1
							//C'est bien la fin de notre commentaire
							$car1:=cwMinifier
							$tjrsCommentaire:=False:C215
						End if 
						
					: ($car1="")
						//Il y a pas de fin de commentaire dans le fichier.
						// On informe notre utilisateur.
						ALERT:C41("Erreur : Il n'y a  pas de fin de commentaire dans le fichier.")
						$tjrsCommentaire:=False:C215
				End case 
				
			End while 
			
	End case 
	
	$0:=$car1
	
End if 