//%attributes = {"shared":true}


$chemin:=Get 4D folder:C485(Current resources folder:K5:16)
$files_o:=Folder:C1567($chemin;fk platform path:K87:2).files(fk recursive:K87:7)