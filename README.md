<p align="center"><a href="http://www.connect-io.fr" target="_blank">
    <img src="https://www.connect-io.fr/www/img/logoConnectio.png">
</a></p>


# Présentation
Le composant cioWeb permet de transformer une application 4D existante traditionnelle en une véritable application web.

Il nécessite du code supplémentaire dans votre application, mais ne modifie aucune méthode de votre application. (Sauf la méthode sur ouverture pour le chargement du serveur web)

Le composant permet de gérer des interfaces de site complètement indépendantes en fonction du sous-domaine. Vous pourrez par exemple depuis votre application 4D utiliser le sous domaine "www." pour le public, "admin." pour la modération et "api." pour les connexions de serveur à serveur.

## Attention
Actuellement le composant est compatible uniquement à partir de 4D V18 r3.
Malgré que ce composant tourne en production sur certaines bases de nos clients. Il n'est pas encore documenté, reste difficile à utiliser dans l'état et subit de grosses transformations en ce moment.

## Utilisation

* [Commencer](Documentation/commencer.md)
* [Gestion des routes](Documentation/route.md)
* [Les vues](Documentation/vue.md)
* [Le javascript](Documentation/javascript.md)
* [Utilisation des formulaires web](Documentation/form.md)
* [Utilisation des tableaux de données](Documentation/datatable.md)

## Documentation des méthodes partagés

[cwDataTableJsInformation](Documentation/Methods/cwDataTableJsInformation.md)

Les méthodes outils
* [cwToolGetClass](Documentation/Methods/cwToolGetClass.md)

## Classes

* [dataTable](Documentation/Classes/dataTable.md)
* [page](Documentation/Classes/page.md)
* [user](Documentation/Classes/user.md)
* [webApp](Documentation/Classes/route.md)