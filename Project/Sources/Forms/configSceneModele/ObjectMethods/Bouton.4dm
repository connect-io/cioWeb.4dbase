//Si (modeleListe_at{modeleListe_at}#"")
//Form.sceneDetail.paramAction.modele:=modeleListe_at{modeleListe_at}

//Si (modeleListe_at{modeleListe_at}#"@.4WP") & (modeleListe_at{modeleListe_at}#"@.4W7")  // Modèle du composant cioWeb

//Si (Form.sceneDetail.paramAction.modelePerso#Null)
//OB SUPPRIMER(Form.sceneDetail.paramAction; "modelePerso")
//Fin de si 

//Si (Form.sceneDetail.paramAction.modele4WP#Null)
//OB SUPPRIMER(Form.sceneDetail.paramAction; "modele4WP")
//Fin de si 

//Sinon   // Modèle perso
//Form.sceneDetail.paramAction.modelePerso:=Vrai
//Form.sceneDetail.paramAction.modele4WP:=WP Importer document(Form.modele[0].path)
//Fin de si 

//Sinon 

//Si (Form.sceneDetail.paramAction.modele#Null)
//OB SUPPRIMER(Form.sceneDetail.paramAction; "modele")
//Fin de si 

//Si (Form.sceneDetail.paramAction.modelePerso#Null)
//OB SUPPRIMER(Form.sceneDetail.paramAction; "modelePerso")
//Fin de si 

//Si (Form.sceneDetail.paramAction.modele4WP#Null)
//OB SUPPRIMER(Form.sceneDetail.paramAction; "modele4WP")
//Fin de si 

//Fin de si 

ACCEPT:C269