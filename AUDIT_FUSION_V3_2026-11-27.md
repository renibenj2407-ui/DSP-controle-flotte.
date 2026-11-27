# DSP Control Flotte — audit préalable à l'intégration V3
Date : 27 novembre 2026
Branche de travail : `integration-v3-logo-2026-11-27`
Branche de protection : `sauvegarde-principale-2026-11-27`

## Règles de sécurité
- La branche `main` n'a pas été modifiée pendant cet audit.
- Aucun enregistrement Supabase n'a été modifié.
- Ne pas remplacer le fichier principal par V3 en bloc.
- Toute intégration doit préserver les fonctionnalités existantes et la totalité des données du projet actuellement référencé par l'application.

## Fichiers comparés
- Version principale : `TEST-DSP.html` (278 492 caractères).
- Référence V3 : `TEST-DSP-V3.html` (81 289 caractères).
- Les deux HTML utilisent la même URL Supabase : `https://aqnhaqjxjvvlobhktlvn.supabase.co`.
- Les deux contiennent les flux d'authentification et utilisent les tables `public.vehicles` et `public.checks`.

## Vérification Supabase — point crucial
Le projet référencé par les deux HTML est le projet Supabase `aqnhaqjxjvvlobhktlvn`, nommé `DSP-SAUVEGARDE-TEST`.
Comptage observé sur ce projet :
- `public.vehicles` : 70 lignes.
- `public.checks` : 273 lignes.
- `public.fleet_app_state` : 0 ligne.
- Le contrôle le plus récent est daté du 27 novembre 2026.

Un second projet Supabase existe : `ibvytlkuzhfsgtznwfix`.
- Il contient 69 véhicules et 273 contrôles.
- Les 273 identifiants de contrôles sont présents dans les deux projets.
- 133 lignes de contrôles diffèrent uniquement par des champs texte vides représentés par `NULL` dans le projet référencé par l'application et par `""` dans l'autre projet.
- Le projet référencé par l'application possède un véhicule supplémentaire : `Nissan 85420` (modèle `etransit`).

**Décision de préservation :** ne pas basculer l'application vers l'autre projet et ne pas recopier une ancienne sauvegarde sur le projet actuellement référencé. Le projet `aqnhaqjxjvvlobhktlvn` est la référence de travail tant qu'aucune vérification contraire ne justifie une décision différente. Les 70 véhicules et 273 contrôles doivent rester intacts.

## Écarts fonctionnels repérés à intégrer / valider
V3 contient des ajouts absents ou non identifiés dans le principal :
- consultation détaillée des contrôles passés et vues complètes d'un contrôle ;
- repérage visuel et historique détaillé des marques ;
- recherche dans l'historique et recherche par immatriculation ;
- retour persistant depuis les fiches détaillées ;
- génération du rapport journalier multicourses et partage du rapport ;
- fonctions de qualification des dégâts / réparations en attente.

La principale contient déjà ses fonctions de flotte, contrôle quotidien, dessin des défauts, historique par véhicule et historique global. Ces fonctions doivent être conservées et testées après intégration.

## Identité visuelle
Le header actuel affiche un titre emoji, et les deux HTML pointent vers `icons/icon-192.png` ainsi que `manifest.webmanifest`. Aucun fichier correspondant n'a été trouvé dans l'arborescence GitHub actuelle.
Un nouveau SVG de marque a été ajouté sur cette branche de travail sous `assets/brand/dsp-control-flotte-logo.svg`, en reprenant les codes validés : bleu nuit, chrome, bouclier, route orange électrique et monogramme DSP.
Il reste à préparer les déclinaisons d'icône PWA / favicon et à vérifier le rendu sur mobile avant d'intégrer le header.

## Étapes suivantes
1. Cartographier précisément les différences de logique entre les fonctions de la principale et celles de V3.
2. Intégrer les fonctions V3 une par une dans une copie de travail de `TEST-DSP.html`.
3. Préserver la connexion Supabase actuellement utilisée et tous les champs / identifiants existants.
4. Ajouter le logo et les déclinaisons d'icône.
5. Tester les parcours de connexion, flotte, contrôle quotidien, dessin, historique, rapport et partage.
6. Faire valider la version intégrée avant toute publication ou changement de production.
