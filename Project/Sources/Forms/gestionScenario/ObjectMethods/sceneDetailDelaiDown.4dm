Case of 
	: (Form event code:C388=Sur clic:K2:4)
		
		If (Num:C11(Form:C1466.sceneSuivanteDelai)>0)
			Form:C1466.sceneSuivanteDelai:=Num:C11(Form:C1466.sceneSuivanteDelai)-1
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 