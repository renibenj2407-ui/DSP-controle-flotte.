# DSP Contrôle Flotte Multicourse PDL

## Inventaire technique Supabase --- 26 novembre 2026

**Attention :** ceci est un inventaire technique fondé sur les résultats
communiqués, pas une sauvegarde complète ni un script de restauration.
Il ne contient pas les lignes des tables, les utilisateurs Auth, les
secrets ni les fichiers externes.

## 1. Volumétrie relevée

  Table                      Lignes
  ------------------------ --------
  public.vehicles                69
  public.checks                 133
  public.fleet_app_state          0

## 2. Colonnes

### public.vehicles

  Colonne      Type                       Nullable   Défaut
  ------------ -------------------------- ---------- --------
  id           bigint                     non        aucun
  name         text                       non        aucun
  plate        text                       oui        aucun
  model        text                       non        aucun
  created_at   timestamp with time zone   oui        now()

### public.checks

  Colonne        Type                       Nullable   Défaut
  -------------- -------------------------- ---------- ---------------
  id             bigint                     non        aucun
  vehicle_id     bigint                     oui        aucun
  check_date     date                       non        aucun
  inspector      text                       non        aucun
  driver         text                       oui        aucun
  status         text                       non        aucun
  notes          text                       oui        aucun
  marks          jsonb                      oui        '\[\]'::jsonb
  clean_status   text                       oui        aucun
  clean_note     text                       oui        aucun
  photo_url      text                       oui        aucun
  created_at     timestamp with time zone   oui        now()

### public.fleet_app_state

  Colonne      Type                       Nullable   Défaut
  ------------ -------------------------- ---------- ---------------
  id           text                       non        'main'::text
  vehicles     jsonb                      non        '\[\]'::jsonb
  checks       jsonb                      non        '\[\]'::jsonb
  updated_at   timestamp with time zone   non        now()
  updated_by   text                       oui        aucun

## 3. Contraintes

-   `vehicles_pkey` : PRIMARY KEY (id)
-   `checks_pkey` : PRIMARY KEY (id)
-   `checks_vehicle_id_fkey` : FOREIGN KEY (vehicle_id) REFERENCES
    vehicles(id) ON DELETE SET NULL
-   `fleet_app_state_pkey` : PRIMARY KEY (id)
-   `fleet_app_state_singleton` : CHECK ((id = 'main'::text))

## 4. Index

-   `vehicles_pkey` : index unique B-tree sur `vehicles(id)`
-   `checks_pkey` : index unique B-tree sur `checks(id)`
-   `fleet_app_state_pkey` : index unique B-tree sur
    `fleet_app_state(id)`

## 5. RLS et politiques

RLS activée sur les trois tables : `vehicles`, `checks`,
`fleet_app_state`.

  ------------------------------------------------------------------------------------
  Table             Politique      Commande    Rôle            USING       WITH CHECK
  ----------------- -------------- ----------- --------------- ----------- -----------
  checks            team delete    DELETE      authenticated   true        ---
                    checks                                                 

  checks            team insert    INSERT      authenticated   ---         true
                    checks                                                 

  checks            team read      SELECT      authenticated   true        ---
                    checks                                                 

  checks            team update    UPDATE      authenticated   true        true
                    checks                                                 

  fleet_app_state   fleet_insert   INSERT      authenticated   ---         true

  fleet_app_state   fleet_read     SELECT      authenticated   true        ---

  fleet_app_state   fleet_update   UPDATE      authenticated   true        true

  vehicles          team delete    DELETE      authenticated   true        ---
                    vehicles                                               

  vehicles          team insert    INSERT      authenticated   ---         true
                    vehicles                                               

  vehicles          team read      SELECT      authenticated   true        ---
                    vehicles                                               

  vehicles          team update    UPDATE      authenticated   true        true
                    vehicles                                               
  ------------------------------------------------------------------------------------

Toutes sont PERMISSIVE. Les expressions `true` ne filtrent pas les
lignes individuellement pour `authenticated` : ce point est à examiner
avant toute évolution. Aucune modification n'a été effectuée.

