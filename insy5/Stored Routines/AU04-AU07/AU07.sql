-- Autor: Mario Fentler
-- Datum: 20.11.2018

-- AU07
--
-- Es soll eine Liste der Kellner und deren jeweiliger Tagesumsatz ausgegeben werden.
-- Dazu werden zuerst noch Dummy Daten eingetragen
--

INSERT INTO rechnung (rnr, datum, tisch, status, knr) VALUES(10, CURRENT_DATE, 3, 'bezahlt', 2);
INSERT INTO rechnung (rnr, datum, tisch, status, knr) VALUES(11, CURRENT_DATE, 4, 'bezahlt', 2);

INSERT INTO bestellung (anzahl, rnr, snr) VALUES (4, 10, 1);
INSERT INTO bestellung (anzahl, rnr, snr) VALUES (6, 10, 2);
INSERT INTO bestellung (anzahl, rnr, snr) VALUES (2, 11, 3);
INSERT INTO bestellung (anzahl, rnr, snr) VALUES (1, 10, 4);

CREATE TABLE tagesumsatzHelper(
    kellnername TEXT,
    tagesumsatz NUMERIC
);

-- Hier inner Joins da die Tabellen kombiniert werden müssen

CREATE OR REPLACE FUNCTION tagesumsatz() RETURNS SETOF tagesumsatzHelper AS $$
    SELECT kellner.name AS "kellnername",
    SUM(speise.preis) AS "tagesumsatz"
    FROM kellner
    INNER JOIN rechnung ON (rechnung.knr = kellner.knr)
    INNER JOIN bestellung ON (bestellung.rnr = rechnung.rnr)
    INNER JOIN speise ON (speise.snr = bestellung.snr)
    WHERE rechnung.datum = CURRENT_DATE AND
    rechnung.status = 'bezahlt'
    GROUP BY kellner.name;
$$ LANGUAGE SQL;

SELECT * FROM tagesumsatz();

DROP FUNCTION tagesumsatz();
DROP TABLE tagesumsatzHelper;

