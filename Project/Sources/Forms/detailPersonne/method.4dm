If (Form event code:C388=Sur chargement:K2:1)
	var $table_o : Object
	
	Form:C1466.updateCaMarketingStatistic(4)  // Je génère à la volée l'enregistrement dans la table [CaMarketing]
	Form:C1466.personne.reload()
	
	$table_o:=Form:C1466.personne.AllCaPersonneMarketing[0]
	$table_o.reload()
	
	Case of 
		: ($table_o.rang=1)
			Form:C1466.resumeMarketing:="• Rang : suspect"
		: ($table_o.rang=2)
			Form:C1466.resumeMarketing:="• Rang : prospect"
		: ($table_o.rang=3)
			Form:C1466.resumeMarketing:="• Rang : client"
		: ($table_o.rang=4)
			Form:C1466.resumeMarketing:="• Rang : client fidèle"
		: ($table_o.rang=5)
			Form:C1466.resumeMarketing:="• Rang : ambassadeur"
	End case 
	
	Form:C1466.resumeMarketing:=Form:C1466.resumeMarketing+Char:C90(Retour à la ligne:K15:40)
	Form:C1466.resumeMarketing:=Form:C1466.resumeMarketing+"Dernière(s) activité(s) des mails envoyés :"+Char:C90(Retour à la ligne:K15:40)
	
	If ($table_o.lastOpened#0)
		Form:C1466.resumeMarketing:=Form:C1466.resumeMarketing+"• Dernier mail ouvert : "+cwTimestampLire("date"; $table_o.lastOpened)+Char:C90(Retour à la ligne:K15:40)
	Else 
		Form:C1466.resumeMarketing:=Form:C1466.resumeMarketing+"• Aucun email ouvert"+Char:C90(Retour à la ligne:K15:40)
	End if 
	
	If ($table_o.lastClicked#0)
		Form:C1466.resumeMarketing:=Form:C1466.resumeMarketing+"• Dernier mail cliqué : "+cwTimestampLire("date"; $table_o.lastClicked)+Char:C90(Retour à la ligne:K15:40)
	Else 
		Form:C1466.resumeMarketing:=Form:C1466.resumeMarketing+"• Aucun email cliqué"+Char:C90(Retour à la ligne:K15:40)
	End if 
	
	If ($table_o.lastBounce#0)
		Form:C1466.resumeMarketing:=Form:C1466.resumeMarketing+"• Email détecté en bounce le : "+cwTimestampLire("date"; $table_o.lastBounce)+Char:C90(Retour à la ligne:K15:40)
	Else 
		Form:C1466.resumeMarketing:=Form:C1466.resumeMarketing+"• Aucun bounce"+Char:C90(Retour à la ligne:K15:40)
	End if 
	
	If ($table_o.desabonementMail=True:C214)
		Form:C1466.resumeMarketing:=Form:C1466.resumeMarketing+"• Désabonnement souhaité"
	Else 
		Form:C1466.resumeMarketing:=Form:C1466.resumeMarketing+"• Aucune demande de désabonnement"
	End if 
	
	Form:C1466.imageDesabonnement:=Storage:C1525.automation.image["toggle-"+Choose:C955(Not:C34($table_o.desabonementMail)=True:C214; "on"; "off")]
	Form:C1466.rang:=$table_o.rang
	
	OBJECT SET HELP TIP:C1181(*; "rang"; "• Rang 1 : Suspect\r• Rang 2 : Prospect\r• Rang 3 : Client\r• Rang 4 : Client fidèle\r• Rang 5 : Ambassadeur")
	
	Form:C1466.scenarioEnCours:=Form:C1466.personne.AllCaPersonneScenario.OneCaScenario
End if 