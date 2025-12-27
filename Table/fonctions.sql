-- =========================
-- Fonctions SQL
-- =========================

-- Fonction : calcul du montant total payé pour une location
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
