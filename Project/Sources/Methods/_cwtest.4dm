//%attributes = {"shared":true}
// Cette fonction n'est pas utile,  il suffit d'utiliser la propriété : fichier.fullName

$cheminObjet_t:="config.folderPath.webApp_t"

$message_t:="WebApp.webAppPath : Cette fonction est obsolette."+Char:C90(Carriage return:K15:38)\
+"Merci d'utiliser maintenant le storage du composant."+Char:C90(Carriage return:K15:38)\
+"Base hôte :"+Char:C90(Carriage return:K15:38)+"cwStorage."+$cheminObjet_t+Char:C90(Carriage return:K15:38)\
+"Dans le composant :"+Char:C90(Carriage return:K15:38)+"Storage."+$cheminObjet_t
ALERT:C41($message_t)
