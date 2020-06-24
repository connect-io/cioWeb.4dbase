Case of 
	: (Form event code:C388=On Load:K2:1)
		  //Mise au propre du tableau.
		ARRAY TEXT:C222(lbTimestamp;0)
		ARRAY TEXT:C222(lbType;0)
		ARRAY TEXT:C222(lbMessage;0)
		
		ARRAY TEXT:C222(listeLog;0)
		
		  //On recupere tout les logs possibles
		DOCUMENT LIST:C474(Get 4D folder:C485(Logs folder:K5:19);listeLog)
		SORT ARRAY:C229(listeLog;<)
		
		  //On filtre les logs de notre composant
		$nbFichierLog:=Size of array:C274(listeLog)
		$i:=1
		While ($i<=$nbFichierLog)
			If (listeLog{$i}#"ogErreur@")
				DELETE FROM ARRAY:C228(listeLog;$i)
				$nbFichierLog:=$nbFichierLog-1
			Else 
				$i:=$i+1
			End if 
		End while 
		
		  //On recupere la date
		For ($i;1;Size of array:C274(listeLog))
			listeLog{$i}:=Replace string:C233(listeLog{$i};"ogErreur";"")
			listeLog{$i}:=Replace string:C233(listeLog{$i};".json";"")
			listeLog{$i}:=\
				Substring:C12(listeLog{$i};5;2)+"/"+\
				Substring:C12(listeLog{$i};3;2)+"/"+\
				Substring:C12(listeLog{$i};1;2)
		End for 
		
		
	: (Form event code:C388=On Data Change:K2:15)
		  //On remonte le chemin du fichier.
		$chLogFichier:="ogErreur"+cwDateFormatTexte ("AAMMJJ";Date:C102(listeLog{listeLog}))+".json"
		$chLogFichier:=Get 4D folder:C485(Logs folder:K5:19)+$chLogFichier
		ASSERT:C1129(Test path name:C476($chLogFichier)=Is a document:K24:1;\
			"Impossible de retrouver le fichier de log : "+$chLogFichier)
		ARRAY OBJECT:C1221(ErreurJson;0)
		logText:=Document to text:C1236($chLogFichier;"UTF-8")
		JSON PARSE ARRAY:C1219(logText;ErreurJson)
		
		ARRAY TEXT:C222(lbTimestamp;Size of array:C274(ErreurJson))
		ARRAY TEXT:C222(lbType;Size of array:C274(ErreurJson))
		ARRAY TEXT:C222(lbMessage;Size of array:C274(ErreurJson))
		
		For ($i;1;Size of array:C274(ErreurJson))
			$ts:=OB Get:C1224(ErreurJson{$i};"timestamps";Is longint:K8:6)
			lbTimestamp{$i}:=cwTimestampLire ("date";$ts)+" à "+cwTimestampLire ("heure";$ts)
			lbType{$i}:=OB Get:C1224(ErreurJson{$i};"type")
			lbMessage{$i}:=OB Get:C1224(ErreurJson{$i};"message")
		End for 
		
End case 