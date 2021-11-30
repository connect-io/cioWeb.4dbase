# Gestion des sessions

## Description
Les sessions web permettent de stocker temporairement puis sur quelques jours les informations du visiteur.

## Fonctionnement
To do...

## Configuration

### La méthode : Sur ouverture
Le plus basic
```4d
  // Aprés le demarrage du serveur
  // <>webApp_o.serverStart()
  // WEB START SERVER
  // ...

  // Démarrage des sessions.
<>webApp_o.sessionWebStart()
```

A titre indication voici les propriétées du serveur web qui sont modifiés par défaut avec le composant :
| Nom de la propriété                       | Valeur composant | Commentaire |
| ----------------------------------------- | ---------------: | ----------- |
| Web session cookie name                   | CIOSID           | nom du cookie de la session |
| Web inactive session timeout              | 30*24*60         | 30 jours, en minute |
| Web inactive process timeout              | 0                | 480 min de durée de vie des process inactifs associés aux sessions |
| Web max sessions                          | 300              | 300 sessions simultanées |
| Web Session IP address validation enabled | 0                | Déconnecte la relation entre l'IP et le cookies |
| Web keep session                          | 1                | activation de la gestion automatique des sessions |
| Web HTTP compression level                | -1               | Niveau de compression des pages automatique |
| Web max concurrent processes              | 1000             | Limite du nombre de process Web acceptés et retourne le message “Serveur non-disponible” |


Vous avez également la possibilité de fixer le fonctionnement du serveur et le chemin par défaut :

```4d
  // Après le démarrage du serveur
  // <>webApp_o.serverStart()
  // WEB START SERVER
  // ...

  // Démarrage des sessions.
$optionsSession_c:=New collection
$optionsSession_c.push(New object("key";Web max concurrent processes;"value";1000))

  // On définit le meilleur emplacement pour les sessions.
<>webApp_o.cacheSessionWebPath(Get 4D folder (Data folder)+"sessionWeb"+Folder separator)
<>webApp_o.sessionWebStart($optionsSession_c)
```


### La méthode : Sur connexion web
```4d
  // Aprés le chargement du visiteur.
  // visiteur_o.getInfo()
  // visiteur_o.ip:=$3
  // ...

  //Gestion des sessions web.
visiteur_o.sessionWebLoad()
```


### La méthode : Sur fermeture process web

```4d
  // On utilise la fonction du composant pour stocker les datas du visiteur.
visiteur_o.sessionWebSave()
```