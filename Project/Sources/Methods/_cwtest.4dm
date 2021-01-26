//%attributes = {"shared":true}

toto:=4D:C1709


$field_t:="dfdfdf"

$recherche_c:=Split string:C1554($field_t; ".")

Use (Storage:C1525)
	Storage:C1525.automation:=New shared object:C1526()
	
End use 

Use (Storage:C1525.automation)
	Storage:C1525.automation.config:=New shared object:C1526()
End use 

Use (Storage:C1525.automation.config)
	
End use 
