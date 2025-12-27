-- =========================
-- Triggers SQL
-- =========================

-- Fonction trigger : vérification des dates de location
CREATE OR REPLACE FUNCTION verifier_dates_location()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.date_fin < NEW.date_debut THEN
        RAISE EXCEPTION 'La date de fin ne peut pas être antérieure à la date de début';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger associé
CREATE TRIGGER trigger_verifier_dates
BEFORE INSERT OR UPDATE ON locations
FOR EACH ROW
EXECUTE FUNCTION verifier_dates_location();
