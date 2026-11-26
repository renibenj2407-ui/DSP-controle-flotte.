-- DSP CONTROLE FLOTTE MULTICOURSE PDL
-- Structure des tables - Inventaire du 26/11/2026
-- ATTENTION : document de sauvegarde technique.
-- Ne pas executer directement sur la base de production.

CREATE TABLE public.vehicles (
    id bigint NOT NULL,
    name text NOT NULL,
    plate text,
    model text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT vehicles_pkey PRIMARY KEY (id)
);

CREATE TABLE public.checks (
    id bigint NOT NULL,
    vehicle_id bigint,
    check_date date NOT NULL,
    inspector text NOT NULL,
    driver text,
    status text NOT NULL,
    notes text,
    marks jsonb DEFAULT '[]'::jsonb,
    clean_status text,
    clean_note text,
    photo_url text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT checks_pkey PRIMARY KEY (id),
    CONSTRAINT checks_vehicle_id_fkey
        FOREIGN KEY (vehicle_id)
        REFERENCES public.vehicles(id)
        ON DELETE SET NULL
);

CREATE TABLE public.fleet_app_state (
    id text NOT NULL DEFAULT 'main'::text,
    vehicles jsonb NOT NULL DEFAULT '[]'::jsonb,
    checks jsonb NOT NULL DEFAULT '[]'::jsonb,
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_by text,
    CONSTRAINT fleet_app_state_pkey PRIMARY KEY (id),
    CONSTRAINT fleet_app_state_singleton CHECK (id = 'main'::text)
);

ALTER TABLE public.vehicles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.checks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fleet_app_state ENABLE ROW LEVEL SECURITY;
-- POLITIQUES RLS EXISTANTES

CREATE POLICY "team read vehicles"
ON public.vehicles FOR SELECT
TO authenticated USING (true);

CREATE POLICY "team insert vehicles"
ON public.vehicles FOR INSERT
TO authenticated WITH CHECK (true);

CREATE POLICY "team update vehicles"
ON public.vehicles FOR UPDATE
TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "team delete vehicles"
ON public.vehicles FOR DELETE
TO authenticated USING (true);

CREATE POLICY "team read checks"
ON public.checks FOR SELECT
TO authenticated USING (true);

CREATE POLICY "team insert checks"
ON public.checks FOR INSERT
TO authenticated WITH CHECK (true);

CREATE POLICY "team update checks"
ON public.checks FOR UPDATE
TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "team delete checks"
ON public.checks FOR DELETE
TO authenticated USING (true);

CREATE POLICY "fleet_read"
ON public.fleet_app_state FOR SELECT
TO authenticated USING (true);

CREATE POLICY "fleet_insert"
ON public.fleet_app_state FOR INSERT
TO authenticated WITH CHECK (true);

CREATE POLICY "fleet_update"
ON public.fleet_app_state FOR UPDATE
TO authenticated USING (true) WITH CHECK (true);
-- IMPORTANT :
-- Ce fichier constitue une sauvegarde partielle de la structure.
-- Il ne contient pas les données des 69 véhicules et des 133 contrôles.
-- Il ne constitue pas encore une sauvegarde complète et restaurable.
-- Ne pas executer sur la base de production.
