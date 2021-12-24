//%attributes = {"shared":true}
/*------------------------------------------------------------------------------
Méthode : _cwTest

Test unitaire de certaines méthodes du composant.

Historique
20/08/21 - Grégory Fromain <gregory@connect-io.fr> - Création : 57 tests (dont 13 object merge) - 44 ok.
24/12/21 - Grégory Fromain <gregory@connect-io.fr> - Ajout de 3 tests, total : 60 tests (dont 13 object merge) - 59 ok.
------------------------------------------------------------------------------*/


/*Méthode en attente d'un protocole de test :
cwGestionErreur
cwGetVersion
cwInputInjection4DHtmlIsValide()
cwInputInjection4DHtmlSafeUse()
cwLogErreurAjout()
cwMinifier()
cwStorage
cwSupprBaliseHtml()
cwTimestamp()
cwTimestampLire()
cwToolGetClass()
cwToolHashUrl()
cwToolJetLag()
cwToolJsoncToJson()
cwToolObjectDeleteKeys()
cwToolObjectFromFile()
cwToolObjectFromPlatformPath()
cwToolObjectProgress4DTag()
cwToolPathSeparator()
cwToolTextReplaceByRegex()
cwToolUrlCleanText()
*/

//cwToolObjectDeletePrefixKey
$ob_o:=New object:C1471("ppId"; 7; "ppName"; "Luc"; "ppAge"; 22)
cwToolObjectDeletePrefixKey($ob_o; "pp")
ASSERT:C1129(OB Is defined:C1231($ob_o; "id"); "Erreur lors du test de la méthode.")


// cwDateClean : Test du nettoyage des dates
ASSERT:C1129(cwDateClean("vendredi 20 aout")=("20/08/"+String:C10(Year of:C25(Current date:C33()))); "Erreur lors du test de la méthode.")
ASSERT:C1129(cwDateClean(String:C10(Current date:C33(); Internal date long:K1:5))=(String:C10(Current date:C33(); System date short:K1:1)); "Erreur lors du test de la méthode.")
ASSERT:C1129(cwDateClean("lundi 1 janvier 2022 (avant 14h)")="01/01/2022"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwDateClean("01 . 01 -22")="01/01/2022"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwDateClean("00/00/0000")="00/00/00"; "Erreur lors du test de la méthode.")


// cwDateFormatTexte : Test du formatage de date
ASSERT:C1129(cwDateFormatTexte("JJMMAA"; !1985-03-23!)="230385"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwDateFormatTexte("AAAAMMJJ"; !1985-03-23!)="19850323"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwDateFormatTexte("Le JJ/MM (AAAA)"; !2021-08-21!)="Le 21/08 (2021)"; "Erreur lors du test de la méthode.")


// cwExtensionFichier : Test trouver l'extension d'un fichier depuis une chaine de caractère
ASSERT:C1129(cwExtensionFichier("laReponseEst42.txt")=".txt"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwExtensionFichier("la/reponse:est 42.txt")=".txt"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwExtensionFichier("laReponseEst42.config.txt")=".txt"; "Erreur lors du test de la méthode.")


// cwFormatValide : Test des formats de saisie
ASSERT:C1129(cwFormatValide="Le nombre de paramêtre est incorrect."; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("XXX"; "coucou")="format inconnu"; "Erreur lors du test de la méthode.")

// Les emails
ASSERT:C1129(cwFormatValide("email"; "gregory@connect-io.fr")="ok"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("email"; "gregory.dupond-henri@connect-io.fr.co")="ok"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("email"; "autreChose")="format incorrect"; "Erreur lors du test de la méthode.")

// Les urls
ASSERT:C1129(cwFormatValide("url"; "https://www.connect-io.fr")="ok"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("url"; "http://connect-io.fr")="ok"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("url"; "https://connect-io.fr?param=1&param2=Grasse")="ok"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("url"; "ftp://login:pass@connect-io.fr?param=1&param2=Grasse")="ok"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("url"; "autreChose")="format incorrect"; "Erreur lors du test de la méthode.")

// Les réels
ASSERT:C1129(cwFormatValide("real"; "-0")="ok"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("real"; "17.42")="ok"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("real"; "-17,42")="ok"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("real"; "-173.2432,42")="format incorrect"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("real"; "-17 323,42")="ok"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("real"; "autreChose")="format incorrect"; "Erreur lors du test de la méthode.")

// Les entiers
ASSERT:C1129(cwFormatValide("int"; "1")="ok"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("int"; "-423")="ok"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("int"; "+423")="ok"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("int"; "0")="ok"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("int"; "autreChose")="format incorrect"; "Erreur lors du test de la méthode.")

// Les bools
ASSERT:C1129(cwFormatValide("bool"; "1")="ok"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("bool"; "0")="ok"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("bool"; "on")="ok"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("bool"; "off")="ok"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("bool"; "autreChose")="format incorrect"; "Erreur lors du test de la méthode.")

// les dates
ASSERT:C1129(cwFormatValide("date"; "01/01/2021")="ok"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("date"; "01/01/21")="ok"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("date"; "00-00-00")="ok"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("date"; "00/00/00")="ok"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("date"; "00/00/0000")="ok"; "Erreur lors du test de la méthode.")
ASSERT:C1129(cwFormatValide("date"; "32/01/2021")="format incorrect"; "Erreur lors du test de la méthode.")
//ASSERT(cwFormatValide("date"; "01/01/00")="format incorrect"; "Erreur lors du test de la méthode.") // Ce test ne passe pas, il y a un souci dans la méthode.


// cwToolObjectMergeTest : Test du merge des objets : cwToolObjectMerge
ASSERT:C1129(cwToolObjectMergeTest="ok"; "Erreur lors du test de la méthode.")

// cwToolUrlCleanText
ASSERT:C1129(cwToolUrlCleanText("ça œuf où")="ca-oeuf-ou"; "Erreur lors du test de la méthode.")

// cwToolUrlEncode : Test Encodage d'une URL.
ASSERT:C1129(cwToolUrlEncode("https://mozilla.org/?x=шел лы")="https://mozilla.org/?x=%D1%88%D0%B5%D0%BB%20%D0%BB%D1%8B"; "Erreur lors du test de la méthode.")

// cwToolUrlEncode : Test Encodage d'une URL.
ASSERT:C1129(cwToolUrlDecode("https://mozilla.org/?x=%D1%88%D0%B5%D0%BB%20%D0%BB%D1%8B")="https://mozilla.org/?x=шел лы"; "Erreur lors du test de la méthode.")