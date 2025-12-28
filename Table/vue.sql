-- ==========================================
-- vues.sql
-- Création des vues
-- ==========================================

-- Vue : locations actives (date_fin future)
CREATE OR REPLACE VIEW locations_actives AS
SELECT *
FROM location
WHERE date_fin >= CURRENT_DATE;

