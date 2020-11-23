# Gestion des formulaires

## Description
Les fichiers ```.form.json``` permettend la gestion des formulaires HTML.

## Prérequis
* La conpréhension des routes est requise.
* La compréhension des views est requise.

# Initialiser notre fichier form

Les fichiers de configuration des formulaires sont au format JSON (ou JSONC). Il est nécessaire de créer un fichier par formulaire et son emplacement est libre dans le dossier source.

Voici un exemple de fichier de configuration JSON permettant à un utilisateur de modifier son mot de passe.

Extrait d'une configuration d'une route.
```jsonc
// Nom du fichier :  WebApp/Sources/www/user/route.jsonc
"userParametre": {                                   // Nom de la route
    "parents": [
        "parentsLayoutConnected"                     // Layout parent
    ],
    "route": {
        "path": "/lang/utilisateur-parametre.html"   // URL de la route.
    },
    "titre": "Gestion de vos paramètres",            // Contenu de la balise title du HTML
    "viewPath": [
        "user/view/parametre.html"                   // Emplacement du fichier HTML
    ],
    "methode": [
        "wpTmUserParametre"                          // La méthode qui sera éxécuté par 4D.
    ]
}
```
Configuration proprement dit du formulaire :
```jsonc
// Nom du fichier :  WebApp/Sources/www/user/form/parametre.form.jsonc
{
    "lib": "formUserParametre",                      // Nom du formulaire
    "class": "m-t",                                  // Class dans l'on insere dans la balise <form>
    "action": "userParametre",                       // Route (URL) de validation du formulaire
    "method": "POST",                                // Methode de transfert des data du formulaire
    "input": [                                       // Détail des entrées du formulaire
        {
            "lib": "upMotDePasseActuel",             // Nom de l'input du formulaire
            "label": "Mot de passe actuel",          // Label, indication sur le nom du champ.
            "type": "password",                      // Type d'input HTML
            "colLabel": 4,                           // Largueur du label (cf. Bootstrap : row - col)
            "required": true                         // Indique que ce champ est obligatoire.
        },
        {
            "lib": "upMotDePasseNouveau",
            "label": "Nouveau mot de passe",
            "type": "password",
            "colLabel": 4,
            "required": true
        },
        {
            "lib": "upMotDePasseConfirmation",
            "label": "Ressaisir le nouveau mot de passe",
            "type": "password",
            "colLabel": 4,
            "required": true
        },
        {
            "lib": "token"                           // Le token permet de valider l'autenticité de la demande.
        },
        {
            "lib": "upSubmit",                       // Configuration du bouton submit.
            "type": "submit",
            "class": "btn btn-large",                // Class qui ser intégré dans le HTML de l'input.
            "divClassSubmit": "text-right",          // Class parent qui ser intégré dans le HTML.
            "value": "Modifier mon mot de passe"     // Texte affiché dans le bouton de validation.
        }
    ]
}
```

Code à inserer dans la view (page HTML) :
```html
// On remarquera que l'insertion de balise 4D est fait sous forme de commentaire HTML.

<form <!--#4DSCRIPT/cwFormInit/formUserParametre-->>
    <!--#4DSCRIPT/cwInputHtml/upMotDePasseActuel-->
    <!--#4DSCRIPT/cwInputHtml/upMotDePasseNouveau-->
    <!--#4DSCRIPT/cwInputHtml/upMotDePasseConfirmation-->
    <!--#4DSCRIPT/cwInputHtml/token-->
    <!--#4DSCRIPT/cwInputHtml/upSubmit-->
</form>
```

Voici le rendu HTML généré par le composant :
```html
<!-- On retrouve la balise FORM avec les éléments indiqués dans le fichier de configuration, la route à également été calculé pour l'action. -->
<form id="formUserParametre" class="m-t" method="POST" action="/fr/utilisateur-parametre.html">

    <!-- Génération du 1er input -->
    <div class="form-group row">
        <!-- On remarquera ici l'indication col-sm-4 issue également du fichier de configuration. -->
        <label class="col-sm-4 col-form-label" for="upMotDePasseActuel">
            <!-- On retrouve ici l'indication du label. -->
            Mot de passe actuel
            <!-- L'indication textuel require est généré automatiquement. -->
            <span class="required">*</span> 
        </label>
        <!-- L'indication col-sm-8 est déduite par le composant : 12 colonnes initiales moins les 4 du label. -->
        <div class="col-sm-8">
            <!-- On retrouve la balise input qui reprend les éléments indiqués dans le fichier de configuration. -->
            <input type="password" id="upMotDePasseActuel" name="upMotDePasseActuel" class="form-control rounded-0 " placeholder="" value="" required="">
        </div>
    </div>

    <div class="form-group row">
        <label class="col-sm-4 col-form-label" for="upMotDePasseNouveau">
            Nouveau mot de passe
            <span class="required">*</span> 
        </label>
        <div class="col-sm-8">
            <input type="password" id="upMotDePasseNouveau" name="upMotDePasseNouveau" class="form-control rounded-0 " placeholder="" value="" required="">
        </div>
    </div>

    <div class="form-group row">
        <label class="col-sm-4 col-form-label" for="upMotDePasseConfirmation">
            Ressaisir le nouveau mot de passe
            <span class="required">*</span> 
        </label>
        <div class="col-sm-8">
            <input type="password" id="upMotDePasseConfirmation" name="upMotDePasseConfirmation" class="form-control rounded-0 " placeholder="" value="" required="">
        </div>
    </div>
    <!-- On retrouve ici le token qui est généré automatiquement. -->
    <input type="hidden" name="token" id="token" value="FD4D4BFA25AB450EBA7D813BDA4C1D16">

    <div class="form-group">
        <input type="hidden" name="upSubmit" value="">    
        <div class="text-right">
            <button type="submit" id="upSubmit" name="upSubmit" class="btn btn-large u-btn-blue rounded-0 g-py-12 g-px-25">
                Modifier mon mot de passe
            </button>
        </div>
    </div>
</form>
```

