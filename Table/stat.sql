-- ==========================================
-- stats.sql
-- Requêtes statistiques
-- ==========================================

-- 1) Nombre total de locations
SELECT COUNT(*) AS total_locations
FROM location;

-- 2) Nombre de locations par client
SELECT id_client, COUNT(*) AS nb_locations
FROM location
GROUP BY id_client
ORDER BY nb_locations DESC;

-- 3) Total payé par client
SELECT l.id_client, SUM(p.montant) AS total_paye
FROM location l
JOIN paiements p ON l.id_location = p.id_location
GROUP BY l.id_client
ORDER BY total_paye DESC;

-- 4) Chiffre d'affaires par mois
SELECT DATE_TRUNC('month', date_paiement) AS mois,
       SUM(montant) AS chiffre_affaires
FROM paiements
GROUP BY mois
ORDER BY mois;

