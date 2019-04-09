-- Aufgabe AU10a
-- Autor: Mario Fentler

CREATE OR REPLACE FUNCTION setCurrentDate() RETURNS trigger AS $$
    BEGIN
        NEW.datum = CURRENT_DATE;
        RETURN NEW;
    END;
$$ LANGUAGE SQL;

DROP TRIGGER IF EXISTS trigger_a;
CREATE TRIGGER trigger_a
    BEFORE INSERT
    ON rechnung
    FOR EACH ROW
    WHEN (NEW.datum IS NULL)
    EXECUTE PROCEDURE setCurrentDate();

SELECT * FROM rechnung;
INSERT INTO rechnung(rnr,datum,tisch,status,knr) VALUES (7,NULL,2,'offen',1);
SELECT * FROM rechnung WHERE rnr = 7;