Rendu Visuel dans un navigateur :

![Demo formulaire 1](images/formDemo1.png "Demo formulaire 1")

Voici maintenant le traitement qui peut être fait dans la méthode 4D de ma route du formulaire : wpTmUserParametre

```4d
C_OBJECT($contactAcces_o;$societe_o)

If (cwFormControl(->visiteur_o;"formUserParametre")="ok")
    
    // On vérifie si le mot de passe actuel est valide.
    
    // On retrouve la fiche de la personne.
    $contactAcces_o:=ds.ContactAcces.query("PKU IS :1";visiteur_o.ContactAccesPKU).first()
    
    If ($contactAcces_o=Null)
        visiteur_o.notificationError:="Impossible de retrouver la fiche de la personne."
    End if 
    
    If (visiteur_o.notificationError="")
        If (Not(Verify password hash(visiteur_o.dataForm.motDePasseActuel;$contactAcces_o.HashPassword)))
            visiteur_o.notificationError:="La saisie du mot de passe actuel n'est pas valide."
            OB REMOVE(visiteur_o;"upMotDePasseActuel")
        End if 
    End if 
    
    // On a retrouvé la fiche du contact, test du nouveau MDP.
    If (visiteur_o.notificationError="") & (visiteur_o.dataForm.motDePasseNouveau#visiteur_o.dataForm.motDePasseConfirmation)
        visiteur_o.notificationError:="Le mot de passe saisi est différent de la confirmation."
    End if 
    
    If (visiteur_o.notificationError="") & (Num(visiteur_o.dataForm.motDePasseNouveau)=0)
        visiteur_o.notificationError:="Le nouveau mot de passe doit contenir au moins 1 chiffre"
    End if 
    
    If (visiteur_o.notificationError="") & (Not(Match regex("^(.*)[a-zA-Z]+(.*)$";visiteur_o.dataForm.motDePasseNouveau)))
        visiteur_o.notificationError:="Le nouveau mot de passe doit contenir au moins 1 lettre."
    End if 
    
    If (visiteur_o.notificationError="") & (Length(visiteur_o.dataForm.motDePasseNouveau)<<>webConfig_o.motDePasse.nombreDeCaracteres)
        visiteur_o.notificationError:="Le nouveau mot de passe doit contenir au moins "+String(<>webConfig_o.motDePasse.nombreDeCaracteres)+" caractéres."
    End if 
    
    // Différent des 2 derniers mot de passe.
    If (visiteur_o.notificationError="")
        If ($contactAcces_o.HashPassword#"")
            If (Verify password hash(visiteur_o.dataForm.motDePasseNouveau;$contactAcces_o.HashPassword))
                visiteur_o.notificationError:="Le nouveau mot de passe doit être différent du dernier mots de passe."
            End if 
        End if 
    End if 
    
    If (visiteur_o.notificationError="")
        // Tout les controles sont passé... On prend en compte la modification du mot de passe.
        //$contactAcces_o.HashPasswordOld:=$contactAcces_o.HashPassword
        $contactAcces_o.HashPassword:=weboHashMotDePasse(visiteur_o.dataForm.motDePasseNouveau)
        $contactAcces_o.DernierChangementPass:=Current date
        $contactAcces_o.save()
        
        // Pour des raisons de sécurité on supprimer les variables sur le mot de passe.
        OB REMOVE(visiteur_o;"upMotDePasseActuel")
        OB REMOVE(visiteur_o;"upMotDePasseNouveau")
        OB REMOVE(visiteur_o;"upMotDePasseConfirmation")
        
        visiteur_o.notificationSuccess:="Votre nouveau mot de passe est actif."
        
    Else 
        
        // Si il y a une erreur on vide l'input du nouveau mot de passe.
        OB REMOVE(visiteur_o;"upMotDePasseNouveau")
        OB REMOVE(visiteur_o;"upMotDePasseConfirmation")
    End if 
    
End if 
```

