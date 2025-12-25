-- 1️⃣ Sélection de tous les clients
SELECT id_client, nom, prenom, email
FROM clients;


-- 2️⃣ Liste des locations avec clients et véhicules
SELECT l.id_location,
       c.nom,
       c.prenom,
       v.marque,
       v.modele,
       l.date_debut,
       l.date_fin
FROM locations l
JOIN clients c ON l.id_client = c.id_client
JOIN vehicules v ON l.id_vehicule = v.id_vehicule;


-- 3️⃣ Nombre de locations par client
SELECT c.id_client,
       c.nom,
       COUNT(l.id_location) AS nombre_locations
FROM clients c
LEFT JOIN locations l ON c.id_client = l.id_client
GROUP BY c.id_client, c.nom;


-- 4️⃣ Clients ayant déjà loué un véhicule (sous-requête)
SELECT *
FROM clients
WHERE id_client IN (
    SELECT id_client
    FROM locations
);


-- 5️⃣ Vue : locations encore actives
CREATE VIEW locations_actives AS
SELECT *
FROM locations
WHERE date_fin >= CURRENT_DATE;


-- 6️⃣ Fonction : montant total payé pour une location
CREATE OR REPLACE FUNCTION total_paiement_location(p_id_location INT)
RETURNS NUMERIC AS $$
BEGIN
    RETURN (
        SELECT SUM(montant)
        FROM paiements
        WHERE id_location = p_id_location
    );
END;
$$ LANGUAGE plpgsql;


-- 7️⃣ Trigger : empêcher une location si le véhicule est en maintenance
CREATE OR REPLACE FUNCTION verifier_disponibilite()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM maintenance
        WHERE id_vehicule = NEW.id_vehicule
    ) THEN
        RAISE EXCEPTION 'Véhicule en maintenance, location impossible';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_verification_location
BEFORE INSERT ON locations
FOR EACH ROW
EXECUTE FUNCTION verifier_disponibilite();
-- 8️⃣ Véhicules jamais loués
-- Permet d’identifier les véhicules inutilisés
SELECT *
FROM vehicules
WHERE id_vehicule NOT IN (
    SELECT id_vehicule
    FROM locations
);


-- 9️⃣ Chiffre d'affaires total par client
SELECT c.id_client,
       c.nom,
       SUM(p.montant) AS total_paye
FROM clients c
JOIN locations l ON c.id_client = l.id_client
JOIN paiements p ON l.id_location = p.id_location
GROUP BY c.id_client, c.nom
ORDER BY total_paye DESC;


-- 🔟 Chiffre d'affaires par mois
SELECT DATE_TRUNC('month', date_paiement) AS mois,
       SUM(montant) AS chiffre_affaires
FROM paiements
GROUP BY mois
ORDER BY mois;


-- 1️⃣1️⃣ Index pour améliorer les performances des recherches
CREATE INDEX idx_locations_client
ON locations(id_client);


-- 1️⃣2️⃣ Transaction : création sécurisée d’une location
BEGIN;

INSERT INTO locations (id_client, id_vehicule, date_debut, date_fin)
VALUES (1, 2, CURRENT_DATE, CURRENT_DATE + INTERVAL '5 days');

COMMIT;


-- 1️⃣3️⃣ Trigger : empêcher une location avec dates incohérentes
CREATE OR REPLACE FUNCTION verifier_dates_location()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.date_fin < NEW.date_debut THEN
        RAISE EXCEPTION 'La date de fin ne peut pas être antérieure à la date de début';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_verifier_dates
BEFORE INSERT OR UPDATE ON locations
FOR EACH ROW
EXECUTE FUNCTION verifier_dates_location();
