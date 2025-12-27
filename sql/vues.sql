-- =========================
-- Vues SQL
-- =========================

-- Vue des locations actives
CREATE VIEW locations_actives AS
SELECT *
FROM locations
WHERE date_fin >= CURRENT_DATE;