# Remplissage de "input"

Après avoir créé le docmuent il faut remplir la partie **input** qui contient nos variables.

Dans sa forme la plus basique, une variable aura la forme suivante :

```json

{
    "lib": "pdVariable1",
    "type": "text",
    "label": "C'est la variable 1",
    "colLabel": 4
},

```

Le **lib** sera le nom de notre variable. Généralement, on choisit les premières lettres du lib de notrefichier (ici PageDetail donc pd). 

Il y a aussi le **label** qui sera un texte qui s'affichera notre élément (zone de complétion, menu déroulant, etc) il permet de donner des infos à l'utilisateur sur ce qu'il doit faire.

Il y a ensuite le **collabel** qui permet de gérer l'espace entre le label et notre élément. C'est un entier comprit entre 0 et 12.

Enfin, il y a le **type** qui permet de choisir le type de varaible. Cela peut être une zone de texte ou bien un menu déroulant, une case à cocher ou encore un élément cacher.

On peut donc utiliser:
* **text** pour une zone de texte
* **textarea** pour une zone de texte de taille plus importante
* **select** pour un menu déroulant
dans ce cas il faut rajouter:
```json
"selection": [
    {
        "lib": "choix1",
        "value": "0"
    },
    {
        "lib": "choix2",
        "value": "1"
    }
]
```
Pour les values, elles se retrouvent dans 4D.
* **checkbox** pour une case à cocher
Il en existe d'autres qui se retrouve facilement sur internet.


Pour résumer les différents éléments que l'on peut trouver dans l'input, nous avons  :

| Nom de la propriété | Type    | Valeur par defaut | Commentaire |
| ------------------- | ------- | ----------------- | ----------- |
| lib                 | texte   | ""                | C'est le nom de la variable |
| type                | texte   | ""                | Permet de choisir le type de notre variable (text, textarea, select, etc) Voir tableau suivant |
| label               | texte   | ""                | C'est le texte qui s'affichera avec notre variable sur la page web |
| collabel            | entier  | ""                | Permet de gérer l'espace entre le label et la variable |
| class               | texte   | ""                | Permet de rajouter des propriétés à notre variable |
| clientDisabled      | boolean | false             | Permet de choisir si les champs sont saisissble ou pas (false = saisissable) |
| append              | texte   | ""                | Permet de rajouter un petit texte au bout du champ de saisi (€, m2, etc) |
| selection           | texte   | ""                | Nécessaire lorsqu'on crée un menu déroulant ou des boutons radios (voir au dessus) |
| format              | texte   | ""                | Permet de définir des format spécifique tel que des dates( °°/°°/°°°°) |
| colRadio            | entier  | ""                | Lorsqu'on a un type: radio cela permet d'aligner les boutons radios |
| required            | texte   | ""                | |
| placeholder         | texte   | ""                | |
| collapse            | texte   | ""                | |
| contentType         | entier  | ""                | |
| divClassSubmit      | boolean | false             | |
| dateMin             | texte   | ""                | Permet de choisir la date minimum lorsqu'on a un type date |
| dateMax             | texte   | ""                | Permet de choisir la date maximum lorsqu'on a un type date  |
| blobSize            | texte   | ""                | |


Voici un tableau regroupant les différentes valeur que peut prendre type:

| Nom de la propriété | Element nécessaire dans input | Element facultatif dans input                          | Commentaire |
| ------------------- | ------------------------------| ------------------------------------------------------ | ----------- |
| text                |                               | append, label, collabel, class, clientDisabled, append | Permet de créer un champ de texte|
| textarea            |                               | label, collabel, clientDisabled, class                 | Permet de créer un champ de texteprenant plusieurs lignes.<br> L'ajout de la class ``` "class": "4dStyledText"``` permet de renvoyer un text multistyle sous 4D accessible depuis ```visiteur.dataFormTyping```. |
| select              | selection                     | label, collabel, clientDisabled                        | Permet de créer un menu déroulant |
| checkbox            |                               | label, collabel, clientDisabled                        | Permet de creer une case à cocher |
| radio               | selection                     | label, collabel, clientDisabled, colRadio              | Permet de créer des boutons radio|



## Element constant

Pour chacune des page il faut toujours mettre le **token** qui est très utile pour la sécurité de la page.

```json
{
    "lib": "token"
},
```

Il y a aussi **Submit** que l'on peut mettre en format cacher. Pour cela, il faut la class **hidden**. Mais on peut aussi afficher le bouton qui permet de valider la saisie. 

```json
{
    "lib": "pdSubmit",
    "type": "submit",
    "class": "hidden",
    "value": "Enregistrer"
}
```
ou

```json
{
    "lib": "pdSubmit",
    "type": "submit",
    "class": "btn btn-large u-btn-outline-teal rounded-0 ",
    "value": "Valider"
}
```

