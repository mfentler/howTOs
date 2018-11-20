-- Autor: Mario Fentler
-- Datum: 14.11.2018

-- AU04 a/b
CREATE OR REPLACE FUNCTION bruttoPreis(speise) RETURNS NUMERIC AS $$
    SELECT $1.preis * 1.2;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION mehrwertSteuer(speise) RETURNS NUMERIC AS $$
    SELECT $1.preis * 0.2;
$$ LANGUAGE SQL;

-- cast(zahl as decimal (vorkommastellen,nachkommastellen)) -> kürzt das Ergebnis
SELECT bezeichnung, preis AS "Netto",
    cast(bruttoPreis(speise.*) AS DECIMAL (12,2)) AS "Brutto", 
    cast(mehrwertSteuer(speise.*) AS DECIMAL(12,2)) AS "Mehrwertsteuer" 
    FROM speise;