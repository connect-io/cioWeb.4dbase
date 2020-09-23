/* -----------------------------------------------------------------------------
  confirmation.js

  Gestion des confirmations.

  Historique
  23/09/20 - Grégory Fromain <gregory@connect-io.fr> - Création
----------------------------------------------------------------------------- */


  //Alerte de confirmation
$('[data-toggle="confirmation"]').confirmation({
	"btnOkLabel" : "<i class='fas fa-check'></i>&nbsp;Oui",
	"btnCancelLabel" : "<i class='fas fa-times'></i>&nbsp;Non"
});

// utilisation de 'tooltip-title' comme title
$('a[tooltip], button[tooltip]').tooltip({
	title: function() {
		return $(this).attr("tooltip-title");
	},
	placement: "auto"
});


/*
Utilisation :
<a id="btnEntiteSupprimer" href="/" tooltip-title="Attention cette action est irréversible." tooltip data-title="Effacer la fiche ?" data-toggle="confirmation">
Supprimer
</a>
*/