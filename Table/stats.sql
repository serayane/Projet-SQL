-- =========================
-- Statistiques
-- =========================

-- Nombre de locations par client
SELECT id_client,
       COUNT(*) AS nombre_locations
FROM locations
GROUP BY id_client;