## 6. Fonction personnalisée

`public.rls_auto_enable()` --- FUNCTION, retourne `event_trigger`,
`SECURITY DEFINER`, `search_path` limité à `pg_catalog`.

Définition relevée :

``` sql
CREATE OR REPLACE FUNCTION public.rls_auto_enable()
 RETURNS event_trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
DECLARE
  cmd record;
  tbl name;
BEGIN
  FOR cmd IN
    SELECT *
    FROM pg_event_trigger_ddl_commands()
    WHERE command_tag IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
      AND object_type IN ('table','partitioned table')
  LOOP
     IF cmd.schema_name IS NOT NULL AND cmd.schema_name IN ('public') AND cmd.schema_name NOT IN ('pg_catalog','information_schema') AND cmd.schema_name NOT LIKE 'pg_toast%' AND cmd.schema_name NOT LIKE 'pg_temp%' THEN
      BEGIN
        SELECT c.relname INTO tbl FROM pg_catalog.pg_class c WHERE c.oid = cmd.objid;
        EXECUTE format('alter table if exists %I.%I enable row level security', cmd.schema_name, tbl);
        RAISE LOG 'rls_auto_enable: enabled RLS on %', cmd.object_identity;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE LOG 'rls_auto_enable: failed to enable RLS on %', cmd.object_identity;
      END;
     ELSE
        RAISE LOG 'rls_auto_enable: skip % (either system schema or not in enforced list: %.)', cmd.object_identity, cmd.schema_name;
     END IF;
  END LOOP;
END;
$function$
```

## 7. Déclencheur d'événement

-   `ensure_rls`
-   Événement : `ddl_command_end`
-   Fonction appelée : `rls_auto_enable`
-   `evtenabled = O` : activé en mode normal.

Autres event triggers système relevés : `issue_graphql_placeholder`,
`pgrst_ddl_watch`, `pgrst_drop_watch`, `issue_pg_cron_access`,
`issue_pg_net_access`, `issue_pg_graphql_access`.

## 8. Séquences

La requête sur `pg_sequences` dans `public` n'a renvoyé aucune ligne.
Les colonnes `id` de `vehicles` et `checks` n'ont pas de
`column_default`. Ne pas inventer ni créer de séquence sans avoir
vérifié le mécanisme d'attribution des identifiants utilisé par
l'application.

## 9. Storage et photos

-   L'inventaire des buckets Storage n'a renvoyé aucune ligne.
-   `checks` : 133 lignes, 0 valeur non nulle dans `photo_url`.
-   Cela ne prouve pas qu'aucune image n'existe dans un autre
    emplacement.

## 10. Copies déjà signalées

-   Archive `DSP_Controle_Flotte_PWA_installable.zip` déposée dans le
    dépôt GitHub privé.
-   `vehicles.csv` et `checks.csv` déposés dans Google Drive, dossier
    `SAUVEGARDE DSP CONTRÔLE FLOTTE`.

Le contenu, la date et la capacité de restauration de ces copies restent
à vérifier. L'archive PWA est une copie des fichiers de
déploiement/test, pas nécessairement le code source original ni la
dernière version de production.

## 11. À terminer avant toute modification

1.  Vérifier que les CSV contiennent bien les 69 véhicules et 133
    contrôles attendus.
2.  Obtenir une sauvegarde réelle de la structure SQL et des données,
    puis tester une restauration.
3.  Vérifier les paramètres Auth, permissions, fonctions, déclencheurs,
    politiques et éventuels autres objets nécessaires.
4.  Confirmer comment les identifiants `id` sont attribués avant toute
    restauration/insertion.
5.  Ne jamais partager la clé `service_role`, le mot de passe de base ou
    d'autres secrets.
6.  Ne pas supprimer, recréer, écraser ou republier la version Netlify
    actuelle avant validation d'une copie restaurable.

**Aucune commande de modification de base n'a été exécutée pendant cet
inventaire.**
