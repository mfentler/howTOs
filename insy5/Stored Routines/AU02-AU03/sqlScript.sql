-- Autor: MARM
-- Datum: 20120306
-- Zweck: Musterloesung fuer "Stored Routines"

-- Editor: Mario Fentler
-- Datum: 07-11-2018
-- Zweck: AU02

\c template1
DROP DATABASE restaurant;
CREATE DATABASE restaurant OWNER mario;
\c restaurant

DROP TABLE IF EXISTS kellner CASCADE;
CREATE TABLE kellner (
             knr         INTEGER,
             name        VARCHAR(255),
             PRIMARY KEY (knr)
             );

INSERT INTO kellner VALUES (1, 'Kellner1');
INSERT INTO kellner VALUES (2, 'Kellner2');
INSERT INTO kellner VALUES (3, 'Kellner3');

DROP TABLE IF EXISTS speise CASCADE;
CREATE TABLE speise (
             snr         INTEGER,
             bezeichnung VARCHAR(255),
             preis       DECIMAL(6,2),
             PRIMARY KEY (snr)
             );

INSERT INTO speise VALUES (1, 'Heisse Liebe',         3);
INSERT INTO speise VALUES (2, 'Schoko Palatschinken', 4);
INSERT INTO speise VALUES (3, 'Pute gebacken',        7);
INSERT INTO speise VALUES (4, 'Pute natur',           8);
INSERT INTO speise VALUES (5, 'Puten-Cordon',         9);
INSERT INTO speise VALUES (6, 'Menue fuer 2',        15);
INSERT INTO speise VALUES (7, 'Menue fuer 3',        19);
INSERT INTO speise VALUES (8, 'Menue fuer 4',        22);

DROP TABLE IF EXISTS rechnung CASCADE;
CREATE TABLE rechnung (
             rnr         INTEGER,
             datum       DATE,
             tisch       SMALLINT,
             status      CHAR(8),
             knr         INTEGER,
             PRIMARY KEY (rnr),
             FOREIGN KEY (knr) REFERENCES kellner (knr)
                               ON UPDATE CASCADE ON DELETE CASCADE
             );

INSERT INTO rechnung VALUES (1, '2013-03-07', 1, 'bezahlt', 1);
INSERT INTO rechnung VALUES (2, '2013-03-07', 2, 'offen', 2);
INSERT INTO rechnung VALUES (3, '2013-03-07', 1, 'gedruckt', 3);
INSERT INTO rechnung VALUES (4, '2013-03-07', 1, 'gedruckt', 1);
INSERT INTO rechnung VALUES (5, CURRENT_DATE, 1, 'bezahlt', 1);
INSERT INTO rechnung VALUES (6, '2013-03-07', 2, 'offen', 2);

DROP TABLE IF EXISTS bestellung CASCADE;
CREATE TABLE bestellung (
             anzahl      SMALLINT,
             rnr         INTEGER,
             snr         INTEGER,
             PRIMARY KEY (rnr, snr),
             FOREIGN KEY (rnr) REFERENCES rechnung (rnr)
                               ON UPDATE CASCADE ON DELETE CASCADE,
             FOREIGN KEY (snr) REFERENCES speise (snr)
                               ON UPDATE CASCADE ON DELETE CASCADE
             );

INSERT INTO bestellung VALUES (9, 1, 1);
INSERT INTO bestellung VALUES (1, 1, 4);
INSERT INTO bestellung VALUES (1, 1, 5);
INSERT INTO bestellung VALUES (1, 2, 7);
INSERT INTO bestellung VALUES (1, 3, 8);
INSERT INTO bestellung VALUES (9, 4, 1);
INSERT INTO bestellung VALUES (9, 5, 1);
INSERT INTO bestellung VALUES (9, 6, 2);

--AU02
-- Die Definition OR REPLACE bewirkt, dass keine Fehlermeldung ausgegeben wird, wenn eine gleichnamige Funktion existiert, die nun überschrieben werden soll. 
CREATE OR REPLACE FUNCTION preisErhoehungHelper(NUMERIC,INTEGER,INTEGER) RETURNS VOID AS $$
    UPDATE speise SET preis = preis + $2 WHERE preis <= $1;
    UPDATE speise SET preis = preis + preis * $3 / 100 WHERE preis > $1; $$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION preisErhoehung(INTEGER,INTEGER) RETURNS VOID AS $$
    SELECT * FROM preisErhoehungHelper((SELECT avg(preis) FROM speise),$1,$2);$$ LANGUAGE SQL;

SELECT * FROM speise;
-- preisErhoehung2(preisErhoehung für preise < durchschnitt, für preise > durchschnitt)
SELECT * FROM preisErhoehung(1,5);

SELECT * FROM speise;


-- AU03

-- umsatz(kellnerNr)
CREATE OR REPLACE FUNCTION umsatz(INTEGER) RETURNS NUMERIC AS $$
    SELECT SUM(speise.preis)
    FROM speise,rechnung,bestellung
    WHERE speise.snr = bestellung.snr
    AND rechnung.rnr = bestellung.rnr
    AND rechnung.status = 'bezahlt'
    AND rechnung.knr = $1
    AND rechnung.datum = CURRENT_DATE;
$$ LANGUAGE SQL;

-- dazu wurde bei den rechnungen das Datum noch auf das current Date gesetzt.
SELECT * FROM umsatz(1);
