var $table_o : Object

Form:C1466.personne.save()

// Sauvegarde de la table [CaMarketing]
$table_o:=Form:C1466.personne.AllCaPersonneMarketing[0]

Case of 
	: (Picture size:C356(Form:C1466.imageDesabonnement)=Picture size:C356(Storage:C1525.automation.image["toggle-off"]))
		$table_o.desabonementMail:=True:C214
	: (Picture size:C356(Form:C1466.imageDesabonnement)=Picture size:C356(Storage:C1525.automation.image["toggle-on"]))
		$table_o.desabonementMail:=False:C215
End case 

$table_o.rang:=Num:C11(Form:C1466.rang)

$table_o.save()

ACCEPT:C269