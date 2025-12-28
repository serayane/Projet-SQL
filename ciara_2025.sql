DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;
DROP TABLE IF EXISTS "public"."vehicule";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS vehicule_id_vehicule_seq;

-- Table Definition
CREATE TABLE "public"."vehicule" (
    "id_vehicule" int4 NOT NULL DEFAULT nextval('vehicule_id_vehicule_seq'::regclass),
    "marque" varchar(50),
    "modele" varchar(50),
    "annee" int4,
    "energie" varchar(50),
    "autonomie_km" int4,
    "immatriculation" varchar(50),
    "etat" varchar(50),
    "localisation" varchar(100),
    PRIMARY KEY ("id_vehicule")
);


-- Indices
CREATE UNIQUE INDEX vehicule_immatriculation_key ON public.vehicule USING btree (immatriculation);

DROP TABLE IF EXISTS "public"."type_vehicule";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS type_vehicule_id_type_vehicule_seq;

-- Table Definition
CREATE TABLE "public"."type_vehicule" (
    "id_type_vehicule" int4 NOT NULL DEFAULT nextval('type_vehicule_id_type_vehicule_seq'::regclass),
    "libelle_type" varchar(50) NOT NULL,
    PRIMARY KEY ("id_type_vehicule")
);

DROP TABLE IF EXISTS "public"."technicien";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS technicien_id_technicien_seq;

-- Table Definition
CREATE TABLE "public"."technicien" (
    "id_technicien" int4 NOT NULL DEFAULT nextval('technicien_id_technicien_seq'::regclass),
    "nom" varchar(50) NOT NULL,
    "prenom" varchar(50) NOT NULL,
    "specialiste" varchar(50),
    PRIMARY KEY ("id_technicien")
);

DROP TABLE IF EXISTS "public"."maintenance";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS maintenance_id_maintenance_seq;

-- Table Definition
CREATE TABLE "public"."maintenance" (
    "id_maintenance" int4 NOT NULL DEFAULT nextval('maintenance_id_maintenance_seq'::regclass),
    "date_intervention" date NOT NULL,
    "type_intervention" varchar(50),
    "commentaire" text,
    "statut" varchar(20),
    "id_vehicule" int4,
    "id_technicien" int4,
    CONSTRAINT "maintenance_id_vehicule_fkey" FOREIGN KEY ("id_vehicule") REFERENCES "public"."vehicule"("id_vehicule"),
    CONSTRAINT "maintenance_id_technicien_fkey" FOREIGN KEY ("id_technicien") REFERENCES "public"."technicien"("id_technicien"),
    PRIMARY KEY ("id_maintenance")
);

DROP TABLE IF EXISTS "public"."station";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS station_id_station_seq;

-- Table Definition
CREATE TABLE "public"."station" (
    "id_station" int4 NOT NULL DEFAULT nextval('station_id_station_seq'::regclass),
    "nom_station" varchar(100) NOT NULL,
    "addresse" text,
    "latitude" numeric(9,6),
    "longitude" numeric(9,6),
    PRIMARY KEY ("id_station")
);

DROP TABLE IF EXISTS "public"."borne_recharge";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS borne_recharge_id_borne_seq;

-- Table Definition
CREATE TABLE "public"."borne_recharge" (
    "id_borne" int4 NOT NULL DEFAULT nextval('borne_recharge_id_borne_seq'::regclass),
    "statuts" varchar(20),
    "id_station" int4,
    CONSTRAINT "borne_recharge_id_station_fkey" FOREIGN KEY ("id_station") REFERENCES "public"."station"("id_station"),
    PRIMARY KEY ("id_borne")
);

DROP TABLE IF EXISTS "public"."client";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS client_id_client_seq;

-- Table Definition
CREATE TABLE "public"."client" (
    "id_client" int4 NOT NULL DEFAULT nextval('client_id_client_seq'::regclass),
    "nom" varchar(50) NOT NULL,
    "prenom" varchar(50) NOT NULL,
    "email" varchar(100) NOT NULL,
    "telephone" varchar(20),
    "date_dinscription" date DEFAULT CURRENT_DATE,
    PRIMARY KEY ("id_client")
);


-- Indices
CREATE UNIQUE INDEX client_email_key ON public.client USING btree (email);

DROP TABLE IF EXISTS "public"."reservation";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS reservation_id_reservation_seq;

-- Table Definition
CREATE TABLE "public"."reservation" (
    "id_reservation" int4 NOT NULL DEFAULT nextval('reservation_id_reservation_seq'::regclass),
    "date_debut_prevue" timestamp NOT NULL,
    "date_fin_prevue" timestamp NOT NULL,
    "statuts" varchar(20),
    "id_client" int4,
    "id_vehicule" int4,
    CONSTRAINT "reservation_id_client_fkey" FOREIGN KEY ("id_client") REFERENCES "public"."client"("id_client"),
    CONSTRAINT "reservation_id_vehicule_fkey" FOREIGN KEY ("id_vehicule") REFERENCES "public"."vehicule"("id_vehicule"),
    PRIMARY KEY ("id_reservation")
);

DROP TABLE IF EXISTS "public"."location";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS location_id_location_seq;

-- Table Definition
CREATE TABLE "public"."location" (
    "id_location" int4 NOT NULL DEFAULT nextval('location_id_location_seq'::regclass),
    "date_debut" timestamp NOT NULL,
    "date_fin" timestamp,
    "status" varchar(20),
    "id_client" int4,
    "id_vehicule" int4,
    "id_station_depart" int4,
    "id_station_arrivee" int4,
    CONSTRAINT "location_id_client_fkey" FOREIGN KEY ("id_client") REFERENCES "public"."client"("id_client"),
    CONSTRAINT "location_id_vehicule_fkey" FOREIGN KEY ("id_vehicule") REFERENCES "public"."vehicule"("id_vehicule"),
    CONSTRAINT "location_id_station_depart_fkey" FOREIGN KEY ("id_station_depart") REFERENCES "public"."station"("id_station"),
    CONSTRAINT "location_id_station_arrivee_fkey" FOREIGN KEY ("id_station_arrivee") REFERENCES "public"."station"("id_station"),
    PRIMARY KEY ("id_location")
);

