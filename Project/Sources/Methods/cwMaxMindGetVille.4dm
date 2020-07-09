//%attributes = {"shared":true}
/* ----------------------------------------------------
Méthode : ogMaxMindGetVille

Retourne la geolocalisation des ip.
Documentation : http://dev.maxmind.com/geoip/geoip2/web-services/

Historique

----------------------------------------------------*/

If (True:C214)  // Déclarations
	C_TEXT:C284($0;$1;$lieux)  // $1 [text] IP que l'on cherche à localiser, $0 [text] renvoie l'emplacement géographique de l'IP.
	
	C_TEXT:C284($url;$tInfoGeoIp;$tPostalCode;$tVilleNameFr;$tVilleConfiance;$tPostalConfiance)
	C_BLOB:C604($retour)
	C_BOOLEAN:C305($onContinue)
	C_OBJECT:C1216($oInfoGeoIp;$oPays;$oPaysName;$oPostal;$oVille;$oVilleName;$oMaxmind)
	C_LONGINT:C283($requeteRestante)
End if 

$onContinue:=True:C214

HTTP AUTHENTICATE:C1161("47831";"uhZk8TxMxtbJ";HTTP basic:K71:8)
$url:="https://geoip.maxmind.com/geoip/v2.1/insights/"+$1
If (HTTP Get:C1157($url;$retour)=200)
	$tInfoGeoIp:=BLOB to text:C555($retour;UTF8 text without length:K22:17)
Else 
	  //Erreur dans l'url//
	$onContinue:=False:C215
End if 

If ($onContinue)
	$oInfoGeoIp:=JSON Parse:C1218($tInfoGeoIp)
	  //Notification en cas de seuil de credit faible.
	$oMaxmind:=OB Get:C1224($oInfoGeoIp;"maxmind")
	$requeteRestante:=OB Get:C1224($oMaxmind;"queries_remaining";Is real:K8:4)
	If ($requeteRestante<1000)
		DISPLAY NOTIFICATION:C910("Base 4D : Maxmind";\
			" merci de recharger le compte. (restant. "+String:C10($requeteRestante)+")")
	End if 
	
	$lieux:=""
	
	  //Le code postal
	If (OB Is defined:C1231($oInfoGeoIp;"postal"))
		$oPostal:=OB Get:C1224($oInfoGeoIp;"postal")
		$tPostalCode:=OB Get:C1224($oPostal;"code")
		$tPostalConfiance:=String:C10(OB Get:C1224($oPostal;"confidence"))
		$lieux:=$tPostalCode+" ("+$tPostalConfiance+"%) "
	End if 
	
	  //La ville
	If (OB Is defined:C1231($oInfoGeoIp;"city"))
		$oVille:=OB Get:C1224($oInfoGeoIp;"city")
		$oVilleName:=OB Get:C1224($oVille;"names")
		$tVilleNameFr:=OB Get:C1224($oVilleName;"fr")
		$tVilleConfiance:=String:C10(OB Get:C1224($oVille;"confidence"))
		$lieux:=$lieux+$tVilleNameFr+" ("+$tVilleConfiance+"%) "+" - "
	End if 
	
	  //On recupere le pays.
	$oPays:=OB Get:C1224($oInfoGeoIp;"country")
	$oPaysName:=OB Get:C1224($oPays;"names")
	$lieux:=$lieux+OB Get:C1224($oPaysName;"fr")
	
	$0:=$lieux
End if 

If (Not:C34($onContinue))
	$0:="Echec localisation IP."
End if 

