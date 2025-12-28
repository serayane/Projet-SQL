-- ==========================================
-- triggers.sql
-- Trigger : empêcher dates incohérentes
-- ==========================================

CREATE OR REPLACE FUNCTION verifier_dates_location()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.date_fin < NEW.date_debut THEN
        RAISE EXCEPTION 'Erreur : date_fin ne peut pas être avant date_debut';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_verifier_dates ON location;

CREATE TRIGGER trigger_verifier_dates
BEFORE INSERT OR UPDATE ON location
FOR EACH ROW
EXECUTE FUNCTION verifier_dates_location();
