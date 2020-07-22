# Gestion des tableaux de données

## Description
Les tableaux de données (vous retrouverez sont nom anglais "datatables")

## Prérequis
* La conpréhention des routes est requis.
* La compréhension des views est requises.
* Chargement des fichiers js et css

## Configuration des fichiers xx.dataTable.json

Propriété lib : Text
La propriété "lib" est le nom de votre tableau de donnée, il permet la correspondance entre 4D, le HTML et le javascript. Il est essentiel que cette propriété soit unique dans votre sous domaine.

Propriété dom : Text
Si la propriété "dom" n'existe pas ou à la valeur "auto"  seul les boutons, les informations sur le nombre de ligne et le filtre de recherche apparaissent au dessus du tableau. Dans le cas ou le tableau depasse 10 lignes, la pagination est généré en dessous du tableau.

Vous pouvez entierement personnaliser la dom en modifiant cette propriété : https://datatables.net/reference/option/dom

Propriété doubleClick : Objet
La propriété "doubleClick" permet de définir une action sur le double clique d'une ligne du tableau.