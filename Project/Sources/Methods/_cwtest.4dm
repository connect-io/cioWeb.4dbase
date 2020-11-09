//%attributes = {"shared":true}

var tinyPng_o : cs:C1710.tinyPng
tinyPng_o:=cs:C1710.tinyPng.new("Kzioor4VCZXDlMTnAB093q46JJRFr03Q")
$chemin_upload:=Convert path POSIX to system:C1107("/Users/titouanguillon/Desktop/figurine-kangourou.jpg")
$chemin_download:=Convert path POSIX to system:C1107("/Users/titouanguillon/Desktop/figurine-kangourou_resize.jpg")



If (tinyPng_o.uploadFromFile($chemin_upload))
	
	tinyPng_o.downloadRequest($chemin_download;"scale";15)
	
End if 