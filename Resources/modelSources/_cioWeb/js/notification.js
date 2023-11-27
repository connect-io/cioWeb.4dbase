/*------------------------------------------------------------------------------
  notification.js

  Gestion des notifications.

  Historique
  20/09/20 - Grégory Fromain <gregory@connect-io.fr> - Création
  27/11/23 - Jonathan Fernandez <jonathan@connect-io.fr> - Ajout Session.storage.user
----------------------------------------------------------------------------- */


// ----- Init de l'objet de récupération des datas 4D -----
if(data4D == null){
	var data4D = {};
}

/* ----- Gestion des notifications de succés -----

Utilisation depuis 4D :
Session.storage.user.notificationSuccess:="Message envoyé"

Utilisation depuis JS :
data4D.notificationSuccess("Message envoyé");
*/
data4D.notificationSuccess = function (message) {
	toastr.success(
		message,
		'Succès !',
		{
			"closeButton": true,
			"progressBar": true,
			"positionClass": "toast-top-center",
			"onclick": null,
			"showDuration": "400",
			"hideDuration": "1000",
			"timeOut": "10000",
			"extendedTimeOut": "10000",
			"showEasing": "swing",
			"hideEasing": "linear",
			"escapeHtml": true
		}
	);

};

<!--#4DIF (string(Session.storage.user.notificationSuccess)#"")-->
data4D.notificationSuccess("<!--#4DHTML Session.storage.user.notificationSuccess-->");
<!--#4DENDIF-->



/* ----- Gestion des notifications d'erreur -----

Utilisation depuis 4D :
Session.storage.user.notificationError:="Votre accès est interdit."

Utilisation depuis JS :
data4D.notificationError("Votre accès est interdit.");
*/
data4D.notificationError = function (message) {
	toastr.error(
		message,
		'Erreur !',
		{
			"closeButton": true,
			"progressBar": true,
			"positionClass": "toast-top-center",
			"onclick": null,
			"showDuration": "400",
			"hideDuration": "1000",
			"timeOut": "60000",
			"extendedTimeOut": "10000",
			"showEasing": "swing",
			"hideEasing": "linear",
			"escapeHtml": true
		}
	);
};

<!--#4DIF (string(Session.storage.user.notificationError)#"")-->
data4D.notificationError("<!--#4DHTML Session.storage.user.notificationError-->");
<!--#4DENDIF-->



/* ----- Gestion des notifications attention -----

Utilisation depuis 4D :
Session.storage.user.notificationWarning:="Le champ prénom est obligatoire."

Utilisation depuis JS :
data4D.notificationWarning("Le champ prénom est obligatoire.");
*/
data4D.notificationWarning = function (message) {
	toastr.warning(
		message,
		'Attention !',
		{
			"closeButton": true,
			"progressBar": true,
			"positionClass": "toast-top-center",
			"onclick": null,
			"showDuration": "400",
			"hideDuration": "1000",
			"timeOut": "10000",
			"extendedTimeOut": "10000",
			"showEasing": "swing",
			"hideEasing": "linear",
			"escapeHtml": true
		}
	);
};


<!--#4DIF (string(Session.storage.user.notificationWarning)#"")-->
data4D.notificationWarning("<!--#4DHTML Session.storage.user.notificationWarning-->");
<!--#4DENDIF-->



/* ----- Gestion des notifications d'information -----

Utilisation depuis 4D :
Session.storage.user.notificationInfo:="Vous avez 4 nouveaux message."

Utilisation depuis JS :
data4D.notificationInfo("Vous avez 4 nouveaux message.");
*/
data4D.notificationInfo = function (message) {
	toastr.info(
		message,
		'Information !',
		{
			"closeButton": true,
			"progressBar": true,
			"positionClass": "toast-top-center",
			"onclick": null,
			"showDuration": "400",
			"hideDuration": "1000",
			"timeOut": "10000",
			"extendedTimeOut": "10000",
			"showEasing": "swing",
			"hideEasing": "linear",
			"escapeHtml": true
		}
	);
};

<!--#4DIF (string(Session.storage.user.notificationInfo)#"")-->
data4D.notificationInfo("<!--#4DHTML Session.storage.user.notificationInfo-->");
<!--#4DENDIF-->
