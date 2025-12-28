-- ==========================================
-- vehicules.sql
-- Affiche tous les véhicules
-- ==========================================

SELECT id_vehicule, marque, modele, annee, energie, autonomie_km,
       immatriculation, etat, localisation
FROM vehicule;
