/* 
Cette class permet de gerer tout les envoi de mail.

Historique
15/07/20 - gregory@connect-io.fr - Mise en place de l'historique

*/

  // ----- Initialisation de l'application web -----
Class constructor
	
	C_OBJECT:C1216($config_o)  // Config du serveurWeb
	
	  // LAUNCH EXTERNAL PROCESS("say Initialisation du serveur web. Initialisation du serveur web ? Initialisation du serveur web !")
	
	$config_o:=cwServerWebInit 
	
	For each ($propriete_t;$config_o)
		
		This:C1470[$propriete_t]:=$config_o[$propriete_t]
		
		Use (Storage:C1525)
			Case of 
				: (OB Get type:C1230($config_o;$propriete_t)=Is object:K8:27)
					Storage:C1525[$propriete_t]:=OB Copy:C1225($config_o[$propriete_t];ck shared:K85:29)
					
					
				: (OB Get type:C1230($config_o;$propriete_t)=Is collection:K8:32)
					Storage:C1525[$propriete_t]:=$config_o[$propriete_t].copy(ck shared:K85:29)
					
				Else 
					ALERT:C41("Dans le fichier de config, merci de renseigner, uniquement des objets ou collection.")
			End case 
			
			
		End use 
		
	End for each 
	