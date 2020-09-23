/* -----------------------------------------------------------------------------
  notification.js

  Prise en charge de summernote.

  Historique
  23/09/20 - Grégory Fromain <gregory@connect-io.fr> - Création
----------------------------------------------------------------------------- */


// Chargement de l'editeur de texte
$(document).ready(function() {
	$('.summernote').summernote({
	  height: 200
  });
});

/*
  Pour forcer l'actualisation de summernote dans js :

$("#beCorps").summernote("code", reponse.corps);

*/