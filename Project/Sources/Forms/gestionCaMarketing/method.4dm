Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		C_OBJECT:C1216($class_cs)
		
		// Note : Form.caMarketing = entity de la table CaPersonneMarketing
		$class_cs:=cwToolGetClass("MarketingAutomation")  // Initialisation de la class
		
		Form:C1466.marketingAutomation:=$class_cs.new()  // Instanciation de la class
		
		// Chargement des images la gestion  du désabonnement
		If (Form:C1466.marketingAutomation.loadImage("toggle-on.png"; "toggle-off.png")=True:C214)
			
			If (Form:C1466.caMarketing.desabonementMail=True:C214)
				Form:C1466.imageDesabonnement:=Storage:C1525.automation.image["toggle-on"]
			Else 
				Form:C1466.imageDesabonnement:=Storage:C1525.automation.image["toggle-off"]
			End if 
			
		Else 
			ALERT:C41("Certaines images n'ont pas pu être charger, le formulaire va se fermer !")
			
			CANCEL:C270
		End if 
		
End case 