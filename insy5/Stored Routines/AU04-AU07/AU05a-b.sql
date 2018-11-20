-- Autor: Mario Fentler
-- Datum: 16.11.2018

-- AU05a
-- 
CREATE OR REPLACE FUNCTION nochNieBestellteSpeisen() RETURNS SETOF TEXT AS $$
    SELECT speise.bezeichnung AS "Bezeichnung" FROM speise
    WHERE speise.snr NOT IN (SELECT snr FROM bestellung);
$$ LANGUAGE SQL;

SELECT * FROM nochNieBestellteSpeisen() AS "Noch nie bestellte Speisen - AU05a";

CREATE TABLE speisenHelper(
    Bezeichnung VARCHAR(255),
    Nettopreis DECIMAL(6,2)
);

-- AU05b
CREATE OR REPLACE FUNCTION nochNieBestellteSpeisen2() RETURNS SETOF speisenHelper AS $$
    SELECT speise.bezeichnung AS "Bezeichnung",speise.preis AS "Nettopreis" FROM speise
    WHERE speise.snr NOT IN (SELECT snr FROM bestellung)
$$ LANGUAGE SQL;

SELECT * FROM nochNieBestellteSpeisen2();

DROP FUNCTION nochNieBestellteSpeisen2();
DROP TABLE speisenHelper;
