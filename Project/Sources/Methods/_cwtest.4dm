//%attributes = {"shared":true}


Use (Storage:C1525)
	Storage:C1525.toto:=OB Copy:C1225(cs:C1710.TinyPng.new();ck shared:K85:29)
End use 

var tinyPng_o : cs:C1710.TinyPng
tinyPng_o:=cs:C1710.TinyPng.new("Kzioor4VCZXDlMTnAB093q46JJRFr03Q")
$chemin_upload:=Convert path POSIX to system:C1107("/Users/titouanguillon/Desktop/figurine-kangourou.jpg")
$chemin_download:=Convert path POSIX to system:C1107("/Users/titouanguillon/Desktop/figurine-kangourou_resize.jpg")



If (tinyPng_o.uploadFromFile($chemin_upload))
	
	tinyPng_o.downloadRequest($chemin_download;"scale";15)
	
End if 