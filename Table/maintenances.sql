-- ==========================================
-- maintenance.sql
-- Affiche toutes les opérations de maintenance
-- ==========================================

SELECT id_maintenance, date_intervention, type_intervention,
       commentaire, statut, id_vehicule, id_technicien
FROM maintenance;

