Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		C_OBJECT:C1216($MAPersonneDisplay_cs;$MAPersonneDisplay_o)
		
		$MAPersonneDisplay_cs:=cwToolGetClass("MAPersonneDisplay")  // Initialisation de la class
		$MAPersonneDisplay_o:=$MAPersonneDisplay_cs.new()  // Instanciation de la class
		
		$MAPersonneDisplay_o.viewPersonList(Form:C1466)
End case 