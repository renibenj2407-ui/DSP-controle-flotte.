# Sauvegarde de la base principale DSP — 27/11/2026

Source Supabase : `ibvytlkuzhfsgtznwfix` (région eu-west-1, PostgreSQL 17).

## Contenu exporté
- `data/vehicles.json` : 69 véhicules.
- `data/checks_*.json` : 272 contrôles répartis en 7 lots.
- `data/fleet_app_state.json` : table vide (0 ligne).
- `technical/supabase_inventory.json` : colonnes, contraintes, index, 11 politiques RLS, fonctions, event triggers, extensions, grants et inventaire Storage.
- `sql/01_structure.sql` : structure des 3 tables et politiques RLS.
- `sql/02_fonction_rls.sql` : fonction et event trigger `ensure_rls`.
- `sql/03_restore_data.sql` : insertions de restauration des 69 véhicules et 272 contrôles.
- `config/supabase_public_config.json` : URL et clés publiques (anon/publishable) uniquement.

## Vérification
Données extraites de la base principale le 27/11/2026. Volumes observés : 69 véhicules, 272 contrôles, 0 état global. Les données JSON ont été exportées en lots pour éviter toute troncature.

## Code de l'application
La branche de sauvegarde conserve également l'intégralité de l'arborescence GitHub `main` au moment de la création (fichiers HTML de test, SQL, documentation, archives ZIP et assets).
**Réserve importante :** aucun fichier de production clairement identifié n'apparaît dans cette arborescence. Les trois HTML présents (`TEST-DSP.html`, `TEST-DSP-V2.html`, `TEST-DSP-V3.html`) référencent tous le projet Supabase V3 `aqnhaqjxjvvlobhktlvn`, et non la base principale `ibvytlkuzhfsgtznwfix`. Le code exact publié sur Netlify à `https://euphonious-taffy-9c51a2.netlify.app` n'a donc pas pu être identifié ni récupéré depuis ce dépôt. Aucun fichier V3 n'a été modifié.

## Limites d'accès
Cette archive n'est pas un dump natif `pg_dump` du cluster Supabase. Elle ne contient pas les mots de passe, les jetons de session/refresh, les clés privées/service_role, les paramètres privés du projet, ni les sauvegardes internes gérées par Supabase. Les utilisateurs Auth (1 compte) ne sont pas exportés avec leurs secrets. Aucun bucket Storage ni objet Storage n'a été détecté. Aucune Edge Function ni migration Supabase n'a été listée par l'API.
Pour une restauration fidèle du service, il faudra également reconfigurer Auth, les clés privées, les paramètres du projet et le déploiement Netlify.
