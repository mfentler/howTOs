-- Autor: Mario Fentler
-- Datum: 20.11.2018

-- AU06
-- Erstelle zwei Funktionen die in der SELECT-Klausel eingebettet werden,
-- um damit zusätzliche Spalten je Kellner anzeigen zu können. 
-- Die aufrufende SELECT-Anweisung soll folgende Ausgabe produzieren:
--
-- Kellnername, Anzahl der Rechnungen, Status der spätesten Rechnung
--

CREATE TABLE kellnerHelper(
    Kellnername TEXT,
    AnzahlRechnungen BIGINT,
    StatusDerLetztenRechnung CHARACTER(255)
);

CREATE OR REPLACE FUNCTION anzahlRechnung(INTEGER) 
RETURNS BIGINT AS $$
SELECT COUNT(rechnung.rnr) 
FROM rechnung
WHERE rechnung.knr = $1;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION statusLetzteRechnung(INTEGER) RETURNS CHARACTER(255) AS $$
    SELECT rechnung.status FROM rechnung
    WHERE rechnung.knr = $1 AND rechnung.datum = (
        SELECT MAX(rechnung.datum)
        FROM rechnung WHERE rechnung.knr = $1
    );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION kellnerDaten() RETURNS SETOF kellnerHelper AS $$
    SELECT kellner.name AS "Kellnername",
    anzahlRechnung(kellner.knr) AS "AnzahlRechnungen",
    statusletzteRechnung(kellner.knr) AS "StatusDerLetzenRechnung"
    FROM kellner;
$$ LANGUAGE SQL;

SELECT * FROM kellnerDaten();

DROP FUNCTION anzahlRechnung();
DROP FUNCTION statusLetzteRechnung();
DROP FUNCTION kellnerDaten();
DROP TABLE kellnerHelper;
