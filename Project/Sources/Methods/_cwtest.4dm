//%attributes = {"shared":true}

$test:=New object:C1471
$test.toto:="tata"

$dodo:=New shared object:C1526("ok";1)
Use (Storage:C1525.eMail)
	Storage:C1525.eMail.globalVar:=New object:C1471
	Storage:C1525.eMail.globalVar:=OB Copy:C1225($test)
End use 



$infoBase_o:=New object:C1471
$infoBase_o.societeNom:="Guillon Corportate SAS"

<>webApp_o.eMailConfigLoad($infoBase_o)