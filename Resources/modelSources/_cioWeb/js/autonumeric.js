/* -----------------------------------------------------------------------------
  autonumeric.js

  Mise en forme des numériques dans les inputs.

  Historique
  30/09/20 - Grégory Fromain <gregory@connect-io.fr> - Création
----------------------------------------------------------------------------- */


//========== Formatage des nombres ==========
if($('.real').length!=0){
    const optionNumberRealFrench = {
        digitGroupSeparator        : '.',
        decimalCharacter           : ',',
        decimalCharacterAlternative: '.',
        digitGroupSeparator        : ' ',
        roundingMethod             : AutoNumeric.options.roundingMethod.halfUpSymmetric,
    };

   anElement = new AutoNumeric.multiple('.real',optionNumberRealFrench); 
}

//========== Utilisation  ==========
/*
  1/ Il faut ajouter "autoNumeric" dans les parents de la route.

  2/ Il suffit qu'un input dans un formulaire contient la class "real", le plus simple dans ce cas
  est d'utiliser un input type "real", la class est ajouté automatiquement.

  {
    "lib": "ldLitCondaMontant",
    "type": "text",
    "format": "real",
    "class": "text-right"
  },
*/