DROP TABLE IF EXISTS "public"."paiements";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS paiements_id_paiement_seq;

-- Table Definition
CREATE TABLE "public"."paiements" (
    "id_paiement" int4 NOT NULL DEFAULT nextval('paiements_id_paiement_seq'::regclass),
    "montant" numeric(10,2) NOT NULL,
    "moyen_paiement" varchar(50),
    "date_paiement" timestamp DEFAULT CURRENT_TIMESTAMP,
    "statut" varchar(20),
    "id_location" int4,
    CONSTRAINT "paiements_id_location_fkey" FOREIGN KEY ("id_location") REFERENCES "public"."location"("id_location"),
    PRIMARY KEY ("id_paiement")
);

INSERT INTO "public"."vehicule" ("id_vehicule", "marque", "modele", "annee", "energie", "autonomie_km", "immatriculation", "etat", "localisation") VALUES
(1, 'Kia', 'EV6', 2022, 'Electrique', 320, 'XR-964-LJ', 'En maintenance', 'Strasbourg'),
(2, 'Kia', 'EV6', 2024, 'Electrique', 270, 'OY-932-RY', 'En maintenance', 'Nantes'),
(3, 'Hyundai', 'Ioniq 5', 2022, 'Electrique', 380, 'BJ-663-FL', 'Hors service', 'Marseille'),
(4, 'Kia', 'EV6', 2024, 'Electrique', 480, 'MW-909-XP', 'Hors service', 'Montpellier'),
(5, 'Mercedes', 'EQA', 2021, 'Electrique', 390, 'UN-317-LM', 'En maintenance', 'Lyon'),
(6, 'Hyundai', 'Ioniq 5', 2024, 'Electrique', 330, 'PU-953-NB', 'En maintenance', 'Montpellier'),
(7, 'BMW', 'iX1', 2024, 'Electrique', 270, 'YO-412-AH', 'Hors service', 'Toulouse'),
(8, 'Nissan', 'Leaf', 2024, 'Electrique', 270, 'SO-650-ZD', 'Disponible', 'Lyon'),
(9, 'Toyota', 'Proace Electric', 2023, 'Electrique', 530, 'YE-805-LI', 'En maintenance', 'Nice'),
(10, 'Renault', 'Megane E-Tech', 2024, 'Electrique', 550, 'YE-951-QU', 'Disponible', 'Montpellier'),
(11, 'Citroen', 'Ami', 2024, 'Electrique', 550, 'WT-751-VN', 'Disponible', 'Lyon'),
(12, 'Mercedes', 'EQB', 2024, 'Electrique', 420, 'OD-742-GO', 'En maintenance', 'Toulouse'),
(13, 'Volkswagen', 'ID.5', 2022, 'Electrique', 550, 'KO-197-KW', 'Hors service', 'Nantes'),
(14, 'Mercedes', 'EQA', 2022, 'Electrique', 500, 'KM-850-ZY', 'En maintenance', 'Lille'),
(15, 'Kia', 'Soul EV', 2024, 'Electrique', 360, 'TR-567-ZM', 'Hors service', 'Nantes'),
(16, 'Renault', 'Megane E-Tech', 2021, 'Electrique', 590, 'JR-526-BM', 'Disponible', 'Marseille'),
(17, 'Citroen', 'Ami', 2023, 'Electrique', 340, 'XF-922-TM', 'Hors service', 'Strasbourg'),
(18, 'Tesla', 'Model 3', 2022, 'Electrique', 270, 'HU-769-AI', 'En maintenance', 'Nice'),
(19, 'Kia', 'Soul EV', 2022, 'Electrique', 510, 'IW-415-IT', 'En service', 'Toulouse'),
(20, 'Mercedes', 'EQA', 2022, 'Electrique', 500, 'IL-910-WY', 'Disponible', 'Paris'),
(21, 'Mercedes', 'EQB', 2023, 'Electrique', 330, 'FF-812-UQ', 'En maintenance', 'Nantes'),
(22, 'Toyota', 'Proace Electric', 2024, 'Electrique', 320, 'UD-673-OE', 'En maintenance', 'Lyon'),
(23, 'Mercedes', 'EQA', 2021, 'Electrique', 420, 'AQ-685-JB', 'En service', 'Montpellier'),
(24, 'Toyota', 'Proace Electric', 2022, 'Electrique', 290, 'PS-158-WM', 'En maintenance', 'Marseille'),
(25, 'Nissan', 'Ariya', 2021, 'Electrique', 470, 'WN-898-EP', 'En maintenance', 'Bordeaux'),
(26, 'Volkswagen', 'ID.4', 2023, 'Electrique', 580, 'XU-837-FD', 'Disponible', 'Lille'),
(27, 'Peugeot', 'e-308', 2023, 'Electrique', 320, 'ON-875-UO', 'Hors service', 'Marseille'),
(28, 'Toyota', 'Proace Electric', 2023, 'Electrique', 430, 'GO-836-IU', 'En maintenance', 'Nantes'),
(29, 'Citroen', 'Ami', 2022, 'Electrique', 480, 'VE-965-UY', 'Disponible', 'Lyon'),
(30, 'Hyundai', 'Ioniq 5', 2024, 'Electrique', 410, 'UE-921-ED', 'En maintenance', 'Nantes'),
(31, 'Mercedes', 'EQA', 2021, 'Electrique', 450, 'YA-188-TY', 'En maintenance', 'Nice'),
(32, 'Citroen', 'Ami', 2023, 'Electrique', 340, 'HV-248-IT', 'En service', 'Toulouse'),
(33, 'Hyundai', 'Ioniq 5', 2022, 'Electrique', 500, 'TZ-433-HF', 'En maintenance', 'Strasbourg'),
(34, 'Fiat', '500e', 2021, 'Electrique', 320, 'NQ-819-BP', 'Hors service', 'Lille'),
(35, 'Fiat', 'Panda EV', 2022, 'Electrique', 540, 'DW-525-FC', 'En service', 'Paris'),
(36, 'Renault', 'Zoe', 2023, 'Electrique', 300, 'QC-782-KP', 'En maintenance', 'Lyon'),
(37, 'BMW', 'iX1', 2022, 'Electrique', 400, 'UG-214-SA', 'En service', 'Bordeaux'),
(38, 'Mercedes', 'EQB', 2021, 'Electrique', 290, 'IT-929-YS', 'Hors service', 'Lyon'),
(39, 'Nissan', 'Leaf', 2022, 'Electrique', 490, 'TH-749-AC', 'En service', 'Montpellier'),
(40, 'Tesla', 'Model 3', 2022, 'Electrique', 390, 'NC-394-CX', 'Disponible', 'Paris'),
(41, 'Volkswagen', 'ID.4', 2023, 'Electrique', 340, 'HX-598-OS', 'En maintenance', 'Strasbourg'),
(42, 'Citroen', 'Berlingo EV', 2023, 'Electrique', 450, 'AN-441-ZU', 'Disponible', 'Bordeaux'),
(43, 'Mercedes', 'EQE', 2022, 'Electrique', 520, 'QN-135-FB', 'En maintenance', 'Nice'),
(44, 'Fiat', '500e', 2024, 'Electrique', 590, 'ZO-456-RC', 'Hors service', 'Marseille'),
(45, 'Tesla', 'Model Y', 2022, 'Electrique', 450, 'HY-708-CY', 'Hors service', 'Lille'),
(46, 'Hyundai', 'Kona Electric', 2023, 'Electrique', 560, 'AR-624-YF', 'Hors service', 'Montpellier'),
(47, 'Citroen', 'e-C4', 2022, 'Electrique', 420, 'TW-514-GR', 'Disponible', 'Nice'),
(48, 'Toyota', 'bZ4X', 2021, 'Electrique', 250, 'SI-389-FD', 'Disponible', 'Lyon'),
(49, 'Toyota', 'bZ4X', 2023, 'Electrique', 320, 'QI-180-WY', 'En service', 'Nantes'),
(50, 'Renault', 'Zoe', 2024, 'Electrique', 550, 'SW-740-DO', 'Hors service', 'Nice'),
(51, 'Tesla', 'Model S', 2023, 'Electrique', 340, 'FF-225-KQ', 'Hors service', 'Lille'),
(52, 'Volkswagen', 'ID.3', 2024, 'Electrique', 480, 'QS-174-ZR', 'Disponible', 'Bordeaux'),
(53, 'Tesla', 'Model S', 2024, 'Electrique', 260, 'LP-456-BF', 'Disponible', 'Nice'),
(54, 'Tesla', 'Model Y', 2024, 'Electrique', 410, 'WE-429-FR', 'Hors service', 'Montpellier'),
(55, 'Peugeot', 'e-208', 2021, 'Electrique', 390, 'EL-581-UI', 'Hors service', 'Montpellier'),
(56, 'Mercedes', 'EQE', 2021, 'Electrique', 250, 'RJ-910-JH', 'En service', 'Lille'),
(57, 'Mercedes', 'EQB', 2024, 'Electrique', 540, 'MM-708-MP', 'Disponible', 'Lyon'),
(58, 'Toyota', 'bZ4X', 2023, 'Electrique', 410, 'AX-830-FQ', 'En maintenance', 'Lille'),
(59, 'Renault', 'Megane E-Tech', 2022, 'Electrique', 570, 'TE-356-RM', 'Hors service', 'Nantes'),
(60, 'Nissan', 'Leaf', 2021, 'Electrique', 250, 'EB-604-AD', 'En service', 'Paris'),
(61, 'Fiat', '500e', 2021, 'Electrique', 430, 'SU-704-FB', 'En service', 'Montpellier'),
(62, 'Mercedes', 'EQE', 2022, 'Electrique', 450, 'VA-230-KN', 'Hors service', 'Bordeaux'),
(63, 'Citroen', 'Berlingo EV', 2023, 'Electrique', 250, 'AN-425-ZW', 'Hors service', 'Marseille'),
(64, 'Renault', 'Twingo E-Tech', 2024, 'Electrique', 350, 'KZ-306-XV', 'Disponible', 'Bordeaux'),
(65, 'Tesla', 'Model 3', 2021, 'Electrique', 570, 'SD-357-YU', 'Disponible', 'Montpellier'),
(66, 'Nissan', 'Ariya', 2023, 'Electrique', 490, 'FO-267-ZD', 'En maintenance', 'Lille'),
(67, 'Kia', 'EV6', 2022, 'Electrique', 260, 'LS-696-PV', 'Disponible', 'Bordeaux'),
(68, 'Citroen', 'Ami', 2023, 'Electrique', 310, 'ZV-338-JX', 'Hors service', 'Toulouse'),
(69, 'Mercedes', 'EQA', 2024, 'Electrique', 480, 'TC-188-QF', 'Hors service', 'Nice'),
(70, 'Mercedes', 'EQA', 2023, 'Electrique', 360, 'QD-535-RQ', 'En service', 'Paris'),
(71, 'Fiat', '500e', 2021, 'Electrique', 260, 'YW-289-PL', 'En maintenance', 'Paris'),
(72, 'Hyundai', 'Ioniq 6', 2024, 'Electrique', 310, 'CX-634-XG', 'Hors service', 'Bordeaux'),
(73, 'Peugeot', 'e-2008', 2023, 'Electrique', 550, 'SE-164-IS', 'En maintenance', 'Strasbourg'),
(74, 'Nissan', 'Ariya', 2023, 'Electrique', 300, 'SW-661-EL', 'Hors service', 'Strasbourg'),
(75, 'Mercedes', 'EQA', 2021, 'Electrique', 490, 'FV-360-TH', 'En maintenance', 'Marseille'),
(76, 'Renault', 'Zoe', 2021, 'Electrique', 540, 'RW-414-YG', 'Hors service', 'Lille'),
(77, 'Toyota', 'bZ4X', 2023, 'Electrique', 350, 'KE-749-OR', 'En maintenance', 'Strasbourg'),
(78, 'Mercedes', 'EQE', 2021, 'Electrique', 570, 'EM-599-QD', 'En service', 'Toulouse'),
(79, 'Kia', 'Soul EV', 2023, 'Electrique', 360, 'YL-392-JL', 'Hors service', 'Toulouse'),
(80, 'Renault', 'Megane E-Tech', 2023, 'Electrique', 340, 'SW-667-JM', 'Disponible', 'Lille'),
(81, 'Hyundai', 'Kona Electric', 2022, 'Electrique', 400, 'HO-110-PM', 'En service', 'Lille'),
(82, 'Hyundai', 'Ioniq 5', 2023, 'Electrique', 280, 'CN-775-SP', 'Hors service', 'Bordeaux'),
(83, 'Tesla', 'Model 3', 2024, 'Electrique', 490, 'NW-528-XK', 'Hors service', 'Nantes'),
(84, 'Fiat', 'Panda EV', 2021, 'Electrique', 520, 'PV-742-CK', 'Hors service', 'Montpellier'),
(85, 'Fiat', '500e', 2021, 'Electrique', 360, 'WZ-347-FT', 'En service', 'Paris'),
(86, 'Tesla', 'Model Y', 2022, 'Electrique', 330, 'JX-290-MI', 'Disponible', 'Marseille'),
(87, 'Hyundai', 'Ioniq 5', 2023, 'Electrique', 540, 'DP-239-MK', 'Hors service', 'Lille'),
(88, 'Kia', 'EV6', 2021, 'Electrique', 300, 'BP-212-VV', 'En service', 'Nantes'),
(89, 'Citroen', 'Ami', 2021, 'Electrique', 310, 'WS-948-XM', 'Disponible', 'Nice'),
(90, 'Toyota', 'Proace Electric', 2024, 'Electrique', 400, 'UO-609-AK', 'Hors service', 'Bordeaux'),
(91, 'Toyota', 'bZ4X', 2022, 'Electrique', 330, 'DE-120-IL', 'En maintenance', 'Nice'),
(92, 'Nissan', 'Ariya', 2023, 'Electrique', 360, 'NL-530-PG', 'En maintenance', 'Paris'),
(93, 'Toyota', 'Proace Electric', 2023, 'Electrique', 300, 'GJ-521-QR', 'Disponible', 'Toulouse'),
(94, 'Citroen', 'Berlingo EV', 2024, 'Electrique', 550, 'OE-844-KP', 'En maintenance', 'Lille'),
(95, 'Hyundai', 'Ioniq 6', 2021, 'Electrique', 470, 'HW-712-EI', 'Hors service', 'Montpellier'),
(96, 'Fiat', 'Panda EV', 2021, 'Electrique', 330, 'TF-251-SI', 'Disponible', 'Strasbourg'),
(97, 'Tesla', 'Model 3', 2023, 'Electrique', 410, 'ZK-632-LE', 'En maintenance', 'Bordeaux'),
(98, 'Renault', 'Zoe', 2023, 'Electrique', 270, 'OM-169-MV', 'En service', 'Nantes'),
(99, 'BMW', 'i4', 2022, 'Electrique', 590, 'ET-620-CS', 'Hors service', 'Marseille'),
(100, 'Kia', 'Niro EV', 2024, 'Electrique', 570, 'LG-389-OK', 'Hors service', 'Bordeaux'),
(101, 'Peugeot', 'e-2008', 2023, 'Electrique', 490, 'WI-254-SD', 'Disponible', 'Lille'),
(102, 'Volkswagen', 'ID.5', 2022, 'Electrique', 540, 'WL-753-WR', 'Hors service', 'Lille'),
(103, 'Kia', 'Soul EV', 2023, 'Electrique', 350, 'IR-711-JA', 'En service', 'Lyon'),
(104, 'Mercedes', 'EQE', 2021, 'Electrique', 470, 'RP-199-AS', 'En maintenance', 'Montpellier'),
(105, 'Renault', 'Megane E-Tech', 2021, 'Electrique', 400, 'XT-498-QA', 'En maintenance', 'Montpellier'),
(106, 'Volkswagen', 'ID.5', 2021, 'Electrique', 290, 'WG-359-PO', 'Disponible', 'Toulouse'),
(107, 'Mercedes', 'EQA', 2022, 'Electrique', 340, 'FX-993-XP', 'Disponible', 'Lyon'),
(108, 'Toyota', 'bZ4X', 2024, 'Electrique', 480, 'MB-368-UO', 'En maintenance', 'Lille'),
(109, 'BMW', 'iX1', 2024, 'Electrique', 290, 'QL-947-DJ', 'Hors service', 'Nantes'),
(110, 'Citroen', 'Ami', 2023, 'Electrique', 570, 'BZ-366-UO', 'Hors service', 'Nantes'),
(111, 'Citroen', 'e-C4', 2022, 'Electrique', 260, 'WJ-620-FG', 'En maintenance', 'Montpellier'),
(112, 'Mercedes', 'EQA', 2023, 'Electrique', 370, 'RZ-370-NL', 'Disponible', 'Toulouse'),
(113, 'Nissan', 'Leaf', 2024, 'Electrique', 390, 'BP-234-SK', 'Disponible', 'Bordeaux'),
(114, 'Fiat', 'Panda EV', 2023, 'Electrique', 350, 'XJ-945-HM', 'En maintenance', 'Marseille'),
(115, 'Mercedes', 'EQB', 2022, 'Electrique', 530, 'DH-852-NY', 'Disponible', 'Marseille'),
(116, 'Mercedes', 'EQA', 2021, 'Electrique', 280, 'NK-133-FM', 'En service', 'Montpellier'),
(117, 'BMW', 'iX1', 2024, 'Electrique', 490, 'WD-869-LS', 'En maintenance', 'Toulouse'),
(118, 'BMW', 'i4', 2024, 'Electrique', 250, 'ZR-949-AH', 'Disponible', 'Paris'),
(119, 'Nissan', 'Ariya', 2022, 'Electrique', 510, 'NL-355-NC', 'En maintenance', 'Paris'),
(120, 'Volkswagen', 'ID.4', 2023, 'Electrique', 260, 'PR-323-VJ', 'Disponible', 'Strasbourg'),
(121, 'Tesla', 'Model Y', 2023, 'Electrique', 360, 'AE-397-CK', 'Disponible', 'Strasbourg'),
(122, 'Fiat', 'Panda EV', 2024, 'Electrique', 340, 'FT-670-QN', 'Hors service', 'Toulouse'),
(123, 'Peugeot', 'e-2008', 2021, 'Electrique', 480, 'PS-782-EL', 'En maintenance', 'Montpellier'),
(124, 'Nissan', 'Ariya', 2023, 'Electrique', 440, 'DK-304-FY', 'Hors service', 'Bordeaux'),
(125, 'Fiat', 'Panda EV', 2023, 'Electrique', 350, 'FC-495-SL', 'En service', 'Strasbourg'),
(126, 'Fiat', 'Panda EV', 2024, 'Electrique', 520, 'VK-465-JT', 'En maintenance', 'Nice'),
(127, 'Mercedes', 'EQB', 2021, 'Electrique', 370, 'QY-837-UB', 'En maintenance', 'Nantes'),
(128, 'Fiat', 'Panda EV', 2023, 'Electrique', 310, 'NH-411-OO', 'Disponible', 'Montpellier'),
(129, 'Mercedes', 'EQB', 2022, 'Electrique', 440, 'LJ-641-IZ', 'Hors service', 'Lille'),
(130, 'Tesla', 'Model S', 2021, 'Electrique', 530, 'UM-650-SA', 'Disponible', 'Lyon'),
(131, 'Kia', 'EV6', 2022, 'Electrique', 590, 'RB-458-VO', 'Hors service', 'Nantes'),
(132, 'Mercedes', 'EQB', 2022, 'Electrique', 510, 'VE-861-VS', 'Hors service', 'Lille'),
(133, 'Mercedes', 'EQE', 2022, 'Electrique', 300, 'CJ-528-YK', 'En service', 'Bordeaux'),
(134, 'Tesla', 'Model 3', 2024, 'Electrique', 560, 'SO-450-TY', 'En maintenance', 'Marseille'),
(135, 'Hyundai', 'Kona Electric', 2024, 'Electrique', 250, 'JL-958-MC', 'Disponible', 'Paris'),
(136, 'Nissan', 'Ariya', 2022, 'Electrique', 450, 'BL-747-IP', 'Disponible', 'Lyon'),
(137, 'Peugeot', 'e-308', 2024, 'Electrique', 560, 'IJ-140-LZ', 'Disponible', 'Lille'),
(138, 'Nissan', 'Leaf', 2023, 'Electrique', 530, 'ME-146-YS', 'Disponible', 'Bordeaux'),
(139, 'Nissan', 'Ariya', 2023, 'Electrique', 360, 'WU-151-UG', 'Disponible', 'Nantes'),
(140, 'Volkswagen', 'ID.5', 2024, 'Electrique', 370, 'MN-866-BT', 'En maintenance', 'Marseille'),
(141, 'Tesla', 'Model 3', 2024, 'Electrique', 270, 'KH-489-MM', 'En service', 'Nantes'),
(142, 'Mercedes', 'EQE', 2024, 'Electrique', 590, 'ZF-466-DO', 'En maintenance', 'Bordeaux'),
(143, 'Fiat', 'Panda EV', 2024, 'Electrique', 270, 'RG-111-UB', 'En maintenance', 'Paris'),
(144, 'Peugeot', 'e-2008', 2022, 'Electrique', 420, 'UT-617-SM', 'En service', 'Lille'),
(145, 'Fiat', 'Panda EV', 2021, 'Electrique', 510, 'VK-657-DT', 'Hors service', 'Bordeaux'),
(146, 'Tesla', 'Model 3', 2024, 'Electrique', 430, 'VN-439-QX', 'En service', 'Montpellier'),
(147, 'Kia', 'Soul EV', 2022, 'Electrique', 500, 'TW-416-PG', 'En maintenance', 'Marseille'),
(148, 'Citroen', 'Berlingo EV', 2022, 'Electrique', 480, 'XI-615-WE', 'Hors service', 'Nantes'),
(149, 'Citroen', 'Ami', 2024, 'Electrique', 460, 'AM-438-XO', 'Hors service', 'Toulouse'),
(150, 'Toyota', 'Proace Electric', 2023, 'Electrique', 330, 'IS-472-XI', 'En maintenance', 'Nantes'),
(151, 'Mercedes', 'EQE', 2022, 'Electrique', 370, 'VH-124-QD', 'Disponible', 'Bordeaux'),
(152, 'Nissan', 'Ariya', 2022, 'Electrique', 320, 'UH-682-IO', 'En maintenance', 'Marseille'),
(153, 'Hyundai', 'Kona Electric', 2024, 'Electrique', 500, 'DE-955-XC', 'Hors service', 'Lyon'),
(154, 'Fiat', '500e', 2022, 'Electrique', 580, 'EB-649-OH', 'En service', 'Nice'),
(155, 'Nissan', 'Ariya', 2022, 'Electrique', 560, 'XN-131-XQ', 'En maintenance', 'Nantes'),
(156, 'Mercedes', 'EQA', 2023, 'Electrique', 290, 'YT-400-RA', 'En service', 'Nantes'),
(157, 'Peugeot', 'e-208', 2024, 'Electrique', 560, 'BN-764-CE', 'En service', 'Paris'),
(158, 'Hyundai', 'Ioniq 6', 2023, 'Electrique', 260, 'MC-203-SW', 'Disponible', 'Lyon'),
(159, 'BMW', 'iX1', 2023, 'Electrique', 480, 'TH-109-OL', 'En service', 'Lyon'),
(160, 'Mercedes', 'EQB', 2023, 'Electrique', 490, 'HA-896-FD', 'En service', 'Toulouse'),
(161, 'Toyota', 'Proace Electric', 2023, 'Electrique', 320, 'IV-986-QN', 'Disponible', 'Nantes'),
(162, 'Mercedes', 'EQE', 2023, 'Electrique', 440, 'TS-753-YT', 'Hors service', 'Nice'),
(163, 'Mercedes', 'EQE', 2021, 'Electrique', 480, 'HQ-340-ME', 'Hors service', 'Lille'),
(164, 'Peugeot', 'e-2008', 2023, 'Electrique', 490, 'TM-569-HA', 'Disponible', 'Marseille'),
(165, 'Toyota', 'bZ4X', 2023, 'Electrique', 440, 'WK-987-YD', 'Disponible', 'Nice'),
(166, 'Peugeot', 'e-308', 2023, 'Electrique', 490, 'UD-306-PX', 'Hors service', 'Nantes'),
(167, 'Kia', 'EV6', 2021, 'Electrique', 280, 'BU-389-QH', 'En service', 'Nice'),
(168, 'Renault', 'Twingo E-Tech', 2024, 'Electrique', 260, 'SV-706-SJ', 'En service', 'Lille'),
(169, 'Volkswagen', 'ID.3', 2022, 'Electrique', 300, 'OI-419-ZT', 'En service', 'Lyon'),
(170, 'Peugeot', 'e-2008', 2024, 'Electrique', 480, 'LN-599-UP', 'En maintenance', 'Lille'),
(171, 'Tesla', 'Model Y', 2024, 'Electrique', 560, 'GD-271-MQ', 'Disponible', 'Toulouse'),
(172, 'Fiat', 'Panda EV', 2022, 'Electrique', 500, 'PF-512-MT', 'En service', 'Lille'),
(173, 'Volkswagen', 'ID.4', 2022, 'Electrique', 350, 'SB-817-VP', 'En service', 'Toulouse'),
(174, 'Peugeot', 'e-208', 2021, 'Electrique', 330, 'VY-619-MP', 'En service', 'Marseille'),
(175, 'BMW', 'i4', 2023, 'Electrique', 330, 'DR-314-DR', 'Hors service', 'Bordeaux'),
(176, 'Fiat', 'Panda EV', 2021, 'Electrique', 270, 'JY-869-HY', 'Disponible', 'Nantes'),
(177, 'Kia', 'Niro EV', 2024, 'Electrique', 340, 'QJ-391-VO', 'En service', 'Lille'),
(178, 'Renault', 'Twingo E-Tech', 2023, 'Electrique', 340, 'SB-797-MR', 'En maintenance', 'Toulouse'),
(179, 'Kia', 'Niro EV', 2023, 'Electrique', 420, 'AX-470-KN', 'En maintenance', 'Strasbourg'),
(180, 'BMW', 'iX1', 2023, 'Electrique', 420, 'KM-572-NJ', 'En service', 'Marseille'),
(181, 'Renault', 'Megane E-Tech', 2021, 'Electrique', 520, 'PU-577-ZZ', 'En maintenance', 'Lyon'),
(182, 'Hyundai', 'Ioniq 6', 2024, 'Electrique', 250, 'TZ-622-EA', 'En maintenance', 'Toulouse'),
(183, 'Toyota', 'Proace Electric', 2022, 'Electrique', 570, 'EH-429-CM', 'Disponible', 'Lille'),
(184, 'Volkswagen', 'ID.3', 2023, 'Electrique', 410, 'OS-980-AT', 'En maintenance', 'Toulouse'),
(185, 'Tesla', 'Model 3', 2022, 'Electrique', 480, 'TI-895-UI', 'En maintenance', 'Lyon'),
(186, 'Tesla', 'Model Y', 2022, 'Electrique', 290, 'NN-119-YJ', 'Disponible', 'Nantes'),
(187, 'Volkswagen', 'ID.3', 2023, 'Electrique', 450, 'RV-850-FT', 'Hors service', 'Montpellier'),
(188, 'Peugeot', 'e-2008', 2022, 'Electrique', 310, 'UX-407-TO', 'Disponible', 'Nantes'),
(189, 'Volkswagen', 'ID.3', 2024, 'Electrique', 540, 'FZ-415-DG', 'En service', 'Toulouse'),
(190, 'Renault', 'Twingo E-Tech', 2024, 'Electrique', 550, 'BH-615-AM', 'Hors service', 'Marseille'),
(191, 'Volkswagen', 'ID.4', 2024, 'Electrique', 540, 'VP-134-EA', 'Hors service', 'Nice'),
(192, 'Volkswagen', 'ID.3', 2024, 'Electrique', 550, 'UJ-309-EH', 'En maintenance', 'Nantes'),
(193, 'Fiat', '500e', 2024, 'Electrique', 370, 'KT-363-MD', 'En service', 'Nice'),
(194, 'Hyundai', 'Ioniq 6', 2021, 'Electrique', 410, 'BK-529-UC', 'Disponible', 'Strasbourg'),
(195, 'Mercedes', 'EQB', 2023, 'Electrique', 590, 'EJ-848-ZK', 'Hors service', 'Strasbourg'),
(196, 'BMW', 'iX1', 2021, 'Electrique', 550, 'OS-817-PA', 'En maintenance', 'Lyon'),
(197, 'Renault', 'Zoe', 2021, 'Electrique', 480, 'LO-729-ZR', 'En service', 'Lyon'),
(198, 'Peugeot', 'e-2008', 2021, 'Electrique', 470, 'XD-909-AR', 'En service', 'Lille'),
(199, 'Citroen', 'e-C4', 2024, 'Electrique', 460, 'HO-747-OR', 'Hors service', 'Nice'),
(200, 'Citroen', 'e-C4', 2022, 'Electrique', 580, 'XE-564-VB', 'Disponible', 'Nice');
INSERT INTO "public"."type_vehicule" ("id_type_vehicule", "libelle_type") VALUES
(1, 'Citadine Électrique'),
(2, 'SUV Électrique'),
(3, 'Citadine Électrique'),
(4, 'Utilitaire Électrique'),
(5, 'Berline de Luxe'),
(6, 'SUV Familial'),
(7, 'Compacte Hybride'),
(8, 'Sportive Électrique'),
(9, 'Mini-Citadine'),
(10, 'Van Aménagé');
INSERT INTO "public"."technicien" ("id_technicien", "nom", "prenom", "specialiste") VALUES
(1, 'Zinedine', 'Yassine', 'Batteries'),
(2, 'Gomez', 'Elena', 'Électronique embarquée'),
(3, 'Traoré', 'Moussa', 'Systèmes de freinage'),
(4, 'Belkacem', 'Sami', 'Bornes de recharge'),
(5, 'Martin', 'Nicolas', 'Systèmes de freinage'),
(6, 'Bernard', 'Sophie', 'Logiciel embarqué'),
(7, 'Dubois', 'Alexandre', 'Carrosserie'),
(8, 'Thomas', 'Julie', 'Pneumatiques'),
(9, 'Robert', 'Kevin', 'Climatisation'),
(10, 'Richard', 'Laura', 'Diagnostic haute tension');
INSERT INTO "public"."maintenance" ("id_maintenance", "date_intervention", "type_intervention", "commentaire", "statut", "id_vehicule", "id_technicien") VALUES
(1, '2025-12-25', 'Révision annuelle', NULL, 'Terminé', 1, 1),
(2, '2025-12-15', 'Changement pneus', NULL, 'Terminé', 5, 2),
(3, '2025-12-25', 'Réparation borne', NULL, 'En cours', 10, 3),
(4, '2025-12-01', 'Diagnostic batterie', NULL, 'Terminé', 3, 3),
(5, '2025-12-05', 'Mise à jour logiciel', NULL, 'Terminé', 4, 4),
(6, '2025-12-10', 'Contrôle technique', NULL, 'Terminé', 5, 1),
(7, '2025-12-15', 'Réparation carrosserie', NULL, 'Terminé', 6, 2),
(8, '2025-12-20', 'Changement pneus hiver', NULL, 'Terminé', 7, 3),
(9, '2025-12-25', 'Révision annuelle', NULL, 'En cours', 8, 4),
(10, '2025-12-26', 'Vérification bornes', NULL, 'En cours', 10, 1),
(11, '2025-12-26', 'Nettoyage intérieur pro', NULL, 'En cours', 12, 2);
INSERT INTO "public"."station" ("id_station", "nom_station", "addresse", "latitude", "longitude") VALUES
(1, 'Station Centre Lyon', NULL, NULL, NULL),
(2, 'Station Gare Strasbourg', 'Place de la Gare, Strasbourg', NULL, NULL),
(3, 'Station Vieux-Port', 'Quai de la Fraternité, Marseille', NULL, NULL),
(4, 'Station Lille-Flandres', 'Place des Buisses, Lille', NULL, NULL),
(5, 'Station Part-Dieu', 'Boulevard Marius Vivier Merle, Lyon', NULL, NULL),
(6, 'Station Méridien', 'Avenue du Prado, Marseille', NULL, NULL),
(7, 'Station Capitole', 'Place du Capitole, 31000 Toulouse', NULL, NULL),
(8, 'Station Promenade', 'Promenade des Anglais, 06000 Nice', NULL, NULL),
(9, 'Station Sainte-Catherine', 'Rue Sainte-Catherine, 33000 Bordeaux', NULL, NULL),
(10, 'Station Place de la Bourse', 'Place de la Bourse, 44000 Nantes', NULL, NULL),
(11, 'Station République', 'Place de la République, 35000 Rennes', NULL, NULL),
(12, 'Station Europe', 'Avenue de l''Europe, 67000 Strasbourg', NULL, NULL),
(13, 'Station Zénith', 'Avenue Raymond Badiou, 31300 Toulouse', NULL, NULL),
(14, 'Station Port-de-Lune', 'Quai de la Douane, 33000 Bordeaux', NULL, NULL),
(15, 'Station Place Bellecour 2', '20 Rue de la République, 69002 Lyon', NULL, NULL),
(16, 'Station Prado-Plage', 'Promenade Georges Pompidou, 13008 Marseille', NULL, NULL),
(17, 'Station Wilson', 'Place du Président Wilson, 31000 Toulouse', NULL, NULL),
(18, 'Station Jean Médecin', 'Avenue Jean Médecin, 06000 Nice', NULL, NULL),
(19, 'Station Quinconces', 'Place des Quinconces, 33000 Bordeaux', NULL, NULL),
(20, 'Station Graslin', 'Place Graslin, 44000 Nantes', NULL, NULL),
(21, 'Station Maillot', 'Boulevard Pereire, 75017 Paris', NULL, NULL),
(22, 'Station Bastille', 'Place de la Bastille, 75004 Paris', NULL, NULL),
(23, 'Station Vieux-Lille', 'Place Louise de Bettignies, 59000 Lille', NULL, NULL),
(24, 'Station Gutenberg', 'Place Gutenberg, 67000 Strasbourg', NULL, NULL),
(25, 'Station Victor Hugo', 'Avenue Victor Hugo, 21000 Dijon', NULL, NULL),
(26, 'Station Grammont', 'Avenue de Grammont, 37000 Tours', NULL, NULL),
(27, 'Station Comédie', 'Place de la Comédie, 34000 Montpellier', NULL, NULL),
(28, 'Station Jaude', 'Place de Jaude, 63000 Clermont-Ferrand', NULL, NULL),
(29, 'Station Saint-Leu', 'Quai Bélu, 80000 Amiens', NULL, NULL),
(30, 'Station Hôtel de Ville', 'Place de l''Hôtel de Ville, 76600 Le Havre', NULL, NULL);
INSERT INTO "public"."borne_recharge" ("id_borne", "statuts", "id_station") VALUES
(1, 'Libre', 1),
(2, 'Occupée', 2),
(3, 'Libre', 3),
(4, 'En maintenance', 3),
(5, 'Libre', 4),
(6, 'Libre', 5),
(7, 'Occupée', 5),
(8, 'Libre', 6),
(9, 'En maintenance', 6),
(10, 'Libre', 7),
(11, 'Libre', 8),
(12, 'Occupée', 9),
(13, 'En maintenance', 10),
(14, 'Libre', 11),
(15, 'Occupée', 12),
(16, 'Libre', 13),
(17, 'Libre', 14),
(18, 'Libre', 1),
(19, 'Occupée', 2),
(20, 'Libre', 3);
INSERT INTO "public"."client" ("id_client", "nom", "prenom", "email", "telephone", "date_dinscription") VALUES
(1, 'Durand', 'Marie', 'marie.durand@exemple.com', NULL, '2025-12-25'),
(2, 'Lefebvre', 'Thomas', 't.lefebvre@email.com', NULL, '2025-12-26'),
(3, 'Moreau', 'Camille', 'c.moreau@email.com', NULL, '2025-12-26'),
(4, 'Petit', 'Lucas', 'l.petit@email.com', NULL, '2025-12-26'),
(5, 'Durant', 'Gerard', 'g.durant@email.com', NULL, '2025-12-26'),
(6, 'Pierre', 'Thibaut', 'p.thibault@email.com', NULL, '2025-12-26'),
(7, 'Rodrigez', 'Adrien', 'adrien.rodrigez@email.com', NULL, '2025-12-26'),
(8, 'Pereira', 'Jose', 'jose.pereira@gmail.com', NULL, '2025-12-26'),
(9, 'Dupuis', 'Lia', 'l.dupuis@gmail.com', NULL, '2025-12-26'),
(10, 'Dali', 'Frank', 'frankdali@gmail.com', NULL, '2025-12-26');
INSERT INTO "public"."reservation" ("id_reservation", "date_debut_prevue", "date_fin_prevue", "statuts", "id_client", "id_vehicule") VALUES
(1, '2025-12-25 22:51:24.287823', '2025-12-26 22:51:24.287823', 'Confirmée', 1, 1),
(2, '2026-01-05 10:00:00', '2026-01-05 20:00:00', 'Confirmée', 2, 5),
(3, '2026-01-10 08:00:00', '2026-01-12 12:00:00', 'En attente', 3, 10),
(4, '2026-01-15 14:00:00', '2026-01-16 10:00:00', 'Annulée', 4, 15),
(5, '2026-01-20 07:30:00', '2026-01-20 19:00:00', 'Confirmée', 5, 20),
(6, '2026-02-01 09:00:00', '2026-02-03 18:00:00', 'Confirmée', 6, 25),
(7, '2026-02-10 11:00:00', '2026-02-10 15:00:00', 'En attente', 7, 30),
(8, '2026-02-14 18:00:00', '2026-02-16 09:00:00', 'Confirmée', 8, 35),
(9, '2026-03-01 08:00:00', '2026-03-01 20:00:00', 'Confirmée', 9, 40),
(10, '2026-03-15 10:00:00', '2026-03-17 12:00:00', 'Confirmée', 10, 45);
INSERT INTO "public"."location" ("id_location", "date_debut", "date_fin", "status", "id_client", "id_vehicule", "id_station_depart", "id_station_arrivee") VALUES
(1, '2025-12-25 22:46:19.820185', NULL, 'En cours', 1, 1, 1, NULL),
(2, '2025-12-20 08:00:00', NULL, 'Terminé', 2, 5, 2, NULL),
(3, '2025-12-26 10:44:32.485349', NULL, 'Terminé', 3, 3, 3, NULL),
(4, '2025-12-26 10:44:32.485349', NULL, 'Terminé', 4, 4, 4, NULL),
(5, '2025-12-01 08:30:00', '2025-12-01 12:00:00', 'Terminé', 1, 1, 1, NULL),
(6, '2025-12-02 09:00:00', '2025-12-02 18:00:00', 'Terminé', 2, 2, 2, NULL),
(7, '2025-12-05 14:20:00', '2025-12-06 10:00:00', 'Terminé', 3, 3, 3, NULL),
(8, '2025-12-10 07:45:00', NULL, 'En cours', 4, 4, 4, NULL),
(9, '2025-12-12 11:00:00', '2025-12-12 15:00:00', 'Terminé', 1, 5, 5, NULL),
(10, '2025-12-15 16:30:00', NULL, 'En cours', 2, 6, 6, NULL),
(11, '2025-12-18 08:00:00', '2025-12-18 20:00:00', 'Terminé', 3, 7, 7, NULL),
(12, '2025-12-20 12:00:00', '2025-12-21 12:00:00', 'Terminé', 4, 8, 8, NULL),
(13, '2025-12-22 09:15:00', NULL, 'En cours', 1, 9, 9, NULL),
(14, '2025-12-23 10:00:00', '2025-12-23 11:30:00', 'Terminé', 2, 10, 10, NULL),
(15, '2025-12-24 14:00:00', NULL, 'En cours', 3, 11, 11, NULL),
(16, '2025-12-25 08:00:00', '2025-12-25 09:00:00', 'Terminé', 4, 12, 12, NULL),
(17, '2025-12-26 07:00:00', NULL, 'En cours', 1, 13, 13, NULL),
(18, '2025-12-26 08:30:00', NULL, 'En cours', 2, 14, 14, NULL);
INSERT INTO "public"."paiements" ("id_paiement", "montant", "moyen_paiement", "date_paiement", "statut", "id_location") VALUES
(1, 45.00, 'Carte Bancaire', '2025-12-25 22:47:59.852057', 'Payé', 1),
(2, 85.00, 'Carte Bancaire', '2025-12-26 10:44:46.755358', 'Payé', 2),
(3, 120.50, 'PayPal', '2025-12-26 10:44:46.755358', 'Payé', 3),
(4, 25.50, 'Carte Bancaire', '2025-12-26 10:44:46.755358', 'Payé', 4),
(5, 45.00, 'PayPal', '2025-12-26 10:44:46.755358', 'Payé', 5),
(6, 89.90, 'Carte Bancaire', '2025-12-26 10:44:46.755358', 'Payé', 6),
(7, 15.00, 'Espèces', '2025-12-26 10:44:46.755358', 'Payé', 7),
(8, 32.00, 'Carte Bancaire', '2025-12-26 10:44:46.755358', 'Payé', 8),
(9, 120.00, 'Virement', '2025-12-26 10:44:46.755358', 'Payé', 9),
(10, 55.00, 'Carte Bancaire', '2025-12-26 10:44:46.755358', 'Payé', 10);
