Case of 
	: (Form event code:C388=Sur clic:K2:4)
		C_OBJECT:C1216($config_o)
		
		$config_o:=New object:C1471("entree";1;"donnee";Form:C1466)  // Form est la class scénario
		
		cwToolWindowsFormCenter("gestionDocument";New object:C1471("ecartHautEcran";90;"ecartBasEcran";70);$config_o)
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 