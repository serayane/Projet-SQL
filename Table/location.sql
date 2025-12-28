-- ==========================================
-- locations.sql
-- Affiche toutes les locations
-- ==========================================

SELECT id_location, date_debut, date_fin, status,
       id_client, id_vehicule, id_station_depart, id_station_arrivee
FROM location;
