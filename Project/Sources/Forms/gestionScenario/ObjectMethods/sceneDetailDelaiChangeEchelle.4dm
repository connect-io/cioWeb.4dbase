Case of 
	: (Form event code:C388=Sur clic:K2:4)
		
		Case of 
			: (String:C10(Form:C1466.sceneDetail.paramAction.echelleDelai)="jour(s)")
				Form:C1466.sceneDetail.paramAction.echelleDelai:="semaine(s)"
			: (String:C10(Form:C1466.sceneDetail.paramAction.echelleDelai)="semaine(s)")
				Form:C1466.sceneDetail.paramAction.echelleDelai:="mois(s)"
			: (String:C10(Form:C1466.sceneDetail.paramAction.echelleDelai)="mois(s)")
				Form:C1466.sceneDetail.paramAction.echelleDelai:="année(s)"
			: (String:C10(Form:C1466.sceneDetail.paramAction.echelleDelai)="année(s)")
				Form:C1466.sceneDetail.paramAction.echelleDelai:="jour(s)"
		End case 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 